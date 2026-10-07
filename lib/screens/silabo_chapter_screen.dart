import 'package:flutter/material.dart';
import '../models/SeccionSilabo.dart';
import '../services/progreso_service.dart';
import '../widgets/mascota_eso.dart';
import 'lesson_screen_v3.dart';

/// Lecciones de un capítulo, presentadas como una ruta vertical.
class SilabusChapterScreen extends StatelessWidget {
  final SeccionSilabo mundo;
  final CapituloSilabo capitulo;

  const SilabusChapterScreen({
    super.key,
    required this.mundo,
    required this.capitulo,
  });

  void _abrirLeccion(BuildContext context, LeccionSilabo leccion) {
    final servicio = ProgresoService.instance;

    if (!servicio.estaLeccionDesbloqueada(leccion)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Completa la lección anterior para abrir esta'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2E2E38),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreenV3(
          mundo: mundo,
          capitulo: capitulo,
          leccion: leccion,
        ),
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
        final avance = servicio.obtenerProgreso(capitulo);
        final hechas = capitulo.lecciones
            .where((l) => servicio.estaLeccionCompletada(l.id))
            .length;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // -------- Cabecera --------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
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
                      Text(
                        'CAPÍTULO ${capitulo.numeroCapitulo}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        capitulo.nombre,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                          height: 1.18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(
                                    begin: 0, end: avance.clamp(0.0, 1.0)),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOut,
                                builder: (context, v, _) =>
                                    LinearProgressIndicator(
                                  value: v,
                                  minHeight: 9,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.25),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$hechas de ${capitulo.lecciones.length}',
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
              ),

              Transform.translate(
                offset: const Offset(0, -32),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Objetivo del capítulo, con la mascota al lado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'OBJETIVO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.3,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    capitulo.objetivoAprendizaje,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      height: 1.5,
                                      color: Color(0xFF3A3A44),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const MascotaESO(size: 64),
                          ],
                        ),
                      ),

                      if (capitulo.normasUsadas.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: [
                            for (final norma in capitulo.normasUsadas)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                      color: color.withOpacity(0.25)),
                                ),
                                child: Text(
                                  norma,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 28),
                      const Text(
                        'Lecciones',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: Color(0xFF17171C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      for (var i = 0; i < capitulo.lecciones.length; i++)
                        _NodoLeccion(
                          leccion: capitulo.lecciones[i],
                          color: color,
                          esUltima: i == capitulo.lecciones.length - 1,
                          servicio: servicio,
                          onTap: () => _abrirLeccion(
                              context, capitulo.lecciones[i]),
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
// NODO DE LECCIÓN
// =====================================================================

class _NodoLeccion extends StatefulWidget {
  final LeccionSilabo leccion;
  final Color color;
  final bool esUltima;
  final ProgresoService servicio;
  final VoidCallback onTap;

  const _NodoLeccion({
    required this.leccion,
    required this.color,
    required this.esUltima,
    required this.servicio,
    required this.onTap,
  });

  @override
  State<_NodoLeccion> createState() => _NodoLeccionState();
}

class _NodoLeccionState extends State<_NodoLeccion> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final leccion = widget.leccion;
    final color = widget.color;
    final completada = widget.servicio.estaLeccionCompletada(leccion.id);
    final abierta = widget.servicio.estaLeccionDesbloqueada(leccion);
    final disponible = abierta && !completada;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: completada
                        ? color
                        : abierta
                            ? Colors.white
                            : const Color(0xFFF0F0F6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: abierta ? color : const Color(0xFFDCDCE6),
                      width: 2.2,
                    ),
                    boxShadow: completada || disponible
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: completada
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 23)
                      : !abierta
                          ? const Icon(Icons.lock_rounded,
                              size: 18, color: Color(0xFFB0B0BC))
                          : Text(
                              leccion.numero,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                ),
                if (!widget.esUltima)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            completada ? color : const Color(0xFFE2E2EC),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.esUltima ? 0 : 16),
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
                    opacity: abierta ? 1 : 0.55,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: disponible
                            ? color.withOpacity(0.07)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: completada
                              ? color
                              : disponible
                                  ? color.withOpacity(0.3)
                                  : const Color(0xFFEAEAF2),
                          width: completada ? 1.8 : 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  leccion.titulo,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                    letterSpacing: -0.25,
                                    color: completada
                                        ? const Color(0xFF6A6A76)
                                        : const Color(0xFF17171C),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  completada
                                      ? 'Completada'
                                      : disponible
                                          ? 'Toca para empezar'
                                          : leccion.tipoLeccion,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: disponible
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: disponible
                                        ? color
                                        : const Color(0xFF8A8A94),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (disponible)
                            Icon(Icons.chevron_right_rounded,
                                color: color, size: 24),
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