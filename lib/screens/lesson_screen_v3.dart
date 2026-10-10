import 'package:flutter/material.dart';
import '../models/SeccionSilabo.dart';
import '../models/ejercicio_model.dart';
import '../services/progreso_service.dart';
import '../data/mock_preguntas.dart';
import '../data/mock_contenidos.dart';
import 'chat_screen.dart';
import '../widgets/mascota_eso.dart';

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
  int _pasoActual = 0;
  int _tarjetaActual = 0;
  int _respuestasCorrectas = 0;
  int _xpTotalesGanados = 0;
  bool _leccionCompletada = false;

  late List<Ejercicio> _ejercicios;
  ContenidoLeccion? _contenido;

  final PageController _pageController = PageController();
  final TextEditingController _respuestaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ejercicios = MockPreguntas.obtenerPreguntasLeccion(widget.leccion.id);
    if (_ejercicios.isEmpty) {
      _ejercicios = MockPreguntas.obtenerPreguntasLeccion('default');
    }
    _contenido = MockContenidos.obtenerContenido(widget.leccion.id);
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
      setState(() => _pasoActual = 1);
    }
  }

  void _responderEjercicio(String respuesta) {
    if (_pasoActual == 0 || _leccionCompletada) return;
    if (respuesta.trim().isEmpty) return;

    final ejercicio = _ejercicios[_pasoActual - 1];
    final esCorrecta = ejercicio.validarRespuesta(respuesta);
    final xp = esCorrecta ? ejercicio.xpPorRespuesta : 0;

    if (esCorrecta) {
      _respuestasCorrectas++;
      _xpTotalesGanados += xp;
    }
    // Reporta el ejercicio al servidor (+10 si acerto, +2 si no).
    // No se espera: el XP del servidor no debe retrasar la animacion.
    ProgresoService.instance.registrarEjercicio(
      '${widget.leccion.id}-ej-$_pasoActual',
      correcto: esCorrecta,
      leccionId: widget.leccion.id,
    );

    _mostrarResultado(esCorrecta, xp, ejercicio.explicacion);
  }

  void _irAlSiguiente() {
    _respuestaController.clear();
    if (_pasoActual < _ejercicios.length) {
      setState(() => _pasoActual++);
    } else {
      _completarLeccion();
    }
  }

  Future<void> _completarLeccion() async {
    setState(() => _leccionCompletada = true);

    // Ademas de marcarla en memoria, la guarda en el dispositivo y la
    // reporta al servidor (+20 XP y racha). No vuelve a reportar si la
    // leccion ya estaba completada: el backend no deduplica.
    await ProgresoService.instance.completarLeccion(
      widget.leccion.id,
      _xpTotalesGanados,
    );

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
              esCorrecta ? '¡Muy bien!' : 'Casi',
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (esCorrecta) _irAlSiguiente();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: acento,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  esCorrecta ? 'Continuar' : 'Intentar de nuevo',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
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
                const MascotaESO(size: 112),
                const SizedBox(height: 14),
                const Text(
                  '¡Lección completada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                      Navigator.pop(context);
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _avanzarTarjeta,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.mundo.colorPrimario,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: Text(
                ultima ? 'Empezar los ejercicios' : 'Siguiente',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
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
            ElevatedButton(
              onPressed: () => setState(() => _pasoActual = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.mundo.colorPrimario,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Ir a los ejercicios',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MascotaESO(size: 76, saludoPeriodico: false),
              const SizedBox(width: 10),
              Expanded(
                child: _Burbuja(
                  texto: 'Pregunta $_pasoActual de ${_ejercicios.length}',
                  color: widget.mundo.colorPrimario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            ejercicio.pregunta,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.32,
              letterSpacing: -0.3,
              color: Color(0xFF17171C),
            ),
          ),
          const SizedBox(height: 26),
          _buildOpciones(ejercicio),
          if (ejercicio.pista.isNotEmpty) ...[
            const SizedBox(height: 10),
            _Pista(
              texto: ejercicio.pista,
              color: widget.mundo.colorPrimario,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOpciones(Ejercicio ejercicio) {
    switch (ejercicio.tipo) {
      case TipoEjercicio.multipleChoice:
        return Column(
          children: ejercicio.opciones
              .map(
                (opcion) => _OpcionCard(
                  texto: opcion,
                  color: widget.mundo.colorPrimario,
                  onTap: () => _responderEjercicio(opcion),
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
                onTap: () => _responderEjercicio('true'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _BotonVF(
                texto: 'Falso',
                icono: Icons.close_rounded,
                color: const Color(0xFFD64545),
                onTap: () => _responderEjercicio('false'),
              ),
            ),
          ],
        );

      case TipoEjercicio.completarTexto:
        return Column(
          children: [
            TextField(
              controller: _respuestaController,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: widget.mundo.colorPrimario.withOpacity(0.25),
                      width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: widget.mundo.colorPrimario.withOpacity(0.25),
                      width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: widget.mundo.colorPrimario, width: 2),
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
              onSubmitted: (_) =>
                  _responderEjercicio(_respuestaController.text),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    _responderEjercicio(_respuestaController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.mundo.colorPrimario,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text('Comprobar',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
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
class _TarjetaVista extends StatelessWidget {
  final TarjetaTeoria tarjeta;
  final Color color;
  final bool primera;

  const _TarjetaVista({
    required this.tarjeta,
    required this.color,
    required this.primera,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mascota y burbuja
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MascotaESO(
                    size: primera ? 100 : 78,
                    saludoPeriodico: primera,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Burbuja(texto: tarjeta.mensaje, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              if (tarjeta.titulo.isNotEmpty) ...[
                Text(
                  tarjeta.titulo,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.6,
                    color: Color(0xFF17171C),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (tarjeta.texto.isNotEmpty)
                Text(
                  tarjeta.texto,
                  style: const TextStyle(
                    fontSize: 16.5,
                    height: 1.65,
                    color: Color(0xFF45454D),
                  ),
                ),

              if (tarjeta.vinetas.isNotEmpty) ...[
                if (tarjeta.texto.isNotEmpty) const SizedBox(height: 20),
                ...tarjeta.vinetas.map(
                  (v) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEDEDF2)),
                    ),
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
                              height: 1.45,
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
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                            height: 1.55,
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
    );
  }
}

/// Pista colapsable al pie del ejercicio.
class _Pista extends StatefulWidget {
  final String texto;
  final Color color;

  const _Pista({required this.texto, required this.color});

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

/// Opción de respuesta con efecto de pulsación.
class _OpcionCard extends StatefulWidget {
  final String texto;
  final Color color;
  final VoidCallback onTap;

  const _OpcionCard({
    required this.texto,
    required this.color,
    required this.onTap,
  });

  @override
  State<_OpcionCard> createState() => _OpcionCardState();
}

class _OpcionCardState extends State<_OpcionCard> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
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
          color: _presionada ? widget.color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: _presionada
                ? widget.color
                : widget.color.withOpacity(0.22),
            width: 2,
          ),
          boxShadow: _presionada
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          widget.texto,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Color(0xFF2A2A32),
            fontWeight: FontWeight.w500,
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
  final VoidCallback onTap;

  const _BotonVF({
    required this.texto,
    required this.icono,
    required this.color,
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
          color: _presionado
              ? widget.color.withOpacity(0.18)
              : widget.color.withOpacity(0.07),
          border: Border.all(color: widget.color, width: 2),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Icon(widget.icono, color: widget.color, size: 26),
            const SizedBox(height: 7),
            Text(
              widget.texto,
              style: TextStyle(
                color: widget.color,
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