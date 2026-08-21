import 'package:flutter/material.dart';

/// Representa una norma ISO dentro de la ruta de aprendizaje gamificada.
class Normativa {
  final String codigo; // Ej. "ISO/IEC 25010"
  final String titulo; // Ej. "Calidad de Producto de Software"
  final IconData icono;
  final Color color;
  final int progreso; // 0 - 100 (100 = ruta completada)
  final String nivel; // Ej. "Avanzado", "Intermedio", "Nuevo"
  final bool desbloqueada; // false = nodo bloqueado en el mapa de rutas

  const Normativa({
    required this.codigo,
    required this.titulo,
    required this.icono,
    required this.color,
    required this.progreso,
    required this.nivel,
    required this.desbloqueada,
  });

  bool get completada => progreso >= 100;
}