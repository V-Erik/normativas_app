import 'package:flutter/material.dart';

/// Estado visual de un nivel dentro del camino.
enum NivelEstado { completado, actual, bloqueado }

/// Un nivel individual (círculo) dentro de una sección/etapa.
class NivelRuta {
  final IconData icono;
  final NivelEstado estado;

  const NivelRuta({required this.icono, required this.estado});
}

/// Una "Sección" del camino: corresponde a una Norma ISO y agrupa
/// varios niveles bajo una cabecera flotante (ej. "Etapa 1: ...").
class SeccionIso {
  final String etapa; // Ej. "Etapa 1"
  final String titulo; // Ej. "Introducción a la ISO/IEC 25010"
  final String codigoNorma; // Ej. "ISO/IEC 25010"
  final IconData icono; // Ícono representativo de la norma
  final Color color;
  final List<NivelRuta> niveles;

  const SeccionIso({
    required this.etapa,
    required this.titulo,
    required this.codigoNorma,
    required this.icono,
    required this.color,
    required this.niveles,
  });

  /// Estado general de la norma completa, derivado de sus niveles:
  /// completada si todos sus niveles están completados, bloqueada si
  /// el primer nivel aún no se desbloquea, o "en curso" en cualquier
  /// otro caso (para mostrar el nodo resumen en el mapa general).
  NivelEstado get estadoGeneral {
    if (niveles.every((n) => n.estado == NivelEstado.completado)) {
      return NivelEstado.completado;
    }
    if (niveles.first.estado == NivelEstado.bloqueado) {
      return NivelEstado.bloqueado;
    }
    return NivelEstado.actual;
  }
}