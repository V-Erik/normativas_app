import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/casos_ra.dart';
import '../services/chat_service.dart';
import '../services/escaneos_ra_service.dart';
import '../services/progreso_service.dart';
import '../services/voz_mascota.dart';
import '../theme/app_theme.dart';
import '../widgets/ancla_ra.dart';
import '../widgets/mascota_viva.dart';
import 'lesson_screen_v3.dart';
import 'tarjetas_ra_screen.dart';

/// Realidad aumentada sobre marcadores impresos.
///
/// QUÉ HACE, EN UNA FRASE
/// ----------------------
/// El docente reparte tarjetas con un caso de software ("historia clínica
/// para un hospital"). El estudiante la apunta con la cámara, la mascota
/// aparece **de pie sobre la tarjeta**, le plantea el encargo y le
/// pregunta qué normativa aplicaría. Solo cuando el estudiante responde,
/// la mascota explica.
///
/// POR QUÉ UN DIÁLOGO Y NO UNA TARJETA DE TEXTO
/// --------------------------------------------
/// La versión anterior mostraba la respuesta nada más detectar el código.
/// Quedaba una contradicción visible: el papel impreso pregunta "¿qué
/// normativa aplicarías?" y la app la contestaba sola medio segundo
/// después. Con eso, lo que la realidad aumentada aportaba sobre abrir el
/// chat era, honestamente, nada.
///
/// Ahora el estudiante tiene que decidir antes de recibir nada, y la
/// explicación se construye sobre **su** elección. Además queda guardado
/// qué eligió, lo que convierte cada marcador en un dato para el capítulo
/// de resultados (ver [EscaneosRAService]).
///
/// POR QUÉ ES RA Y NO UNA SUPERPOSICIÓN
/// ------------------------------------
/// Realidad aumentada basada en marcadores significa que el contenido
/// virtual mantiene su posición respecto al mundo real: se queda sobre el
/// papel aunque muevas la cámara. Eso es lo que hace [AnclaRA]. Dibujar
/// una imagen fija sobre un vídeo en vivo no es RA, es una superposición,
/// y es una diferencia que un tribunal puede preguntar.
class ArScannerScreen extends StatefulWidget {
  /// false cuando la pestaña no está a la vista.
  ///
  /// `MainScaffold` mantiene las cuatro pestañas vivas con un
  /// `IndexedStack` para no perder el chat al navegar, y eso significa que
  /// esta pantalla existe desde que arranca la app. Sin este indicador la
  /// cámara se quedaría encendida toda la sesión.
  final bool activa;

  const ArScannerScreen({super.key, this.activa = true});

  @override
  State<ArScannerScreen> createState() => _ArScannerScreenState();
}

/// En qué punto de la conversación está el estudiante.
enum _Momento { encargo, pregunta, reaccion, consejo }

/// La conversación en curso con un marcador.
class _Sesion {
  final CasoRA caso;
  _Momento momento;
  OpcionNorma? elegida;

  _Sesion(this.caso) : momento = _Momento.encargo;
}

/// Lo que la mascota dice en cada momento de la conversación.
///
/// Vive aquí y no dentro del globo porque lo usan dos: el globo para
/// escribirlo y la voz para leerlo. Con un switch en cada sitio, lo que
/// se oye y lo que se lee acaban separándose en cuanto alguien toque uno
/// de los dos.
String _textoDelMomento(_Sesion s) => switch (s.momento) {
      _Momento.encargo => s.caso.enganche,
      _Momento.pregunta => '¿Qué normativa aplicarías aquí?',
      _Momento.reaccion => s.elegida?.reaccion ?? '',
      _Momento.consejo => s.caso.primerPaso,
    };

/// La clave del clip de voz que corresponde a este momento.
///
/// Tiene que coincidir exactamente con la que calcula `generar_voces.py`
/// al nombrar los MP3. Si aquí se renombra una, allí deja de encontrarse
/// su clip y esa frase pasa a leerla el motor del teléfono: se degrada,
/// no se rompe, que es lo que se busca.
String _claveDeVoz(_Sesion s) => switch (s.momento) {
      _Momento.encargo => '${s.caso.id}__enganche',
      _Momento.pregunta => '__pregunta',
      _Momento.reaccion =>
        '${s.caso.id}__op${s.caso.opciones.indexOf(s.elegida!)}',
      _Momento.consejo => '${s.caso.id}__paso',
    };

/// Lo que se publica a cada fotograma para mover el contenido.
@immutable
class _Vista {
  final AnclaRA ancla;

  /// false cuando el marcador dejó de verse pero la conversación sigue
  /// abierta: entonces el contenido se congela donde estaba.
  final bool siguiendo;

  /// Cuánto está enderezado el contenido respecto del plano del papel.
  /// 0 = tumbado sobre la mesa, 1 = de frente a la cámara. Se anima entre
  /// los dos valores, así que vive aquí y no en el estado: cambia a cada
  /// fotograma y solo tiene que repintar el contenido aumentado.
  final double aplanado;

  const _Vista(this.ancla, this.siguiendo, this.aplanado);

  _Vista con({AnclaRA? ancla, bool? siguiendo, double? aplanado}) => _Vista(
        ancla ?? this.ancla,
        siguiendo ?? this.siguiendo,
        aplanado ?? this.aplanado,
      );
}

class _ArScannerScreenState extends State<ArScannerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  /// Cuánto aguanta el contenido sin volver a ver el marcador, cuando
  /// todavía no hay conversación abierta. La detección falla sola de vez
  /// en cuando (un reflejo, un parpadeo de enfoque) y sin esta tolerancia
  /// la mascota estaría apareciendo y desapareciendo.
  static const _tolerancia = Duration(milliseconds: 900);

  /// Cuánto aguanta una conversación abierta después de perder el
  /// marcador. Más que la tolerancia, porque aquí el estudiante puede
  /// estar leyendo o buscando el botón; pero no para siempre, o el globo
  /// se quedaría flotando sobre una pared.
  static const _abandono = Duration(seconds: 8);

  /// Lo mismo, pero cuando la conversación ya llegó al consejo.
  ///
  /// Los ocho segundos existen para proteger a quien está a medio
  /// responder y aparta la cámara un momento. Al final no hay nada que
  /// proteger: lo único que hacen es estorbar a quien ya terminó y quiere
  /// apuntar a la tarjeta siguiente. Apartar la cámara es entonces la
  /// forma natural de decir «siguiente», y conviene que responda rápido.
  static const _abandonoTerminado = Duration(milliseconds: 2200);

  Duration get _esperaAntesDeSoltar => _sesion?.momento == _Momento.consejo
      ? _abandonoTerminado
      : _abandono;

  /// Suavizado del seguimiento, por fotograma. Más alto = sigue más
  /// pegado pero tiembla; más bajo = más suave pero va por detrás.
  ///
  /// Subido de 0,28 a 0,38: con el teléfono quieto tiembla un pelo más,
  /// pero el muñeco flota por su cuenta y su sombra es difusa, así que
  /// ese temblor no se aprecia. El arrastre al girar sí se apreciaba.
  static const _suavizado = 0.38;

  /// Cuánto se endereza el contenido mientras se lee el encargo.
  ///
  /// Ni 0 ni 1. Tumbado del todo, el escorzo se come el texto cuando la
  /// mesa se mira desde arriba, que es como se mira una mesa. De frente
  /// del todo es la calcomanía de antes. En medio se lee sin esfuerzo y
  /// se sigue viendo que la tarjeta está apoyada en el papel.
  ///
  /// Con la sombra de contacto a los pies del muñeco se puede tumbar más
  /// que sin ella: el apoyo ya no depende solo del escorzo.
  static const _apoyado = 0.30;

  /// Velocidad con la que la tarjeta se levanta de la mesa al pasar a la
  /// pregunta, por fotograma.
  static const _enderezamiento = 0.12;

  late final MobileScannerController _camara = MobileScannerController(
    // Manda la pantalla, no el controlador: la cámara solo arranca cuando
    // esta pestaña está delante.
    autoStart: false,
    // Solo QR. Buscar los otros catorce formatos en cada fotograma gasta
    // CPU para nada.
    formats: const [BarcodeFormat.qrCode],
    // Unas dieciséis detecciones por segundo. Con `unrestricted` (cada
    // fotograma) los teléfonos modestos se calientan y el seguimiento no
    // mejora tanto; el movimiento fino lo pone el suavizado.
    //
    // Estaba en 100 ms, y ahí se notaba al girar: mientras la imagen va
    // movida el código no se decodifica, y cuanto más separadas van las
    // lecturas más dura el hueco en el que el muñeco se queda con la
    // última pose buena.
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 60,
  );

  Ticker? _reloj;

  /// Posición mostrada, ya suavizada. Se actualiza a cada fotograma y
  /// solo repinta el contenido aumentado, no la vista previa de la
  /// cámara, que es lo caro.
  final ValueNotifier<_Vista?> _vista = ValueNotifier(null);

  /// La conversación. Cambia pocas veces, así que va con `setState`.
  _Sesion? _sesion;

  AnclaRA? _destino;
  CasoRA? _casoDestino;

  /// Un salto grande no se aplica a la primera: se anota aquí y hace
  /// falta una segunda detección que lo confirme.
  ///
  /// Con un movimiento brusco la imagen sale movida y el lector puede
  /// devolver una posición disparatada durante un solo fotograma. Sin
  /// esto, el muñeco se iba de un salto y volvía al fotograma siguiente.
  AnclaRA? _candidato;
  DateTime _candidatoDesde = DateTime.fromMillisecondsSinceEpoch(0);

  /// Cuánto vale un candidato antes de olvidarlo. Dos detecciones seguidas
  /// llegan en unos 100 ms; con este margen caben tres o cuatro.
  static const _confirmacion = Duration(milliseconds: 420);

  /// Hacia dónde tiende el enderezado. Durante el encargo la tarjeta se
  /// queda apoyada en la mesa; en cuanto hay que elegir entre tres
  /// opciones se pone de frente, porque ahí se lee y se pulsa.
  double get _aplanadoObjetivo {
    final s = _sesion;
    if (s == null) return _apoyado;
    return s.momento == _Momento.encargo ? _apoyado : 1.0;
  }
  DateTime _ultimaDeteccion = DateTime.fromMillisecondsSinceEpoch(0);

  /// Tamaño real del hueco donde se dibuja la cámara. Hace falta para
  /// traducir coordenadas, y no es el de la pantalla: aquí arriba hay una
  /// cabecera.
  Size _tamanoVista = Size.zero;

  /// Mientras la ficha está abierta no se sigue el marcador: el
  /// estudiante está leyendo.
  bool _fichaAbierta = false;

  /// Si el contenido debe quedarse quieto en lugar de seguir al marcador.
  ///
  /// Antes esto se activaba también a partir de la pregunta, porque el
  /// texto colgaba del marcador y perder el globo mientras el estudiante
  /// alargaba el dedo era perderle la respuesta: es lo que la validación
  /// describió como «es muy difícil escoger la respuesta porque cambia
  /// muy fácil».
  ///
  /// Ya no hace falta. El texto vive en un panel fijo abajo y no se mueve
  /// pase lo que pase; lo único que sigue al marcador es el muñeco, y al
  /// muñeco no hay que pulsarlo. Congelarlo había dejado de proteger nada
  /// y era el motivo de que la conversación se quedara flotando en
  /// pantalla al terminar, sin cerrarse nunca sola.
  ///
  /// Con la ficha abierta sí: ahí el estudiante está leyendo otra cosa y
  /// el escaneo no debe correr por debajo.
  bool get _congelado => _fichaAbierta;

  /// Caso que el estudiante cerró con la X. Se ignora mientras siga
  /// apuntando a esa misma tarjeta; si aparta la cámara un par de
  /// segundos, vuelve a estar disponible. Sin esto, cerrar el globo sería
  /// inútil: la siguiente detección lo abriría otra vez al instante.
  String? _descartado;

  String? _codigoDesconocido;
  Timer? _olvidarDesconocido;

  MobileScannerException? _fallo;

  /// Evita dos `start()` solapados, que el controlador rechaza con
  /// `controllerInitializing`.
  bool _arrancando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    EscaneosRAService.instance.cargar().then((_) {
      if (mounted) setState(() {});
    });

    _reloj = createTicker(_latido);

    // Busca una voz española en el motor del sistema. Si no la hay, la
    // función queda deshabilitada y el botón ni siquiera aparece.
    VozMascota.instance.preparar();

    // La cámara arranca después del primer fotograma: `MobileScanner`
    // tiene que estar montado para quedarse con la sesión de cámara, y si
    // no lo está el controlador responde `controllerNotAttached`.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.activa) _encender();
    });
  }

  @override
  void didUpdateWidget(ArScannerScreen anterior) {
    super.didUpdateWidget(anterior);
    if (widget.activa != anterior.activa) {
      if (widget.activa) {
        _encender();
      } else {
        _apagar();
      }
    }
  }

  /// Cuando la app se va al fondo hay que soltar la cámara: Android se la
  /// lleva igual, y al volver la vista previa aparecería negra.
  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    if (!widget.activa) return;
    switch (estado) {
      case AppLifecycleState.resumed:
        _encender();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _apagar();
    }
  }

  Future<void> _encender() async {
    if (!mounted || _arrancando) return;
    _arrancando = true;

    // El contenido se coloca con las coordenadas de la cámara; si la
    // pantalla gira, esas coordenadas dejan de coincidir con la vista
    // previa. En vertical todo cuadra.
    await SystemChrome.setPreferredOrientations(
      const [DeviceOrientation.portraitUp],
    );

    try {
      await _camara.start();
      if (mounted) setState(() => _fallo = null);
    } on MobileScannerException catch (e) {
      // Solo dos de estos errores justifican tapar la cámara. Los demás
      // son de estado ("ya estaba arrancando", "ya estaba arrancada") y
      // pintar una pantalla de fallo sería mentir: la cámara funciona.
      switch (e.errorCode) {
        case MobileScannerErrorCode.permissionDenied:
        case MobileScannerErrorCode.unsupported:
          if (mounted) setState(() => _fallo = e);
        default:
          debugPrint('RA: start() descartado -> ${e.errorCode}');
      }
    } catch (e) {
      debugPrint('RA: no se pudo arrancar la cámara -> $e');
    } finally {
      _arrancando = false;
    }
  }

  Future<void> _apagar() async {
    // El `await` va primero a propósito: `_apagar` se llama desde
    // `didUpdateWidget`, y `_cerrarSesion` hace `setState`. Llamarlo
    // síncronamente ahí sería un setState en plena construcción del árbol.
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _cerrarSesion();
    try {
      await _camara.stop();
    } catch (e) {
      debugPrint('RA: no se pudo detener la cámara -> $e');
    }
  }

  @override
  void dispose() {
    VozMascota.instance.callar();
    WidgetsBinding.instance.removeObserver(this);
    _olvidarDesconocido?.cancel();
    _reloj?.stop(canceled: true);
    _reloj?.dispose();
    _vista.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    // Con un controlador propio, `MobileScanner` no lo detiene ni lo
    // libera: eso es de quien lo creó.
    _camara.dispose();
    super.dispose();
  }

  // ======================================================================
  // DETECCIÓN Y SEGUIMIENTO
  // ======================================================================

  void _alDetectar(BarcodeCapture captura) {
    if (!mounted || _fichaAbierta || _tamanoVista.isEmpty) return;

    final ahora = DateTime.now();
    // Si hubo una pausa de verdad desde la última lectura, se perdona lo
    // que el estudiante hubiera cerrado: volvió a buscar la tarjeta.
    if (ahora.difference(_ultimaDeteccion) > const Duration(seconds: 2)) {
      _descartado = null;
    }

    for (final codigo in captura.barcodes) {
      final caso = CasosRA.resolver(codigo.rawValue);
      if (caso == null) continue;

      // Con una conversación abierta, otro marcador no la reemplaza.
      // Nunca, tampoco en el último paso.
      //
      // Este era el defecto principal que reportó la validación: basta
      // con que otra tarjeta de la mesa entre en el encuadre para que el
      // caso en curso se reinicie y el estudiante pierda lo que estaba
      // haciendo. Llegué a abrir una excepción para el consejo, pensando
      // que ahí la conversación ya estaba terminada; no lo está. El
      // consejo es donde está el texto que hay que leer y el botón de la
      // ficha, así que leer ahí quedaba a merced de la tarjeta de al
      // lado. Era el mismo defecto, desplazado al final.
      //
      // Para pasar a otro caso hay dos salidas, las dos del estudiante:
      // la X del globo, o apartar la cámara (ver [_esperaAntesDeSoltar],
      // que suelta enseguida cuando ya no queda nada que perder).
      if (_sesion != null && caso.id != _sesion!.caso.id) continue;

      final ancla = AnclaRA.desde(captura, codigo, _tamanoVista);
      if (ancla == null) continue;

      if (caso.id == _descartado) {
        // Lo cerró a propósito y sigue apuntando ahí. Se sigue contando
        // como "visto" para que la pausa no empiece a correr.
        _ultimaDeteccion = ahora;
        return;
      }

      // Un salto grande respecto de donde está el contenido ahora mismo
      // se trata como sospechoso hasta que una segunda detección lo
      // confirme. Mientras tanto se cuenta como "visto", para que la
      // pausa no empiece a correr y el contenido no se retire.
      final mostrada = _vista.value?.ancla;
      if (mostrada != null && mostrada.lejosDe(ancla)) {
        final c = _candidato;
        final caducado = ahora.difference(_candidatoDesde) > _confirmacion;
        if (c == null || caducado || c.lejosDe(ancla)) {
          _candidato = ancla;
          _candidatoDesde = ahora;
          _ultimaDeteccion = ahora;
          return;
        }
        // Dos detecciones seguidas coinciden en el sitio nuevo: el
        // teléfono se movió de verdad y el salto se acepta.
      }
      _candidato = null;

      _destino = ancla;
      _ultimaDeteccion = ahora;

      if (_casoDestino?.id != caso.id) {
        // Marcador distinto: empieza una conversación nueva y el
        // contenido se coloca de una vez, sin interpolar desde el sitio
        // donde estaba el anterior.
        _casoDestino = caso;
        _vista.value = _Vista(ancla, true, _apoyado);
        final nueva = _Sesion(caso);
        setState(() => _sesion = nueva);
        VozMascota.instance
            .decir(_textoDelMomento(nueva), clave: _claveDeVoz(nueva));
      }

      if (!(_reloj?.isActive ?? false)) _reloj?.start();
      return;
    }

    // Se leyó un QR, pero no es de la guía.
    if (_sesion == null) {
      final crudo = captura.barcodes
          .map((b) => b.rawValue)
          .firstWhere(
            (v) => v != null && v.trim().isNotEmpty,
            orElse: () => null,
          );
      if (crudo != null) _avisarDesconocido(crudo);
    }
  }

  /// Interpola la posición mostrada hacia la última detectada, una vez
  /// por fotograma.
  void _latido(Duration _) {
    if (!mounted) return;

    // El enderezado corre siempre, también con el contenido congelado:
    // justo al congelar es cuando la tarjeta tiene que levantarse de la
    // mesa, y si se saliera antes se levantaría de golpe.
    _enderezar();

    // Con el contenido congelado no se interpola ni se cuenta el abandono:
    // el estudiante está decidiendo y perder el globo ahora significa
    // perder la respuesta. La salida sigue siendo la X del propio globo.
    if (_congelado) return;

    final actual = _vista.value;
    final destino = _destino;
    if (actual == null) {
      _reloj?.stop();
      return;
    }

    final fuera = DateTime.now().difference(_ultimaDeteccion);

    if (fuera > _tolerancia) {
      // Sin conversación abierta, el contenido se retira: no hay nada que
      // leer y dejarlo flotando sobre una escena que ya no tiene el papel
      // sería justo la superposición falsa que se quería evitar.
      //
      // Con conversación abierta se congela donde estaba, porque si no,
      // bastaría un reflejo para borrarle la pregunta al estudiante
      // mientras alarga el dedo para contestarla. Pero solo un rato: si
      // deja de apuntar de verdad, se retira igual.
      if (_sesion == null || fuera > _esperaAntesDeSoltar) {
        _cerrarSesion();
        return;
      }
      if (actual.siguiendo) _vista.value = actual.con(siguiendo: false);
      return;
    }

    if (destino == null) return;

    final siguiente = actual.ancla.lejosDe(destino)
        ? destino
        : actual.ancla.haciaDestino(destino, _suavizado);

    _vista.value = _Vista(siguiente, true, actual.aplanado);
  }

  /// Acerca el enderezado a su objetivo, un poco por fotograma.
  void _enderezar() {
    final v = _vista.value;
    if (v == null) return;
    final falta = _aplanadoObjetivo - v.aplanado;
    if (falta.abs() < 0.004) {
      if (v.aplanado != _aplanadoObjetivo) {
        _vista.value = v.con(aplanado: _aplanadoObjetivo);
      }
      return;
    }
    _vista.value = v.con(aplanado: v.aplanado + falta * _enderezamiento);
  }

  void _cerrarSesion() {
    VozMascota.instance.callar();
    _destino = null;
    _casoDestino = null;
    _candidato = null;
    _vista.value = null;
    _reloj?.stop();
    if (_sesion != null && mounted) setState(() => _sesion = null);
  }

  /// La X del globo. Además de cerrar, anota el caso para no reabrirlo en
  /// el siguiente fotograma mientras la cámara sigue encima.
  void _descartarSesion() {
    _descartado = _sesion?.caso.id;
    _cerrarSesion();
  }

  void _avisarDesconocido(String crudo) {
    if (_codigoDesconocido == crudo) return;
    setState(() => _codigoDesconocido = crudo);
    _olvidarDesconocido?.cancel();
    _olvidarDesconocido = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _codigoDesconocido = null);
    });
  }

  // ======================================================================
  // EL DIÁLOGO
  // ======================================================================

  void _avanzar() {
    final s = _sesion;
    if (s == null) return;

    // El contorno del QR se atenúa al congelar, igual que cuando se pierde
    // el marcador: es la señal de que lo que hay en pantalla ya no está
    // siguiendo al papel y el estudiante puede bajar el teléfono.
    final v = _vista.value;
    if (v != null && v.siguiendo) _vista.value = v.con(siguiendo: false);

    setState(() {
      s.momento = switch (s.momento) {
        _Momento.encargo => _Momento.pregunta,
        _Momento.pregunta => _Momento.pregunta,
        _Momento.reaccion => _Momento.consejo,
        _Momento.consejo => _Momento.consejo,
      };
    });

    VozMascota.instance
        .decir(_textoDelMomento(s), clave: _claveDeVoz(s));
  }

  Future<void> _elegir(OpcionNorma opcion) async {
    final s = _sesion;
    if (s == null) return;

    setState(() {
      s.elegida = opcion;
      s.momento = _Momento.reaccion;
    });

    // La reacción es el texto que más importa que se oiga: es el que
    // explica por qué esa normativa encaja o se queda corta.
    VozMascota.instance.decir(_textoDelMomento(s), clave: _claveDeVoz(s));

    final primera = await EscaneosRAService.instance.registrarRespuesta(
      s.caso,
      eligio: opcion.etiqueta,
      acerto: opcion.correcta,
    );
    if (!mounted) return;

    // El contador de la cabecera ("3 de 8 resueltos · 2 a la primera")
    // cambia en cuanto se contesta.
    setState(() {});
    if (primera) _avisarXp(s.caso);
  }

  void _avisarXp(CasoRA caso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.deepPurple,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        content: Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Marcador respondido  ·  +${caso.xp} XP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  // FICHA COMPLETA
  // ======================================================================

  Future<void> _abrirFicha(CasoRA caso) async {
    VozMascota.instance.callar();
    setState(() => _fichaAbierta = true);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FichaCaso(
        caso: caso,
        onIrALaLeccion: () => _irALaLeccion(caso),
      ),
    );

    if (mounted) setState(() => _fichaAbierta = false);
  }

  /// Abre la lección del sílabo que corresponde al caso.
  ///
  /// Se busca en la lista única de `ProgresoService` y no en una copia de
  /// `MockDataSilabo`: con una copia, el candado que se ve aquí no sería
  /// el mismo que ve el mapa de rutas.
  void _irALaLeccion(CasoRA caso) {
    for (final mundo in ProgresoService.instance.obtenerMundos()) {
      for (final capitulo in mundo.capitulos) {
        for (final leccion in capitulo.lecciones) {
          if (leccion.id != caso.leccionId) continue;

          if (!leccion.desbloqueada) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                content: Text(
                  'Esta tarjeta corresponde a "${leccion.titulo}", '
                  'del Mundo ${mundo.numeroMundo}. Todavía está bloqueada.',
                ),
              ),
            );
            return;
          }

          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => LessonScreenV3(
                mundo: mundo,
                capitulo: capitulo,
                leccion: leccion,
              ),
            ),
          );
          return;
        }
      }
    }
  }

  // ======================================================================
  // PINTADO
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    final registro = EscaneosRAService.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Cabecera(
              camara: _camara,
              respondidos: registro.cuantosRespondidos,
              aciertos: registro.cuantosAcertados,
              total: registro.cuantosHay,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.card),
                ),
                child: LayoutBuilder(
                  builder: (context, limites) {
                    // Se guarda para `AnclaRA.desde`. Dentro de build para
                    // que siga siendo correcto si cambia la barra de
                    // sistema o el tamaño de la ventana.
                    _tamanoVista = limites.biggest;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_fallo == null)
                          MobileScanner(
                            controller: _camara,
                            onDetect: _alDetectar,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e) => _SinCamara(fallo: e),
                            placeholderBuilder: (_) =>
                                const ColoredBox(color: Color(0xFF101014)),
                          )
                        else
                          _SinCamara(fallo: _fallo!),

                        ValueListenableBuilder<_Vista?>(
                          valueListenable: _vista,
                          builder: (context, vista, _) {
                            final sesion = _sesion;
                            if (vista == null || sesion == null) {
                              return _ModoBusqueda(
                                desconocido: _codigoDesconocido,
                              );
                            }
                            return _DialogoAnclado(
                              vista: vista,
                              sesion: sesion,
                              tamanoVista: _tamanoVista,
                              onAvanzar: _avanzar,
                              onElegir: _elegir,
                              onFicha: () => _abrirFicha(sesion.caso),
                              onCerrar: _descartarSesion,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// CABECERA
// ==========================================================================

class _Cabecera extends StatelessWidget {
  final MobileScannerController camara;
  final int respondidos;
  final int aciertos;
  final int total;

  const _Cabecera({
    required this.camara,
    required this.respondidos,
    required this.aciertos,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(18, 10, 10, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Realidad aumentada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  respondidos == 0
                      ? '$total casos por resolver'
                      : '$respondidos de $total resueltos  ·  '
                          '$aciertos a la primera',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // El acceso a las hojas imprimibles vive aquí porque es aquí
          // donde hace falta: quien está en el escáner sin tarjeta
          // delante es exactamente quien necesita imprimirla.
          IconButton(
            tooltip: 'Tarjetas para imprimir',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TarjetasRAScreen()),
            ),
            icon: const Icon(Icons.style_rounded, color: Colors.white70),
          ),

          // El altavoz solo aparece si este teléfono tiene instalada una
          // voz en español. Ofrecer el botón y que luego lea en inglés
          // sería peor que no ofrecerlo.
          ValueListenableBuilder<bool>(
            valueListenable: VozMascota.instance.disponible,
            builder: (context, hayVoz, _) {
              if (!hayVoz) return const SizedBox.shrink();
              return ValueListenableBuilder<bool>(
                valueListenable: VozMascota.instance.activa,
                builder: (context, encendida, _) {
                  return IconButton(
                    tooltip: encendida
                        ? 'Silenciar a la mascota'
                        : 'Que la mascota lea en voz alta',
                    onPressed: () => VozMascota.instance.alternar(),
                    icon: Icon(
                      encendida
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      color: encendida ? AppColors.gold : Colors.white70,
                    ),
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: camara,
            builder: (context, estado, _) {
              if (estado.torchState == TorchState.unavailable) {
                return const SizedBox.shrink();
              }
              final encendida = estado.torchState == TorchState.on;
              return IconButton(
                tooltip:
                    encendida ? 'Apagar la linterna' : 'Encender la linterna',
                onPressed: () => camara.toggleTorch(),
                icon: Icon(
                  encendida
                      ? Icons.flashlight_on_rounded
                      : Icons.flashlight_off_rounded,
                  color: encendida ? AppColors.gold : Colors.white70,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// MODO BÚSQUEDA
// ==========================================================================

class _ModoBusqueda extends StatelessWidget {
  final String? desconocido;
  const _ModoBusqueda({this.desconocido});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Cuatro esquinas en vez de un marco cerrado: no tapa la escena
          // y se entiende igual de bien dónde poner la tarjeta.
          Center(
            child: SizedBox(
              width: 230,
              height: 230,
              child: CustomPaint(painter: _PintaMira()),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: desconocido != null
                ? const _Pastilla(
                    icono: Icons.help_outline_rounded,
                    color: AppColors.gold,
                    texto: 'Ese código no es de la guía',
                  )
                : const _Pastilla(
                    icono: Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    texto: 'Apunta a una tarjeta de caso',
                  ),
          ),
        ],
      ),
    );
  }
}

class _Pastilla extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String texto;

  const _Pastilla({
    required this.icono,
    required this.color,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: color, size: 18),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PintaMira extends CustomPainter {
  @override
  void paint(Canvas lienzo, Size tamano) {
    final lapiz = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const brazo = 30.0;
    final w = tamano.width;
    final h = tamano.height;

    void esquina(double x, double y, double dx, double dy) {
      lienzo.drawLine(Offset(x, y), Offset(x + brazo * dx, y), lapiz);
      lienzo.drawLine(Offset(x, y), Offset(x, y + brazo * dy), lapiz);
    }

    esquina(0, 0, 1, 1);
    esquina(w, 0, -1, 1);
    esquina(0, h, 1, -1);
    esquina(w, h, -1, -1);
  }

  @override
  bool shouldRepaint(_PintaMira oldDelegate) => false;
}

// ==========================================================================
// EL CONTENIDO ANCLADO
// ==========================================================================

/// La parte que hace que esto sea realidad aumentada.
///
/// Todo se coloca y se mide **en función del marcador**: el muñeco mide
/// algo más que el lado del QR, el globo cuatro veces, y el conjunto se
/// inclina con el papel. Al acercar el teléfono crece, como crecería un
/// objeto de verdad.
///
/// El contenido no se dibuja de frente a la cámara, sino **en el plano del
/// papel**: la homografía que sale de las cuatro esquinas del QR lo tumba
/// sobre la mesa, con el borde lejano más corto que el cercano. Es la
/// diferencia entre una calcomanía pegada al cristal y algo apoyado ahí.
///
/// Dos decisiones que parecen inconsistentes y no lo son:
///
///   - El contorno del QR usa la pose **exacta**, sin enderezar. Tiene que
///     encajar en el código hasta cuando la hoja está muy inclinada: es la
///     prueba visible de que el seguimiento es real, y ahí no hay texto.
///   - El muñeco y el globo van a medio enderezar mientras se lee el
///     encargo, y se levantan del todo al pasar a la pregunta. Leer tres
///     líneas escorzadas y acertarle a un botón de 38 px mientras sostienes
///     el teléfono con la otra mano es justo lo que la validación describió
///     como «es muy difícil escoger la respuesta porque cambia muy fácil».
class _DialogoAnclado extends StatelessWidget {
  final _Vista vista;
  final _Sesion sesion;
  final Size tamanoVista;
  final VoidCallback onAvanzar;
  final ValueChanged<OpcionNorma> onElegir;
  final VoidCallback onFicha;
  final VoidCallback onCerrar;

  const _DialogoAnclado({
    required this.vista,
    required this.sesion,
    required this.tamanoVista,
    required this.onAvanzar,
    required this.onElegir,
    required this.onFicha,
    required this.onCerrar,
  });

  @override
  Widget build(BuildContext context) {
    final ancla = vista.ancla;

    // --- Tamaños ---------------------------------------------------------
    //
    // El muñeco ya no comparte fila con el texto, así que su tamaño sale
    // libre del marcador: ahí está la profundidad, y al acercar el
    // teléfono crece como crecería algo que estuviera de verdad ahí.
    final altoMascota = _entre(ancla.lado * 1.7, 58, 250);
    final anchoMascota = MascotaViva.anchoDeCuerpo(altoMascota);

    // El panel de texto mide siempre lo mismo y vive en coordenadas de
    // pantalla, porque es lo único que hay que leer.
    final anchoPanel = math.min(380.0, tamanoVista.width - 28);

    // --- Colocación ------------------------------------------------------
    //
    // El muñeco NO se proyecta en el plano del papel. Esto es lo que
    // estaba mal antes: un personaje que flota está derecho, y meterlo en
    // la homografía de la mesa lo acuesta sobre ella, que es exactamente
    // la lectura de calcomanía que se quería evitar. Va en coordenadas de
    // pantalla, de pie, encima del marcador.
    //
    // Lo único que está de verdad sobre el papel es la sombra, y esa sí
    // se proyecta (más abajo, con la pose exacta).
    //
    // Y el hueco entre los dos es lo que dice «flota»: con los pies
    // pegados a la sombra se lee «apoyado»; separándolos, «suspendido
    // ahí». La altura sale del lado del marcador para que se mantenga al
    // acercarse y alejarse.
    final alturaVuelo = ancla.lado * 0.42;

    // Y «encima» quiere decir encima DE LA TARJETA, no de la pantalla.
    // Con el papel de lado, el sitio donde flota el muñeco también está
    // de lado. El eje vertical de la tarjeta apunta en pantalla hacia
    // (sen θ, −cos θ); con θ = 0 eso es hacia arriba, como antes.
    final pies = ancla.centro +
        Offset(math.sin(ancla.angulo), -math.cos(ancla.angulo)) *
            alturaVuelo;

    // Sujeto dentro del encuadre en los dos ejes: ahora el vuelo puede
    // apuntar a cualquier sitio, así que ya no basta con vigilar los
    // lados. El punto es el de los pies, y el cuerpo sube desde ahí.
    final px = _entre(
      pies.dx,
      anchoMascota / 2 + 8,
      math.max(
        anchoMascota / 2 + 8,
        tamanoVista.width - anchoMascota / 2 - 8,
      ),
    );
    final py = _entre(
      pies.dy,
      math.min(altoMascota + 8, tamanoVista.height - 8),
      tamanoVista.height - 8,
    );

    // El giro, entero. Al girar el teléfono, algo que estuviera de verdad
    // sobre la mesa giraría con ella, y eso es lo que tiene que hacer el
    // muñeco. Antes iba al 45 % y se anulaba al pasar a la pregunta,
    // porque llevaba el texto encima y un párrafo del revés no se lee; el
    // texto se fue al panel de abajo, que no gira nunca.
    final inclina = ancla.angulo;

    return Stack(
      children: [
        // 1. El contorno sobre el QR, con la pose exacta y sin enderezar:
        //    se dibuja como un cuadrilátero en perspectiva, encajado en el
        //    código aunque la hoja esté muy inclinada. Confirma que la app
        //    está viendo la tarjeta y es lo que delataría un anclaje
        //    descuadrado. Se atenúa cuando se pierde el código, para que
        //    el estudiante sepa que lo que queda en pantalla está
        //    congelado.
        Positioned(
          left: 0,
          top: 0,
          child: Transform(
            transform: ancla.matriz,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: vista.siguiendo ? 1 : 0.25,
                  child: Container(
                    width: ancla.lado,
                    height: ancla.lado,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(ancla.lado * 0.12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 2. La sombra, en el plano del papel.
        //
        //    Es lo único de toda la escena que está realmente sobre la
        //    hoja, así que es lo único que se dibuja con la homografía
        //    del marcador: se deforma con la perspectiva de la mesa y se
        //    inclina con ella. Aquí va la pose exacta, sin enderezar.
        Positioned(
          left: 0,
          top: 0,
          child: IgnorePointer(
            child: Transform(
              transform: ancla.matriz,
              child: FractionalTranslation(
                translation: const Offset(-0.5, -0.5),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: vista.siguiendo ? 1 : 0.4,
                  child: _SombraEnElPlano(
                    ancho: anchoMascota * 1.3,
                    alto: anchoMascota * 1.3 * 0.42,
                  ),
                ),
              ),
            ),
          ),
        ),

        // 3. El muñeco, de pie y flotando por encima del marcador.
        Positioned(
          left: 0,
          top: 0,
          child: Transform.translate(
            offset: Offset(px, py),
            child: FractionalTranslation(
              // Los pies justo encima de la sombra, el cuerpo hacia arriba.
              translation: const Offset(-0.5, -1.0),
              child: Transform.rotate(
                angle: inclina,
                alignment: Alignment.bottomCenter,
                child: MascotaViva(
                  size: altoMascota,
                  completa: true,
                  pensando: sesion.momento == _Momento.pregunta,
                  // Salta al acertar y se sacude al fallar. El gesto se
                  // dispara cuando cambia, así que llegar a la reacción lo
                  // reproduce una vez y ya.
                  gesto: sesion.momento == _Momento.reaccion
                      ? ((sesion.elegida?.correcta ?? false)
                          ? GestoMascota.acierto
                          : GestoMascota.fallo)
                      : GestoMascota.reposo,
                ),
              ),
            ),
          ),
        ),

        // 4. El texto, quieto.
        //
        //    El seguimiento es lo que hace que esto sea realidad
        //    aumentada, pero leer tres líneas sobre algo que se mueve con
        //    el pulso de la mano no se puede, y acertarle a un botón de
        //    38 px tampoco. Separar las dos cosas resuelve las dos.
        Positioned(
          left: (tamanoVista.width - anchoPanel) / 2,
          bottom: 16,
          width: anchoPanel,
          child: _PanelDeslizante(
            paso: sesion.momento.index,
            desdeLaDerecha: sesion.momento.index.isEven,
            child: _Globo(
              sesion: sesion,
              onAvanzar: onAvanzar,
              onElegir: onElegir,
              onFicha: onFicha,
              onCerrar: onCerrar,
            ),
          ),
        ),
      ],
    );
  }

  static double _entre(double valor, double minimo, double maximo) {
    if (maximo < minimo) return minimo;
    if (valor < minimo) return minimo;
    if (valor > maximo) return maximo;
    return valor;
  }
}

/// La mancha de sombra que el muñeco proyecta sobre la tarjeta.
///
/// De todo lo que hay en esta pantalla, esto es lo que más hace por que
/// la escena se lea como real, y cuesta cuatro líneas. Sin ella el muñeco
/// es un dibujo encima del vídeo; con ella hay algo suspendido sobre un
/// papel. El cerebro resuelve «dónde está esto» con la sombra mucho antes
/// que con la perspectiva.
///
/// Se dibuja aparte del muñeco y no dentro de él, porque las dos cosas
/// viven en sitios distintos: la sombra está sobre la hoja y se proyecta
/// con su perspectiva; el muñeco está en el aire y se queda derecho.
///
/// El difuminado es un degradado radial y no un desenfoque de verdad:
/// a este tamaño no se distingue y cuesta una fracción.
class _SombraEnElPlano extends StatelessWidget {
  final double ancho;
  final double alto;

  const _SombraEnElPlano({required this.ancho, required this.alto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      height: alto,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.elliptical(ancho / 2, alto / 2),
          ),
          gradient: const RadialGradient(
            colors: [
              Color.fromRGBO(0, 0, 0, 0.40),
              Color.fromRGBO(0, 0, 0, 0.0),
            ],
            stops: [0.15, 1.0],
          ),
        ),
      ),
    );
  }
}

class _PanelDeslizante extends StatefulWidget {
  /// Cambiar este número es lo que dispara la entrada.
  final int paso;

  final bool desdeLaDerecha;
  final Widget child;

  const _PanelDeslizante({
    required this.paso,
    required this.desdeLaDerecha,
    required this.child,
  });

  @override
  State<_PanelDeslizante> createState() => _PanelDeslizanteState();
}

class _PanelDeslizanteState extends State<_PanelDeslizante>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entra;

  @override
  void initState() {
    super.initState();
    _entra = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    )..forward();
  }

  @override
  void didUpdateWidget(_PanelDeslizante anterior) {
    super.didUpdateWidget(anterior);
    // Solo al cambiar de paso. El padre reconstruye a cada fotograma para
    // mover al muñeco, y sin esta comparación el panel estaría entrando
    // una y otra vez sin llegar nunca.
    if (widget.paso != anterior.paso) _entra.forward(from: 0);
  }

  @override
  void dispose() {
    _entra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entra,
      // El hijo se construye una vez y se reutiliza en cada fotograma de
      // la animación: lo único que cambia es la transformación.
      child: widget.child,
      builder: (context, hijo) {
        final t = Curves.easeOutCubic.transform(_entra.value);
        final desde = widget.desdeLaDerecha ? 1.0 : -1.0;
        return FractionalTranslation(
          translation: Offset(desde * (1 - t), 0),
          child: Opacity(opacity: t.clamp(0.0, 1.0), child: hijo),
        );
      },
    );
  }
}

// ==========================================================================
// EL GLOBO
// ==========================================================================

/// Lo que dice la mascota, y lo que el estudiante puede hacer.
///
/// Un paso a la vez, de una a tres líneas. Es la única forma de que el
/// texto se pueda leer sobre una imagen en movimiento y de que no tape
/// media cámara.
class _Globo extends StatelessWidget {
  final _Sesion sesion;
  final VoidCallback onAvanzar;
  final ValueChanged<OpcionNorma> onElegir;
  final VoidCallback onFicha;
  final VoidCallback onCerrar;

  const _Globo({
    required this.sesion,
    required this.onAvanzar,
    required this.onElegir,
    required this.onFicha,
    required this.onCerrar,
  });

  @override
  Widget build(BuildContext context) {
    final caso = sesion.caso;
    final elegida = sesion.elegida;

    final texto = _textoDelMomento(sesion);

    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 11, 9, 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Cabecera: en qué paso vamos, y la X --------------------
            Row(
              children: [
                _Pasos(momento: sesion.momento),
                const Spacer(),
                InkResponse(
                  onTap: onCerrar,
                  radius: 18,
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.close_rounded,
                      size: 15,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // --- Lo que dice --------------------------------------------
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sesion.momento == _Momento.reaccion && elegida != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 7, top: 1),
                      child: Icon(
                        elegida.correcta
                            ? Icons.check_circle_rounded
                            : Icons.lightbulb_rounded,
                        size: 16,
                        color: elegida.correcta
                            ? AppColors.primaryGreen
                            : AppColors.gold,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      texto,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12.8,
                        height: 1.38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Lo que se puede hacer ----------------------------------
            const SizedBox(height: 10),
            if (sesion.momento == _Momento.pregunta)
              _Opciones(caso: caso, onElegir: onElegir)
            else
              _Accion(
                etiqueta: switch (sesion.momento) {
                  _Momento.encargo => 'Sigue',
                  _Momento.reaccion => '¿Por dónde empiezo?',
                  _ => 'Ver la ficha completa',
                },
                icono: sesion.momento == _Momento.consejo
                    ? Icons.article_rounded
                    : Icons.arrow_forward_rounded,
                onTap:
                    sesion.momento == _Momento.consejo ? onFicha : onAvanzar,
              ),
          ],
        ),
      ),
    );
  }
}

/// Cuatro puntitos: en cuál de los cuatro pasos va la conversación.
/// Sin esto, el estudiante no sabe si lo que leyó era todo.
class _Pasos extends StatelessWidget {
  final _Momento momento;
  const _Pasos({required this.momento});

  @override
  Widget build(BuildContext context) {
    final actual = _Momento.values.indexOf(momento);
    return Row(
      children: [
        for (var i = 0; i < _Momento.values.length; i++)
          Container(
            width: i == actual ? 13 : 5,
            height: 5,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: i <= actual ? AppColors.deepPurple : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

/// Las tres normas entre las que elegir.
///
/// Cada una ocupa toda la fila y mide 38 px de alto a propósito: hay que
/// poder acertarle con el pulgar mientras la otra mano sostiene el
/// teléfono apuntando a un papel.
class _Opciones extends StatelessWidget {
  final CasoRA caso;
  final ValueChanged<OpcionNorma> onElegir;

  const _Opciones({required this.caso, required this.onElegir});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final o in caso.opciones)
          Padding(
            padding: const EdgeInsets.only(bottom: 6, right: 4),
            child: SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton(
                onPressed: () => onElegir(o),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.deepPurpleDark,
                  backgroundColor:
                      AppColors.deepPurple.withValues(alpha: 0.06),
                  side: BorderSide(
                    color: AppColors.deepPurple.withValues(alpha: 0.35),
                  ),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  o.etiqueta,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Accion extends StatelessWidget {
  final String etiqueta;
  final IconData icono;
  final VoidCallback onTap;

  const _Accion({
    required this.etiqueta,
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icono, size: 15),
        label: Text(
          etiqueta,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
        ),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryGreen,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// FICHA DEL CASO
// ==========================================================================

/// La ficha completa, en una hoja que sube desde abajo.
///
/// Se separa del marcador a propósito: en cuanto el estudiante quiere
/// *leer*, seguir el papel con la cámara estorba. La RA sirve para
/// descubrir y decidir; la lectura larga necesita estar quieta.
class _FichaCaso extends StatefulWidget {
  final CasoRA caso;
  final VoidCallback onIrALaLeccion;

  const _FichaCaso({required this.caso, required this.onIrALaLeccion});

  @override
  State<_FichaCaso> createState() => _FichaCasoState();
}

class _FichaCasoState extends State<_FichaCaso> {
  bool _preguntando = false;
  String? _respuesta;
  String? _notaTutor;
  String _estadoCola = 'El tutor está escribiendo…';

  Future<void> _preguntarAlTutor() async {
    setState(() {
      _preguntando = true;
      _respuesta = null;
      _notaTutor = null;
      _estadoCola = 'El tutor está escribiendo…';
    });

    try {
      final r = await ChatService.preguntarAlTutor(
        widget.caso.preguntaParaElTutor,
        leccionId: widget.caso.leccionIdParaChat,
        alCambiarCola: (estado) {
          if (mounted) setState(() => _estadoCola = estado.mensaje);
        },
      );
      if (!mounted) return;
      setState(() {
        _respuesta = _sinMarcas(r.respuesta);
        _notaTutor = r.sinDocumentacion
            ? 'El tutor no tiene documentación indexada de este tema'
            : r.notaDeEspera;
        _preguntando = false;
      });
    } on ErrorTutor catch (e) {
      if (!mounted) return;
      setState(() {
        _respuesta = e.mensaje;
        _preguntando = false;
      });
    }
  }

  /// El tutor responde en Markdown ligero. Aquí se muestra como texto, así
  /// que los asteriscos se quitan en lugar de enseñarlos.
  static String _sinMarcas(String texto) => texto
      .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1] ?? '')
      .replaceAll(RegExp(r'^\s*\*\s+', multiLine: true), '•  ');

  @override
  Widget build(BuildContext context) {
    final caso = widget.caso;
    final respuesta = EscaneosRAService.instance.respuestaDe(caso.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.68,
      minChildSize: 0.4,
      maxChildSize: 0.93,
      expand: false,
      builder: (context, scroll) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 32),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // En vez del emoji, un antetítulo. Lo que el emoji
              // intentaba decir lo dice mejor una palabra, y además se ve
              // igual en todos los teléfonos.
              const Text(
                'CASO PARA ANALIZAR',
                style: TextStyle(
                  color: AppColors.deepPurple,
                  fontSize: 10.5,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                caso.titulo,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  height: 1.18,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                caso.contexto,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14.5,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // La corrección, justo debajo del encargo y no enterrada a
              // media ficha: es lo que convierte esto en una corrección y
              // no en un texto más, así que va donde se lee primero.
              if (respuesta != null) ...[
                const SizedBox(height: 18),
                _TuRespuesta(respuesta: respuesta, caso: caso),
              ],

              const _Separador(),
              const _Rotulo('Qué normativa aplica'),
              const SizedBox(height: 14),
              for (final n in caso.normas) _FilaNorma(norma: n),

              const _Separador(),
              const _Rotulo('Por dónde empezar'),
              const SizedBox(height: 12),
              _ConFilete(
                color: AppColors.primaryGreen,
                child: Text(
                  caso.primerPaso,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              if (_preguntando || _respuesta != null) ...[
                const _Separador(),
                const _Rotulo('El tutor sobre este caso'),
                const SizedBox(height: 12),
                _BloqueTutor(
                  pensando: _preguntando,
                  estadoCola: _estadoCola,
                  respuesta: _respuesta,
                  nota: _notaTutor,
                ),
              ],

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _preguntando ? null : _preguntarAlTutor,
                      icon: const Icon(Icons.forum_rounded, size: 18),
                      label: Text(
                        _respuesta == null
                            ? 'Preguntar al tutor'
                            : 'Volver a preguntar',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.deepPurpleDark,
                        side: const BorderSide(color: AppColors.deepPurple),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onIrALaLeccion();
                      },
                      icon: const Icon(Icons.school_rounded, size: 18),
                      label: const Text(
                        'Ir a la lección',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'Marcador ${caso.id}'
                  '${caso.tema == null ? '' : '  ·  tema ${caso.tema} del sílabo'}',
                  style: TextStyle(
                    color: AppColors.textGrey.withValues(alpha: 0.65),
                    fontSize: 11,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Qué eligió el estudiante la primera vez que vio este caso.
class _TuRespuesta extends StatelessWidget {
  final RespuestaRA respuesta;
  final CasoRA caso;

  const _TuRespuesta({required this.respuesta, required this.caso});

  @override
  Widget build(BuildContext context) {
    final bien = respuesta.acerto;
    final tono = bien ? AppColors.primaryGreen : AppColors.gold;
    // Un tono oscuro propio para el titular: el de relleno no tiene
    // contraste suficiente sobre su propio fondo al 10 %.
    final tinta = bien ? const Color(0xFF2F5E13) : const Color(0xFF7A5200);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: tono.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: tono.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            bien ? Icons.check_circle_rounded : Icons.flag_rounded,
            size: 19,
            color: tono,
          ),
          const SizedBox(width: 11),
          Expanded(
            // Dos niveles: el veredicto de un vistazo y el detalle
            // debajo. En una sola línea corrida había que leerla entera
            // para saber si se había acertado.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bien ? 'Acertaste' : 'Esa no era',
                  style: TextStyle(
                    color: tinta,
                    fontSize: 13.5,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bien
                      ? 'Elegiste ${respuesta.eligio}, y es la que aplica '
                          'en este caso.'
                      : 'Elegiste ${respuesta.eligio}. La que aplica aquí '
                          'es ${caso.opcionCorrecta.etiqueta}.',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13.5,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Rotulo extends StatelessWidget {
  final String texto;
  const _Rotulo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 10.5,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

/// Un filo entre secciones.
///
/// La ficha es una columna larga y solo con espacios en blanco las
/// secciones se confunden con los párrafos. Una línea de un píxel separa
/// sin añadir ruido, que es más de lo que hacían las cajas de colores.
class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 16),
      child: Container(
        height: 1,
        color: AppColors.border.withValues(alpha: 0.6),
      ),
    );
  }
}

/// Un bloque con un filete de color a la izquierda.
///
/// Es lo que sustituye a la caja rellena del primer paso. Rellenar dos
/// bloques de la misma ficha hacía que compitieran; con un filete, el
/// bloque sigue destacando pero no le disputa el sitio a la corrección,
/// que es lo que hay que leer sí o sí.
class _ConFilete extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ConFilete({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _FilaNorma extends StatelessWidget {
  final NormaSugerida norma;
  const _FilaNorma({required this.norma});

  @override
  Widget build(BuildContext context) {
    // La norma, encima de su explicación y no al lado.
    //
    // Con el chip a la izquierda, el párrafo arrancaba a una altura
    // distinta y cada fila rompía el margen izquierdo de la siguiente.
    // Apilados, todo cuelga de la misma línea y la ficha se lee de
    // arriba abajo sin saltos.
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            norma.norma,
            style: const TextStyle(
              color: AppColors.deepPurpleDark,
              fontSize: 13,
              letterSpacing: 0.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              norma.porque,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloqueTutor extends StatelessWidget {
  final bool pensando;
  final String estadoCola;
  final String? respuesta;
  final String? nota;

  const _BloqueTutor({
    required this.pensando,
    required this.estadoCola,
    this.respuesta,
    this.nota,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FB),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // La mascota también aquí, y "pensando" mientras se genera: con
          // esperas de medio minuto en CPU hace falta algo que demuestre
          // que la app no se colgó.
          MascotaViva(size: 46, pensando: pensando),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pensando ? estadoCola : (respuesta ?? ''),
                  style: TextStyle(
                    color: pensando ? AppColors.textGrey : AppColors.textDark,
                    fontSize: 13.5,
                    height: 1.5,
                    fontStyle: pensando ? FontStyle.italic : FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (!pensando && nota != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    nota!,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// SIN CÁMARA
// ==========================================================================

class _SinCamara extends StatelessWidget {
  final MobileScannerException fallo;
  const _SinCamara({required this.fallo});

  @override
  Widget build(BuildContext context) {
    final sinPermiso =
        fallo.errorCode == MobileScannerErrorCode.permissionDenied;

    return ColoredBox(
      color: const Color(0xFF101014),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                sinPermiso
                    ? Icons.no_photography_rounded
                    : Icons.videocam_off_rounded,
                color: Colors.white38,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                sinPermiso
                    ? 'La app necesita permiso para usar la cámara.\n'
                        'Actívalo en los ajustes del teléfono y vuelve a '
                        'entrar aquí.'
                    : 'No se pudo abrir la cámara.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14.5,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}