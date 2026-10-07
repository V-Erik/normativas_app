import 'package:flutter/material.dart';
import '../models/seccion_iso.dart';
import '../theme/app_theme.dart';

/// Camino minimalista para el detalle de una norma: una línea delgada
/// y continua conecta nodos planos, integrados al fondo (sin relieve
/// 3D ni sombras duras). El único acento visual está en el nivel
/// "actual" y en los tramos ya recorridos.
class DuolingoZigzagPath extends StatelessWidget {
  final List<NivelRuta> niveles;
  final Color color;
  final List<Color>? coloresIndividuales;
  final ValueChanged<NivelRuta> onTapNivel;
  final double nodeSize;
  final double spacing;

  const DuolingoZigzagPath({
    super.key,
    required this.niveles,
    required this.color,
    required this.onTapNivel,
    this.coloresIndividuales,
    this.nodeSize = 60,
    this.spacing = 104,
  });

  int get _indiceActual {
    final i = niveles.indexWhere((n) => n.estado == NivelEstado.actual);
    return i == -1 ? niveles.length : i;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.maxWidth;
        final radio = nodeSize / 2;
        final margen = radio + 28;

        final xCentro = ancho / 2;
        // Desplazamiento lateral sutil (antes 0.20, ahora 0.11) para un
        // serpenteo elegante en vez de un zigzag pronunciado.
        final xIzquierda = (xCentro - ancho * 0.11).clamp(margen, ancho - margen);
        final xDerecha = (xCentro + ancho * 0.11).clamp(margen, ancho - margen);

        double xPara(int index) {
          switch (index % 4) {
            case 0:
              return xCentro;
            case 1:
              return xIzquierda;
            case 2:
              return xCentro;
            default:
              return xDerecha;
          }
        }

        final centros = <Offset>[
          for (int i = 0; i < niveles.length; i++)
            Offset(xPara(i), radio + i * spacing),
        ];

        final alturaTotal = (centros.isEmpty ? 0 : centros.last.dy) + radio + 48;

        return SizedBox(
          height: alturaTotal,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CaminoPainter(
                    puntos: centros,
                    colorActivo: color,
                    indiceActual: _indiceActual,
                  ),
                ),
              ),
              for (int i = 0; i < niveles.length; i++)
                Positioned(
                  left: centros[i].dx - radio,
                  top: centros[i].dy - radio,
                  child: _MinimalNode(
                    nivel: niveles[i],
                    color: coloresIndividuales != null ? coloresIndividuales![i] : color,
                    size: nodeSize,
                    onTap: () => onTapNivel(niveles[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Dibuja una línea sólida y delgada (sin punteado) entre cada par de
/// nodos consecutivos. Los tramos ya recorridos se pintan con el color
/// de acento; el resto queda en un gris neutro casi imperceptible.
class _CaminoPainter extends CustomPainter {
  final List<Offset> puntos;
  final Color colorActivo;
  final int indiceActual;

  _CaminoPainter({
    required this.puntos,
    required this.colorActivo,
    required this.indiceActual,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (puntos.length < 2) return;

    for (int i = 0; i < puntos.length - 1; i++) {
      final p1 = puntos[i];
      final p2 = puntos[i + 1];
      final midY = (p1.dy + p2.dy) / 2;

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..cubicTo(p1.dx, midY, p2.dx, midY, p2.dx, p2.dy);

      final recorrido = i < indiceActual;
      final paint = Paint()
        ..color = recorrido ? colorActivo.withValues(alpha: 0.55) : AppColors.border
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CaminoPainter oldDelegate) =>
      oldDelegate.puntos != puntos ||
      oldDelegate.colorActivo != colorActivo ||
      oldDelegate.indiceActual != indiceActual;
}

/// Nodo plano: círculo delgado sin efecto de botón físico. El nivel
/// "actual" se distingue con un halo suave y una pequeña etiqueta de
/// texto ("Continuar"), en vez de un globo de diálogo llamativo.
///
/// Incluye la micro-interacción de rebote: al presionar se encoge
/// (escala 0.85) con un AnimationController de 150ms, y al soltar
/// regresa a su tamaño original. Solo se anima si el nodo no está
/// bloqueado.
class _MinimalNode extends StatefulWidget {
  final NivelRuta nivel;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _MinimalNode({
    required this.nivel,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  State<_MinimalNode> createState() => _MinimalNodeState();
}

class _MinimalNodeState extends State<_MinimalNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _esPresionable => widget.nivel.estado != NivelEstado.bloqueado;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!_esPresionable) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!_esPresionable) return;
    _controller.reverse();
  }

  void _onTapCancel() {
    if (!_esPresionable) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final estado = widget.nivel.estado;
    final color = widget.color;
    final size = widget.size;

    late final Color fondo;
    late final Color borde;
    late final Color iconoColor;
    List<BoxShadow> sombra = const [];

    switch (estado) {
      case NivelEstado.completado:
        fondo = color;
        borde = color;
        iconoColor = Colors.white;
        break;
      case NivelEstado.actual:
        fondo = Colors.white;
        borde = color;
        iconoColor = color;
        sombra = [
          BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 18, spreadRadius: 1),
        ];
        break;
      case NivelEstado.bloqueado:
        fondo = AppColors.background;
        borde = AppColors.border;
        iconoColor = AppColors.textGrey;
        break;
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fondo,
                border: Border.all(
                  color: borde,
                  width: estado == NivelEstado.bloqueado ? 1.4 : 1.8,
                ),
                boxShadow: sombra,
              ),
              child: Icon(
                estado == NivelEstado.bloqueado ? Icons.lock_outline_rounded : widget.nivel.icono,
                color: iconoColor,
                size: size * 0.4,
              ),
            ),
          ),
          if (estado == NivelEstado.actual) ...[
            const SizedBox(height: 6),
            Text(
              'Continuar',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}