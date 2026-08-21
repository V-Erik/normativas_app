import 'package:flutter/material.dart';

/// Cabecera flotante de sección: cuadro redondeado con "Etapa N" y el
/// título de la norma ISO correspondiente, en el color de la sección.
class DuolingoSectionHeader extends StatelessWidget {
  final String etapa;
  final String titulo;
  final Color color;

  const DuolingoSectionHeader({
    super.key,
    required this.etapa,
    required this.titulo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              etapa.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}