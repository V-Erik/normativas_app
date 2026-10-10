/// Traduce el id de lección de la app al tema del sílabo que el backend
/// conoce, para que `POST /api/v1/chat` pueda centrar la búsqueda de
/// contexto en ese tema.
///
/// POR QUÉ HACE FALTA
/// ------------------
/// El backend solo reconoce los ids que estén en
/// `servidor/configuracion/lecciones.json`. Hoy ese archivo tiene cinco:
/// `leccion-metodologias-agiles` (1.2), `leccion-iso-9001` (2.2),
/// `leccion-iso-25010` (2.5), `leccion-metricas-agiles` (3.4) y
/// `leccion-pruebas-software` (4.1). Los ids de la app (`cap-2-2-lec-1`…)
/// no están ahí: enviarlos no rompe nada, pero no tienen efecto.
///
/// Mientras Sebastián no añada los 37 ids al JSON, esta tabla hace la
/// traducción del lado de la app usando los **ids de tema** de
/// `configuracion/silabo.yaml`, que sí son los definitivos. El id de tema
/// no está en `lecciones.json`, así que no sirve como `leccion_id`
/// directamente; lo que se envía es la clave canónica equivalente cuando
/// existe, y en los demás casos el propio id de la app (inofensivo).
///
/// OJO CON EL ORDEN DE LOS MUNDOS
/// ------------------------------
/// La app y el sílabo no numeran igual las dos últimas unidades:
///
///   App Mundo 1  Metodologías de Desarrollo              = Unidad 1
///   App Mundo 2  Normativas y Calidad                    = Unidad 2
///   App Mundo 3  Pruebas, Implementación y Mantenimiento = Unidad **4**
///   App Mundo 4  Métricas de Proyectos                   = Unidad **3**
///
/// Por eso las lecciones de `cap-3-*` apuntan a temas `4.x` y las de
/// `cap-4-*` a temas `3.x`. No es una errata.
class MapeoLecciones {
  const MapeoLecciones._();

  /// id de lección de la app -> id de tema de `silabo.yaml`.
  ///
  /// Esta es la tabla que hay que pasarle a Sebastián para que la añada a
  /// `configuracion/lecciones.json` (ver `lecciones_para_el_backend.json`).
  static const Map<String, String> temaPorLeccion = {
    // ============ MUNDO 1 · Metodologías de Desarrollo (Unidad 1) ============
    // 1.6 Ciclo de vida del desarrollo de software (SDLC)  [tiene documento]
    'cap-1-1-lec-1': '1.6', // Qué es el SDLC
    'cap-1-1-lec-2': '1.6', // Fases del SDLC
    // 1.1 Marcos predictivos, iterativos, incrementales e híbridos
    'cap-1-2-lec-1': '1.1', // Modelo Waterfall paso a paso
    'cap-1-2-lec-2': '1.1', // Cuándo usar Waterfall
    'cap-1-3-lec-1': '1.1', // Principios Ágiles
    // 1.2 Scrum (roles, eventos y artefactos)
    'cap-1-3-lec-2': '1.2', // Scrum en detalle
    // 4.3 CI/CD, gestión de la configuración y contenedores
    'cap-1-4-lec-1': '4.3', // CI/CD Pipelines
    // 1.7 DevOps y DevSecOps
    'cap-1-4-lec-2': '1.7', // Automatización y Monitoreo

    // ============ MUNDO 2 · Normativas y Calidad (Unidad 2) ==================
    // 2.1 Fundamentos de normas ISO/IEC/IEEE
    'cap-2-1-lec-1': '2.1', // Definición de Norma ISO
    'cap-2-1-lec-2': '2.1', // Beneficios de las Normas
    // 2.2 ISO 9001  [tiene documento]
    'cap-2-2-lec-1': '2.2', // ISO 9001: Sistema de Gestión de Calidad
    // 2.5 ISO/IEC 25010  [tiene documento]
    'cap-2-2-lec-2': '2.5', // ISO 25010: Calidad del Producto
    // 2.6 ISO/IEC 27001 y 27002  [tienen documento]
    'cap-2-3-lec-1': '2.6', // Confidencialidad, Integridad, Disponibilidad
    'cap-2-3-lec-2': '2.6', // ISO 27001: SGSI
    // 2.3 ISO/IEC/IEEE 12207  [tiene documento]
    'cap-2-4-lec-1': '2.3', // Procesos Primarios de Desarrollo
    'cap-2-4-lec-2': '2.3', // Procesos de Soporte

    // ===== MUNDO 3 · Pruebas, Implementación y Mantenimiento (Unidad 4) ======
    // 4.1 V&V, niveles de prueba e ISO/IEC/IEEE 29119
    'cap-3-1-lec-1': '4.1', // Pruebas Unitarias
    'cap-3-1-lec-2': '4.1', // Pruebas de Integración
    'cap-3-1-lec-3': '4.1', // Pruebas de Sistema y UAT
    'cap-3-2-lec-1': '4.1', // Pruebas Caja Blanca
    'cap-3-2-lec-2': '4.1', // Pruebas Caja Negra
    'cap-3-3-lec-1': '4.1', // Ciclo de Vida de un Defecto
    'cap-3-3-lec-2': '4.1', // Severidad vs Prioridad
    // 4.3 CI/CD, configuración y contenedores
    'cap-3-4-lec-1': '4.3', // Estrategias de Despliegue
    'cap-3-4-lec-2': '4.3', // Plan de Rollback
    // 4.4 Mantenimiento y evolución (ISO/IEC/IEEE 14764)
    'cap-3-5-lec-1': '4.4', // Tipos de Mantenimiento
    'cap-3-5-lec-2': '4.4', // Gestión de Mantenimiento

    // ============ MUNDO 4 · Métricas de Proyectos (Unidad 3) =================
    // 3.1 Fundamentos de medición: KPIs, líneas base y GQM
    'cap-4-1-lec-1': '3.1', // Métrica vs Medida vs Indicador
    'cap-4-1-lec-2': '3.1', // Tipos de Métricas
    'cap-4-2-lec-1': '3.1', // Línea Base del Proyecto
    // 3.4 Métricas ágiles y de flujo
    'cap-4-2-lec-2': '3.4', // Seguimiento de Avance
    // 3.3 Métricas de calidad del producto  [tiene documento]
    'cap-4-3-lec-1': '3.3', // Defect Density y Defect Escape Rate
    'cap-4-3-lec-2': '3.3', // Cobertura de Pruebas y MTBF
    // 3.2 Tamaño, esfuerzo y estimación
    'cap-4-4-lec-1': '3.2', // Velocidad y Capacidad en Scrum
    // 3.6 Métricas de UX, seguridad y sostenibilidad; tableros
    'cap-4-4-lec-2': '3.6', // Métricas Humanas
    // 1.8 Gobierno de procesos y mejora continua  [tiene documento]
    'cap-4-5-lec-1': '1.8', // Lecciones Aprendidas
    'cap-4-5-lec-2': '1.8', // Retrospectivas y Mejora Continua
  };

  /// Las cinco claves que el backend YA reconoce hoy, por tema.
  /// Mientras `lecciones.json` no tenga los ids de la app, enviar una de
  /// estas es la única forma de que el filtro por lección funcione de
  /// verdad.
  static const Map<String, String> _claveCanonicaPorTema = {
    '1.2': 'leccion-metodologias-agiles',
    '2.2': 'leccion-iso-9001',
    '2.5': 'leccion-iso-25010',
    '3.4': 'leccion-metricas-agiles',
    '4.1': 'leccion-pruebas-software',
  };

  /// Los 9 temas del sílabo que NO tienen ningún documento indexado
  /// (`reportes/cobertura_silabo.md`). Dentro de una lección que apunte a
  /// uno de estos, el tutor responderá `tipo: "sin_contexto"`, y eso es el
  /// comportamiento correcto, no un fallo: sin documentos un modelo
  /// pequeño se inventa la norma.
  static const Set<String> temasSinDocumentacion = {
    '1.3', '1.4', '2.7', '3.1', '3.4', '3.5', '3.6', '4.2', '4.4',
  };

  /// El `leccion_id` que conviene enviar en `POST /chat` para la lección
  /// [idLeccionApp].
  ///
  /// Devuelve la clave canónica si el tema ya está en `lecciones.json`
  /// (entonces el filtro por lección funciona hoy mismo), y si no, el
  /// propio id de la app: no tiene efecto todavía, pero no rompe nada y
  /// funcionará solo en cuanto Sebastián añada la tabla al JSON.
  static String? leccionIdParaChat(String? idLeccionApp) {
    if (idLeccionApp == null || idLeccionApp.isEmpty) return null;
    final tema = temaPorLeccion[idLeccionApp];
    if (tema == null) return idLeccionApp;
    return _claveCanonicaPorTema[tema] ?? idLeccionApp;
  }

  /// Id del tema del sílabo al que pertenece la lección, o null.
  static String? temaDeLeccion(String? idLeccionApp) =>
      idLeccionApp == null ? null : temaPorLeccion[idLeccionApp];

  /// true si el tutor no tiene documentación para esta lección. Sirve para
  /// avisar al estudiante antes de que pregunte, en vez de dejar que
  /// reciba un "eso no está en mis documentos" y lo lea como un error.
  static bool sinDocumentacion(String? idLeccionApp) {
    final tema = temaDeLeccion(idLeccionApp);
    return tema != null && temasSinDocumentacion.contains(tema);
  }
}
