import 'package:flutter/material.dart';

import '../models/SeccionSilabo.dart';
import '../services/auth_service.dart';
import '../services/progreso_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascota_eso.dart';
import 'lesson_screen_v3.dart';
import 'silabo_roadmap_screen.dart';

/// Pantalla de inicio.
///
/// Cabecera con la mascota, tarjeta de acción superpuesta, recorrido del
/// sílabo y actividad. Los bloques entran escalonados al abrir.
class HomeScreenRediseno extends StatelessWidget {
  const HomeScreenRediseno({super.key});

  // ==================== NAVEGACIÓN ====================

  void _abrirMundo(BuildContext context, SeccionSilabo mundo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SilabusRoadmapScreen(mundo: mundo)),
    );
  }

  void _abrirLeccion(BuildContext context, _Siguiente s) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreenV3(
          mundo: s.mundo,
          capitulo: s.capitulo,
          leccion: s.leccion,
        ),
      ),
    );
  }

  // ==================== DATOS ====================

  _Siguiente? _buscarSiguiente(List<SeccionSilabo> mundos) {
    final progreso = ProgresoService.instance;
    for (final mundo in mundos) {
      for (final capitulo in mundo.capitulos) {
        for (final leccion in capitulo.lecciones) {
          if (leccion.desbloqueada &&
              !progreso.estaLeccionCompletada(leccion.id)) {
            return _Siguiente(mundo, capitulo, leccion);
          }
        }
      }
    }
    return null;
  }

  String _saludo() {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProgresoService.instance,
      builder: (context, _) {
        final progreso = ProgresoService.instance;
        final mundos = progreso.obtenerMundos();

        final avance = mundos.isEmpty
            ? 0.0
            : mundos
                    .map(progreso.obtenerProgresoMundo)
                    .reduce((a, b) => a + b) /
                mundos.length;

        final siguiente = _buscarSiguiente(mundos);
        final nombre =
            AuthService.instance.usuario?.primerNombre ?? 'estudiante';
        final comenzado = avance > 0 || progreso.obtenerXPTotal() > 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // -------- Cabecera con degradado y mascota --------
              _Cabecera(
                saludo: _saludo(),
                nombre: nombre,
                xp: progreso.obtenerXPTotal(),
                racha: progreso.obtenerRacha(),
                comenzado: comenzado,
              ),

              // El resto sube para montarse sobre la cabecera.
              Transform.translate(
                offset: const Offset(0, -46),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Aparece(
                        retraso: 80,
                        child: siguiente != null
                            ? _TarjetaContinuar(
                                siguiente: siguiente,
                                esPrimeraVez: !comenzado,
                                onTap: () => _abrirLeccion(context, siguiente),
                              )
                            : const _TarjetaTerminado(),
                      ),
                      const SizedBox(height: 30),

                      _Aparece(
                        retraso: 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Tu recorrido',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                                color: Color(0xFF17171C),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFE8E8F0)),
                              ),
                              child: Text(
                                '${(avance * 100).round()} %',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF6A6A78),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      for (var i = 0; i < mundos.length; i++) ...[
                        _Aparece(
                          retraso: 220 + i * 70,
                          child: _FilaMundo(
                            mundo: mundos[i],
                            onTap: () => _abrirMundo(context, mundos[i]),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      const SizedBox(height: 16),
                      _Aparece(
                        retraso: 220 + mundos.length * 70,
                        child: _Actividad(
                          racha: progreso.obtenerRacha(),
                          xp: progreso.obtenerXPTotal(),
                          nivel: progreso.obtenerNivel(),
                        ),
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

class _Siguiente {
  final SeccionSilabo mundo;
  final CapituloSilabo capitulo;
  final LeccionSilabo leccion;
  const _Siguiente(this.mundo, this.capitulo, this.leccion);
}

// =====================================================================
// ANIMACIÓN DE ENTRADA
// =====================================================================

/// Desvanece y desliza su hijo hacia arriba al construirse.
class _Aparece extends StatelessWidget {
  final Widget child;
  final int retraso;

  const _Aparece({required this.child, this.retraso = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + retraso),
      curve: Interval(
        retraso / (420 + retraso),
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, t, hijo) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 22),
          child: hijo,
        ),
      ),
      child: child,
    );
  }
}

// =====================================================================
// CABECERA
// =====================================================================

class _Cabecera extends StatelessWidget {
  final String saludo;
  final String nombre;
  final int xp;
  final int racha;
  final bool comenzado;

  const _Cabecera({
    required this.saludo,
    required this.nombre,
    required this.xp,
    required this.racha,
    required this.comenzado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 62),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepPurple, AppColors.electricBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        saludo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.78),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.9,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        comenzado
                            ? 'Sigamos con las normativas'
                            : 'Vamos a empezar las normativas',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const MascotaESO(size: 96, saludoPeriodico: true),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _Chip(valor: '$xp', texto: 'XP'),
                const SizedBox(width: 10),
                _Chip(
                  valor: '$racha',
                  texto: racha == 1 ? 'día seguido' : 'días seguidos',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String valor;
  final String texto;

  const _Chip({required this.valor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            texto,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// TARJETA DE CONTINUAR
// =====================================================================

class _TarjetaContinuar extends StatefulWidget {
  final _Siguiente siguiente;
  final bool esPrimeraVez;
  final VoidCallback onTap;

  const _TarjetaContinuar({
    required this.siguiente,
    required this.esPrimeraVez,
    required this.onTap,
  });

  @override
  State<_TarjetaContinuar> createState() => _TarjetaContinuarState();
}

class _TarjetaContinuarState extends State<_TarjetaContinuar> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.siguiente.mundo.colorPrimario;

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionada = true),
      onTapCancel: () => setState(() => _presionada = false),
      onTapUp: (_) {
        setState(() => _presionada = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _presionada ? 0.975 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.esPrimeraVez
                        ? 'EMPIEZA POR AQUÍ'
                        : 'CONTINÚA DONDE LO DEJASTE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.siguiente.leccion.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  height: 1.22,
                  letterSpacing: -0.6,
                  color: Color(0xFF17171C),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.siguiente.mundo.nombre}  ·  '
                'Capítulo ${widget.siguiente.capitulo.numeroCapitulo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF8A8A94),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.32),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.esPrimeraVez
                      ? 'Comenzar la primera lección'
                      : 'Continuar',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaTerminado extends StatelessWidget {
  const _TarjetaTerminado();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMPLETASTE EL SÍLABO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
              color: Color(0xFF8A8A94),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'No queda ninguna lección pendiente',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.5,
              color: Color(0xFF17171C),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Puedes repasar cualquier unidad cuando quieras.',
            style: TextStyle(fontSize: 13.5, color: Color(0xFF6A6A76)),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// FILA DE MUNDO
// =====================================================================

class _FilaMundo extends StatefulWidget {
  final SeccionSilabo mundo;
  final VoidCallback onTap;

  const _FilaMundo({required this.mundo, required this.onTap});

  @override
  State<_FilaMundo> createState() => _FilaMundoState();
}

class _FilaMundoState extends State<_FilaMundo> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
    final mundo = widget.mundo;
    final color = mundo.colorPrimario;
    final avance = ProgresoService.instance.obtenerProgresoMundo(mundo);
    final completado = ProgresoService.instance.estaMundoCompletado(mundo);
    final iniciado = avance > 0;

    final totalLecciones =
        mundo.capitulos.fold<int>(0, (s, c) => s + c.lecciones.length);

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionada = true),
      onTapCancel: () => setState(() => _presionada = false),
      onTapUp: (_) {
        setState(() => _presionada = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _presionada ? 0.98 : 1,
        duration: const Duration(milliseconds: 110),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 18, 14),
          decoration: BoxDecoration(
            color: iniciado ? color.withOpacity(0.07) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: completado
                  ? color
                  : iniciado
                      ? color.withOpacity(0.25)
                      : const Color(0xFFEAEAF2),
              width: completado ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            children: [
              // Número grande, sin icono
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iniciado ? color : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: iniciado
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${mundo.numeroMundo}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                    color: iniciado ? Colors.white : color,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mundo.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        letterSpacing: -0.25,
                        color: Color(0xFF17171C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mundo.capitulos.length} capítulos  ·  '
                      '$totalLecciones lecciones',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8A8A94),
                      ),
                    ),
                    if (iniciado) ...[
                      const SizedBox(height: 11),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: avance.clamp(0.0, 1.0),
                                minHeight: 5,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation(color),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${(avance * 100).round()}%',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// ACTIVIDAD
// =====================================================================

class _Actividad extends StatelessWidget {
  final int racha;
  final int xp;
  final int nivel;

  const _Actividad({
    required this.racha,
    required this.xp,
    required this.nivel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEAEAF2)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Dato(valor: '$xp', etiqueta: 'XP acumulada'),
            const VerticalDivider(
                width: 1, thickness: 1, color: Color(0xFFEFEFF5)),
            _Dato(
              valor: '$racha',
              etiqueta: racha == 1 ? 'día de racha' : 'días de racha',
            ),
            const VerticalDivider(
                width: 1, thickness: 1, color: Color(0xFFEFEFF5)),
            _Dato(valor: '$nivel', etiqueta: 'nivel actual'),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String valor;
  final String etiqueta;

  const _Dato({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.1,
            color: Color(0xFF17171C),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF8A8A94)),
        ),
      ],
    );
  }
}