/// BASE DE CONOCIMIENTO DIDÁCTICO
///
/// Cada lección se divide en tarjetas cortas que el estudiante avanza una a
/// una, en lugar de un bloque largo de texto.
///
/// Fuentes: ISO/IEC/IEEE 12207, ISO 9001:2015, ISO/IEC 25010,
/// ISO/IEC 27001, ISO/IEC/IEEE 29119, ISO/IEC 14764, Manifiesto Ágil,
/// Scrum Guide y el Plan Analítico de Normativas de Ingeniería de Software.

/// Una tarjeta de teoría: una sola idea por pantalla.
class TarjetaTeoria {
  /// Lo que dice la mascota en la burbuja.
  final String mensaje;

  /// Título corto de la idea. Puede ir vacío.
  final String titulo;

  /// Cuerpo de la tarjeta. Dos o tres frases como máximo.
  final String texto;

  /// Lista breve, cuando la idea se entiende mejor enumerada.
  final List<String> vinetas;

  /// Dato o ejemplo que se resalta en una caja aparte.
  final String? destacado;

  const TarjetaTeoria({
    required this.mensaje,
    this.titulo = '',
    this.texto = '',
    this.vinetas = const [],
    this.destacado,
  });
}

class ContenidoLeccion {
  final String leccionId;
  final String titulo;
  final List<TarjetaTeoria> tarjetas;
  final int tiempoLectura;

  const ContenidoLeccion({
    required this.leccionId,
    required this.titulo,
    required this.tarjetas,
    required this.tiempoLectura,
  });
}

class MockContenidos {
  static const Map<String, ContenidoLeccion> _contenidos = {

    // =================================================================
    // MUNDO 1 — METODOLOGÍAS DE DESARROLLO
    // =================================================================

    'cap-1-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-1-lec-1',
      titulo: 'Qué es el SDLC',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Empecemos por lo básico',
          titulo: 'El ciclo de vida del software',
          texto:
              'Es el orden en que ocurren las cosas: desde que alguien necesita '
              'algo hasta que el sistema se apaga para siempre.',
        ),
        TarjetaTeoria(
          mensaje: 'Ojo con esto',
          titulo: 'No es una herramienta',
          texto:
              'El SDLC no se instala ni se programa. Es la estructura que evita '
              'que el equipo improvise.',
        ),
        TarjetaTeoria(
          mensaje: 'Aquí entra la norma',
          titulo: 'ISO/IEC/IEEE 12207',
          texto: 'Es el estándar internacional que define el ciclo. Agrupa los '
              'procesos en tres familias.',
          vinetas: [
            'Técnicos: construir el producto',
            'De gestión: controlar el proyecto',
            'Organizacionales: sostener a la empresa',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Un ejemplo real',
          titulo: 'Sistema de matrícula',
          texto:
              'Sin análisis previo, el equipo programa pantallas y a mitad de '
              'camino descubre que nadie definió qué pasa con un estudiante que '
              'debe dinero. Toca rehacer.',
          destacado:
              'Programar antes de analizar es el error más común en quienes '
              'recién empiezan. El SDLC existe para impedirlo.',
        ),
      ],
    ),

    'cap-1-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-1-lec-2',
      titulo: 'Fases del SDLC',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Seis pasos, en orden',
          titulo: 'Las fases',
          vinetas: [
            'Análisis: qué hay que construir',
            'Diseño: cómo se va a construir',
            'Desarrollo: se escribe el código',
            'Pruebas: se verifica que sirve',
            'Despliegue: sale a producción',
            'Mantenimiento: se corrige y crece',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Esto sorprende a muchos',
          titulo: 'El mantenimiento gana',
          texto:
              'Durante la vida de un sistema, mantenerlo cuesta más esfuerzo que '
              'construirlo. A veces mucho más.',
        ),
        TarjetaTeoria(
          mensaje: 'La palabra clave',
          titulo: 'Trazabilidad',
          texto:
              'Cada requisito que levantas en el análisis debe poder seguirse '
              'hasta la prueba que lo comprueba.',
          destacado:
              'Un requisito sin prueba asociada no se puede demostrar. Y lo que '
              'no se demuestra, el cliente no lo paga.',
        ),
        TarjetaTeoria(
          mensaje: 'El documento olvidado',
          titulo: 'Matriz de riesgos',
          texto:
              'Registra qué puede salir mal, qué tan probable es y qué se hará. '
              'Casi ningún equipo la hace. Casi todos se retrasan por algo que '
              'habría estado ahí.',
        ),
      ],
    ),

    'cap-1-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-2-lec-1',
      titulo: 'Modelo Waterfall paso a paso',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El más antiguo de todos',
          titulo: 'Cascada',
          texto:
              'Una fase termina, se documenta, se aprueba. Recién ahí empieza la '
              'siguiente. El agua cae y no vuelve a subir.',
        ),
        TarjetaTeoria(
          mensaje: 'Así se ve',
          titulo: 'La secuencia',
          vinetas: [
            'Requisitos',
            'Diseño',
            'Implementación',
            'Pruebas',
            'Mantenimiento',
          ],
          texto: 'Cada flecha necesita una firma antes de avanzar.',
        ),
        TarjetaTeoria(
          mensaje: 'Y esto trae dos consecuencias',
          titulo: 'Predecible pero lento',
          texto:
              'Sabes exactamente qué entregas y cuándo. Pero el cliente no ve '
              'nada funcionando hasta el final.',
          destacado:
              'Si entendiste mal un requisito, te enteras cuando ya está todo '
              'programado. Ahí corregir es caro.',
        ),
      ],
    ),

    'cap-1-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-2-lec-2',
      titulo: 'Cuándo usar Waterfall',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Lo bueno',
          titulo: 'Por qué sigue vivo',
          vinetas: [
            'Documentación completa de cada fase',
            'Costos y plazos estimables desde el día uno',
            'Auditorías fáciles: todo deja evidencia',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Lo malo, y es uno solo',
          titulo: 'No soporta el cambio',
          texto:
              'Cambiar un requisito cuando ya se programa significa volver '
              'atrás, rehacer diseño, rehacer documentos y renegociar plazos.',
        ),
        TarjetaTeoria(
          mensaje: 'Entonces, ¿cuándo sí?',
          titulo: 'Sectores regulados',
          texto:
              'Aeroespacial, salud, banca. Ahí los requisitos los fija una '
              'norma, no el cliente, y no van a cambiar a mitad del proyecto.',
          destacado:
              'La pregunta no es qué metodología es mejor. Es cuánta '
              'incertidumbre tiene tu proyecto.',
        ),
      ],
    ),

    'cap-1-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-3-lec-1',
      titulo: 'Principios Ágiles',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Año 2001, Utah',
          titulo: 'El Manifiesto Ágil',
          texto:
              'Diecisiete personas se juntaron a esquiar y salieron con cuatro '
              'frases que cambiaron la industria.',
        ),
        TarjetaTeoria(
          mensaje: 'Los cuatro valores',
          titulo: 'Esto vale más que aquello',
          vinetas: [
            'Personas, más que procesos',
            'Software funcionando, más que documentos',
            'Colaborar, más que negociar el contrato',
            'Responder al cambio, más que seguir el plan',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y aquí casi todos se equivocan',
          titulo: 'No dice lo que crees',
          texto:
              'El manifiesto no dice que documentar no importe. Dice que importa '
              'menos. Es una jerarquía, no una lista de cosas que puedes borrar.',
          destacado:
              'Un equipo que no documenta nada no es ágil. Es desordenado.',
        ),
        TarjetaTeoria(
          mensaje: 'Un dato de ahora mismo',
          titulo: 'Los ciclos se acortaron',
          texto:
              'Con asistentes de IA, lo que antes era un sprint de dos semanas '
              'hoy se resuelve en horas. La retroalimentación llega mucho antes.',
        ),
      ],
    ),

    'cap-1-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-3-lec-2',
      titulo: 'Scrum en detalle',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Tres personas, tres trabajos',
          titulo: 'Los roles',
          vinetas: [
            'Product Owner: decide qué se construye',
            'Scrum Master: quita obstáculos',
            'Equipo: decide cómo construirlo',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Cuidado con este',
          titulo: 'El Product Owner no manda en lo técnico',
          texto:
              'Prioriza el backlog y define el orden. La arquitectura, el '
              'lenguaje y la forma de implementar los decide el equipo.',
        ),
        TarjetaTeoria(
          mensaje: 'Cuatro reuniones',
          titulo: 'Los eventos',
          vinetas: [
            'Planificación: qué entra al sprint',
            'Daily: 15 minutos, de pie',
            'Review: se muestra lo hecho',
            'Retrospectiva: cómo trabajamos',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Pero Scrum no siempre cabe',
          titulo: 'Kanban, la alternativa',
          texto:
              'Sin sprints y sin roles obligatorios. Un tablero, columnas, y un '
              'límite de cuántas tareas pueden estar en curso a la vez.',
          destacado:
              'Scrum necesita gente para sus tres roles. Si el equipo es de tres '
              'personas, Kanban pesa menos y funciona mejor.',
        ),
      ],
    ),

    'cap-1-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-4-lec-1',
      titulo: 'CI/CD Pipelines',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Dos equipos que peleaban',
          titulo: 'De dónde sale DevOps',
          texto:
              'Desarrollo quiere entregar rápido. Operaciones quiere que nada se '
              'caiga. "En mi máquina funciona" contra "no lo subo a producción".',
        ),
        TarjetaTeoria(
          mensaje: 'La primera pieza',
          titulo: 'CI: Integración Continua',
          texto:
              'Cada vez que subes código, el servidor lo compila y corre todas '
              'las pruebas solo. Si rompiste algo, lo sabes en minutos.',
        ),
        TarjetaTeoria(
          mensaje: 'Y la segunda',
          titulo: 'CD: son dos cosas distintas',
          vinetas: [
            'Entrega Continua: queda listo, alguien aprueba',
            'Despliegue Continuo: sale solo, sin aprobación',
          ],
          destacado: 'La diferencia es quién aprieta el botón final.',
        ),
        TarjetaTeoria(
          mensaje: 'Falta una letra',
          titulo: 'DevSecOps',
          texto:
              'La seguridad entra dentro del mismo pipeline. Se buscan '
              'vulnerabilidades en cada cambio, no en una revisión al final.',
        ),
      ],
    ),

    'cap-1-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-4-lec-2',
      titulo: 'Automatización y Monitoreo',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Primero, automatizar',
          titulo: 'Infraestructura como código',
          texto:
              'La configuración del servidor se escribe en un archivo y se sube '
              'al repositorio. Si el servidor muere, levantas otro igual '
              'ejecutando ese archivo.',
          destacado:
              'La configuración deja de vivir en la cabeza de una persona.',
        ),
        TarjetaTeoria(
          mensaje: 'Después, mirar',
          titulo: 'Qué medir en producción',
          vinetas: [
            'Latencia: cuánto tarda en responder',
            'Errores: qué porcentaje falla',
            'Tráfico: cuánta gente entra',
            'Saturación: qué tan lleno está',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'La regla de oro',
          titulo: 'Enterarse antes que el usuario',
          texto:
              'Si el cliente te avisa que el sistema se cayó, el monitoreo '
              'falló. Las alertas existen para adelantarse.',
        ),
      ],
    ),

    // =================================================================
    // MUNDO 2 — NORMATIVAS Y CALIDAD
    // =================================================================

    'cap-2-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-1-lec-1',
      titulo: 'Definición de Norma ISO',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Quién las escribe',
          titulo: 'ISO',
          texto:
              'Organización Internacional de Normalización. Expertos de más de '
              '160 países se ponen de acuerdo y publican un estándar.',
        ),
        TarjetaTeoria(
          mensaje: 'Dato que confunde',
          titulo: 'No son leyes',
          texto:
              'Las normas ISO son voluntarias. Nadie te multa por no cumplirlas. '
              'Pero los contratos y las licitaciones las exigen, y eso las '
              'vuelve obligatorias en la práctica.',
        ),
        TarjetaTeoria(
          mensaje: 'Aprende a leer el nombre',
          titulo: 'Qué significa cada prefijo',
          vinetas: [
            'ISO: solo esa organización',
            'ISO/IEC: junto a la comisión electrotécnica',
            'ISO/IEC/IEEE: se suma el IEEE',
          ],
          destacado: 'El año indica la versión: ISO 9001:2015 es la de 2015.',
        ),
        TarjetaTeoria(
          mensaje: 'Las que verás en esta materia',
          titulo: 'Tu mapa',
          vinetas: [
            '12207: procesos del ciclo de vida',
            '25010: calidad del producto',
            '27001: seguridad de la información',
            '29119: pruebas',
            '9001: gestión de la calidad',
          ],
        ),
      ],
    ),

    'cap-2-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-1-lec-2',
      titulo: 'Beneficios de las Normas',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El beneficio principal',
          titulo: 'Criterio en lugar de opinión',
          texto:
              'Sin norma, discutir si un software es bueno se reduce a gustos. '
              'Con ISO/IEC 25010 dices: el acoplamiento supera el umbral, la '
              'mantenibilidad es baja.',
        ),
        TarjetaTeoria(
          mensaje: 'Tres efectos más',
          titulo: 'Qué ganas',
          vinetas: [
            'Consistencia: distintos equipos, mismo resultado',
            'Confianza: el cliente no necesita auditarte',
            'Mejora: te obliga a medir, y lo medido se mejora',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Lo ves en la vida real',
          titulo: 'En una licitación pública',
          texto:
              'La entidad exige ISO 9001 al proveedor. No es capricho: es su '
              'forma de bajar el riesgo sin auditar a cada empresa que se '
              'presenta.',
        ),
        TarjetaTeoria(
          mensaje: 'Y si no las tienes',
          titulo: 'El costo de no tenerlas',
          texto:
              'Sin estándar de documentación, el conocimiento se va cuando '
              'renuncia alguien. Sin estándar de pruebas, los defectos los '
              'descubre el usuario.',
          destacado: 'La norma no es burocracia. Es memoria de la organización.',
        ),
      ],
    ),

    'cap-2-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-2-lec-1',
      titulo: 'ISO 9001: Sistema de Gestión de Calidad',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Lo primero que hay que entender',
          titulo: 'No mira el producto',
          texto:
              'ISO 9001 certifica a la organización, no al software. Su apuesta '
              'es que un proceso ordenado produce resultados parejos.',
        ),
        TarjetaTeoria(
          mensaje: 'Su herramienta central',
          titulo: 'El ciclo PHVA',
          vinetas: [
            'Planificar: qué hacer y cómo medirlo',
            'Hacer: ejecutar',
            'Verificar: comparar con lo planeado',
            'Actuar: corregir las desviaciones',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Un ejemplo concreto',
          titulo: 'PHVA con defectos',
          texto:
              'Planificar: bajar 30 % los defectos este trimestre. Hacer: '
              'revisión de código obligatoria. Verificar: contar. Actuar: si no '
              'se logró, buscar la causa.',
        ),
        TarjetaTeoria(
          mensaje: 'El malentendido más caro',
          titulo: 'No se trata de escribir manuales',
          texto:
              'La documentación es la evidencia, no el objetivo. Si un proceso '
              'está escrito pero nadie lo sigue, el auditor levanta una no '
              'conformidad.',
          destacado:
              'El certificado dura tres años, con auditorías de seguimiento '
              'cada año.',
        ),
      ],
    ),

    'cap-2-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-2-lec-2',
      titulo: 'ISO 25010: Calidad del Producto',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La diferencia con la anterior',
          titulo: 'Esta sí mira el producto',
          texto:
              'ISO 9001 evalúa cómo trabaja la empresa. ISO/IEC 25010 evalúa el '
              'software que salió.',
        ),
        TarjetaTeoria(
          mensaje: 'Ocho características',
          titulo: 'El modelo de calidad',
          vinetas: [
            'Adecuación funcional',
            'Eficiencia de desempeño',
            'Compatibilidad',
            'Usabilidad',
            'Fiabilidad',
            'Seguridad',
            'Mantenibilidad',
            'Portabilidad',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Cada una se abre',
          titulo: 'Subcaracterísticas',
          texto:
              'La mantenibilidad, por ejemplo, se divide en modularidad, '
              'reusabilidad, analizabilidad, modificabilidad y capacidad de ser '
              'probado. Ahí es donde se puede medir.',
        ),
        TarjetaTeoria(
          mensaje: 'Aplícalo ya',
          titulo: 'Un requisito bien escrito',
          texto:
              '"El sistema debe ser rápido" no sirve: no se puede verificar.',
          destacado:
              '"El 95 % de las consultas responde en menos de 2 segundos con '
              '100 usuarios simultáneos" sí sirve. Eso es comportamiento '
              'temporal.',
        ),
      ],
    ),

    'cap-2-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-3-lec-1',
      titulo: 'Confidencialidad, Integridad, Disponibilidad (CIA)',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Todo parte de aquí',
          titulo: 'La triada CIA',
          vinetas: [
            'Confidencialidad: solo quien debe, accede',
            'Integridad: nadie altera los datos sin permiso',
            'Disponibilidad: está ahí cuando se necesita',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Míralo en algo que conoces',
          titulo: 'Un sistema de notas',
          texto:
              'Confidencialidad: cada estudiante ve solo las suyas. Integridad: '
              'nadie cambia una calificación sin dejar rastro. Disponibilidad: '
              'funciona el día del cierre de actas.',
        ),
        TarjetaTeoria(
          mensaje: 'Y aquí está el problema',
          titulo: 'Las tres pelean entre sí',
          texto:
              'Cifrar todo mejora la confidencialidad, pero si pierdes la clave '
              'pierdes la disponibilidad. Replicar datos mejora la '
              'disponibilidad, pero multiplica por dónde se pueden filtrar.',
          destacado:
              'Diseñar seguridad es elegir dónde equilibrar. No se puede '
              'maximizar las tres.',
        ),
      ],
    ),

    'cap-2-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-3-lec-2',
      titulo: 'ISO 27001: Sistema de Gestión de Seguridad',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Misma lógica que ISO 9001',
          titulo: 'El SGSI',
          texto:
              'Sistema de Gestión de Seguridad de la Información. Identificas '
              'tus activos, evalúas qué los amenaza, eliges controles y revisas '
              'cada cierto tiempo.',
        ),
        TarjetaTeoria(
          mensaje: 'Esto se malentiende seguido',
          titulo: 'No se aplican todos los controles',
          texto:
              'La norma trae un anexo con controles de referencia. Tú eliges los '
              'que tu análisis de riesgos justifica y explicas por qué '
              'descartaste el resto.',
          destacado:
              'Ese documento se llama Declaración de Aplicabilidad.',
        ),
        TarjetaTeoria(
          mensaje: 'En tu día a día',
          titulo: 'Seguridad al programar',
          vinetas: [
            'Revisar el código buscando puertas traseras',
            'Analizar vulnerabilidades en las dependencias',
            'Controlar quién entra al repositorio',
          ],
        ),
      ],
    ),

    'cap-2-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-4-lec-1',
      titulo: 'Procesos Primarios de Desarrollo',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Los que producen valor',
          titulo: 'Procesos primarios',
          vinetas: [
            'Acuerdo: qué se construye y bajo qué reglas',
            'Adquisición y suministro: cliente y proveedor',
            'Desarrollo: del requisito a la integración',
            'Operación: mantenerlo andando',
            'Mantenimiento: corregirlo y hacerlo crecer',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Algo que da libertad',
          titulo: 'La norma no te dice cómo',
          texto:
              'Define qué resultados debe producir cada proceso. Cómo los logras '
              'es tu decisión. Por eso 12207 funciona con cascada y con Scrum.',
        ),
        TarjetaTeoria(
          mensaje: 'El que más se salta',
          titulo: 'El proceso de acuerdo',
          texto:
              'Antes de una línea de código: alcance, criterios de aceptación, '
              'plazos, responsabilidades.',
          destacado:
              'Casi todos los conflictos al entregar nacen de haberse saltado '
              'este paso.',
        ),
      ],
    ),

    'cap-2-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-4-lec-2',
      titulo: 'Procesos de Soporte',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'No hacen el producto',
          titulo: 'Pero sin ellos se cae',
          vinetas: [
            'Documentación',
            'Gestión de configuración',
            'Aseguramiento de la calidad',
            'Verificación y validación',
            'Resolución de problemas',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Estas dos se confunden siempre',
          titulo: 'Verificar no es validar',
          vinetas: [
            'Verificar: ¿se construyó bien?',
            'Validar: ¿se construyó lo correcto?',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Un caso que duele',
          titulo: 'Verificación bien, validación mal',
          texto:
              'El sistema calcula el promedio tal como decía el requisito. '
              'Verificación superada. Pero el reglamento pondera las notas y eso '
              'nadie lo preguntó.',
          destacado: 'El código está perfecto. El producto no sirve.',
        ),
      ],
    ),

    // =================================================================
    // MUNDO 3 — PRUEBAS, IMPLEMENTACIÓN Y MANTENIMIENTO
    // =================================================================

    'cap-3-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-1-lec-1',
      titulo: 'Pruebas Unitarias',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La prueba más pequeña',
          titulo: 'Una función a la vez',
          texto:
              'Pruebas una sola función, aislada. Sin base de datos, sin red, '
              'sin depender de otros módulos.',
        ),
        TarjetaTeoria(
          mensaje: 'Si necesita algo externo',
          titulo: 'Dobles de prueba',
          texto:
              'Se reemplaza lo externo por una versión falsa que devuelve lo que '
              'tú decidas. Así la prueba nunca depende de que el servidor esté '
              'arriba.',
        ),
        TarjetaTeoria(
          mensaje: 'Por qué importa tanto',
          titulo: 'Velocidad',
          texto:
              'Una suite unitaria corre en segundos. Por eso se ejecuta en cada '
              'cambio y atrapa las regresiones de inmediato.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué probar, en concreto',
          titulo: 'Validar una cédula',
          vinetas: [
            'Una cédula válida',
            'Una inválida',
            'Campo vacío',
            'Longitud incorrecta',
            'Letras en lugar de números',
          ],
          destacado:
              'Los casos raros encuentran más defectos que el caso que sí '
              'funciona.',
        ),
      ],
    ),

    'cap-3-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-1-lec-2',
      titulo: 'Pruebas de Integración',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Un nivel más arriba',
          titulo: 'Los módulos hablando entre sí',
          texto:
              'Cada módulo puede estar perfecto por separado y fallar al '
              'conectarse, porque cada lado entendió la interfaz distinto.',
        ),
        TarjetaTeoria(
          mensaje: 'El clásico',
          titulo: 'Fallo de formato',
          texto:
              'Usuarios manda la fecha como 14/09/2026. Reportes la espera como '
              '2026-09-14. Ambos pasan sus pruebas unitarias. Juntos producen '
              'basura.',
        ),
        TarjetaTeoria(
          mensaje: 'Dos formas de hacerlo',
          titulo: 'Incremental o big bang',
          vinetas: [
            'Incremental: de a poco, fácil de depurar',
            'Big bang: todo junto, rápido de montar',
          ],
          destacado:
              'Con big bang, si algo falla estás buscando a ciegas entre todos '
              'los módulos.',
        ),
      ],
    ),

    'cap-3-1-lec-3': ContenidoLeccion(
      leccionId: 'cap-3-1-lec-3',
      titulo: 'Pruebas de Sistema y UAT',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Ahora sí, todo junto',
          titulo: 'Prueba de sistema',
          texto:
              'El producto completo, integrado, en un entorno parecido a '
              'producción, contra los requisitos. Funcionales y no funcionales.',
        ),
        TarjetaTeoria(
          mensaje: 'Y la última de todas',
          titulo: 'UAT',
          texto:
              'La ejecuta el cliente, no el equipo. Su pregunta no es si cumple '
              'la especificación, sino si resuelve el problema.',
          destacado:
              'Es tu última oportunidad de descubrir que construiste algo '
              'correcto pero inútil.',
        ),
        TarjetaTeoria(
          mensaje: 'Sin esto la UAT se desarma',
          titulo: 'Criterios de aceptación',
          texto:
              'Deben estar escritos antes. Si no, la prueba se convierte en una '
              'opinión sobre si al cliente le gustó, y eso no se puede cerrar.',
        ),
      ],
    ),

    'cap-3-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-2-lec-1',
      titulo: 'Pruebas Caja Blanca (White-box)',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Con el código a la vista',
          titulo: 'Caja blanca',
          texto:
              'El tester lee el código y diseña los casos según su estructura. '
              'El objetivo es recorrer todos los caminos posibles.',
        ),
        TarjetaTeoria(
          mensaje: 'Cómo se mide',
          titulo: 'Cobertura',
          vinetas: [
            'De sentencias: qué % de líneas se ejecutó',
            'De ramas: qué % de decisiones se probó en ambos sentidos',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Aviso importante',
          titulo: 'Cobertura alta no es calidad',
          texto:
              'Puedes ejecutar el 100 % del código sin comprobar ni un solo '
              'resultado. La cobertura dice qué recorriste, no qué verificaste.',
          destacado:
              'Un if necesita dos casos: uno que lo haga verdadero y otro falso. '
              'Solo con el verdadero, la cobertura de ramas queda en 50 %.',
        ),
      ],
    ),

    'cap-3-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-2-lec-2',
      titulo: 'Pruebas Caja Negra (Black-box)',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Sin ver el código',
          titulo: 'Caja negra',
          texto:
              'Diseñas desde la especificación: con estas entradas, el sistema '
              'debe dar estas salidas. Es la mirada del usuario.',
        ),
        TarjetaTeoria(
          mensaje: 'Primera técnica',
          titulo: 'Clases de equivalencia',
          texto:
              'Agrupas las entradas que el sistema debería tratar igual y '
              'pruebas un representante de cada grupo. No hace falta probar los '
              'mil casos.',
        ),
        TarjetaTeoria(
          mensaje: 'Segunda, y la más útil',
          titulo: 'Valores límite',
          texto:
              'Si apruebas con 7 sobre 10, las clases son 0 a 6,99 y 7 a 10. '
              'Pruebas 6,99, 7 y 7,01.',
          destacado:
              'Ahí vive el error clásico: escribir mayor que cuando debía ser '
              'mayor o igual.',
        ),
      ],
    ),

    'cap-3-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-3-lec-1',
      titulo: 'Ciclo de Vida de un Defecto',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Un bug también tiene vida',
          titulo: 'Los estados',
          vinetas: [
            'Nuevo: alguien lo reportó',
            'Asignado: tiene responsable',
            'En progreso: lo están arreglando',
            'Resuelto: el dev terminó',
            'Verificado: el tester confirmó',
            'Cerrado',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Dos salidas más',
          titulo: 'Rechazado o diferido',
          texto:
              'Rechazado si resulta que no era un defecto. Diferido si se decide '
              'arreglarlo en otra versión.',
        ),
        TarjetaTeoria(
          mensaje: 'Aquí se gana o se pierde tiempo',
          titulo: 'Cómo reportar bien',
          texto: 'Inútil: "la pantalla de matrícula falla".',
          destacado:
              'Útil: "al matricular a un estudiante con dos materias '
              'reprobadas, sale error 500. Pasos: entrar como usuario X, ir a '
              'Matrícula, elegir periodo, pulsar Confirmar. Esperado: mensaje '
              'de restricción."',
        ),
        TarjetaTeoria(
          mensaje: 'Y una regla',
          titulo: 'No te verificas a ti mismo',
          texto:
              'Quien confirma que el defecto quedó arreglado no puede ser quien '
              'lo arregló.',
        ),
      ],
    ),

    'cap-3-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-3-lec-2',
      titulo: 'Severidad vs Prioridad',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Dos cosas distintas',
          titulo: 'No son sinónimos',
          vinetas: [
            'Severidad: cuánto se rompe el sistema',
            'Prioridad: qué tan urgente es arreglarlo',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Son independientes',
          titulo: 'Las cuatro combinaciones existen',
          vinetas: [
            'Alta y alta: el sistema no arranca',
            'Alta y baja: se cae algo que nadie usa',
            'Baja y alta: el nombre de la UPEC mal escrito',
            'Baja y baja: un margen desalineado',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'El caso que sorprende',
          titulo: 'Un error de ortografía urgente',
          texto:
              'Severidad mínima: no deja de funcionar nada. Prioridad máxima: el '
              'sistema se presenta mañana ante las autoridades.',
          destacado:
              'La severidad la pone el tester. La prioridad, quien responde por '
              'el producto.',
        ),
      ],
    ),

    'cap-3-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-4-lec-1',
      titulo: 'Estrategias de Despliegue',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La más simple',
          titulo: 'Big bang',
          texto:
              'Reemplazas todo de una vez. Barato y directo. Si falla, falla '
              'para todos al mismo tiempo.',
        ),
        TarjetaTeoria(
          mensaje: 'Sin cortar el servicio',
          titulo: 'Rolling',
          texto:
              'Actualizas los servidores por tandas. Mientras unos se '
              'actualizan, los otros siguen atendiendo.',
        ),
        TarjetaTeoria(
          mensaje: 'La más prudente',
          titulo: 'Canary',
          texto:
              'Liberas a un 5 % de usuarios. Si las métricas se mantienen sanas, '
              'subes a 20, a 50, a todos. Si no, retrocedes afectando a pocos.',
        ),
        TarjetaTeoria(
          mensaje: 'La más rápida de revertir',
          titulo: 'Blue-green',
          texto:
              'Dos entornos idénticos. Conmutas el tráfico de uno al otro. Si '
              'algo sale mal, vuelves en segundos.',
          destacado:
              'Feature flags: despliegas el código apagado y lo enciendes por '
              'configuración. Separa el riesgo de desplegar del riesgo de '
              'activar.',
        ),
      ],
    ),

    'cap-3-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-4-lec-2',
      titulo: 'Plan de Rollback',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Se escribe antes',
          titulo: 'Nunca durante la crisis',
          texto:
              'Bajo presión nadie razona bien. El plan de reversión se redacta '
              'cuando todo está tranquilo.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué debe decir',
          titulo: 'Cuatro cosas',
          vinetas: [
            'Qué dispara la reversión, con números',
            'Quién tiene autoridad para decidirla',
            'Los pasos técnicos exactos',
            'A quién se le avisa',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Aquí está la trampa',
          titulo: 'Los datos no se revierten fácil',
          texto:
              'Volver atrás el código es sencillo. Volver atrás un cambio de '
              'esquema en la base de datos casi nunca lo es.',
          destacado:
              'Truco: en vez de renombrar una columna, crea la nueva y deja las '
              'dos una versión. Borras la vieja en el siguiente ciclo.',
        ),
      ],
    ),

    'cap-3-5-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-5-lec-1',
      titulo: 'Tipos de Mantenimiento',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Cuatro tipos, según ISO/IEC 14764',
          titulo: 'No todo es arreglar bugs',
          vinetas: [
            'Correctivo: reparar defectos',
            'Adaptativo: el entorno cambió',
            'Perfectivo: agregar o mejorar',
            'Preventivo: arreglar lo que aún no falla',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Los cuatro en un caso',
          titulo: 'Sistema de notas',
          vinetas: [
            'Correctivo: el promedio sale mal con recuperaciones',
            'Adaptativo: cambia la nota mínima por reglamento',
            'Perfectivo: los docentes piden exportar a Excel',
            'Preventivo: se refactoriza el módulo de notas',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Esto rompe la intuición',
          titulo: 'El correctivo es minoría',
          texto:
              'La mayor parte del mantenimiento es perfectivo y adaptativo. '
              'Arreglar bugs ocupa mucho menos de lo que uno imagina.',
        ),
      ],
    ),

    'cap-3-5-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-5-lec-2',
      titulo: 'Gestión de Mantenimiento',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'De caos a flujo',
          titulo: 'Toda petición se registra',
          texto:
              'Se clasifica por tipo, se estima el esfuerzo, se prioriza y entra '
              'en una versión. Nada se atiende por WhatsApp.',
        ),
        TarjetaTeoria(
          mensaje: 'El acuerdo que ordena todo',
          titulo: 'SLA',
          vinetas: [
            'Crítico: respuesta 1 h, solución 8 h',
            'Alto: respuesta 4 h, solución 3 días',
            'Medio: respuesta 1 día, próxima versión',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Por qué importa',
          titulo: 'Sin SLA manda el que grita',
          texto:
              'Con SLA, la atención sigue criterios acordados de antemano. Sin '
              'él, sigue el volumen de la queja.',
          destacado:
              'Sin registro no hay métricas. Sin métricas no hay mejora.',
        ),
      ],
    ),

    // =================================================================
    // MUNDO 4 — MÉTRICAS DE PROYECTOS
    // =================================================================

    'cap-4-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-1-lec-1',
      titulo: 'Métrica vs Medida vs Indicador',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Tres palabras que no son lo mismo',
          titulo: 'La cadena',
          vinetas: [
            'Medida: dato crudo',
            'Métrica: medidas combinadas por una fórmula',
            'Indicador: métrica comparada con un objetivo',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Míralo aplicado',
          titulo: 'De dato a decisión',
          texto:
              'Medida: 45 defectos este mes. Métrica: 2,1 defectos por cada mil '
              'líneas. Indicador: el objetivo era 2,0, estamos arriba, hay que '
              'revisar.',
        ),
        TarjetaTeoria(
          mensaje: 'La conclusión práctica',
          titulo: 'Medir sin objetivo no sirve',
          texto:
              'Una métrica sin umbral es un número que nadie sabe si es bueno o '
              'malo. Termina en un reporte que nadie abre.',
        ),
      ],
    ),

    'cap-4-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-1-lec-2',
      titulo: 'Tipos de Métricas',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Según qué midas',
          titulo: 'Tres familias',
          vinetas: [
            'De producto: tamaño, complejidad, defectos',
            'De proceso: tiempo de ciclo, frecuencia de entrega',
            'De proyecto: costo, cronograma, recursos',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Una forma de medir tamaño',
          titulo: 'Puntos de función',
          texto:
              'ISO/IEC 20968 mide el tamaño según lo que el sistema hace, no '
              'según cuántas líneas tiene. Así puedes comparar proyectos en '
              'lenguajes distintos.',
        ),
        TarjetaTeoria(
          mensaje: 'La advertencia clásica',
          titulo: 'Cuidado con qué mides',
          texto:
              'Cuando una métrica se vuelve objetivo, la gente optimiza el '
              'número y no el resultado.',
          destacado:
              'Mide líneas por programador y tendrás código inflado. Mide '
              'defectos cerrados y tendrás cierres apurados.',
        ),
      ],
    ),

    'cap-4-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-2-lec-1',
      titulo: 'Línea Base del Proyecto',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El punto de referencia',
          titulo: 'Línea base',
          texto:
              'La versión aprobada del alcance, el cronograma y el presupuesto. '
              'Contra ella se mide todo lo que pase después.',
        ),
        TarjetaTeoria(
          mensaje: 'Sin ella no hay retraso',
          titulo: 'Literalmente',
          texto:
              'Si nunca se acordó cuándo había que terminar, tampoco se puede '
              'decir que el proyecto va tarde.',
        ),
        TarjetaTeoria(
          mensaje: 'Solo cambia de una forma',
          titulo: 'Control de cambios',
          texto:
              'Se solicita, se evalúa el impacto en alcance, plazo y costo, se '
              'aprueba o se rechaza. Si se aprueba, se replantea la línea base.',
          destacado:
              'Moverla informalmente equivale a no tenerla: el proyecto siempre '
              'llega a tiempo a una meta que se corrió.',
        ),
        TarjetaTeoria(
          mensaje: 'Así se descarrila un proyecto',
          titulo: 'Quince favores pequeños',
          texto:
              'El cliente pide algo chico, el equipo dice que sí sin evaluarlo, '
              'y eso se repite. Al final hay tres meses de retraso y nadie sabe '
              'en qué momento pasó.',
        ),
      ],
    ),

    'cap-4-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-2-lec-2',
      titulo: 'Seguimiento de Avance',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El gráfico del sprint',
          titulo: 'Burndown',
          texto:
              'Muestra el trabajo pendiente día a día. La línea debería bajar '
              'hasta cero al cierre.',
        ),
        TarjetaTeoria(
          mensaje: 'Aprende a leerlo',
          titulo: 'Qué te está diciendo',
          vinetas: [
            'Por encima de la ideal: van retrasados',
            'Plana y luego cae de golpe: acumulan sin cerrar',
            'Sube en vez de bajar: entró trabajo nuevo al sprint',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y la otra métrica',
          titulo: 'Velocidad',
          texto:
              'El promedio de puntos completados por sprint. Sirve para '
              'proyectar cuántos sprints faltan.',
          destacado:
              'No compares velocidades entre equipos. Los puntos son una unidad '
              'que cada equipo calibra para sí mismo.',
        ),
      ],
    ),

    'cap-4-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-3-lec-1',
      titulo: 'Defect Density y Defect Escape Rate',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La primera métrica',
          titulo: 'Densidad de defectos',
          texto:
              'Defectos divididos entre el tamaño del software. Permite comparar '
              'módulos grandes con módulos chicos.',
          destacado:
              '500 líneas con 10 defectos está peor que 5.000 líneas con 40.',
        ),
        TarjetaTeoria(
          mensaje: 'La segunda',
          titulo: 'Tasa de escape',
          texto:
              'Qué porcentaje de los defectos llegó hasta producción en vez de '
              'ser atrapado en pruebas.',
        ),
        TarjetaTeoria(
          mensaje: 'Calcúlalo',
          titulo: 'Un ejemplo',
          texto:
              '80 defectos en pruebas, 20 en producción. Tasa de escape: 20 de '
              '100, es decir 20 %. Un objetivo razonable está bajo el 10 %.',
          destacado:
              'Una tasa alta no dice que el software sea malo. Dice que tus '
              'pruebas no están encontrando lo que deberían.',
        ),
      ],
    ),

    'cap-4-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-3-lec-2',
      titulo: 'Cobertura de Pruebas y MTBF',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Ya la viste antes',
          titulo: 'Cobertura',
          texto:
              'Qué porcentaje del código ejecuta tu suite. Sirve para encontrar '
              'zonas sin probar.',
          destacado:
              'Exigir 90 % obligatorio produce pruebas escritas solo para subir '
              'el número.',
        ),
        TarjetaTeoria(
          mensaje: 'Dos siglas de fiabilidad',
          titulo: 'MTBF y MTTR',
          vinetas: [
            'MTBF: tiempo medio entre fallos',
            'MTTR: tiempo medio de reparación',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'De ahí sale el número famoso',
          titulo: 'Disponibilidad',
          texto: 'Disponibilidad = MTBF / (MTBF + MTTR)',
          destacado:
              '99,9 % permite 8,7 horas de caída al año. 99,99 % la baja a 52 '
              'minutos, pero el costo se dispara. Cada nueve extra es mucho más '
              'caro que el anterior.',
        ),
      ],
    ),

    'cap-4-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-4-lec-1',
      titulo: 'Velocidad y Capacidad en Scrum',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La unidad de Scrum',
          titulo: 'Puntos de historia',
          texto:
              'Miden esfuerzo relativo: complejidad, incertidumbre y volumen. No '
              'son horas.',
        ),
        TarjetaTeoria(
          mensaje: 'Por qué esos números raros',
          titulo: '1, 2, 3, 5, 8, 13',
          texto:
              'Fibonacci. Los saltos crecen porque mientras más grande es la '
              'tarea, menos precisa es la estimación.',
        ),
        TarjetaTeoria(
          mensaje: 'Dos conceptos que se confunden',
          titulo: 'Velocidad y capacidad',
          vinetas: [
            'Velocidad: lo que hicimos, mira atrás',
            'Capacidad: lo que podemos, mira adelante',
          ],
          destacado:
              'Capacidad ajusta por vacaciones, feriados y gente prestada a otro '
              'proyecto.',
        ),
        TarjetaTeoria(
          mensaje: 'Para qué sirve todo esto',
          titulo: 'Proyectar',
          texto:
              'Velocidad de 30 puntos y quedan 180 en el backlog: faltan unos 6 '
              'sprints. Es orientativo, y mejora con cada sprint que pasa.',
        ),
      ],
    ),

    'cap-4-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-4-lec-2',
      titulo: 'Métricas Humanas',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Lo que el burndown no muestra',
          titulo: 'El equipo también se mide',
          vinetas: [
            'Satisfacción',
            'Rotación',
            'Ausentismo',
            'Horas extra',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Por qué son útiles',
          titulo: 'Avisan antes',
          texto:
              'Un equipo agotado produce más defectos. Eso aparece en las '
              'métricas humanas semanas antes de aparecer en el cronograma.',
          destacado:
              'Tres sprints con horas extra: la velocidad se mantiene, pero la '
              'densidad de defectos empieza a subir.',
        ),
        TarjetaTeoria(
          mensaje: 'Una regla que no se rompe',
          titulo: 'Nunca para evaluar personas',
          texto:
              'Si una métrica de equipo entra en una evaluación individual, deja '
              'de reflejar la realidad. La gente ajusta el número para '
              'protegerse.',
        ),
      ],
    ),

    'cap-4-5-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-5-lec-1',
      titulo: 'Lecciones Aprendidas',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Para no tropezar dos veces',
          titulo: 'Qué son',
          texto:
              'Documentan qué funcionó, qué no y por qué. Se recogen durante '
              'todo el proyecto, no al final.',
          destacado:
              'Al cierre nadie recuerda con precisión qué pasó en el segundo '
              'mes.',
        ),
        TarjetaTeoria(
          mensaje: 'Tienen tres partes',
          titulo: 'Cómo se escribe una',
          vinetas: [
            'La situación concreta',
            'El impacto que tuvo',
            'La recomendación accionable',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Compara',
          titulo: 'Queja contra lección',
          texto: 'Queja: "hubo problemas de comunicación".',
          destacado:
              'Lección: "los requisitos llegaron por correo sin registro '
              'central, hubo tres versiones contradictorias y dos semanas de '
              'retrabajo. Usar una sola herramienta de gestión de requisitos."',
        ),
      ],
    ),

    'cap-4-5-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-5-lec-2',
      titulo: 'Retrospectivas y Mejora Continua',
      tiempoLectura: 3,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La última reunión del sprint',
          titulo: 'Retrospectiva',
          texto:
              'El equipo revisa su propia forma de trabajar. Tres preguntas: qué '
              'salió bien, qué no, qué cambiamos.',
        ),
        TarjetaTeoria(
          mensaje: 'La tercera es la que importa',
          titulo: 'Sin acciones no sirve',
          texto:
              'Cada cambio necesita responsable y fecha. Si no, la retrospectiva '
              'se vuelve una sesión de desahogo.',
          destacado:
              'Vacía: "comunicarnos mejor". Útil: "María configura una alerta '
              'en el canal cuando el pipeline falle, antes del viernes."',
        ),
        TarjetaTeoria(
          mensaje: 'Sin esto nadie habla',
          titulo: 'Seguridad psicológica',
          texto:
              'Si señalar un problema trae consecuencias, nadie señala nada y la '
              'reunión produce silencio cortés.',
        ),
        TarjetaTeoria(
          mensaje: 'Y cierra el círculo',
          titulo: 'Esto ya lo viste',
          texto:
              'La retrospectiva es el Actuar del ciclo PHVA de ISO 9001. Scrum '
              'llegó al mismo lugar por otro camino.',
        ),
      ],
    ),
  };

  static ContenidoLeccion? obtenerContenido(String leccionId) =>
      _contenidos[leccionId];

  static List<String> obtenerLeccionesDisponibles() =>
      _contenidos.keys.toList();

  static int get totalLecciones => _contenidos.length;
}