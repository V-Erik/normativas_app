import 'package:flutter/material.dart';
import '../models/SeccionSilabo.dart';
import '../models/ejercicio_model.dart';
import '../services/progreso_service.dart';
import '../theme/app_theme.dart';
import '../data/mock_preguntas.dart';
import 'chat_screen.dart';

/// Pantalla de Lección: Explicación → Ejercicios → Rewards
/// Estilo Duolingo: contenido educativo + ejercicios interactivos
class LessonScreen extends StatefulWidget {
  final SeccionSilabo mundo;
  final CapituloSilabo capitulo;
  final LeccionSilabo leccion;

  const LessonScreen({
    super.key,
    required this.mundo,
    required this.capitulo,
    required this.leccion,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _pasoActual = 0; // 0: Explicación, 1+: Ejercicios
  int _respuestasCorrectas = 0;
  int _xpTotalesGanados = 0;
  bool _leccionCompletada = false;

  // Ejercicios para esta lección
  late List<Ejercicio> _ejercicios;

  @override
  void initState() {
    super.initState();
    _inicializarEjercicios();
  }

  void _inicializarEjercicios() {
    // Obtener preguntas específicas para esta lección
    _ejercicios = MockPreguntas.obtenerPreguntasLeccion(widget.leccion.id);

    // Si no hay preguntas, usar por defecto
    if (_ejercicios.isEmpty) {
      _ejercicios = MockPreguntas.obtenerPreguntasLeccion('default');
    }
  }

  void _responderEjercicio(String respuesta) {
    if (_pasoActual == 0 || _leccionCompletada) return;

    final ejercicio = _ejercicios[_pasoActual - 1];
    final esCorrecta = ejercicio.validarRespuesta(respuesta);

    int xpGanados = esCorrecta ? ejercicio.xpPorRespuesta : 0;

    if (esCorrecta) {
      _respuestasCorrectas++;
      _xpTotalesGanados += xpGanados;
    }

    _mostrarResultado(esCorrecta, xpGanados, ejercicio.explicacion);
  }

  void _mostrarResultado(
      bool esCorrecta, int xp, List<String> explicacion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono de resultado
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: esCorrecta
                      ? widget.mundo.colorPrimario.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(
                    esCorrecta ? Icons.check_rounded : Icons.close_rounded,
                    size: 40,
                    color: esCorrecta ? widget.mundo.colorPrimario : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Texto
              Text(
                esCorrecta ? '¡Correcto!' : 'Intenta de nuevo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: esCorrecta
                          ? widget.mundo.colorPrimario
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Explicación
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.mundo.colorPrimario.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explicación:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...explicacion.map(
                      (punto) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $punto',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // XP ganados
              if (esCorrecta)
                Text(
                  '+$xp XP',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: widget.mundo.colorPrimario,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const SizedBox(height: 16),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _irAlSiguiente();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.mundo.colorPrimario,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(esCorrecta ? 'Siguiente' : 'Reintentar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _irAlSiguiente() {
    if (_pasoActual < _ejercicios.length) {
      setState(() => _pasoActual++);
    } else {
      _completarLeccion();
    }
  }

  void _completarLeccion() {
    setState(() => _leccionCompletada = true);

    // Guardar progreso
    ProgresoService.instance.completarLeccion(
      widget.leccion.id,
      _xpTotalesGanados,
      ProgresoService.instance.obtenerMundos(),
    );

    // Mostrar resumen
    Future.delayed(const Duration(milliseconds: 500), () {
      _mostrarResumen();
    });
  }

  void _mostrarResumen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text(
                '¡Lección Completada!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Stats
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.mundo.colorPrimario.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox(
                      icon: Icons.check_rounded,
                      value: '${_respuestasCorrectas}/${_ejercicios.length}',
                      label: 'Correctas',
                    ),
                    _buildStatBox(
                      icon: Icons.star_rounded,
                      value: '+$_xpTotalesGanados',
                      label: 'XP',
                      color: widget.mundo.colorPrimario,
                    ),
                    _buildStatBox(
                      icon: Icons.local_fire_department_rounded,
                      value: '+1',
                      label: 'Racha',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botones
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.mundo.colorPrimario,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Siguiente Lección'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _pasoActual = 0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: widget.mundo.colorPrimario,
                      side: BorderSide(color: widget.mundo.colorPrimario),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Repasar Lección'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.black, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mundo.numeroMundo}. ${widget.leccion.titulo}'),
        backgroundColor: widget.mundo.colorPrimario,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Avatar/Mascota
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const Text('🤖', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          // Botón de ayuda (tutor IA)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.help_outline_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Ayuda',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _leccionCompletada
          ? const SizedBox()
          : _pasoActual == 0
              ? _buildExplicacion()
              : _buildEjercicio(),
    );
  }

  Widget _buildExplicacion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascota hablando
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.mundo.colorPrimario.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.mundo.colorPrimario.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Text('🤖', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola! Vamos a aprender',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lee el contenido y luego responde las preguntas',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Título
          Text(
            widget.leccion.titulo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Contenido (placeholder)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.mundo.colorPrimario.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Concepto Principal',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.mundo.colorPrimario,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'En esta lección aprenderemos sobre ${widget.leccion.titulo}. '
                  'Este es un contenido importante para entender '
                  '${widget.capitulo.nombre}.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

                // Puntos clave
                Text(
                  'Puntos Clave:',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...[
                  'Punto principal del concepto',
                  'Aplicación práctica',
                  'Importancia en ingeniería de software',
                ].map(
                  (punto) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_rounded,
                            color: widget.mundo.colorPrimario, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(punto,
                              style:
                                  Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botón continuar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _pasoActual = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.mundo.colorPrimario,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                '¿Entiendes? Continuar a Ejercicios',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEjercicio() {
    if (_pasoActual > _ejercicios.length) {
      return const SizedBox();
    }

    final ejercicio = _ejercicios[_pasoActual - 1];
    final numeroEjercicio = _pasoActual;
    final totalEjercicios = _ejercicios.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascota hablando
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.mundo.colorPrimario.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.mundo.colorPrimario.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Text('🤖', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '¡Vamos! Responde esta pregunta',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Número de ejercicio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pregunta $numeroEjercicio de $totalEjercicios',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF999999),
                    ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: numeroEjercicio / totalEjercicios,
                      minHeight: 4,
                      backgroundColor:
                          widget.mundo.colorPrimario.withOpacity(0.2),
                      valueColor:
                          AlwaysStoppedAnimation(widget.mundo.colorPrimario),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pregunta
          Text(
            ejercicio.pregunta,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Componente de ejercicio según tipo
          _buildEjercicioSegunTipo(ejercicio),

          const SizedBox(height: 24),

          // Pista
          if (ejercicio.pista.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pista: ${ejercicio.pista}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEjercicioSegunTipo(Ejercicio ejercicio) {
    switch (ejercicio.tipo) {
      case TipoEjercicio.multipleChoice:
        return _buildMultipleChoice(ejercicio);

      case TipoEjercicio.verdaderoFalso:
        return _buildVerdaderoFalso(ejercicio);

      case TipoEjercicio.completarTexto:
        return _buildCompletarTexto(ejercicio);

      default:
        return const SizedBox();
    }
  }

  Widget _buildMultipleChoice(Ejercicio ejercicio) {
    return Column(
      children: ejercicio.opciones
          .map(
            (opcion) => GestureDetector(
              onTap: () => _responderEjercicio(opcion),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: widget.mundo.colorPrimario.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.mundo.colorPrimario.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opcion,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildVerdaderoFalso(Ejercicio ejercicio) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _responderEjercicio('true'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Verdadero',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _responderEjercicio('false'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Falso',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletarTexto(Ejercicio ejercicio) {
    final controller = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta aquí',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.mundo.colorPrimario.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.mundo.colorPrimario,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onSubmitted: (_) => _responderEjercicio(controller.text),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _responderEjercicio(controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.mundo.colorPrimario,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Verificar Respuesta'),
          ),
        ),
      ],
    );
  }
}