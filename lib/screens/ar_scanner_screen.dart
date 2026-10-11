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
import '../theme/app_theme.dart';
import '../widgets/ancla_ra.dart';
import '../widgets/mascota_viva.dart';
import 'lesson_screen_v3.dart';

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

/// Lo que se publica a cada fotograma para mover el contenido.
@immutable
class _Vista {
  final AnclaRA ancla;

  /// false cuando el marcador dejó de verse pero la conversación sigue
  /// abierta: entonces el contenido se congela donde estaba.
  final bool siguiendo;

  const _Vista(this.ancla, this.siguiendo);
}

class _ArScannerScreenState extends State<ArScannerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  /// Cuánto aguanta el contenido sin volver a ver el marcador, cuando
  /// todavía no hay conversación abierta. La detección falla sola de vez
  /// en cuando (un reflejo, un parpadeo de enfoque) y sin esta tolerancia
  /// la mascota estaría apareciendo y desapareciendo.
  static const _tolerancia = Duration(milliseconds: 900);

  /// Cuánto se queda congelada una conversación abierta después de perder
  /// el marcador. Más que la tolerancia, porque aquí el estudiante puede
  /// estar leyendo o buscando el botón; pero no para siempre, o el globo
  /// se quedaría flotando sobre una pared.
  static const _abandono = Duration(seconds: 8);

  /// Suavizado del seguimiento, por fotograma. Más alto = sigue más
  /// pegado pero tiembla; más bajo = más suave pero va por detrás.
  static const _suavizado = 0.28;

  late final MobileScannerController _camara = MobileScannerController(
    // Manda la pantalla, no el controlador: la cámara solo arranca cuando
    // esta pestaña está delante.
    autoStart: false,
    // Solo QR. Buscar los otros catorce formatos en cada fotograma gasta
    // CPU para nada.
    formats: const [BarcodeFormat.qrCode],
    // 10 detecciones por segundo. Con `unrestricted` (cada fotograma) el
    // seguimiento no mejora a la vista y los teléfonos modestos se
    // calientan; el movimiento fino lo pone el suavizado.
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 100,
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
  DateTime _ultimaDeteccion = DateTime.fromMillisecondsSinceEpoch(0);

  /// Tamaño real del hueco donde se dibuja la cámara. Hace falta para
  /// traducir coordenadas, y no es el de la pantalla: aquí arriba hay una
  /// cabecera.
  Size _tamanoVista = Size.zero;

  /// Mientras la ficha está abierta no se sigue el marcador: el
  /// estudiante está leyendo.
  bool _fichaAbierta = false;

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

      final ancla = AnclaRA.desde(captura, codigo, _tamanoVista);
      if (ancla == null) continue;

      if (caso.id == _descartado) {
        // Lo cerró a propósito y sigue apuntando ahí. Se sigue contando
        // como "visto" para que la pausa no empiece a correr.
        _ultimaDeteccion = ahora;
        return;
      }

      _destino = ancla;
      _ultimaDeteccion = ahora;

      if (_casoDestino?.id != caso.id) {
        // Marcador distinto: empieza una conversación nueva y el
        // contenido se coloca de una vez, sin interpolar desde el sitio
        // donde estaba el anterior.
        _casoDestino = caso;
        _vista.value = _Vista(ancla, true);
        setState(() => _sesion = _Sesion(caso));
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
      if (_sesion == null || fuera > _abandono) {
        _cerrarSesion();
        return;
      }
      if (actual.siguiendo) _vista.value = _Vista(actual.ancla, false);
      return;
    }

    if (destino == null) return;

    final siguiente = actual.ancla.lejosDe(destino)
        ? destino
        : actual.ancla.haciaDestino(destino, _suavizado);

    _vista.value = _Vista(siguiente, true);
  }

  void _cerrarSesion() {
    _destino = null;
    _casoDestino = null;
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
    setState(() {
      s.momento = switch (s.momento) {
        _Momento.encargo => _Momento.pregunta,
        _Momento.pregunta => _Momento.pregunta,
        _Momento.reaccion => _Momento.consejo,
        _Momento.consejo => _Momento.consejo,
      };
    });
  }

  Future<void> _elegir(OpcionNorma opcion) async {
    final s = _sesion;
    if (s == null) return;

    setState(() {
      s.elegida = opcion;
      s.momento = _Momento.reaccion;
    });

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
/// Dos decisiones que parecen inconsistentes y no lo son:
///
///   - El contorno del QR gira el ángulo **completo** del marcador, porque
///     es la prueba visible de que el seguimiento es real.
///   - El muñeco y el globo giran solo un tercio de ese ángulo y como
///     mucho 12°. Leer tres líneas de texto inclinadas 30° mientras
///     sostienes el teléfono es incómodo, y aquí hay que leer y pulsar.
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

    // --- Tamaños, derivados del marcador -------------------------------
    // Los topes son lo que impide que el muñeco invada la pantalla al
    // acercarse y que el globo se vuelva ilegible al alejarse.
    final altoMascota = _entre(ancla.lado * 1.45, 96, 152);
    final anchoGrupo = _entre(
      ancla.lado * 3.6,
      230,
      math.min(300, tamanoVista.width - 24),
    );

    // --- Colocación -----------------------------------------------------
    // Si el marcador está en la mitad de abajo, el grupo va encima; si
    // está arriba, debajo. Así nunca se sale por un borde de la pantalla.
    final arriba = ancla.centro.dy > tamanoVista.height * 0.42;

    // El grupo se centra en el marcador, pero sin salirse de la pantalla.
    // El contorno del QR no se clampa: ese tiene que caer exacto sobre el
    // código aunque esté medio fuera de cuadro.
    final cx = _entre(
      ancla.centro.dx,
      anchoGrupo / 2 + 8,
      math.max(anchoGrupo / 2 + 8, tamanoVista.width - anchoGrupo / 2 - 8),
    );

    final anguloSuave = _entre(ancla.angulo * 0.35, -0.21, 0.21);

    final marcador = Matrix4.translationValues(
      ancla.centro.dx,
      ancla.centro.dy,
      0,
    ).multiplied(Matrix4.rotationZ(ancla.angulo));

    final grupo = Matrix4.translationValues(cx, ancla.centro.dy, 0)
        .multiplied(Matrix4.rotationZ(anguloSuave));

    return Stack(
      children: [
        // 1. El contorno sobre el QR. Confirma que la app está viendo la
        //    tarjeta y es lo que delataría un anclaje descuadrado. Se
        //    atenúa cuando se pierde el código, para que el estudiante
        //    sepa que lo que queda en pantalla está congelado.
        Positioned(
          left: 0,
          top: 0,
          child: Transform(
            transform: marcador,
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

        // 2. El muñeco y su globo, de pie junto al marcador.
        Positioned(
          left: 0,
          top: 0,
          child: Transform(
            transform: grupo,
            child: Transform.translate(
              offset: Offset(0, ancla.lado * (arriba ? -0.52 : 0.52)),
              child: FractionalTranslation(
                translation: Offset(-0.5, arriba ? -1.0 : 0.0),
                child: SizedBox(
                  width: anchoGrupo,
                  child: Row(
                    // Arriba y no abajo: el globo tiene que salir a la
                    // altura de la cabeza, no de los pies.
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MascotaViva(
                        size: altoMascota,
                        completa: true,
                        pensando: sesion.momento == _Momento.pregunta,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: altoMascota * 0.17),
                        child: CustomPaint(
                          size: const Size(9, 16),
                          painter: _PintaPico(),
                        ),
                      ),
                      Expanded(
                        child: _Globo(
                          sesion: sesion,
                          onAvanzar: onAvanzar,
                          onElegir: onElegir,
                          onFicha: onFicha,
                          onCerrar: onCerrar,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

/// El piquito del globo, apuntando al muñeco.
class _PintaPico extends CustomPainter {
  @override
  void paint(Canvas lienzo, Size t) {
    final camino = Path()
      ..moveTo(t.width, t.height * 0.12)
      ..lineTo(0, t.height * 0.5)
      ..lineTo(t.width, t.height * 0.88)
      ..close();
    lienzo.drawPath(camino, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PintaPico oldDelegate) => false;
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

    final texto = switch (sesion.momento) {
      _Momento.encargo => caso.enganche,
      _Momento.pregunta => '¿Qué normativa aplicarías aquí?',
      _Momento.reaccion => elegida?.reaccion ?? '',
      _Momento.consejo => caso.primerPaso,
    };

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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caso.icono, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      caso.titulo,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                caso.contexto,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14.5,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Qué contestó, si ya contestó. Es lo que convierte la ficha
              // en una corrección y no en un texto más.
              if (respuesta != null) ...[
                const SizedBox(height: 16),
                _TuRespuesta(respuesta: respuesta, caso: caso),
              ],

              const SizedBox(height: 22),
              const _Rotulo('Qué normativa aplica'),
              const SizedBox(height: 10),
              for (final n in caso.normas) _FilaNorma(norma: n),

              const SizedBox(height: 14),
              const _Rotulo('Por dónde empezar'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.28),
                  ),
                ),
                child: Text(
                  caso.primerPaso,
                  style: const TextStyle(
                    color: Color(0xFF2F5E13),
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              if (_preguntando || _respuesta != null) ...[
                const SizedBox(height: 22),
                const _Rotulo('El tutor sobre este caso'),
                const SizedBox(height: 10),
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
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Marcador ${caso.id}'
                  '${caso.tema == null ? '' : '  ·  tema ${caso.tema} del sílabo'}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11.5,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: (bien ? AppColors.primaryGreen : AppColors.gold)
            .withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        children: [
          Icon(
            bien ? Icons.check_circle_rounded : Icons.lightbulb_rounded,
            size: 18,
            color: bien ? AppColors.primaryGreen : AppColors.gold,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              bien
                  ? 'Elegiste ${respuesta.eligio} y era la correcta.'
                  : 'Elegiste ${respuesta.eligio}. '
                      'La que manda aquí es ${caso.opcionCorrecta.etiqueta}.',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
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
        fontSize: 11,
        letterSpacing: 0.9,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FilaNorma extends StatelessWidget {
  final NormaSugerida norma;
  const _FilaNorma({required this.norma});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.deepPurple.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              norma.norma,
              style: const TextStyle(
                color: AppColors.deepPurpleDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
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
