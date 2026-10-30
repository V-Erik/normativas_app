import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/SeccionSilabo.dart';
import '../models/ejercicio_model.dart';
import '../services/progreso_service.dart';
import '../data/frases_mascota.dart';
import '../data/mock_preguntas.dart';
import '../data/casos_ra.dart';
import '../data/mock_contenidos.dart';
import '../services/hoja_marcadores.dart';
import 'chat_screen.dart';
import 'main_scaffold.dart';
import '../widgets/mascota_eso.dart';
import '../widgets/mascota_viva.dart' show GestoMascota;

/// Pantalla de Lección.
///
/// Fase 1: teoría en tarjetas, una idea por pantalla.
/// Fase 2: ejercicios con retroalimentación inmediata.
class LessonScreenV3 extends StatefulWidget {
  final SeccionSilabo mundo;
  final CapituloSilabo capitulo;
  final LeccionSilabo leccion;

  const LessonScreenV3({
    super.key,
    required this.mundo,
    required this.capitulo,
    required this.leccion,
  });

  @override
  State<LessonScreenV3> createState() => _LessonScreenV3State();
}

class _LessonScreenV3State extends State<LessonScreenV3> {
  /// Cuántas preguntas se plantean por intento.
  ///
  /// Si el banco de la lección tiene más, se toma una muestra distinta
  /// cada vez. Con el banco actual de cuatro no cambia nada todavía,
  /// pero en cuanto se amplíe, repetir una lección deja de ser repetir
  /// exactamente el mismo examen.
  static const int _preguntasPorIntento = 4;

  int _pasoActual = 0;
  int _tarjetaActual = 0;
  int _respuestasCorrectas = 0;
  int _xpTotalesGanados = 0;
  bool _leccionCompletada = false;

  /// true mientras se muestra el puente entre la teoría y los ejercicios.
  bool _enPuente = false;

  /// true cuando ESTA lección fue la que cerró el mundo.
  ///
  /// Se calcula comparando antes y después de completarla, no preguntando
  /// solo después: si el mundo ya estaba cerrado porque el estudiante
  /// repitió una lección, ofrecerle otra vez las tarjetas sería ruido.
  bool _mundoCerrado = false;

  final math.Random _azar = math.Random();

  late List<Ejercicio> _ejercicios;

  /// Opciones ya barajadas, en paralelo a [_ejercicios].
  ///
  /// POR QUÉ SE GUARDAN Y NO SE BARAJAN AL DIBUJAR
  /// ---------------------------------------------
  /// Barajar dentro del `build` sería un desastre: la pantalla se
  /// reconstruye varias veces por pregunta (al pulsar una opción, al
  /// cerrar la hoja de resultado) y las respuestas cambiarían de sitio
  /// mientras el estudiante las está leyendo. Peor aún al fallar: la
  /// pregunta se repite, y si las opciones se recolocaran, el segundo
  /// intento sería a ciegas.
  ///
  /// Se barajan una sola vez por intento y se conservan.
  late List<List<String>> _opciones;

  /// Índices de preguntas ya reportadas al servidor.
  ///
  /// Al fallar, la pregunta se vuelve a intentar, y sin este control cada
  /// intento sumaba otra vez los puntos por participación. Bastaba con
  /// fallar en bucle para subir de nivel.
  final Set<int> _reportadas = {};

  /// Respuesta marcada pero todavía no comprobada.
  ///
  /// POR QUÉ HAY UN PASO INTERMEDIO
  /// ------------------------------
  /// Antes, tocar una opción la evaluaba en el acto. Eso convertía
  /// cualquier roce en una respuesta incorrecta sin vuelta atrás, y
  /// quitaba el momento de decidir, que es justo donde el estudiante
  /// piensa. Ahora se marca, se puede cambiar, y se confirma con el
  /// botón de abajo.
  ///
  /// Importa además para la validación con estudiantes: un toque
  /// accidental contabilizado como fallo ensucia los datos del reactivo
  /// que mide si el ejercicio les hizo razonar.
  String? _respuestaElegida;

  /// Lo que dice la mascota en la pregunta actual. Se elige una vez al
  /// cambiar de pregunta y se guarda: si se sorteara dentro del `build`,
  /// la frase cambiaría sola cada vez que la pantalla se redibuja.
  String _fraseBurbuja = '';

  ContenidoLeccion? _contenido;

  final PageController _pageController = PageController();
  final TextEditingController _respuestaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prepararEjercicios();
    _contenido = MockContenidos.obtenerContenido(widget.leccion.id);
  }

  /// Arma la tanda de preguntas de este intento.
  ///
  /// Baraja el orden de las preguntas y, en cada una, el orden de las
  /// opciones. Lo segundo era necesario: en el banco actual la respuesta
  /// correcta ocupa la primera posición en las 115 preguntas de opción
  /// múltiple, de modo que un estudiante atento aprende a pulsar arriba
  /// sin leer.
  ///
  /// Barajar aquí y no en el archivo de datos tiene dos ventajas: el
  /// orden cambia en cada intento, y una pregunta nueva escrita más
  /// adelante no puede volver a introducir el sesgo por descuido.
  ///
  /// Es seguro porque [Ejercicio.validarRespuesta] compara el texto de la
  /// respuesta, no su posición.
  void _prepararEjercicios() {
    var banco = MockPreguntas.obtenerPreguntasLeccion(widget.leccion.id);
    if (banco.isEmpty) {
      banco = MockPreguntas.obtenerPreguntasLeccion('default');
    }

    final mezcladas = List<Ejercicio>.of(banco)..shuffle(_azar);
    _ejercicios = mezcladas.length > _preguntasPorIntento
        ? mezcladas.sublist(0, _preguntasPorIntento)
        : mezcladas;

    _opciones = [
      for (final e in _ejercicios) List<String>.of(e.opciones)..shuffle(_azar),
    ];

    _reportadas.clear();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _respuestaController.dispose();
    super.dispose();
  }

  List<TarjetaTeoria> get _tarjetas => _contenido?.tarjetas ?? const [];

  // ==================== LÓGICA ====================

  void _avanzarTarjeta() {
    if (_tarjetaActual < _tarjetas.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      setState(() => _enPuente = true);
    }
  }

  /// El número de mundo, sacado del id de la lección (`cap-2-3-lec-1`).
  ///
  /// Se deduce del id y no de `mundo.numeroMundo` a propósito: es la misma
  /// fuente de la que sale `CasoRA.mundo`, de modo que los dos no pueden
  /// discrepar. Si algún día cambiara el formato del id, dejarían de
  /// emparejarse a la vez y el fallo sería visible, en lugar de repartir
  /// en silencio las tarjetas de otro mundo.
  int? _numeroDeMundo() {
    final m = RegExp(r'^cap-(\d)-').firstMatch(widget.leccion.id);
    return m == null ? null : int.tryParse(m.group(1)!);
  }

  /// Sortea la frase de la burbuja para la pregunta actual.
  void _refrescarFrase() {
    if (_pasoActual < 1 || _pasoActual > _ejercicios.length) return;
    final ejercicio = _ejercicios[_pasoActual - 1];
    _fraseBurbuja = FrasesMascota.pregunta(
      numero: _pasoActual,
      total: _ejercicios.length,
      esCompletar: ejercicio.tipo == TipoEjercicio.completarTexto,
    );
  }

  /// Marca una respuesta sin comprobarla todavía.
  void _elegir(String? respuesta) {
    if (respuesta == _respuestaElegida) return;
    HapticFeedback.selectionClick();
    setState(() => _respuestaElegida = respuesta);
  }

  void _responderEjercicio(String respuesta) {
    if (_pasoActual == 0 || _leccionCompletada) return;
    if (respuesta.trim().isEmpty) return;

    final indice = _pasoActual - 1;
    final ejercicio = _ejercicios[indice];
    final esCorrecta = ejercicio.validarRespuesta(respuesta);
    final xp = esCorrecta ? ejercicio.xpPorRespuesta : 0;

    if (esCorrecta) {
      _respuestasCorrectas++;
      _xpTotalesGanados += xp;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    // Reporta el ejercicio al servidor (+10 si acerto, +2 si no).
    // No se espera: el XP del servidor no debe retrasar la animacion.
    //
    // Solo el primer intento de cada pregunta. Al fallar, la pregunta se
    // repite, y reportar cada reintento regalaba los puntos por
    // participacion tantas veces como el estudiante quisiera fallar.
    if (_reportadas.add(indice)) {
      ProgresoService.instance.registrarEjercicio(
        '${widget.leccion.id}-ej-${ejercicio.id}',
        correcto: esCorrecta,
        leccionId: widget.leccion.id,
      );
    }

    _mostrarResultado(esCorrecta, xp, ejercicio.explicacion);
  }

  void _irAlSiguiente() {
    _respuestaController.clear();
    if (_pasoActual < _ejercicios.length) {
      setState(() {
        _pasoActual++;
        // La selección es de la pregunta anterior; arrastrarla dejaría el
        // botón de comprobar activo antes de tocar nada.
        _respuestaElegida = null;
        _refrescarFrase();
      });
    } else {
      _completarLeccion();
    }
  }

  void _completarLeccion() {
    setState(() => _leccionCompletada = true);

    // Antes y después, para distinguir «este mundo acaba de cerrarse» de
    // «este mundo ya estaba cerrado y el estudiante repitió una lección».
    final servicio = ProgresoService.instance;
    final yaEstaba = servicio.estaMundoCompletado(widget.mundo);

    // Se lanza sin esperar, a proposito. El servicio actualiza XP, racha y
    // candados en memoria antes de tocar nada lento; lo que viene despues
    // es guardar en disco y reportar al servidor, y el estudiante no tiene
    // por que esperar a la red para ver su resumen. Con el servidor
    // inalcanzable, el await anterior congelaba la pantalla hasta que
    // expiraba la peticion.
    ProgresoService.instance.completarLeccion(
      widget.leccion.id,
      _xpTotalesGanados,
    );

    // `completarLeccion` marca la lección antes de su primer await, así
    // que esto ya refleja el estado nuevo aunque no se haya esperado.
    _mundoCerrado = !yaEstaba && servicio.estaMundoCompletado(widget.mundo);

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _mostrarResumen();
    });
  }

  // ==================== RETROALIMENTACIÓN ====================

  void _mostrarResultado(bool esCorrecta, int xp, List<String> explicacion) {
    final Color acento =
        esCorrecta ? const Color(0xFF2E9E5B) : const Color(0xFFD64545);
    final Color fondo =
        esCorrecta ? const Color(0xFFE8F6EE) : const Color(0xFFFCEBEB);

    // Se sortea aquí, fuera del `builder`, para que la hoja no cambie de
    // veredicto si se vuelve a dibujar mientras está abierta.
    final veredicto =
        esCorrecta ? FrasesMascota.acierto() : FrasesMascota.fallo();

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícono circular
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: acento,
              ),
              child: Icon(
                esCorrecta ? Icons.check_rounded : Icons.close_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 14),

            // Veredicto
            Text(
              veredicto,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: acento,
                letterSpacing: -0.3,
              ),
            ),

            // XP ganados
            if (esCorrecta) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: acento.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: acento, size: 17),
                    const SizedBox(width: 5),
                    Text(
                      '+$xp XP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: acento,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Explicación
            ...explicacion.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  p,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.5,
                    height: 1.55,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),
            _BotonPrincipal(
              texto: esCorrecta ? 'Continuar' : 'Intentar de nuevo',
              color: acento,
              onPressed: () {
                Navigator.pop(context);
                if (esCorrecta) _irAlSiguiente();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarResumen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(26, 30, 26, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Salta solo si la tanda salió entera. Celebrar un
                // 2 de 4 igual que un pleno convierte la celebración en
                // ruido de fondo: si siempre ocurre, no dice nada.
                MascotaESO(
                  size: 112,
                  saludoPeriodico: true,
                  gesto: _respuestasCorrectas == _ejercicios.length
                      ? GestoMascota.acierto
                      : GestoMascota.reposo,
                ),
                const SizedBox(height: 14),
                Text(
                  FrasesMascota.resumen(
                    aciertos: _respuestasCorrectas,
                    total: _ejercicios.length,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: widget.mundo.colorPrimario.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat(Icons.check_circle_outline_rounded,
                          '$_respuestasCorrectas/${_ejercicios.length}',
                          'Correctas'),
                      _stat(Icons.star_rounded, '+$_xpTotalesGanados', 'XP',
                          color: widget.mundo.colorPrimario),
                      _stat(Icons.local_fire_department_rounded, '+1',
                          'Racha'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Si esta lección cerró el mundo, antes de salir se
                      // ofrecen las tarjetas de realidad aumentada que
                      // practican lo que acaba de verse.
                      if (_mundoCerrado) {
                        _mostrarMundoCompletado();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.mundo.colorPrimario,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _pasoActual = 0;
                      _tarjetaActual = 0;
                      _respuestasCorrectas = 0;
                      _xpTotalesGanados = 0;
                      _leccionCompletada = false;
                      _respuestaElegida = null;
                      // Nuevo intento, nueva tanda: otro orden de
                      // preguntas y de opciones.
                      _prepararEjercicios();
                    });
                    _pageController.jumpToPage(0);
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: widget.mundo.colorPrimario),
                  child: const Text('Repasar la lección'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Al cerrar un mundo: las tarjetas de RA que practican ese temario.
  ///
  /// Es el puente que faltaba entre los dos componentes. El Modo Ruta
  /// enseña la norma y el escáner la pone en un caso, pero hasta ahora el
  /// estudiante que terminaba un tema no tenía manera de llegar al caso
  /// que lo practica: las tarjetas las imprimía el docente y quien no
  /// estaba ese día se quedaba fuera.
  void _mostrarMundoCompletado() {
    final color = widget.mundo.colorPrimario;
    final numero = _numeroDeMundo();
    final casos =
        numero == null ? const <CasoRA>[] : HojaMarcadores.casosDelMundo(numero);

    // Sin casos asociados no hay nada que ofrecer, y un diálogo que no
    // lleva a ninguna parte es peor que no mostrarlo.
    if (casos.isEmpty) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogo) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(26, 28, 26, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: MascotaESO(
                    size: 100,
                    saludoPeriodico: true,
                    gesto: GestoMascota.acierto,
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: _Etiqueta(texto: 'UNIDAD COMPLETA', color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  'Terminaste ${widget.mundo.nombre}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  casos.length == 1
                      ? 'Hay un caso de realidad aumentada que practica justo '
                          'esto. Imprime la tarjeta, déjala sobre la mesa y '
                          'apúntala con la pestaña Escáner AR.'
                      : 'Hay ${casos.length} casos de realidad aumentada que '
                          'practican justo esto. Imprime las tarjetas, '
                          'déjalas sobre la mesa y apúntalas con la pestaña '
                          'Escáner AR.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Las tienes siempre en el icono de tarjetas del Escáner '
                  'AR, por si prefieres imprimirlas en otro momento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final caso in casos)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.qr_code_2_rounded,
                                  size: 17, color: color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  caso.titulo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.35,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2A2A32),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => HojaMarcadores.imprimirMundo(
                    numero!,
                    titulo: widget.mundo.nombre,
                    // La hoja sale con el color de su mundo, el mismo que
                    // el estudiante acaba de ver en la ruta.
                    color: color,
                  ),
                  icon: const Icon(Icons.print_rounded, size: 19),
                  label: Text(
                    casos.length == 1
                        ? 'Imprimir la tarjeta'
                        : 'Imprimir las tarjetas',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogo);
                    // Primero se deshace la pila hasta el contenedor y
                    // después se le pide la pestaña: al revés, el cambio
                    // de pestaña quedaría tapado por las rutas que siguen
                    // encima.
                    Navigator.of(context).popUntil((r) => r.isFirst);
                    PestanaPrincipal.pedir(
                      PestanaPrincipal.realidadAumentada,
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: color),
                  child: const Text('Ir al escáner ahora'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? const Color(0xFF555555), size: 25),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF8A8A8A)),
        ),
      ],
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final enTeoria = _pasoActual == 0;
    final total = enTeoria ? _tarjetas.length : _ejercicios.length;
    final actual = enTeoria ? _tarjetaActual + 1 : _pasoActual;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFD),
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: _BarraProgreso(
          valor: total == 0 ? 0 : actual / total,
          color: widget.mundo.colorPrimario,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      mundo: widget.mundo,
                      capitulo: widget.capitulo,
                      leccion: widget.leccion,
                    ),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.mundo.colorPrimario.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.forum_rounded,
                        color: widget.mundo.colorPrimario, size: 17),
                    const SizedBox(width: 5),
                    Text(
                      'Tutor',
                      style: TextStyle(
                        color: widget.mundo.colorPrimario,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _leccionCompletada
          ? const SizedBox()
          : _enPuente
              ? _buildPuente()
              : enTeoria
                  ? _buildTeoria()
                  : _buildEjercicio(),
    );
  }

  // ==================== FASE DE TEORÍA ====================

  Widget _buildTeoria() {
    if (_tarjetas.isEmpty) return _buildSinContenido();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _tarjetas.length,
            onPageChanged: (i) => setState(() => _tarjetaActual = i),
            itemBuilder: (context, i) => _TarjetaVista(
              tarjeta: _tarjetas[i],
              color: widget.mundo.colorPrimario,
              primera: i == 0,
              indice: i + 1,
              total: _tarjetas.length,
            ),
          ),
        ),
        _buildPuntosYBoton(),
      ],
    );
  }

  Widget _buildPuntosYBoton() {
    final ultima = _tarjetaActual == _tarjetas.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
      decoration: const BoxDecoration(color: Color(0xFFFBFBFD)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _tarjetas.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                width: i == _tarjetaActual ? 24 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: i <= _tarjetaActual
                      ? widget.mundo.colorPrimario
                      : widget.mundo.colorPrimario.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _BotonPrincipal(
            texto: ultima ? 'Empezar los ejercicios' : 'Siguiente',
            color: widget.mundo.colorPrimario,
            onPressed: _avanzarTarjeta,
          ),
        ],
      ),
    );
  }

  /// El puente entre la teoría y los ejercicios.
  ///
  /// Antes se pasaba de la última tarjeta a la primera pregunta sin aviso:
  /// el estudiante seguía leyendo y de pronto le estaban preguntando.
  /// Separar las dos fases le da el momento de cambiar de disposición, que
  /// no cuesta nada y es justo lo que distingue estudiar de que te
  /// examinen.
  Widget _buildPuente() {
    final color = widget.mundo.colorPrimario;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 24, 30, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Aquí sí se mueve: es una pausa de dos frases, no una
            // pantalla de estudio. Durante los ejercicios se queda
            // quieta a propósito, que es cuando hay que pensar.
            const MascotaESO(size: 120, saludoPeriodico: true),
            const SizedBox(height: 18),
            _Etiqueta(texto: 'TEORÍA COMPLETA', color: color),
            const SizedBox(height: 14),
            const Text(
              'Pasemos a las preguntas de lo visto',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.6,
                color: Color(0xFF17171C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _ejercicios.length == 1
                  ? 'Una pregunta sobre lo que acabas de leer. Si fallas, la '
                      'vuelves a intentar.'
                  : 'Son ${_ejercicios.length} preguntas sobre lo que acabas '
                      'de leer. Si fallas alguna, la vuelves a intentar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.5,
                height: 1.55,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),
            _BotonPrincipal(
              texto: 'Empezar',
              color: color,
              onPressed: () => setState(() {
                _enPuente = false;
                _pasoActual = 1;
                _refrescarFrase();
              }),
            ),
            const SizedBox(height: 4),
            // Volver atrás tiene que ser posible: alguien querrá releer la
            // última idea antes de contestar, y obligarle a salir de la
            // lección para eso sería absurdo.
            TextButton(
              onPressed: () => setState(() => _enPuente = false),
              style: TextButton.styleFrom(foregroundColor: color),
              child: const Text('Volver a la teoría'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinContenido() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotaESO(size: 130),
            const SizedBox(height: 22),
            const Text(
              'Esta lección aún no tiene teoría',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Puedes pasar directo a los ejercicios.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 26),
            _BotonPrincipal(
              texto: 'Ir a los ejercicios',
              color: widget.mundo.colorPrimario,
              onPressed: () => setState(() {
                _pasoActual = 1;
                _refrescarFrase();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== FASE DE EJERCICIOS ====================

  Widget _buildEjercicio() {
    if (_pasoActual > _ejercicios.length) return const SizedBox();
    final ejercicio = _ejercicios[_pasoActual - 1];
    final color = widget.mundo.colorPrimario;

    // En el banco de palabras, el enunciado ya se dibuja dentro de la
    // tarjeta, con sus huecos en su sitio. Repetirlo arriba en negrita y
    // con los `___` a la vista mostraba la misma frase dos veces y dejaba
    // los guiones bajos crudos, que no significan nada para quien lee.
    final esBanco = ejercicio.tipo == TipoEjercicio.completarTexto &&
        _opciones[_pasoActual - 1].isNotEmpty;

    // La pantalla se divide en tres franjas, y solo la del medio se
    // desplaza.
    //
    // POR QUÉ LA MASCOTA Y EL BOTÓN NO SE DESPLAZAN
    // ---------------------------------------------
    // Antes todo iba dentro de un mismo área desplazable. Con preguntas
    // largas eso tenía dos consecuencias malas: la mascota se iba hacia
    // arriba y desaparecía justo cuando el estudiante está pensando, y
    // el botón de comprobar quedaba más abajo del borde, de modo que
    // había que bajar a buscarlo después de elegir.
    //
    // Fijando las dos franjas de los extremos, la mascota acompaña todo
    // el ejercicio y confirmar está siempre a un toque, se desplace lo
    // que se desplace el enunciado.
    return Column(
      children: [
        // ---------- Fijo: la mascota ----------
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MascotaESO(size: 70, saludoPeriodico: false),
              const SizedBox(width: 10),
              Expanded(child: _Burbuja(texto: _fraseBurbuja, color: color)),
            ],
          ),
        ),

        // ---------- Desplazable: enunciado y respuestas ----------
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _Etiqueta(
                    texto: 'PREGUNTA $_pasoActual DE ${_ejercicios.length}',
                    color: color,
                  ),
                ),
                if (!esBanco) ...[
                  const SizedBox(height: 10),
                  Text(
                    ejercicio.pregunta,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      height: 1.32,
                      letterSpacing: -0.3,
                      color: Color(0xFF17171C),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                _buildOpciones(ejercicio, _opciones[_pasoActual - 1]),
              ],
            ),
          ),
        ),

        // ---------- Fijo: pista y confirmación ----------
        Container(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 18),
          decoration: const BoxDecoration(
            color: Color(0xFFFBFBFD),
            border: Border(top: BorderSide(color: Color(0xFFEDEDF3))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (ejercicio.pista.isNotEmpty) ...[
                // La clave es necesaria: sin ella Flutter reutiliza el
                // State de la pista anterior y, una vez abierta una, las
                // siguientes aparecen ya desplegadas.
                _Pista(
                  key: ValueKey('pista-${ejercicio.id}'),
                  texto: ejercicio.pista,
                  color: color,
                ),
                const SizedBox(height: 10),
              ],
              _BotonPrincipal(
                texto: 'Comprobar',
                color: color,
                onPressed: _respuestaElegida == null
                    ? null
                    : () => _responderEjercicio(_respuestaElegida!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// [opciones] llega ya barajada desde [_prepararEjercicios]; no se usa
  /// `ejercicio.opciones` directamente para no mostrar siempre el mismo
  /// orden del archivo de datos.
  ///
  /// Ningún tipo de ejercicio comprueba por su cuenta: todos se limitan a
  /// dejar la respuesta en [_respuestaElegida] y el único botón de
  /// comprobar vive al pie de la pantalla. Así el gesto de confirmar
  /// está siempre en el mismo sitio, se escriba, se toque o se arme la
  /// respuesta.
  Widget _buildOpciones(Ejercicio ejercicio, List<String> opciones) {
    final color = widget.mundo.colorPrimario;

    switch (ejercicio.tipo) {
      case TipoEjercicio.multipleChoice:
        // `stretch` es lo que faltaba: sin él, el Column centra a los
        // hijos y cada tarjeta se encoge hasta el ancho de su texto, de
        // modo que «ISO 9001» salía mucho más estrecha que
        // «ISO/IEC/IEEE 12207» y la columna quedaba dentada.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: opciones
              .map(
                (opcion) => _OpcionCard(
                  texto: opcion,
                  color: color,
                  seleccionada: _respuestaElegida == opcion,
                  onTap: () => _elegir(opcion),
                ),
              )
              .toList(),
        );

      case TipoEjercicio.verdaderoFalso:
        return Row(
          children: [
            Expanded(
              child: _BotonVF(
                texto: 'Verdadero',
                icono: Icons.check_rounded,
                color: const Color(0xFF2E9E5B),
                seleccionado: _respuestaElegida == 'true',
                onTap: () => _elegir('true'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _BotonVF(
                texto: 'Falso',
                icono: Icons.close_rounded,
                color: const Color(0xFFD64545),
                seleccionado: _respuestaElegida == 'false',
                onTap: () => _elegir('false'),
              ),
            ),
          ],
        );

      case TipoEjercicio.completarTexto:
        // Si el ejercicio trae opciones, se resuelve tocando palabras de
        // un banco en vez de escribiendo. Es más rápido en el teléfono,
        // evita las erratas y se parece a lo que el estudiante ya conoce
        // de otras apps de aprendizaje.
        //
        // No hace falta un tipo nuevo en el modelo: la validación de
        // `completarTexto` compara el texto de la respuesta, y el banco
        // entrega exactamente eso, las palabras elegidas unidas por
        // espacios.
        if (opciones.isNotEmpty) {
          return _BancoPalabras(
            key: ValueKey('banco-${ejercicio.id}'),
            enunciado: ejercicio.pregunta,
            palabras: opciones,
            color: color,
            onCambio: (respuesta) => setState(
              () => _respuestaElegida = respuesta,
            ),
          );
        }
        return TextField(
          controller: _respuestaController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(fontSize: 16),
          onChanged: (v) => setState(
            () => _respuestaElegida = v.trim().isEmpty ? null : v,
          ),
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: color.withOpacity(0.25), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: color.withOpacity(0.25), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: color, width: 2),
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        );

      default:
        return const SizedBox();
    }
  }
}

// =====================================================================
// WIDGETS DE APOYO
// =====================================================================

/// Barra de progreso del encabezado.
class _BarraProgreso extends StatelessWidget {
  final double valor;
  final Color color;

  const _BarraProgreso({required this.valor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: valor.clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 340),
          curve: Curves.easeOut,
          builder: (context, v, _) => LinearProgressIndicator(
            value: v,
            minHeight: 11,
            backgroundColor: color.withOpacity(0.13),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ),
    );
  }
}

/// Burbuja de diálogo con punta hacia la izquierda.
class _Burbuja extends StatelessWidget {
  final String texto;
  final Color color;

  const _Burbuja({required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          height: 1.35,
          color: Color(0xFF2E2E2E),
        ),
      ),
    );
  }
}

/// Una tarjeta de teoría. El contenido se centra verticalmente cuando
/// es corto, y pasa a desplazarse cuando no cabe.
/// POR QUÉ EL CUERPO VA DENTRO DE UNA TARJETA BLANCA
/// -------------------------------------------------
/// Antes el título y el texto flotaban sueltos sobre el fondo. Con
/// treinta o cuarenta palabras por pantalla, eso deja dos huecos enormes
/// arriba y abajo y la lección parece sin terminar. Encerrar el cuerpo
/// en una superficie con borde y relleno generoso le da un contorno: la
/// misma cantidad de texto ocupa un bloque reconocible en vez de flotar.
///
/// Es un parche de presentación, no la solución. Lo que de verdad
/// llena estas pantallas es más contenido por tarjeta.
class _TarjetaVista extends StatelessWidget {
  final TarjetaTeoria tarjeta;
  final Color color;
  final bool primera;
  final int indice;
  final int total;

  const _TarjetaVista({
    required this.tarjeta,
    required this.color,
    required this.primera,
    required this.indice,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // Igual que en los ejercicios: la mascota se queda fija arriba y solo
    // se desplaza la tarjeta. Con las lecciones ampliadas hay tarjetas
    // que ya no caben de una vez, y al desplazarlas la mascota se perdía.
    return Column(
      children: [
        // ---------- Fijo: la mascota ----------
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MascotaESO(size: primera ? 92 : 74, saludoPeriodico: primera),
              const SizedBox(width: 10),
              Expanded(child: _Burbuja(texto: tarjeta.mensaje, color: color)),
            ],
          ),
        ),

        // ---------- Desplazable: el cuerpo de la idea ----------
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                // Centrada cuando la idea es corta; desde arriba cuando no
                // cabe, que es el comportamiento natural al desplazarse.
                child: Center(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFEAEAF2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Etiqueta(
                      texto: 'IDEA $indice DE $total',
                      color: color,
                    ),
                    const SizedBox(height: 12),

                    if (tarjeta.titulo.isNotEmpty) ...[
                      Text(
                        tarjeta.titulo,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.6,
                          color: Color(0xFF17171C),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    if (tarjeta.texto.isNotEmpty)
                      Text(
                        tarjeta.texto,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.62,
                          color: Color(0xFF45454D),
                        ),
                      ),

                    if (tarjeta.vinetas.isNotEmpty) ...[
                      if (tarjeta.texto.isNotEmpty) const SizedBox(height: 18),
                      ...tarjeta.vinetas.map(
                        (v) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 7),
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  v,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    height: 1.5,
                                    color: Color(0xFF32323A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    if (tarjeta.destacado != null) ...[
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.lightbulb_rounded,
                                  color: color, size: 17),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tarjeta.destacado!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Color(0xFF3A3A42),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Rótulo pequeño en versales que encabeza un bloque.
class _Etiqueta extends StatelessWidget {
  final String texto;
  final Color color;

  const _Etiqueta({required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Pista colapsable al pie del ejercicio.
class _Pista extends StatefulWidget {
  final String texto;
  final Color color;

  const _Pista({super.key, required this.texto, required this.color});

  @override
  State<_Pista> createState() => _PistaState();
}

class _PistaState extends State<_Pista> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return Center(
        child: TextButton.icon(
          onPressed: () => setState(() => _visible = true),
          icon: Icon(Icons.lightbulb_outline_rounded,
              size: 18, color: widget.color),
          label: Text(
            'Ver una pista',
            style: TextStyle(
                color: widget.color,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: widget.color, size: 19),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              widget.texto,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: Color(0xFF45454D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opción de respuesta.
///
/// Tiene tres estados y los tres se ven distintos: en reposo, marcada
/// (el estudiante la eligió pero aún no comprueba) y pulsada. El estado
/// marcado es el que faltaba: sin él no había forma de saber qué
/// habías elegido antes de confirmar.
class _OpcionCard extends StatefulWidget {
  final String texto;
  final Color color;
  final bool seleccionada;
  final VoidCallback onTap;

  const _OpcionCard({
    required this.texto,
    required this.color,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  State<_OpcionCard> createState() => _OpcionCardState();
}

class _OpcionCardState extends State<_OpcionCard> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
    final marcada = widget.seleccionada;

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionada = true),
      onTapCancel: () => setState(() => _presionada = false),
      onTapUp: (_) {
        setState(() => _presionada = false);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: marcada || _presionada
              ? widget.color.withOpacity(0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: marcada || _presionada
                ? widget.color
                : widget.color.withOpacity(0.22),
            width: marcada ? 2.4 : 2,
          ),
          boxShadow: marcada || _presionada
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.texto,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: marcada
                      ? widget.color
                      : const Color(0xFF2A2A32),
                  fontWeight: marcada ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (marcada) ...[
              const SizedBox(width: 10),
              Icon(Icons.check_circle_rounded, color: widget.color, size: 21),
            ],
          ],
        ),
      ),
    );
  }
}

/// Botón de acción principal, con relieve.
///
/// POR QUÉ EL LABIO INFERIOR
/// -------------------------
/// Es el detalle que separa un botón plano de uno que parece una tecla:
/// una franja más oscura de cuatro píxeles bajo el botón, que desaparece
/// al pulsarlo mientras el botón baja esos mismos cuatro píxeles. El
/// movimiento es mínimo y es lo que hace que la pantalla se sienta
/// física en lugar de inerte.
///
/// El labio se consigue con un contenedor oscuro detrás y relleno
/// inferior, no con `Border(bottom:)`: un borde no uniforme combinado
/// con `borderRadius` hace saltar una aserción de BoxDecoration.
class _BotonPrincipal extends StatefulWidget {
  final String texto;
  final Color color;
  final VoidCallback? onPressed;

  const _BotonPrincipal({
    required this.texto,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_BotonPrincipal> createState() => _BotonPrincipalState();
}

class _BotonPrincipalState extends State<_BotonPrincipal> {
  bool _abajo = false;

  @override
  Widget build(BuildContext context) {
    final activo = widget.onPressed != null;
    final base = activo ? widget.color : const Color(0xFFE4E4ED);
    final sombra = activo
        ? Color.lerp(widget.color, Colors.black, 0.28)!
        : const Color(0xFFD2D2DE);
    final hundido = _abajo && activo;

    return GestureDetector(
      onTapDown: activo ? (_) => setState(() => _abajo = true) : null,
      onTapCancel: activo ? () => setState(() => _abajo = false) : null,
      onTapUp: activo
          ? (_) {
              setState(() => _abajo = false);
              widget.onPressed!();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(top: hundido ? 4 : 0),
        padding: EdgeInsets.only(bottom: hundido ? 0 : 4),
        decoration: BoxDecoration(
          color: sombra,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(
            widget.texto,
            style: TextStyle(
              color: activo ? Colors.white : const Color(0xFFA0A0AE),
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón de verdadero o falso.
class _BotonVF extends StatefulWidget {
  final String texto;
  final IconData icono;
  final Color color;
  final bool seleccionado;
  final VoidCallback onTap;

  const _BotonVF({
    required this.texto,
    required this.icono,
    required this.color,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  State<_BotonVF> createState() => _BotonVFState();
}

class _BotonVFState extends State<_BotonVF> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapCancel: () => setState(() => _presionado = false),
      onTapUp: (_) {
        setState(() => _presionado = false);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: widget.seleccionado
              ? widget.color
              : _presionado
                  ? widget.color.withOpacity(0.18)
                  : widget.color.withOpacity(0.07),
          border: Border.all(
            color: widget.color,
            width: widget.seleccionado ? 2.4 : 2,
          ),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Icon(
              widget.icono,
              color: widget.seleccionado ? Colors.white : widget.color,
              size: 26,
            ),
            const SizedBox(height: 7),
            Text(
              widget.texto,
              style: TextStyle(
                color: widget.seleccionado ? Colors.white : widget.color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// Ejercicio de completar con un banco de palabras.
///
/// CÓMO SE USA
/// -----------
/// El enunciado del ejercicio lleva uno o varios `___`, y cada uno se
/// convierte en un hueco. Debajo aparecen las palabras del campo
/// `opciones`, ya barajadas. El estudiante toca una palabra y esta salta
/// al primer hueco libre; toca un hueco ocupado y la palabra vuelve al
/// banco.
///
/// POR QUÉ NO LLEVA UN TIPO PROPIO EN EL MODELO
/// --------------------------------------------
/// Porque no hace falta. Es un `completarTexto` con `opciones`, y la
/// validación existente compara el texto de la respuesta: el banco
/// entrega las palabras elegidas unidas por espacios y la comparación
/// funciona igual, con su tolerancia a erratas incluida. Añadir un valor
/// al enum habría obligado a tocar el modelo y todos los `switch` que lo
/// recorren, a cambio de nada.
///
/// POR QUÉ LA PALABRA USADA NO DESAPARECE DEL BANCO
/// ------------------------------------------------
/// Se deja un hueco invisible en su sitio. Si las fichas se recolocaran
/// al usar una, las demás cambiarían de posición entre toque y toque, y
/// acertar pasaría a depender de la puntería.
class _BancoPalabras extends StatefulWidget {
  final String enunciado;
  final List<String> palabras;
  final Color color;

  /// Avisa a la pantalla de la respuesta en curso: el texto completo
  /// cuando no queda ningún hueco libre, y `null` mientras falte alguno.
  ///
  /// El banco no comprueba por su cuenta; el botón vive al pie de la
  /// pantalla, igual que en los demás tipos de ejercicio.
  final void Function(String?) onCambio;

  const _BancoPalabras({
    super.key,
    required this.enunciado,
    required this.palabras,
    required this.color,
    required this.onCambio,
  });

  @override
  State<_BancoPalabras> createState() => _BancoPalabrasState();
}

class _BancoPalabrasState extends State<_BancoPalabras> {
  /// Trozos del enunciado entre hueco y hueco.
  late final List<String> _partes;

  /// Para cada hueco, el índice de la palabra del banco que lo ocupa.
  late List<int?> _puestas;

  @override
  void initState() {
    super.initState();
    _partes = widget.enunciado.split('___');
    // Si el enunciado no trae ningún `___`, se asume un hueco al final.
    final huecos = _partes.length > 1 ? _partes.length - 1 : 1;
    _puestas = List<int?>.filled(huecos, null);
  }

  bool get _completo => _puestas.every((p) => p != null);

  String get _respuesta => _puestas
      .map((i) => i == null ? '' : widget.palabras[i])
      .join(' ')
      .trim();

  void _colocar(int indiceBanco) {
    final libre = _puestas.indexOf(null);
    if (libre == -1) return;
    HapticFeedback.selectionClick();
    setState(() => _puestas[libre] = indiceBanco);
    _avisar();
  }

  void _quitar(int hueco) {
    HapticFeedback.selectionClick();
    setState(() => _puestas[hueco] = null);
    _avisar();
  }

  /// Notifica a la pantalla tras el frame en curso.
  ///
  /// Llamar al callback durante el `setState` del hijo provocaría un
  /// `setState` del padre en plena construcción, que Flutter rechaza.
  void _avisar() {
    final valor = _completo ? _respuesta : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onCambio(valor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _frase(),
        const SizedBox(height: 22),
        _Etiqueta(texto: 'TOCA LAS PALABRAS', color: widget.color),
        const SizedBox(height: 12),
        _banco(),
      ],
    );
  }

  /// La frase con sus huecos, dentro de una tarjeta.
  Widget _frase() {
    final hijos = <Widget>[];

    for (var i = 0; i < _partes.length; i++) {
      for (final palabra in _partes[i].split(RegExp(r'\s+'))) {
        if (palabra.isEmpty) continue;
        hijos.add(
          Text(
            palabra,
            style: const TextStyle(
              fontSize: 17,
              height: 1.2,
              color: Color(0xFF32323A),
            ),
          ),
        );
      }
      if (i < _puestas.length) hijos.add(_hueco(i));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAEAF2)),
      ),
      // Cada palabra es un hijo del Wrap, así que el espacio entre ellas
      // lo fija `spacing` y no el espacio tipográfico normal. Con 7 se
      // veían desperdigadas; 5 se acerca a cómo se lee un párrafo.
      child: Wrap(
        spacing: 5,
        runSpacing: 9,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: hijos,
      ),
    );
  }

  Widget _hueco(int i) {
    final indice = _puestas[i];

    if (indice == null) {
      return Container(
        width: 82,
        height: 34,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.color.withOpacity(0.38),
            width: 1.6,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _quitar(i),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.palabras[indice],
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _banco() {
    return Wrap(
      spacing: 9,
      runSpacing: 10,
      children: [
        for (var i = 0; i < widget.palabras.length; i++) _ficha(i),
      ],
    );
  }

  Widget _ficha(int i) {
    final usada = _puestas.contains(i);

    final ficha = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.color.withOpacity(0.3), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.palabras[i],
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2A2A32),
        ),
      ),
    );

    // Hueco invisible: conserva el sitio para que el banco no se mueva.
    if (usada) {
      return IgnorePointer(child: Opacity(opacity: 0, child: ficha));
    }

    return GestureDetector(onTap: () => _colocar(i), child: ficha);
  }
}