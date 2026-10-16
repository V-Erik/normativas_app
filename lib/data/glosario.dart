/// Glosario de normativas de ingeniería de software.
///
/// POR QUÉ EXISTE ESTA PANTALLA
/// ---------------------------
/// El diagnóstico del capítulo IV dejó dos datos que apuntan al mismo
/// sitio. El primero: el texto es el formato **menos** preferido por los
/// estudiantes (9,8 % en la P6). El segundo, de la entrevista al
/// profesional: el error más frecuente en desarrolladores junior es
/// "requerimientos con alto grado de subjetividad", que es un problema de
/// vocabulario antes que de técnica. Nadie redacta bien un requisito si
/// no distingue verificación de validación.
///
/// El glosario no pretende ser más contenido que leer. Pretende ser el
/// sitio al que se va cuando una palabra de una lección o de un caso de
/// RA no se entiende, y volver enseguida.
///
/// POR QUÉ ESTÁ AQUÍ Y NO EN EL SERVIDOR
/// -------------------------------------
/// Misma razón que el catálogo de casos: tiene que abrirse al instante y
/// funcionar sin red. Un glosario que tarda tres segundos en cargar no se
/// consulta, y se consulta justo cuando el estudiante está a mitad de
/// otra cosa.
///
/// EL CAMPO [enLaPractica] ES LO QUE LO HACE ÚTIL
/// ----------------------------------------------
/// Una definición de diccionario no enseña nada: "trazabilidad es la
/// capacidad de seguir un requisito a lo largo del ciclo de vida" se
/// entiende y se olvida. Por eso cada término lleva, cuando tiene
/// sentido, una línea que lo aterriza en uno de los ocho casos de los
/// marcadores. Así el glosario y la realidad aumentada se refuerzan en
/// vez de ser dos cosas sueltas.
library;

/// Agrupación temática. Sirve para los filtros de la pantalla y para que
/// el estudiante pueda recorrer el glosario por bloque en vez de en orden
/// alfabético, que es como no lo va a recorrer nunca.
enum CategoriaGlosario {
  calidad('Calidad'),
  seguridad('Seguridad'),
  cicloVida('Ciclo de vida'),
  requisitos('Requisitos'),
  pruebas('Pruebas'),
  agil('Ágil y DevOps');

  const CategoriaGlosario(this.etiqueta);

  /// Texto que se muestra en el chip de filtro.
  final String etiqueta;
}

class TerminoGlosario {
  const TerminoGlosario({
    required this.termino,
    required this.definicion,
    required this.categoria,
    this.sigla,
    this.norma,
    this.enLaPractica,
    this.sinonimos = const [],
  });

  /// Nombre completo, tal como aparece en la norma o en el sílabo.
  final String termino;

  /// Abreviatura de uso corriente, si la tiene. Se muestra junto al
  /// término y también se busca.
  final String? sigla;

  /// Dos o tres frases. La regla al redactarlas fue no usar en la
  /// definición ningún término que no esté también en el glosario.
  final String definicion;

  /// Cómo se ve esto en un proyecto real. Cuando se pudo, el ejemplo es
  /// uno de los ocho casos de los marcadores de RA.
  final String? enLaPractica;

  final CategoriaGlosario categoria;

  /// Norma de referencia, para quien quiera ir a la fuente.
  final String? norma;

  /// Otras formas de nombrarlo. No se muestran: existen para que la
  /// búsqueda encuentre el término aunque se escriba de otra manera.
  final List<String> sinonimos;

  /// Todo lo indexable, en minúsculas y sin tildes.
  String get textoBusqueda => sinTildes([
        termino,
        sigla ?? '',
        definicion,
        norma ?? '',
        ...sinonimos,
      ].join(' '));
}

/// Quita tildes y pasa a minúsculas.
///
/// Sin esto, buscar "gestion" no encuentra "gestión", que es exactamente
/// lo que va a escribir alguien con prisa en el teclado del teléfono.
String sinTildes(String texto) {
  const conAcento = 'áàäâãéèëêíìïîóòöôõúùüûñç';
  const sinAcento = 'aaaaaeeeeiiiiooooouuuunc';
  var resultado = texto.toLowerCase();
  for (var i = 0; i < conAcento.length; i++) {
    resultado = resultado.replaceAll(conAcento[i], sinAcento[i]);
  }
  return resultado;
}

/// Catálogo completo. Está ordenado por categoría y, dentro de cada una,
/// de lo más general a lo más concreto, no alfabéticamente: leído de
/// corrido tiene sentido, y para encontrar algo suelto está el buscador.
abstract final class Glosario {
  static const List<TerminoGlosario> terminos = [
    // ─────────────────────────────── CALIDAD
    TerminoGlosario(
      termino: 'Calidad del software',
      categoria: CategoriaGlosario.calidad,
      definicion:
          'Grado en que un producto satisface las necesidades declaradas e '
          'implícitas de quienes lo usan. No es una propiedad absoluta: se '
          'define siempre respecto de un conjunto de requisitos acordados.',
      enLaPractica:
          'Un sistema puede ser rapidísimo y aun así de mala calidad si lo '
          'que el cliente necesitaba era que fuera auditable.',
      sinonimos: ['calidad'],
    ),
    TerminoGlosario(
      termino: 'Calidad de proceso y calidad de producto',
      categoria: CategoriaGlosario.calidad,
      definicion:
          'La calidad de proceso mide cómo se construye el software: si hay '
          'procedimientos definidos y si se siguen. La calidad de producto '
          'mide el resultado. Un buen proceso hace probable un buen '
          'producto, pero no lo garantiza.',
      enLaPractica:
          'La ISO 9001 y el CMMI miran el proceso; la ISO/IEC 25010 mira el '
          'producto. Por eso se citan juntas y no son redundantes.',
    ),
    TerminoGlosario(
      termino: 'ISO 9001',
      categoria: CategoriaGlosario.calidad,
      norma: 'ISO 9001:2015',
      definicion:
          'Norma de sistemas de gestión de la calidad, aplicable a cualquier '
          'organización y no solo al software. Exige procesos definidos, '
          'registros que demuestren que se siguieron y un ciclo de mejora '
          'continua.',
      enLaPractica:
          'En el caso de la tienda en línea de la PYME es la que obliga a '
          'documentar el proceso de pedido tal como ocurre hoy, antes de '
          'automatizarlo.',
      sinonimos: ['sistema de gestion de la calidad', 'sgc'],
    ),
    TerminoGlosario(
      termino: 'ISO/IEC 25010',
      categoria: CategoriaGlosario.calidad,
      norma: 'ISO/IEC 25010',
      definicion:
          'Modelo de calidad del producto software. Descompone la calidad en '
          'ocho características (adecuación funcional, eficiencia de '
          'desempeño, compatibilidad, usabilidad, fiabilidad, seguridad, '
          'mantenibilidad y portabilidad), cada una con subcaracterísticas '
          'medibles.',
      enLaPractica:
          'Sirve para convertir "la app tiene que ser buena" en requisitos '
          'que se pueden verificar uno a uno.',
      sinonimos: ['square', '25000', 'modelo de calidad'],
    ),
    TerminoGlosario(
      termino: 'Característica de calidad',
      categoria: CategoriaGlosario.calidad,
      norma: 'ISO/IEC 25010',
      definicion:
          'Cada una de las ocho dimensiones en que la ISO/IEC 25010 divide la '
          'calidad de un producto. Se subdividen en subcaracterísticas, y '
          'estas sí se miden con métricas concretas.',
      enLaPractica:
          'La mantenibilidad se descompone en modularidad, reusabilidad, '
          'analizabilidad, modificabilidad y capacidad de ser probado.',
      sinonimos: ['atributo de calidad'],
    ),
    TerminoGlosario(
      termino: 'Métrica',
      categoria: CategoriaGlosario.calidad,
      definicion:
          'Procedimiento definido para asignar un número a un atributo del '
          'software o del proceso. Para que sirva tiene que decir qué se '
          'mide, cómo y respecto de qué valor se compara.',
      enLaPractica:
          '"Cobertura de pruebas del 80 %" es una métrica; "código limpio" '
          'no lo es.',
      sinonimos: ['indicador', 'medicion'],
    ),
    TerminoGlosario(
      termino: 'No conformidad',
      categoria: CategoriaGlosario.calidad,
      norma: 'ISO 9001',
      definicion:
          'Incumplimiento de un requisito, sea del cliente, de la norma o del '
          'propio procedimiento interno. Una auditoría las clasifica como '
          'mayores o menores según su impacto.',
      enLaPractica:
          'Si el procedimiento dice que todo cambio pasa por revisión de '
          'código y hay commits en la rama principal sin revisar, eso es una '
          'no conformidad aunque el código funcione.',
    ),
    TerminoGlosario(
      termino: 'Acción correctiva',
      categoria: CategoriaGlosario.calidad,
      norma: 'ISO 9001',
      definicion:
          'Medida que ataca la causa raíz de una no conformidad para que no '
          'vuelva a ocurrir. Se distingue de la corrección, que solo repara '
          'el efecto puntual.',
      enLaPractica:
          'Arreglar el error es corrección; añadir una prueba automática que '
          'lo habría detectado es acción correctiva.',
    ),
    TerminoGlosario(
      termino: 'Auditoría',
      categoria: CategoriaGlosario.calidad,
      definicion:
          'Revisión sistemática e independiente que compara lo que la '
          'organización dice que hace con lo que las evidencias demuestran '
          'que hace. Puede ser interna o externa.',
      enLaPractica:
          'El auditor no pide opiniones: pide registros. Si no quedó '
          'registrado, a efectos de la auditoría no ocurrió.',
    ),
    TerminoGlosario(
      termino: 'Mejora continua',
      categoria: CategoriaGlosario.calidad,
      norma: 'ISO 9001',
      definicion:
          'Principio según el cual los procesos se revisan y ajustan de forma '
          'periódica a partir de datos. Suele instrumentarse con el ciclo '
          'PHVA: planificar, hacer, verificar y actuar.',
      enLaPractica:
          'Una retrospectiva de Scrum que no genera un cambio comprobable en '
          'el siguiente sprint no es mejora continua, es una reunión.',
      sinonimos: ['phva', 'pdca', 'deming', 'kaizen'],
    ),
    TerminoGlosario(
      termino: 'CMMI',
      sigla: 'CMMI',
      categoria: CategoriaGlosario.calidad,
      norma: 'CMMI for Development',
      definicion:
          'Modelo de madurez de procesos. Ordena a las organizaciones en '
          'niveles, desde el inicial, donde todo depende del esfuerzo '
          'individual, hasta el optimizado, donde los procesos se mejoran con '
          'datos. No certifica productos, evalúa organizaciones.',
      sinonimos: [
        'capability maturity model integration',
        'madurez',
        'niveles de madurez',
      ],
    ),

    // ─────────────────────────────── SEGURIDAD
    TerminoGlosario(
      termino: 'ISO/IEC 27001',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'Norma del sistema de gestión de seguridad de la información. '
          'Establece cómo identificar los activos de información, analizar '
          'sus riesgos y seleccionar controles proporcionados a esos riesgos.',
      enLaPractica:
          'Es la norma del caso de la historia clínica del hospital: ahí el '
          'primer paso no es programar, es definir el alcance del SGSI.',
      sinonimos: ['27001', 'seguridad de la informacion'],
    ),
    TerminoGlosario(
      termino: 'ISO/IEC 27002',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27002',
      definicion:
          'Catálogo de controles de seguridad con su guía de implantación. '
          'Es el complemento práctico de la 27001: esta dice que hay que '
          'tratar el riesgo, y la 27002 propone con qué.',
      sinonimos: ['27002', 'controles'],
    ),
    TerminoGlosario(
      termino: 'Sistema de gestión de seguridad de la información',
      sigla: 'SGSI',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'Conjunto de políticas, procedimientos y controles con los que una '
          'organización gestiona la seguridad de su información. Lo primero '
          'que se define es su alcance: qué sistemas y qué datos cubre.',
      enLaPractica:
          'Delimitar mal el alcance es el error clásico. Si el SGSI del '
          'hospital no incluye el laboratorio externo, ahí queda el agujero.',
      sinonimos: ['sgsi', 'isms'],
    ),
    TerminoGlosario(
      termino: 'Activo de información',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'Cualquier elemento con valor para la organización que haya que '
          'proteger: bases de datos, código fuente, credenciales, '
          'documentación e incluso el conocimiento de las personas.',
      sinonimos: ['activo'],
    ),
    TerminoGlosario(
      termino: 'Amenaza, vulnerabilidad y riesgo',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'La amenaza es el suceso que puede causar daño. La vulnerabilidad '
          'es la debilidad que permitiría que ocurra. El riesgo combina la '
          'probabilidad de que la amenaza aproveche la vulnerabilidad con el '
          'impacto que tendría.',
      enLaPractica:
          'Amenaza: que alguien robe credenciales. Vulnerabilidad: que estén '
          'guardadas sin cifrar. Riesgo: alto, porque el impacto son datos '
          'de salud.',
      sinonimos: ['amenaza', 'vulnerabilidad', 'riesgo'],
    ),
    TerminoGlosario(
      termino: 'Análisis de riesgos',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'Proceso de identificar los riesgos, estimar su probabilidad e '
          'impacto y decidir qué hacer con cada uno: mitigarlo, transferirlo, '
          'aceptarlo o evitarlo. El resultado se registra en una matriz.',
      enLaPractica:
          'En el caso de la banca móvil es el primer paso, antes de escribir '
          'una línea. Omitirlo es uno de los cinco errores que señaló el '
          'profesional entrevistado.',
      sinonimos: ['matriz de riesgos', 'gestion de riesgos', 'evaluacion'],
    ),
    TerminoGlosario(
      termino: 'Control',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27002',
      definicion:
          'Medida concreta que reduce un riesgo. Puede ser técnica (cifrado, '
          'doble factor), organizativa (una política) o física (una puerta '
          'con llave).',
      sinonimos: ['salvaguarda', 'contramedida'],
    ),
    TerminoGlosario(
      termino: 'Confidencialidad, integridad y disponibilidad',
      sigla: 'CID',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'Las tres propiedades que la seguridad de la información protege. '
          'Confidencialidad: solo accede quien debe. Integridad: el dato no '
          'se altera sin autorización. Disponibilidad: está accesible cuando '
          'hace falta.',
      enLaPractica:
          'Suelen entrar en conflicto. Cifrar y exigir doble factor sube la '
          'confidencialidad y baja la disponibilidad en urgencias.',
      sinonimos: ['cia', 'triada'],
    ),
    TerminoGlosario(
      termino: 'Declaración de aplicabilidad',
      sigla: 'SoA',
      categoria: CategoriaGlosario.seguridad,
      norma: 'ISO/IEC 27001',
      definicion:
          'Documento que lista todos los controles de referencia e indica, '
          'para cada uno, si se aplica y por qué. Justificar las exclusiones '
          'es tan obligatorio como justificar las inclusiones.',
      sinonimos: ['soa', 'statement of applicability'],
    ),

    // ─────────────────────────────── CICLO DE VIDA
    TerminoGlosario(
      termino: 'Ciclo de vida del software',
      categoria: CategoriaGlosario.cicloVida,
      norma: 'ISO/IEC/IEEE 12207',
      definicion:
          'Conjunto de etapas por las que pasa un sistema desde que se '
          'concibe hasta que se retira. Un modelo de ciclo de vida es una '
          'forma concreta de ordenar y repetir esas etapas.',
      sinonimos: ['sdlc', 'ciclo de vida'],
    ),
    TerminoGlosario(
      termino: 'ISO/IEC/IEEE 12207',
      categoria: CategoriaGlosario.cicloVida,
      norma: 'ISO/IEC/IEEE 12207',
      definicion:
          'Norma que define los procesos del ciclo de vida del software: qué '
          'procesos existen, qué actividades los componen y qué resultados '
          'debe producir cada uno. No impone un modelo concreto, sirve igual '
          'para cascada que para ágil.',
      enLaPractica:
          'Es la que exige trazabilidad y gestión de la configuración, dos '
          'cosas que se saltan casi todos los proyectos académicos.',
      sinonimos: ['12207', 'procesos del ciclo de vida'],
    ),
    TerminoGlosario(
      termino: 'Modelo en cascada',
      categoria: CategoriaGlosario.cicloVida,
      definicion:
          'Modelo secuencial: cada etapa termina antes de que empiece la '
          'siguiente y produce un documento aprobado. Funciona cuando los '
          'requisitos son estables y el coste de equivocarse al final es '
          'asumible.',
      enLaPractica:
          'Sigue siendo razonable en sistemas con certificación obligatoria, '
          'como el control de un ascensor.',
      sinonimos: ['waterfall', 'cascada'],
    ),
    TerminoGlosario(
      termino: 'Modelo iterativo e incremental',
      categoria: CategoriaGlosario.cicloVida,
      definicion:
          'El sistema se construye en ciclos cortos que añaden funcionalidad '
          'utilizable y permiten revisar decisiones anteriores. Iterativo se '
          'refiere a repetir; incremental, a que cada vuelta entrega algo '
          'más.',
      sinonimos: ['iterativo', 'incremental'],
    ),
    TerminoGlosario(
      termino: 'Gestión de la configuración',
      sigla: 'SCM',
      categoria: CategoriaGlosario.cicloVida,
      norma: 'ISO/IEC/IEEE 12207',
      definicion:
          'Disciplina que controla qué versiones de qué elementos componen el '
          'sistema en cada momento, quién las cambió y por qué. Incluye '
          'control de versiones, gestión de cambios y liberaciones.',
      enLaPractica:
          'Es la que permite responder a "qué exactamente había desplegado el '
          'martes a las tres". En la migración del sistema heredado esa '
          'pregunta aparece siempre.',
      sinonimos: ['configuracion', 'control de versiones'],
    ),
    TerminoGlosario(
      termino: 'Línea base',
      categoria: CategoriaGlosario.cicloVida,
      definicion:
          'Versión de un producto o documento formalmente aprobada, que a '
          'partir de ese momento solo puede cambiarse mediante un '
          'procedimiento de control de cambios.',
      enLaPractica:
          'Sin línea base de requisitos no se puede saber si algo es un '
          'cambio o siempre estuvo pedido, que es el origen de la mitad de '
          'las discusiones con el cliente.',
      sinonimos: ['baseline'],
    ),
    TerminoGlosario(
      termino: 'Deuda técnica',
      categoria: CategoriaGlosario.cicloVida,
      definicion:
          'Coste futuro de las decisiones de diseño o implementación que se '
          'tomaron para ir más rápido ahora. Como una deuda financiera, '
          'genera intereses: cada cambio posterior cuesta un poco más.',
      enLaPractica:
          'No toda deuda es mala. La mala es la que se contrae sin registrarla '
          'y sin plan de pago.',
      sinonimos: ['technical debt'],
    ),

    // ─────────────────────────────── REQUISITOS
    TerminoGlosario(
      termino: 'Requisito funcional y no funcional',
      categoria: CategoriaGlosario.requisitos,
      definicion:
          'El funcional describe qué debe hacer el sistema. El no funcional '
          'describe cómo debe comportarse: rendimiento, seguridad, '
          'usabilidad, disponibilidad. Los no funcionales son los que suelen '
          'quedarse sin escribir y los que hunden proyectos.',
      enLaPractica:
          '"Registrar un pedido" es funcional. "Responder en menos de dos '
          'segundos con cien usuarios simultáneos" es no funcional.',
      sinonimos: ['requerimiento', 'funcional', 'no funcional'],
    ),
    TerminoGlosario(
      termino: 'Requisito verificable',
      categoria: CategoriaGlosario.requisitos,
      definicion:
          'Requisito redactado de forma que exista una prueba capaz de '
          'determinar, sin discusión, si se cumple o no. Si dos personas '
          'razonables pueden discrepar sobre si está cumplido, no es '
          'verificable.',
      enLaPractica:
          '"El sistema debe ser rápido" no es verificable. "El 95 % de las '
          'consultas debe responder en menos de 500 ms" sí lo es.',
      sinonimos: ['ambiguedad', 'subjetividad', 'medible'],
    ),
    TerminoGlosario(
      termino: 'Trazabilidad',
      categoria: CategoriaGlosario.requisitos,
      norma: 'ISO/IEC/IEEE 12207',
      definicion:
          'Capacidad de seguir un requisito en las dos direcciones: hacia '
          'adelante, hasta el diseño, el código y la prueba que lo validan; y '
          'hacia atrás, hasta la necesidad de negocio que lo originó.',
      enLaPractica:
          'Es el tercer error que señala el profesional entrevistado. Sin '
          'trazabilidad no se puede responder a "por qué está este módulo '
          'aquí" ni demostrar que todo lo pedido se probó.',
      sinonimos: ['trazar', 'traceability'],
    ),
    TerminoGlosario(
      termino: 'Matriz de trazabilidad',
      categoria: CategoriaGlosario.requisitos,
      definicion:
          'Tabla que cruza cada requisito con los elementos de diseño, los '
          'componentes de código y los casos de prueba que lo cubren. Las '
          'filas vacías señalan requisitos sin probar; las columnas sin '
          'origen, funcionalidad que nadie pidió.',
      sinonimos: ['matriz', 'rtm'],
    ),
    TerminoGlosario(
      termino: 'Elicitación de requisitos',
      categoria: CategoriaGlosario.requisitos,
      definicion:
          'Actividad de descubrir qué necesita realmente el usuario, mediante '
          'entrevistas, observación, análisis de documentos o prototipos. No '
          'es transcribir lo que pide: es entender el problema que hay '
          'detrás.',
      enLaPractica:
          'En la tienda de la PYME, el cliente pide "un botón de descuentos" '
          'y lo que necesita es controlar el margen por producto.',
      sinonimos: ['levantamiento', 'obtencion', 'elicitacion'],
    ),
    TerminoGlosario(
      termino: 'Interesado',
      categoria: CategoriaGlosario.requisitos,
      definicion:
          'Cualquier persona u organización afectada por el sistema o con '
          'capacidad de influir en él. Incluye a quien paga, a quien lo usa, '
          'a quien lo mantiene y a quien lo audita, que casi nunca son los '
          'mismos.',
      sinonimos: ['stakeholder', 'parte interesada'],
    ),

    // ─────────────────────────────── PRUEBAS
    TerminoGlosario(
      termino: 'Verificación y validación',
      sigla: 'V&V',
      categoria: CategoriaGlosario.pruebas,
      norma: 'ISO/IEC/IEEE 12207',
      definicion:
          'Verificar es comprobar que el producto se construyó conforme a su '
          'especificación. Validar es comprobar que esa especificación '
          'resolvía el problema real. Se puede verificar con éxito un sistema '
          'que no sirve para nada.',
      enLaPractica:
          'Verificación: "¿lo construimos bien?". Validación: "¿construimos '
          'lo correcto?". En el caso del ascensor hay que separarlas desde '
          'los requisitos.',
      sinonimos: ['verificacion', 'validacion', 'vyv'],
    ),
    TerminoGlosario(
      termino: 'ISO/IEC/IEEE 29119',
      categoria: CategoriaGlosario.pruebas,
      norma: 'ISO/IEC/IEEE 29119',
      definicion:
          'Norma de pruebas de software. Cubre el proceso de pruebas, la '
          'documentación, las técnicas de diseño de casos y las pruebas '
          'basadas en palabras clave.',
      sinonimos: ['29119', 'norma de pruebas'],
    ),
    TerminoGlosario(
      termino: 'Niveles de prueba',
      categoria: CategoriaGlosario.pruebas,
      norma: 'ISO/IEC/IEEE 29119',
      definicion:
          'Escalones en los que se organiza la prueba: unitaria sobre piezas '
          'aisladas, de integración sobre sus interacciones, de sistema sobre '
          'el conjunto, y de aceptación frente a las necesidades del usuario.',
      enLaPractica:
          'Cada nivel se deriva de un documento distinto. La de aceptación '
          'sale de los requisitos de usuario, no del código.',
      sinonimos: ['unitaria', 'integracion', 'sistema', 'niveles'],
    ),
    TerminoGlosario(
      termino: 'Prueba de aceptación',
      categoria: CategoriaGlosario.pruebas,
      definicion:
          'Prueba final que ejecuta o acuerda el cliente para decidir si el '
          'sistema cubre lo que necesitaba. Sus criterios deben estar '
          'definidos al escribir el requisito, no al terminar el desarrollo.',
      enLaPractica:
          'Si los criterios se negocian al final, el proyecto ya se perdió: '
          'lo que se discute entonces es el alcance, no la calidad.',
      sinonimos: ['uat', 'aceptacion', 'criterios de aceptacion'],
    ),
    TerminoGlosario(
      termino: 'Error, defecto y fallo',
      categoria: CategoriaGlosario.pruebas,
      definicion:
          'El error es la equivocación humana. El defecto es su huella en el '
          'código o en el documento. El fallo es el comportamiento incorrecto '
          'que el usuario percibe. Un defecto puede existir años sin producir '
          'ningún fallo.',
      enLaPractica:
          'Por eso "no ha fallado nunca" no es evidencia de que no haya '
          'defectos.',
      sinonimos: ['bug', 'error', 'defecto', 'falla', 'fallo'],
    ),
    TerminoGlosario(
      termino: 'Caso de prueba',
      categoria: CategoriaGlosario.pruebas,
      norma: 'ISO/IEC/IEEE 29119',
      definicion:
          'Conjunto formado por precondiciones, datos de entrada, pasos y '
          'resultado esperado, con el que se comprueba una condición '
          'concreta. Sin resultado esperado escrito de antemano, no es un '
          'caso de prueba.',
      sinonimos: ['test case'],
    ),
    TerminoGlosario(
      termino: 'Prueba de regresión',
      categoria: CategoriaGlosario.pruebas,
      definicion:
          'Reejecución de pruebas que ya pasaban, para comprobar que un '
          'cambio nuevo no rompió nada que antes funcionaba. Es la primera '
          'candidata a automatizarse, porque se repite en cada entrega.',
      enLaPractica:
          'En el caso de los defectos que llegan a producción, suele faltar '
          'justamente esto.',
      sinonimos: ['regresion'],
    ),
    TerminoGlosario(
      termino: 'Cobertura de pruebas',
      categoria: CategoriaGlosario.pruebas,
      definicion:
          'Proporción del sistema ejercitada por las pruebas, medida sobre '
          'líneas, ramas o requisitos. Es un indicador de lo que no se ha '
          'probado, no una garantía sobre lo que sí.',
      enLaPractica:
          'Un 100 % de cobertura de líneas con aserciones vacías no prueba '
          'absolutamente nada.',
      sinonimos: ['coverage'],
    ),

    // ─────────────────────────────── ÁGIL Y DEVOPS
    TerminoGlosario(
      termino: 'Scrum',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Marco de trabajo iterativo que organiza el desarrollo en sprints '
          'de duración fija, con tres responsabilidades definidas, cuatro '
          'eventos y tres artefactos. No es una metodología de gestión de '
          'proyectos: deja fuera a propósito casi todo.',
      enLaPractica:
          'Es el marco que el equipo nuevo de la app de delivery necesita '
          'para dejar de improvisar la planificación.',
      sinonimos: ['scrum master', 'product owner'],
    ),
    TerminoGlosario(
      termino: 'Sprint',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Periodo de duración fija, habitualmente de una a cuatro semanas, '
          'al final del cual el equipo entrega un incremento utilizable. Su '
          'duración no se alarga para que quepa el trabajo pendiente.',
      sinonimos: ['iteracion'],
    ),
    TerminoGlosario(
      termino: 'Backlog del producto',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Lista ordenada de todo lo que podría necesitar el producto. Está '
          'siempre priorizada y nunca completa: se refina de forma continua a '
          'medida que se aprende.',
      sinonimos: ['backlog', 'pila de producto'],
    ),
    TerminoGlosario(
      termino: 'Definición de hecho',
      sigla: 'DoD',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Acuerdo explícito del equipo sobre qué condiciones debe cumplir un '
          'elemento para considerarse terminado: probado, revisado, '
          'documentado, desplegable. Evita la discusión sobre qué significa '
          '"ya está".',
      enLaPractica:
          'Es el sitio natural para meter los requisitos de la norma: si la '
          'definición de hecho exige trazabilidad, deja de depender de que '
          'alguien se acuerde.',
      sinonimos: ['dod', 'definition of done', 'terminado'],
    ),
    TerminoGlosario(
      termino: 'Retrospectiva',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Reunión de fin de sprint en la que el equipo examina cómo trabajó y '
          'acuerda una mejora concreta para el siguiente. Es el mecanismo de '
          'mejora continua dentro de Scrum.',
      enLaPractica:
          'El caso de las retrospectivas que no cambian nada trata justo de '
          'esto: sin un acuerdo accionable y con responsable, la reunión no '
          'produce mejora.',
      sinonimos: ['retro'],
    ),
    TerminoGlosario(
      termino: 'Kanban',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Método de flujo continuo que visualiza el trabajo en un tablero y '
          'limita cuántos elementos pueden estar en curso a la vez. No usa '
          'iteraciones de duración fija.',
      enLaPractica:
          'El profesional entrevistado lo prefiere frente a Scrum para '
          'equipos pequeños, porque exige menos estructura de roles.',
      sinonimos: ['wip', 'tablero', 'flujo'],
    ),
    TerminoGlosario(
      termino: 'Integración y entrega continuas',
      sigla: 'CI/CD',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Práctica de integrar los cambios en la rama principal varias veces '
          'al día, con una tubería automática que compila, prueba y prepara '
          'el despliegue en cada integración.',
      enLaPractica:
          'La tubería es también evidencia de auditoría: deja registro '
          'automático de qué se probó y cuándo.',
      sinonimos: ['ci', 'cd', 'integracion continua', 'pipeline'],
    ),
    TerminoGlosario(
      termino: 'DevOps',
      categoria: CategoriaGlosario.agil,
      definicion:
          'Enfoque que integra desarrollo y operación en un mismo flujo de '
          'responsabilidad, apoyado en automatización, despliegues frecuentes '
          'y monitorización. Es tanto un cambio cultural como técnico.',
      sinonimos: ['devsecops'],
    ),
  ];

  /// Términos de una categoría, en el orden del catálogo.
  static List<TerminoGlosario> porCategoria(CategoriaGlosario categoria) =>
      terminos.where((t) => t.categoria == categoria).toList();

  /// Búsqueda tolerante a tildes y a mayúsculas.
  ///
  /// Los resultados se ordenan poniendo delante los términos cuyo nombre
  /// empieza por lo buscado: quien escribe "traza" quiere "Trazabilidad"
  /// arriba, no las seis definiciones que la mencionan de pasada.
  static List<TerminoGlosario> buscar(String consulta) {
    final q = sinTildes(consulta.trim());
    if (q.isEmpty) return terminos;

    final encontrados =
        terminos.where((t) => t.textoBusqueda.contains(q)).toList();

    encontrados.sort((a, b) {
      final ia = sinTildes(a.termino).indexOf(q);
      final ib = sinTildes(b.termino).indexOf(q);
      // -1 significa que la coincidencia está en la definición, no en el
      // nombre; esos van al final.
      final pa = ia < 0 ? 1000 : ia;
      final pb = ib < 0 ? 1000 : ib;
      if (pa != pb) return pa.compareTo(pb);
      return a.termino.compareTo(b.termino);
    });

    return encontrados;
  }
}
