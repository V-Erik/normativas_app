import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Mascota ESO animada con Lottie.
///
/// Reproduce la animación una vez al aparecer y luego se queda quieta en el
/// último fotograma. Si [saludoPeriodico] es true, vuelve a animarse cada
/// [intervalo], lo que da sensación de vida sin molestar durante la lectura.
class MascotaESO extends StatefulWidget {
  final double size;
  final bool saludoPeriodico;
  final Duration intervalo;

  const MascotaESO({
    super.key,
    this.size = 110,
    this.saludoPeriodico = false,
    this.intervalo = const Duration(seconds: 12),
  });

  @override
  State<MascotaESO> createState() => _MascotaESOState();
}

class _MascotaESOState extends State<MascotaESO>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    if (widget.saludoPeriodico) {
      _timer = Timer.periodic(widget.intervalo, (_) {
        if (mounted && !_controller.isAnimating) {
          _controller.forward(from: 0);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.15,
      child: Lottie.asset(
        'assets/animations/Frame_1.json',
        controller: _controller,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward(from: 0);
        },
      ),
    );
  }
}

/// Mascota con burbuja de diálogo apilada encima.
/// Se conserva por compatibilidad con otras pantallas del proyecto.
class MascotaESOBurbuja extends StatelessWidget {
  final String textoBurbuja;
  final Color colorBurbuja;
  final double size;
  final bool saludoPeriodico;

  const MascotaESOBurbuja({
    super.key,
    required this.textoBurbuja,
    required this.colorBurbuja,
    this.size = 110,
    this.saludoPeriodico = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MascotaESO(size: size, saludoPeriodico: saludoPeriodico),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: colorBurbuja.withOpacity(0.22), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              textoBurbuja,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}