import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Fondo decorativo compartido por Login y Registro: degradado suave
/// sobre `#F8F9FA` con "manchas" de color difuminadas detrás de la
/// tarjeta de vidrio (glassmorphism).
class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: AppColors.background),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: -50,
            child: _Blob(color: AppColors.primaryGreen.withOpacity(0.35), size: 220),
          ),
          Positioned(
            top: 120,
            right: -70,
            child: _Blob(color: AppColors.electricBlue.withOpacity(0.30), size: 200),
          ),
          Positioned(
            bottom: -70,
            left: -40,
            child: _Blob(color: AppColors.deepPurple.withOpacity(0.28), size: 240),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}