import 'package:flutter/material.dart';
import '../models/ejercicio_model.dart';

/// MODELO ACTUALIZADO: Reemplaza a SeccionISO
/// Representa un MUNDO = Un Contenido Temático del Sílabo
class SeccionSilabo {
  final String id;                          // "mundo-1", "mundo-2", etc.
  final int numeroMundo;                    // 1, 2, 3, 4
  final String nombre;                      // Nombre del mundo
  final String descripcion;                 // Descripción breve
  final String icono;                       // Emoji o asset path
  final Color colorPrimario;                // Color del mundo
  final Color colorSecundario;              // Color de fondo/variante
  final List<CapituloSilabo> capitulos;     // Capítulos dentro del mundo
  final List<String> normasAsociadas;       // ["ISO/IEC 12207", "ISO 9001"]
  final int experienciaTotal;               // XP máximo del mundo
  final String objetivoAprendizaje;         // Resultado de aprendizaje oficial

  SeccionSilabo({
    required this.id,
    required this.numeroMundo,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.capitulos,
    required this.normasAsociadas,
    required this.experienciaTotal,
    required this.objetivoAprendizaje,
  });

  /// Calcula el progreso total del mundo (0.0 - 1.0)
  double obtenerProgreso() {
    if (capitulos.isEmpty) return 0.0;
    
    int completados = 0;
    for (var capitulo in capitulos) {
      if (capitulo.estaCompletado()) {
        completados++;
      }
    }
    return completados / capitulos.length;
  }

  /// Retorna todos los capítulos en orden
  List<CapituloSilabo> obtenerCapitulosOrdenados() {
    return capitulos..sort((a, b) => a.numeroCapitulo.compareTo(b.numeroCapitulo));
  }

  /// Obtiene el siguiente capítulo no completado
  CapituloSilabo? obtenerProximoCapitulo() {
    try {
      return capitulos.firstWhere((cap) => !cap.estaCompletado());
    } catch (e) {
      return null; // Todos completados
    }
  }

  /// Retorna si el mundo está completamente terminado
  bool estaCompletado() {
    return capitulos.isNotEmpty && capitulos.every((cap) => cap.estaCompletado());
  }

  /// Retorna cuántos capítulos están completados
  int obtenerCapitulosCompletados() {
    return capitulos.where((cap) => cap.estaCompletado()).length;
  }
}

/// NUEVO MODELO: CapituloSilabo
/// Reemplaza a NivelRuta (ahora es "capítulo temático")
class CapituloSilabo {
  final String id;                          // "cap-1-1", "cap-2-2", etc.
  final String numeroCapitulo;              // "1.1", "2.2", "3.1", etc.
  final String nombre;                      // Nombre del capítulo
  final String descripcion;                 // Descripción breve
  final String objetivoAprendizaje;         // Qué aprenderá el estudiante
  final String temaRelacionado;             // "Ciclo de vida", "Calidad", etc.
  final List<String> normasUsadas;          // ["ISO/IEC 12207"] si es relevante
  final List<LeccionSilabo> lecciones;      // Sub-puntos del capítulo
  final int experienciaBase;                // XP al completar
  final String dificultad;                  // "Fácil", "Medio", "Difícil"
  final String tipoCapitulo;                // "Conceptual", "Práctica", "Evaluación"

  CapituloSilabo({
    required this.id,
    required this.numeroCapitulo,
    required this.nombre,
    required this.descripcion,
    required this.objetivoAprendizaje,
    required this.temaRelacionado,
    required this.normasUsadas,
    required this.lecciones,
    required this.experienciaBase,
    required this.dificultad,
    required this.tipoCapitulo,
  });

  /// Retorna si el capítulo está completado
  bool estaCompletado() {
    return lecciones.isNotEmpty && lecciones.every((leccion) => leccion.completado);
  }

  /// Retorna si el capítulo está desbloqueado
  bool estaDesbloqueado() {
    // Un capítulo se desbloquea cuando el anterior está completado
    // Esto lo maneja ProgresoService, aquí solo retornamos si tiene lecciones
    return true; // Se gestionará en ProgresoService
  }

  /// Retorna el progreso del capítulo (0.0 - 1.0)
  double obtenerProgreso() {
    if (lecciones.isEmpty) return 0.0;
    int completadas = lecciones.where((l) => l.completado).length;
    return completadas / lecciones.length;
  }

  /// Obtiene la próxima lección a completar
  LeccionSilabo? obtenerProximaLeccion() {
    try {
      return lecciones.firstWhere((leccion) => !leccion.completado);
    } catch (e) {
      return null;
    }
  }

  /// Retorna cuántas lecciones están completadas
  int obtenerLeccionesCompletadas() {
    return lecciones.where((l) => l.completado).length;
  }
}

/// NUEVO MODELO: LeccionSilabo
/// Representa un punto específico dentro de un capítulo
class LeccionSilabo {
  final String id;                          // "cap-1-1-leccion-1"
  final String numero;                      // "1", "2", "3"
  final String titulo;                      // Título breve de la lección
  final String descripcion;                 // Explicación de qué se aprenderá
  bool completado;                          // ¿Está completada?
  bool desbloqueada;                        // ¿Está disponible?
  final int experiencia;                    // XP al completar
  final String tipoLeccion;                 // "Concepto", "Práctica", "Evaluación"

  List<Ejercicio> obtenerEjercicios() {
  return [];
  }
  
  LeccionSilabo({
    required this.id,
    required this.numero,
    required this.titulo,
    required this.descripcion,
    this.completado = false,
    this.desbloqueada = false,
    required this.experiencia,
    required this.tipoLeccion,
  });

  /// Copia con cambios (para inmutabilidad)
  LeccionSilabo copyWith({
    bool? completado,
    bool? desbloqueada,
  }) {
    return LeccionSilabo(
      id: id,
      numero: numero,
      titulo: titulo,
      descripcion: descripcion,
      completado: completado ?? this.completado,
      desbloqueada: desbloqueada ?? this.desbloqueada,
      experiencia: experiencia,
      tipoLeccion: tipoLeccion,
    );
  }
}

/// SOPORTE: Clase para mapear Capítulos → Normas ISO (para documentación)
class MapeoCAPItuloNorma {
  final String numeroCapitulo;              // "1.1", "2.2", etc.
  final List<String> normasPrimarias;       // ISO principal(es)
  final List<String> normasSecundarias;     // ISO de apoyo
  final String razon;                       // "Porque el capítulo trata de..."

  MapeoCAPItuloNorma({
    required this.numeroCapitulo,
    required this.normasPrimarias,
    required this.normasSecundarias,
    required this.razon,
  });
}
