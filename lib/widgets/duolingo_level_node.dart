import 'package:flutter/material.dart';
import '../models/seccion_iso.dart';
import '../theme/app_theme.dart';

/// Círculo de nivel con aspecto 3D real (no sombra difusa): se apila un
/// círculo "base" más oscuro detrás/debajo de un círculo superior del
/// color principal, dejando ver un borde inferior oscuro que simula
/// altura/profundidad — la misma técnica que usa Duolingo.
///
/// Además, incluye una micro-interacción de "rebote": al presionar el
/// nodo se encoge levemente (escala 0.9) y, al soltar, regresa a su
/// tamaño original con un efecto elástico (Curves.elasticOut).
class DuolingoLevelNode extends StatefulWidget {
  final NivelRuta nivel;
  final Color colorSeccion;
  final double size;
  final VoidCallback? onTap;

  const DuolingoLevelNode({
    super.key,
    required this.nivel,
    required this.colorSeccion,
    required this.onTap,
    this.size = 68,
  });

  @override
  State<DuolingoLevelNode> createState() => _DuolingoLevelNodeState();
}

class _DuolingoLevelNodeState extends State<DuolingoLevelNode>
    with SingleTickerProviderStateMixin {
  static const double _relieve = 7; // alto del "borde" 3D inferior

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  // Solo se anima (y se "hunde") si el nodo realmente es interactuable,
  // es decir, si no está bloqueado. Un nodo bloqueado puede seguir
  // recibiendo el tap (p. ej. para mostrar un mensaje), pero sin
  // el feedback visual de rebote.
  bool get _esPresionable =>
      widget.onTap != null && widget.nivel.estado != NivelEstado.bloqueado;

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
    final Widget circulo = _build3dCircle();

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      // Evita que el "hitbox" quede limitado solo a las áreas pintadas
      // del Stack (el SizedBox de abajo tiene padding extra para la
      // etiqueta flotante), así el gesto se detecta de forma consistente
      // en toda la zona del nodo.
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        // espacio extra para que la etiqueta flotante no se corte
        width: widget.size + 40,
        height: widget.size + _relieve + 34,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: circulo,
              ),
            ),
            if (widget.nivel.estado == NivelEstado.actual)
              Positioned(
                top: -30,
                child: _EtiquetaFlotante(color: widget.colorSeccion),
              ),
          ],
        ),
      ),
    );
  }

  Widget _build3dCircle() {
    switch (widget.nivel.estado) {
      case NivelEstado.completado:
        return _Puck(
          size: widget.size,
          relieve: _relieve,
          colorSuperior: widget.colorSeccion,
          colorInferior: Color.lerp(widget.colorSeccion, Colors.black, 0.28)!,
          icono: Icons.star_rounded,
          iconoColor: Colors.white,
        );
      case NivelEstado.actual:
        return _Puck(
          size: widget.size,
          relieve: _relieve,
          colorSuperior: widget.colorSeccion,
          colorInferior: Color.lerp(widget.colorSeccion, Colors.black, 0.28)!,
          icono: Icons.play_arrow_rounded,
          iconoColor: Colors.white,
          conAnillo: true,
        );
      case NivelEstado.bloqueado:
        return _Puck(
          size: widget.size,
          relieve: _relieve,
          colorSuperior: const Color(0xFFD3D6DC),
          colorInferior: const Color(0xFFB6BAC2),
          icono: Icons.lock_rounded,
          iconoColor: Colors.white,
        );
    }
  }
}

/// El "puck" 3D en sí: dos círculos apilados (inferior oscuro + superior
/// de color) que crean el efecto de botón físico elevado.
class _Puck extends StatelessWidget {
  final double size;
  final double relieve;
  final Color colorSuperior;
  final Color colorInferior;
  final IconData icono;
  final Color iconoColor;
  final bool conAnillo;

  const _Puck({
    required this.size,
    required this.relieve,
    required this.colorSuperior,
    required this.colorInferior,
    required this.icono,
    required this.iconoColor,
    this.conAnillo = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + relieve,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Anillo pulsante sutil para el nivel "actual".
          if (conAnillo)
            Positioned(
              top: -6,
              left: -6,
              child: Container(
                width: size + 12,
                height: size + 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorSuperior.withOpacity(0.35),
                    width: 3,
                  ),
                ),
              ),
            ),
          // Círculo base (oscuro): forma el "borde inferior" 3D.
          Positioned(
            top: relieve,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colorInferior),
            ),
          ),
          // Círculo superior (color principal + ícono).
          Positioned(
            top: 0,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSuperior,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(icono, color: iconoColor, size: size * 0.42),
            ),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta flotante "AQUÍ" sobre el nivel actual, con una pequeña
/// "colita" apuntando hacia el círculo (efecto globo de diálogo).
class _EtiquetaFlotante extends StatelessWidget {
  final Color color;
  const _EtiquetaFlotante({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '¡AQUÍ!',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Transform.rotate(
          angle: 0.785398, // 45°
          child: Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: -5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}