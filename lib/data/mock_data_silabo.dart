import 'package:flutter/material.dart';
import '../models/SeccionSilabo.dart';

/// DATOS INICIALES REFACTORIZADOS
/// Basados en el Sílabo Oficial: "Normativas de Ingeniería de Software" (UPEC)
class MockDataSilabo {
  
  /// Retorna los 4 mundos principales del sílabo
  static List<SeccionSilabo> obtenerMundosSilabo() {
    return [
      _construirMundo1Metodologias(),
      _construirMundo2Normativas(),
      _construirMundo3Pruebas(),
      _construirMundo4Metricas(),
    ];
  }

  // ========== MUNDO 1: METODOLOGÍAS DE DESARROLLO ==========
  
  static SeccionSilabo _construirMundo1Metodologias() {
    return SeccionSilabo(
      id: 'mundo-1',
      numeroMundo: 1,
      nombre: 'Metodologías de Desarrollo',
      descripcion: 'Comprende y aplica metodologías ágiles, cascada e híbridas',
      icono: '🚀',
      colorPrimario: Color(0xFF6366F1), // Índigo
      colorSecundario: Color(0xFFE0E7FF),
      experienciaTotal: 400,
      objetivoAprendizaje: 
        'El estudiante comprende los ciclos de vida de software y selecciona '
        'la metodología apropiada según el contexto del proyecto.',
      normasAsociadas: ['ISO/IEC 12207', 'ISO 9001'],
      capitulos: [
        _capitulo11CicloVida(),
        _capitulo12Waterfall(),
        _capitulo13Agil(),
        _capitulo14DevOps(),
      ],
    );
  }

  static CapituloSilabo _capitulo11CicloVida() {
    return CapituloSilabo(
      id: 'cap-1-1',
      numeroCapitulo: '1.1',
      nombre: 'Concepto de Ciclo de Vida (SDLC)',
      descripcion: 'Introducción a las fases del desarrollo de software',
      objetivoAprendizaje: 
        'Definir qué es el SDLC, identificar sus fases principales '
        'y entender su importancia.',
      temaRelacionado: 'Fases del desarrollo',
      normasUsadas: ['ISO/IEC 12207'],
      experienciaBase: 100,
      dificultad: 'Fácil',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-1-1-lec-1',
          numero: '1',
          titulo: 'Qué es el SDLC',
          descripcion: 'Definición y propósito del ciclo de vida',
          desbloqueada: true,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-1-1-lec-2',
          numero: '2',
          titulo: 'Fases del SDLC',
          descripcion: 'Planificación, análisis, diseño, desarrollo, pruebas, despliegue',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo12Waterfall() {
    return CapituloSilabo(
      id: 'cap-1-2',
      numeroCapitulo: '1.2',
      nombre: 'Metodología Waterfall',
      descripcion: 'Enfoque secuencial de desarrollo',
      objetivoAprendizaje: 
        'Comprender el modelo en cascada, sus ventajas, limitaciones '
        'y cuándo es apropiado usarlo.',
      temaRelacionado: 'Métodos secuenciales',
      normasUsadas: ['ISO/IEC 12207'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-1-2-lec-1',
          numero: '1',
          titulo: 'Modelo Waterfall paso a paso',
          descripcion: 'Fases lineales: Requisitos → Diseño → Implementación → Testing → Mantenimiento',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-1-2-lec-2',
          numero: '2',
          titulo: 'Cuándo usar Waterfall',
          descripcion: 'Casos de uso, ventajas y desventajas',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Evaluación',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo13Agil() {
    return CapituloSilabo(
      id: 'cap-1-3',
      numeroCapitulo: '1.3',
      nombre: 'Metodología Ágil / Scrum',
      descripcion: 'Enfoque iterativo e incremental',
      objetivoAprendizaje: 
        'Comprender Scrum, sprints, roles (PO, Scrum Master, Team) '
        'y aplicar en un proyecto.',
      temaRelacionado: 'Métodos iterativos',
      normasUsadas: ['ISO/IEC 12207'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-1-3-lec-1',
          numero: '1',
          titulo: 'Principios Ágiles',
          descripcion: 'Manifiesto Ágil, valores, principios',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-1-3-lec-2',
          numero: '2',
          titulo: 'Scrum en detalle',
          descripcion: 'Roles, eventos (sprint, daily, review, retro), artefactos',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo14DevOps() {
    return CapituloSilabo(
      id: 'cap-1-4',
      numeroCapitulo: '1.4',
      nombre: 'Metodología DevOps',
      descripcion: 'Integración continua, entrega continua y calidad',
      objetivoAprendizaje: 
        'Entender DevOps como la convergencia de desarrollo y operaciones, '
        'CI/CD y automatización.',
      temaRelacionado: 'Métodos modernos',
      normasUsadas: ['ISO/IEC 27001', 'ISO 9001'],
      experienciaBase: 100,
      dificultad: 'Difícil',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-1-4-lec-1',
          numero: '1',
          titulo: 'CI/CD Pipelines',
          descripcion: 'Integración continua, entrega continua, despliegue continuo',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-1-4-lec-2',
          numero: '2',
          titulo: 'Automatización y Monitoreo',
          descripcion: 'Herramientas, infraestructura como código, logging',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  // ========== MUNDO 2: NORMATIVAS DE DESARROLLO Y CALIDAD ==========
  
  static SeccionSilabo _construirMundo2Normativas() {
    return SeccionSilabo(
      id: 'mundo-2',
      numeroMundo: 2,
      nombre: 'Normativas y Calidad',
      descripcion: 'Conoce las normas ISO aplicables y cómo implementarlas',
      icono: '📋',
      colorPrimario: Color(0xFF059669), // Verde
      colorSecundario: Color(0xFFD1FAE5),
      experienciaTotal: 400,
      objetivoAprendizaje: 
        'El estudiante identifica, interpreta e implementa normas ISO '
        'en proyectos de software.',
      normasAsociadas: ['ISO 9001', 'ISO 25010', 'ISO/IEC 27001', 'ISO/IEC 12207'],
      capitulos: [
        _capitulo21EsNorma(),
        _capitulo22Calidad(),
        _capitulo23Seguridad(),
        _capitulo24Procesos(),
      ],
    );
  }

  static CapituloSilabo _capitulo21EsNorma() {
    return CapituloSilabo(
      id: 'cap-2-1',
      numeroCapitulo: '2.1',
      nombre: '¿Qué es una Norma de Software?',
      descripcion: 'Concepto, propósito y beneficios de las normas ISO',
      objetivoAprendizaje: 
        'Definir qué es una norma ISO, por qué existe y qué beneficios aporta.',
      temaRelacionado: 'Conceptos normativos',
      normasUsadas: ['ISO 9001'],
      experienciaBase: 100,
      dificultad: 'Fácil',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-2-1-lec-1',
          numero: '1',
          titulo: 'Definición de Norma ISO',
          descripcion: 'Qué es, quién las crea, cómo se nombran',
          desbloqueada: true,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-2-1-lec-2',
          numero: '2',
          titulo: 'Beneficios de las Normas',
          descripcion: 'Calidad, consistencia, mejora continua',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo22Calidad() {
    return CapituloSilabo(
      id: 'cap-2-2',
      numeroCapitulo: '2.2',
      nombre: 'Normas de Calidad',
      descripcion: 'ISO 9001 e ISO 25010 en detalle',
      objetivoAprendizaje: 
        'Distinguir entre ISO 9001 (sistemas) e ISO 25010 (producto), '
        'y saber cuándo aplicar cada una.',
      temaRelacionado: 'Calidad de software',
      normasUsadas: ['ISO 9001', 'ISO 25010'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-2-2-lec-1',
          numero: '1',
          titulo: 'ISO 9001: Sistema de Gestión de Calidad',
          descripcion: 'Enfoque a procesos, satisfacción del cliente, mejora',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-2-2-lec-2',
          numero: '2',
          titulo: 'ISO 25010: Calidad del Producto',
          descripcion: 'Características: Funcionalidad, confiabilidad, usabilidad, rendimiento',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo23Seguridad() {
    return CapituloSilabo(
      id: 'cap-2-3',
      numeroCapitulo: '2.3',
      nombre: 'Normas de Seguridad',
      descripcion: 'ISO/IEC 27001 y gestión de seguridad de la información',
      objetivoAprendizaje: 
        'Comprender ISO/IEC 27001: controles, ISMS, auditoría y cumplimiento.',
      temaRelacionado: 'Seguridad de información',
      normasUsadas: ['ISO/IEC 27001'],
      experienciaBase: 100,
      dificultad: 'Difícil',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-2-3-lec-1',
          numero: '1',
          titulo: 'Confidencialidad, Integridad, Disponibilidad (CIA)',
          descripcion: 'Triada de seguridad de la información',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-2-3-lec-2',
          numero: '2',
          titulo: 'ISO 27001: Sistema de Gestión de Seguridad',
          descripcion: 'Implementación de controles, evaluación, certificación',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Evaluación',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo24Procesos() {
    return CapituloSilabo(
      id: 'cap-2-4',
      numeroCapitulo: '2.4',
      nombre: 'Normas de Desarrollo',
      descripcion: 'ISO/IEC 12207 y procesos de desarrollo estructurados',
      objetivoAprendizaje: 
        'Aplicar ISO/IEC 12207 para estructurar procesos de desarrollo.',
      temaRelacionado: 'Procesos de desarrollo',
      normasUsadas: ['ISO/IEC 12207'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-2-4-lec-1',
          numero: '1',
          titulo: 'Procesos Primarios de Desarrollo',
          descripcion: 'Acuerdo, suministro, desarrollo, operación, mantenimiento',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-2-4-lec-2',
          numero: '2',
          titulo: 'Procesos de Soporte',
          descripcion: 'Documentación, gestión de configuración, aseguramiento de calidad',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  // ========== MUNDO 3: GESTIÓN DE PRUEBAS, IMPLEMENTACIÓN Y MANTENIMIENTO ==========
  
  static SeccionSilabo _construirMundo3Pruebas() {
    return SeccionSilabo(
      id: 'mundo-3',
      numeroMundo: 3,
      nombre: 'Pruebas, Implementación y Mantenimiento',
      descripcion: 'Planifica, ejecuta y gestiona pruebas; despliegue y mantenimiento',
      icono: '🧪',
      colorPrimario: Color(0xFFDC2626), // Rojo
      colorSecundario: Color(0xFFFEE2E2),
      experienciaTotal: 500,
      objetivoAprendizaje: 
        'El estudiante ejecuta estrategias de pruebas, gestiona defectos '
        'y realiza despliegues y mantenimiento de software.',
      normasAsociadas: ['ISO/IEC 29119', 'ISO/IEC 12207', 'ISO 9001'],
      capitulos: [
        _capitulo31TiposPruebas(),
        _capitulo32Estrategias(),
        _capitulo33Defectos(),
        _capitulo34Despliegue(),
        _capitulo35Mantenimiento(),
      ],
    );
  }

  static CapituloSilabo _capitulo31TiposPruebas() {
    return CapituloSilabo(
      id: 'cap-3-1',
      numeroCapitulo: '3.1',
      nombre: 'Tipos de Pruebas de Software',
      descripcion: 'Unitarias, integración, sistema, UAT y más',
      objetivoAprendizaje: 
        'Identificar y aplicar los tipos de prueba según el nivel de validación.',
      temaRelacionado: 'Niveles de prueba',
      normasUsadas: ['ISO/IEC 29119'],
      experienciaBase: 125,
      dificultad: 'Medio',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-3-1-lec-1',
          numero: '1',
          titulo: 'Pruebas Unitarias',
          descripcion: 'Función/módulo individual, caja blanca',
          desbloqueada: true,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-3-1-lec-2',
          numero: '2',
          titulo: 'Pruebas de Integración',
          descripcion: 'Módulos juntos, componentes interactuando',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-3-1-lec-3',
          numero: '3',
          titulo: 'Pruebas de Sistema y UAT',
          descripcion: 'Software completo, requerimientos, usuarios reales',
          desbloqueada: false,
          experiencia: 25,
          tipoLeccion: 'Concepto',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo32Estrategias() {
    return CapituloSilabo(
      id: 'cap-3-2',
      numeroCapitulo: '3.2',
      nombre: 'Estrategias de Pruebas',
      descripcion: 'Caja blanca, caja negra, gray-box',
      objetivoAprendizaje: 
        'Aplicar técnicas de prueba según el nivel de acceso al código.',
      temaRelacionado: 'Técnicas de prueba',
      normasUsadas: ['ISO/IEC 29119'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Práctica',
      lecciones: [
        LeccionSilabo(
          id: 'cap-3-2-lec-1',
          numero: '1',
          titulo: 'Pruebas Caja Blanca (White-box)',
          descripcion: 'Acceso al código, coverage, caminos lógicos',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-3-2-lec-2',
          numero: '2',
          titulo: 'Pruebas Caja Negra (Black-box)',
          descripcion: 'Sin acceso al código, comportamiento, casos de uso',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo33Defectos() {
    return CapituloSilabo(
      id: 'cap-3-3',
      numeroCapitulo: '3.3',
      nombre: 'Gestión de Defectos',
      descripcion: 'Ciclo de vida del bug, severidad, seguimiento',
      objetivoAprendizaje: 
        'Gestionar defectos desde detección hasta cierre, clasificación por severidad.',
      temaRelacionado: 'Control de calidad',
      normasUsadas: ['ISO 9001', 'ISO/IEC 29119'],
      experienciaBase: 100,
      dificultad: 'Fácil',
      tipoCapitulo: 'Práctica',
      lecciones: [
        LeccionSilabo(
          id: 'cap-3-3-lec-1',
          numero: '1',
          titulo: 'Ciclo de Vida de un Defecto',
          descripcion: 'Reporte, análisis, reparación, verificación, cierre',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-3-3-lec-2',
          numero: '2',
          titulo: 'Severidad vs Prioridad',
          descripcion: 'Clasificación, impacto, orden de atención',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Evaluación',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo34Despliegue() {
    return CapituloSilabo(
      id: 'cap-3-4',
      numeroCapitulo: '3.4',
      nombre: 'Implementación y Despliegue',
      descripcion: 'Estrategias: Big Bang, Rolling, Canary, Blue-Green',
      objetivoAprendizaje: 
        'Seleccionar y ejecutar estrategias de despliegue según riesgos.',
      temaRelacionado: 'Transición a producción',
      normasUsadas: ['ISO/IEC 12207'],
      experienciaBase: 125,
      dificultad: 'Difícil',
      tipoCapitulo: 'Práctica',
      lecciones: [
        LeccionSilabo(
          id: 'cap-3-4-lec-1',
          numero: '1',
          titulo: 'Estrategias de Despliegue',
          descripcion: 'Big Bang, Rolling, Canary, Blue-Green, Feature Flags',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-3-4-lec-2',
          numero: '2',
          titulo: 'Plan de Rollback',
          descripcion: 'Contingencia, reversión, comunicación',
          desbloqueada: false,
          experiencia: 75,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo35Mantenimiento() {
    return CapituloSilabo(
      id: 'cap-3-5',
      numeroCapitulo: '3.5',
      nombre: 'Mantenimiento del Software',
      descripcion: 'Correctivo, adaptativo, preventivo, perfectivo',
      objetivoAprendizaje: 
        'Clasificar y ejecutar actividades de mantenimiento post-despliegue.',
      temaRelacionado: 'Soporte y mejora',
      normasUsadas: ['ISO/IEC 12207'],
      experienciaBase: 100,
      dificultad: 'Fácil',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-3-5-lec-1',
          numero: '1',
          titulo: 'Tipos de Mantenimiento',
          descripcion: 'Correctivo (bugs), Adaptativo (cambios), Preventivo (mejora), Perfectivo (nuevas features)',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-3-5-lec-2',
          numero: '2',
          titulo: 'Gestión de Mantenimiento',
          descripcion: 'Priorización, SLA, documentación, métricas',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  // ========== MUNDO 4: MÉTRICAS DE GESTIÓN DE PROYECTOS ==========
  
  static SeccionSilabo _construirMundo4Metricas() {
    return SeccionSilabo(
      id: 'mundo-4',
      numeroMundo: 4,
      nombre: 'Métricas de Proyectos',
      descripcion: 'Mide, monitorea y optimiza proyectos de software',
      icono: '📊',
      colorPrimario: Color(0xFFF59E0B), // Ámbar
      colorSecundario: Color(0xFFFEF3C7),
      experienciaTotal: 450,
      objetivoAprendizaje: 
        'El estudiante define, recopila y analiza métricas para optimizar '
        'procesos y productos de software.',
      normasAsociadas: ['ISO/IEC 20968', 'ISO 9001', 'ISO 25010'],
      capitulos: [
        _capitulo41ConceptoMetrica(),
        _capitulo42Alcance(),
        _capitulo43Calidad(),
        _capitulo44Equipo(),
        _capitulo45Mejora(),
      ],
    );
  }

  static CapituloSilabo _capitulo41ConceptoMetrica() {
    return CapituloSilabo(
      id: 'cap-4-1',
      numeroCapitulo: '4.1',
      nombre: 'Concepto de Métrica en Software',
      descripcion: 'Qué medir, por qué y cómo',
      objetivoAprendizaje: 
        'Definir métrica, entender su propósito y clasificarlas según tipo.',
      temaRelacionado: 'Medición de software',
      normasUsadas: ['ISO/IEC 20968', 'ISO 9001'],
      experienciaBase: 100,
      dificultad: 'Fácil',
      tipoCapitulo: 'Conceptual',
      lecciones: [
        LeccionSilabo(
          id: 'cap-4-1-lec-1',
          numero: '1',
          titulo: 'Métrica vs Medida vs Indicador',
          descripcion: 'Definiciones, diferencias, ejemplos',
          desbloqueada: true,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-4-1-lec-2',
          numero: '2',
          titulo: 'Tipos de Métricas',
          descripcion: 'Producto, proceso, proyecto; cuantitativas, cualitativas',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo42Alcance() {
    return CapituloSilabo(
      id: 'cap-4-2',
      numeroCapitulo: '4.2',
      nombre: 'Métricas de Alcance y Tiempo',
      descripcion: 'Línea base, avance, desviaciones, burndown',
      objetivoAprendizaje: 
        'Monitorear alcance y cronograma, detectar y corregir desviaciones.',
      temaRelacionado: 'Gestión de proyectos',
      normasUsadas: ['ISO 9001'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Práctica',
      lecciones: [
        LeccionSilabo(
          id: 'cap-4-2-lec-1',
          numero: '1',
          titulo: 'Línea Base del Proyecto',
          descripcion: 'Definición, documentación, aprobación',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-4-2-lec-2',
          numero: '2',
          titulo: 'Seguimiento de Avance',
          descripcion: 'Burndown chart, velocidad, % completado, desviaciones',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo43Calidad() {
    return CapituloSilabo(
      id: 'cap-4-3',
      numeroCapitulo: '4.3',
      nombre: 'Métricas de Calidad',
      descripcion: 'Defectos, cobertura de pruebas, confiabilidad',
      objetivoAprendizaje: 
        'Medir calidad mediante defectos, cobertura y confiabilidad del software.',
      temaRelacionado: 'Aseguramiento de calidad',
      normasUsadas: ['ISO 25010', 'ISO 9001'],
      experienciaBase: 125,
      dificultad: 'Medio',
      tipoCapitulo: 'Práctica',
      lecciones: [
        LeccionSilabo(
          id: 'cap-4-3-lec-1',
          numero: '1',
          titulo: 'Defect Density y Defect Escape Rate',
          descripcion: 'Defectos por línea de código, defectos encontrados en producción',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-4-3-lec-2',
          numero: '2',
          titulo: 'Cobertura de Pruebas y MTBF',
          descripcion: 'Code coverage, Mean Time Between Failures, confiabilidad',
          desbloqueada: false,
          experiencia: 75,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo44Equipo() {
    return CapituloSilabo(
      id: 'cap-4-4',
      numeroCapitulo: '4.4',
      nombre: 'Métricas de Equipo y Productividad',
      descripcion: 'Velocidad, capacidad, burndown, satisfacción',
      objetivoAprendizaje: 
        'Medir productividad, capacidad y salud del equipo de desarrollo.',
      temaRelacionado: 'Gestión de recursos',
      normasUsadas: ['ISO 9001'],
      experienciaBase: 100,
      dificultad: 'Fácil',
      tipoCapitulo: 'Práctica',
      lecciones: [
        LeccionSilabo(
          id: 'cap-4-4-lec-1',
          numero: '1',
          titulo: 'Velocidad y Capacidad en Scrum',
          descripcion: 'Story points, velocity, planning, forecasting',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-4-4-lec-2',
          numero: '2',
          titulo: 'Métricas Humanas',
          descripcion: 'Satisfacción, retención, tasa de ausentismo, clima laboral',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Práctica',
        ),
      ],
    );
  }

  static CapituloSilabo _capitulo45Mejora() {
    return CapituloSilabo(
      id: 'cap-4-5',
      numeroCapitulo: '4.5',
      nombre: 'Análisis y Mejora de Procesos',
      descripcion: 'Lecciones aprendidas, retrospectivas, optimización',
      objetivoAprendizaje: 
        'Recolectar, analizar e implementar mejoras basadas en datos.',
      temaRelacionado: 'Mejora continua',
      normasUsadas: ['ISO 9001'],
      experienciaBase: 100,
      dificultad: 'Medio',
      tipoCapitulo: 'Evaluación',
      lecciones: [
        LeccionSilabo(
          id: 'cap-4-5-lec-1',
          numero: '1',
          titulo: 'Lecciones Aprendidas',
          descripcion: 'Documentación, análisis post-proyecto, mejoras futuras',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Concepto',
        ),
        LeccionSilabo(
          id: 'cap-4-5-lec-2',
          numero: '2',
          titulo: 'Retrospectivas y Mejora Continua',
          descripcion: 'Reuniones iterativas, acciones correctivas, cultura de mejora',
          desbloqueada: false,
          experiencia: 50,
          tipoLeccion: 'Evaluación',
        ),
      ],
    );
  }
}
