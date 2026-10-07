import '../models/SeccionSilabo.dart';

/// Clase que define un mapeo entre un capítulo y las normas ISO asociadas
class MapeoCapituloNorma {
  final String numeroCapitulo;
  final List<String> normasPrimarias;
  final List<String> normasSecundarias;
  final String razon;

  MapeoCapituloNorma({
    required this.numeroCapitulo,
    required this.normasPrimarias,
    required this.normasSecundarias,
    required this.razon,
  });
}

/// MAPEO ACADÉMICO: Capítulos del Sílabo → Normas ISO
/// 
/// Este archivo documenta la **justificación académica** de cada capítulo,
/// mostrando qué normas ISO lo respaldan. Útil para la tesis y defensa.

class MapeoCapitulosNormas {
  
  /// Mapeo completo de todos los capítulos
  static final List<MapeoCapituloNorma> mapeoCompleto = [
    
    // ========== MUNDO 1: METODOLOGÍAS ==========
    MapeoCapituloNorma(
      numeroCapitulo: '1.1',
      normasPrimarias: ['ISO/IEC 12207'],
      normasSecundarias: ['ISO 9001'],
      razon: 'ISO/IEC 12207 define los procesos de ciclo de vida del software. '
              'El SDLC es el marco conceptual que estructura todos los procesos.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '1.2',
      normasPrimarias: ['ISO/IEC 12207'],
      normasSecundarias: [],
      razon: 'Waterfall es un modelo de ciclo de vida cubierto en ISO/IEC 12207 '
              'como "sequential development". Es el modelo tradicional.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '1.3',
      normasPrimarias: ['ISO/IEC 12207'],
      normasSecundarias: ['ISO 9001'],
      razon: 'Agile/Scrum es un modelo iterativo reconocido por ISO/IEC 12207. '
              'ISO 9001 respalda el pensamiento de mejora continua inherente a Agile.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '1.4',
      normasPrimarias: ['ISO/IEC 27001', 'ISO 9001'],
      normasSecundarias: ['ISO/IEC 12207'],
      razon: 'DevOps integra desarrollo y operaciones con énfasis en seguridad (ISO 27001) '
              'y calidad (ISO 9001). ISO/IEC 12207 cubre los procesos de desarrollo subyacentes.',
    ),

    // ========== MUNDO 2: NORMATIVAS ==========
    MapeoCapituloNorma(
      numeroCapitulo: '2.1',
      normasPrimarias: ['ISO 9001'],
      normasSecundarias: ['ISO/IEC 12207'],
      razon: 'Este capítulo introduce el concepto de normalización. ISO 9001 es el estándar '
              'de gestión de calidad más relevante en ingeniería de software.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '2.2',
      normasPrimarias: ['ISO 9001', 'ISO 25010'],
      normasSecundarias: [],
      razon: 'ISO 9001 se enfoca en la gestión de calidad del PROCESO. '
              'ISO 25010 se enfoca en la calidad del PRODUCTO (software). Ambas son esenciales.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '2.3',
      normasPrimarias: ['ISO/IEC 27001'],
      normasSecundarias: ['ISO/IEC 27000', 'ISO/IEC 27002'],
      razon: 'ISO/IEC 27001 es el estándar internacional para sistemas de gestión '
              'de seguridad de la información. Fundamental en ingeniería de software moderna.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '2.4',
      normasPrimarias: ['ISO/IEC 12207'],
      normasSecundarias: ['ISO 9001'],
      razon: 'ISO/IEC 12207 define los procesos primarios y de soporte del ciclo de vida. '
              'Es el estándar de procesos más específico para desarrollo de software.',
    ),

    // ========== MUNDO 3: PRUEBAS, IMPLEMENTACIÓN Y MANTENIMIENTO ==========
    MapeoCapituloNorma(
      numeroCapitulo: '3.1',
      normasPrimarias: ['ISO/IEC 29119'],
      normasSecundarias: ['ISO/IEC 12207'],
      razon: 'ISO/IEC 29119 es el estándar específico para pruebas de software. '
              'Define los tipos de prueba, niveles de prueba y técnicas.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '3.2',
      normasPrimarias: ['ISO/IEC 29119'],
      normasSecundarias: [],
      razon: 'ISO/IEC 29119 especifica técnicas de diseño de casos de prueba: '
              'equivalencia, valores límite, caja blanca, caja negra, etc.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '3.3',
      normasPrimarias: ['ISO 9001', 'ISO/IEC 29119'],
      normasSecundarias: [],
      razon: 'ISO 9001 requiere "control de cambios" y "gestión de no conformidades". '
              'ISO/IEC 29119 especifica gestión de defectos en pruebas.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '3.4',
      normasPrimarias: ['ISO/IEC 12207'],
      normasSecundarias: ['ISO 9001'],
      razon: 'ISO/IEC 12207 define el proceso de "transición" (implementación en el entorno real). '
              'ISO 9001 requiere planificación y control de este proceso.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '3.5',
      normasPrimarias: ['ISO/IEC 12207'],
      normasSecundarias: ['ISO 9001'],
      razon: 'ISO/IEC 12207 define el proceso de "mantenimiento y soporte del software". '
              'Cubre correctivos, adaptativos, preventivos y perfectivos.',
    ),

    // ========== MUNDO 4: MÉTRICAS ==========
    MapeoCapituloNorma(
      numeroCapitulo: '4.1',
      normasPrimarias: ['ISO/IEC 20968', 'ISO 9001'],
      normasSecundarias: [],
      razon: 'ISO/IEC 20968 define métricas de software. ISO 9001 requiere "seguimiento '
              'y medición" de procesos. Ambas respaldan la necesidad de métricas.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '4.2',
      normasPrimarias: ['ISO 9001'],
      normasSecundarias: ['ISO/IEC 20968'],
      razon: 'ISO 9001 requiere "planificación y seguimiento" de proyectos. '
              'Las métricas de alcance y tiempo son herramientas clave.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '4.3',
      normasPrimarias: ['ISO 25010', 'ISO 9001'],
      normasSecundarias: ['ISO/IEC 20968'],
      razon: 'ISO 25010 define características de calidad. ISO 9001 requiere medición '
              'de la conformidad. Las métricas de calidad vinculan ambas.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '4.4',
      normasPrimarias: ['ISO 9001'],
      normasSecundarias: ['ISO/IEC 20968'],
      razon: 'ISO 9001 requiere "competencia" y "conciencia" del personal. '
              'Las métricas de equipo miden productividad y satisfacción.',
    ),
    MapeoCapituloNorma(
      numeroCapitulo: '4.5',
      normasPrimarias: ['ISO 9001'],
      normasSecundarias: ['ISO/IEC 12207'],
      razon: 'ISO 9001 requiere "mejora continua" y "no conformidad/acción correctiva". '
              'Las retrospectivas y lecciones aprendidas son mecanismos de mejora.',
    ),
  ];

  /// Obtiene el mapeo de un capítulo específico
  static MapeoCapituloNorma? obtenerMapeoCapitulo(String numeroCapitulo) {
    try {
      return mapeoCompleto.firstWhere((m) => m.numeroCapitulo == numeroCapitulo);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene todos los mapeos de un mundo específico
  static List<MapeoCapituloNorma> obtenerMapeosMundo(int numeroMundo) {
    String prefijo = '$numeroMundo.';
    return mapeoCompleto.where((m) => m.numeroCapitulo.startsWith(prefijo)).toList();
  }

  /// Obtiene todas las normas únicas mencionadas
  static Set<String> obtenerNormasUnicas() {
    Set<String> normas = {};
    for (var mapeo in mapeoCompleto) {
      normas.addAll(mapeo.normasPrimarias);
      normas.addAll(mapeo.normasSecundarias);
    }
    return normas..removeWhere((n) => n.isEmpty);
  }

  /// Genera una tabla resumen para la tesis (formato Markdown)
  static String generarTablaResumen() {
    StringBuffer buf = StringBuffer();
    
    buf.writeln('# Mapeo: Contenidos del Sílabo → Normas ISO');
    buf.writeln('');
    buf.writeln('| Capítulo | Nombre | Norma(s) Primaria(s) | Norma(s) Secundaria(s) |');
    buf.writeln('|----------|--------|----------------------|------------------------|');
    
    for (var mapeo in mapeoCompleto) {
      String primarias = mapeo.normasPrimarias.join(', ');
      String secundarias = mapeo.normasSecundarias.isEmpty 
          ? '—' 
          : mapeo.normasSecundarias.join(', ');
      
      buf.writeln('| ${mapeo.numeroCapitulo} | — | $primarias | $secundarias |');
    }
    
    return buf.toString();
  }

  /// Genera un documento de justificación detallada para cada capítulo
  static String generarJustificacionDetallada() {
    StringBuffer buf = StringBuffer();
    
    buf.writeln('# Justificación Académica: Alineación Sílabo-Normas ISO');
    buf.writeln('');
    buf.writeln('## Propósito');
    buf.writeln('Este documento demuestra cómo cada capítulo del sílabo oficial');
    buf.writeln('se alinea con normas ISO internacionales, justificando la selección');
    buf.writeln('de contenidos y su cobertura en la aplicación educativa.');
    buf.writeln('');
    buf.writeln('---');
    buf.writeln('');
    
    for (var mapeo in mapeoCompleto) {
      buf.writeln('### Capítulo ${mapeo.numeroCapitulo}');
      buf.writeln('');
      buf.writeln('**Normas Primarias:** ${mapeo.normasPrimarias.join(', ')}');
      if (mapeo.normasSecundarias.isNotEmpty) {
        buf.writeln('**Normas Secundarias:** ${mapeo.normasSecundarias.join(', ')}');
      }
      buf.writeln('');
      buf.writeln('**Justificación:**');
      buf.writeln('${mapeo.razon}');
      buf.writeln('');
      buf.writeln('---');
      buf.writeln('');
    }
    
    return buf.toString();
  }
}

/// ESTADÍSTICAS DEL SÍLABO (para la tesis)
class EstadisticasSilabo {
  
  static final datos = {
    'total_mundos': 4,
    'total_capitulos': 16,
    'total_lecciones': 42,
    'total_experiencia': 1750,
    
    'mundo_1': {
      'nombre': 'Metodologías de Desarrollo',
      'capitulos': 4,
      'lecciones': 10,
      'experiencia': 400,
    },
    
    'mundo_2': {
      'nombre': 'Normativas y Calidad',
      'capitulos': 4,
      'lecciones': 10,
      'experiencia': 400,
    },
    
    'mundo_3': {
      'nombre': 'Pruebas, Implementación y Mantenimiento',
      'capitulos': 5,
      'lecciones': 15,
      'experiencia': 500,
    },
    
    'mundo_4': {
      'nombre': 'Métricas de Proyectos',
      'capitulos': 5,
      'lecciones': 15,
      'experiencia': 450,
    },
    
    'normas_iso_totales': [
      'ISO 9001',
      'ISO 25010',
      'ISO/IEC 12207',
      'ISO/IEC 27001',
      'ISO/IEC 29119',
      'ISO/IEC 20968',
    ],
  };
  
  static void imprimirEstadisticas() {
    print('═════════════════════════════════════════');
    print('📊 ESTADÍSTICAS DEL SÍLABO REFACTORIZADO');
    print('═════════════════════════════════════════');
    print('');
    print('Total de Mundos: ${datos['total_mundos']}');
    print('Total de Capítulos: ${datos['total_capitulos']}');
    print('Total de Lecciones: ${datos['total_lecciones']}');
    print('Experiencia Total: ${datos['total_experiencia']} XP');
    print('');
    print('Normas ISO Principales: ${(datos['normas_iso_totales'] as List).length}');
    for (var norma in (datos['normas_iso_totales'] as List)) {
      print('  • $norma');
    }
    print('');
    print('═════════════════════════════════════════');
  }
}
