import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Campo de texto con efecto neumórfico "hundido" (sombras invertidas),
/// pensado para usarse sobre tarjetas de vidrio (glassmorphism).
class NeumorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const NeumorphicTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(AppRadius.field),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.deepPurple, size: 20),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
            borderSide: const BorderSide(color: AppColors.electricBlue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
            borderSide: const BorderSide(color: AppColors.red, width: 1.5),
          ),
        ),
      ),
    );
  }
}