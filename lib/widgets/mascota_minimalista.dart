import 'package:flutter/material.dart';

/// MASCOTA MINIMALISTA - ESO
/// Robot simple, minimalista, estilo ESO (Wall-E)
/// Colores: Blanco, negro, ojos brillantes
class MascotaMinimalista extends StatefulWidget {
  final bool hablando;
  final Color colorOjos;

  const MascotaMinimalista({
    super.key,
    this.hablando = false,
    this.colorOjos = Colors.green,
  });

  @override
  State<MascotaMinimalista> createState() => _MascotaMinimalistaState();
}

class _MascotaMinimalistaState extends State<MascotaMinimalista>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de parpadeo
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.hablando) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(MascotaMinimalista oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hablando != oldWidget.hablando) {
      if (widget.hablando) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: 80,
            height: 100,
            child: CustomPaint(
              painter: _MascotaPainter(
                colorOjos: widget.colorOjos,
                parpadeoOpacity: _blinkAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MascotaPainter extends CustomPainter {
  final Color colorOjos;
  final double parpadeoOpacity;

  _MascotaPainter({
    required this.colorOjos,
    required this.parpadeoOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final ojoPaint = Paint()
      ..color = colorOjos.withOpacity(parpadeoOpacity)
      ..style = PaintingStyle.fill;

    // Cuerpo principal (rectángulo redondeado)
    final bodyRect = RRect.fromLTRBR(
      size.width * 0.1,
      size.height * 0.35,
      size.width * 0.9,
      size.height * 0.95,
      const Radius.circular(8),
    );

    canvas.drawRRect(bodyRect, paint);
    canvas.drawRRect(bodyRect, borderPaint);

    // Cabeza (círculo)
    final headCenter = Offset(size.width / 2, size.height * 0.2);
    canvas.drawCircle(headCenter, size.width * 0.25, paint);
    canvas.drawCircle(
      headCenter,
      size.width * 0.25,
      borderPaint,
    );

    // Ojos izquierdo
    final leftEyeCenter = Offset(
      size.width * 0.35,
      size.height * 0.18,
    );
    canvas.drawCircle(leftEyeCenter, size.width * 0.08, ojoPaint);

    // Brillo en ojo izquierdo
    final leftBrillo = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(leftEyeCenter.dx + 2, leftEyeCenter.dy - 2),
      size.width * 0.03,
      leftBrillo,
    );

    // Ojo derecho
    final rightEyeCenter = Offset(
      size.width * 0.65,
      size.height * 0.18,
    );
    canvas.drawCircle(rightEyeCenter, size.width * 0.08, ojoPaint);

    // Brillo en ojo derecho
    canvas.drawCircle(
      Offset(rightEyeCenter.dx + 2, rightEyeCenter.dy - 2),
      size.width * 0.03,
      leftBrillo,
    );

    // "Boca" - línea simple
    final mouthPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.3),
        width: size.width * 0.15,
        height: size.width * 0.12,
      ),
      0,
      3.14,
      false,
      mouthPaint,
    );

    // Antena simple (línea)
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.05),
      Offset(size.width * 0.4, 0),
      borderPaint..strokeWidth = 1,
    );

    // Puntito en antena
    canvas.drawCircle(
      Offset(size.width * 0.4, 0),
      size.width * 0.02,
      Paint()..color = Colors.black.withOpacity(0.3),
    );
  }

  @override
  bool shouldRepaint(_MascotaPainter oldDelegate) {
    return oldDelegate.parpadeoOpacity != parpadeoOpacity ||
        oldDelegate.colorOjos != colorOjos;
  }
}

/// Widget para mostrar la mascota con diferentes estados
class MascotaWidget extends StatelessWidget {
  final bool hablando;
  final String? textoBurbuja;
  final Color colorOjos;

  const MascotaWidget({
    super.key,
    this.hablando = false,
    this.textoBurbuja,
    this.colorOjos = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Burbuja de diálogo (si está hablando)
        if (textoBurbuja != null && textoBurbuja!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                )
              ],
            ),
            child: Text(
              textoBurbuja!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Mascota
        MascotaMinimalista(
          hablando: hablando,
          colorOjos: colorOjos,
        ),
      ],
    );
  }
}