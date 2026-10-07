import 'package:flutter/material.dart';
import '../models/SeccionSilabo.dart';
import '../services/progreso_service.dart';
import '../widgets/mascota_eso.dart';
import 'silabo_chapter_screen.dart';

/// Capítulos de un mundo, presentados como una ruta vertical.
class SilabusRoadmapScreen extends StatelessWidget {
  final SeccionSilabo mundo;

  const SilabusRoadmapScreen({super.key, required this.mundo});

  void _abrirCapitulo(BuildContext context, CapituloSilabo capitulo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SilabusChapterScreen(mundo: mundo, capitulo: capitulo),
      ),
    );
  }

  void _avisoBloqueado(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Termina el capítulo anterior para abrir este'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E2E38),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProgresoService.instance,
      builder: (context, _) {
        final servicio = ProgresoService.instance;
        final color = mundo.colorPrimario;
        final avance = servicio.obtenerProgresoMundo(mundo);
        final hechas = servicio.contarLeccionesCompletadas(mundo);
        final totales = servicio.contarLeccionesTotales(mundo);

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              _Cabecera(
                mundo: mundo,
                avance: avance,
                hechas: hechas,
                totales: totales,
              ),

              Transform.translate(
                offset: const Offset(0, -34),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Objetivo del mundo
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LO QUE VAS A LOGRAR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.3,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              mundo.objetivoAprendizaje,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xFF3A3A44),
                              ),
                            ),
                            if (mundo.normasAsociadas.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 7,
                                runSpacing: 7,
                                children: [
                                  for (final norma in mundo.normasAsociadas)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        norma,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Text(
                        'Capítulos',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: Color(0xFF17171C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ruta de capítulos
                      for (var i = 0; i < mundo.capitulos.length; i++)
                        _NodoCapitulo(
                          capitulo: mundo.capitulos[i],
                          color: color,
                          esUltimo: i == mundo.capitulos.length - 1,
                          servicio: servicio,
                          onTap: () {
                            final cap = mundo.capitulos[i];
                            if (servicio.estaCapituloDesbloqueado(cap)) {
                              _abrirCapitulo(context, cap);
                            } else {
                              _avisoBloqueado(context);
                            }
                          },
                        ),
                    ],
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

// =====================================================================
// CABECERA
// =====================================================================

class _Cabecera extends StatelessWidget {
  final SeccionSilabo mundo;
  final double avance;
  final int hechas;
  final int totales;

  const _Cabecera({
    required this.mundo,
    required this.avance,
    required this.hechas,
    required this.totales,
  });

  @override
  Widget build(BuildContext context) {
    final color = mundo.colorPrimario;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.28)!],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 26),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UNIDAD ${mundo.numeroMundo}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mundo.nombre,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const MascotaESO(size: 78),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: avance.clamp(0.0, 1.0)),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 9,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        valueColor:
                            const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$hechas de $totales',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// NODO DE CAPÍTULO
// =====================================================================

class _NodoCapitulo extends StatefulWidget {
  final CapituloSilabo capitulo;
  final Color color;
  final bool esUltimo;
  final ProgresoService servicio;
  final VoidCallback onTap;

  const _NodoCapitulo({
    required this.capitulo,
    required this.color,
    required this.esUltimo,
    required this.servicio,
    required this.onTap,
  });

  @override
  State<_NodoCapitulo> createState() => _NodoCapituloState();
}

class _NodoCapituloState extends State<_NodoCapitulo> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final cap = widget.capitulo;
    final color = widget.color;
    final completado = widget.servicio.estaCapituloCompletado(cap);
    final abierto = widget.servicio.estaCapituloDesbloqueado(cap);
    final avance = widget.servicio.obtenerProgreso(cap);
    final enCurso = abierto && avance > 0 && !completado;

    final hechas = cap.lecciones
        .where((l) => widget.servicio.estaLeccionCompletada(l.id))
        .length;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Columna del indicador y la línea
          SizedBox(
            width: 44,
            child: Column(
              children: [
                _Indicador(
                  completado: completado,
                  abierto: abierto,
                  numero: cap.numeroCapitulo,
                  color: color,
                ),
                if (!widget.esUltimo)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: completado
                            ? color
                            : const Color(0xFFE2E2EC),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Tarjeta del capítulo
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.esUltimo ? 0 : 16),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _presionado = true),
                onTapCancel: () => setState(() => _presionado = false),
                onTapUp: (_) {
                  setState(() => _presionado = false);
                  widget.onTap();
                },
                child: AnimatedScale(
                  scale: _presionado ? 0.98 : 1,
                  duration: const Duration(milliseconds: 110),
                  child: Opacity(
                    opacity: abierto ? 1 : 0.55,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: enCurso
                            ? color.withOpacity(0.07)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: completado
                              ? color
                              : enCurso
                                  ? color.withOpacity(0.3)
                                  : const Color(0xFFEAEAF2),
                          width: completado ? 1.8 : 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  cap.nombre,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                    letterSpacing: -0.25,
                                    color: Color(0xFF17171C),
                                  ),
                                ),
                              ),
                              if (!abierto)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8, top: 2),
                                  child: Icon(Icons.lock_rounded,
                                      size: 17, color: Color(0xFFB0B0BC)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            abierto
                                ? '$hechas de ${cap.lecciones.length} lecciones  ·  ${cap.dificultad}'
                                : '${cap.lecciones.length} lecciones  ·  ${cap.dificultad}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF8A8A94),
                            ),
                          ),
                          if (abierto && avance > 0) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: avance,
                                minHeight: 5,
                                backgroundColor: enCurso
                                    ? Colors.white
                                    : const Color(0xFFEDEDF3),
                                valueColor: AlwaysStoppedAnimation(color),
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
      ),
    );
  }
}

/// Círculo de la izquierda: número, check o candado.
class _Indicador extends StatelessWidget {
  final bool completado;
  final bool abierto;
  final String numero;
  final Color color;

  const _Indicador({
    required this.completado,
    required this.abierto,
    required this.numero,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: completado
            ? color
            : abierto
                ? Colors.white
                : const Color(0xFFF0F0F6),
        shape: BoxShape.circle,
        border: Border.all(
          color: abierto ? color : const Color(0xFFDCDCE6),
          width: 2,
        ),
        boxShadow: completado
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: completado
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 21)
          : !abierto
              ? const Icon(Icons.lock_rounded,
                  size: 16, color: Color(0xFFB0B0BC))
              : Text(
                  numero,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
    );
  }
}