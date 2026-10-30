import '../models/ejercicio_model.dart';

/// BANCO DE EJERCICIOS
///
/// Ocho ejercicios por lección, 296 en total, alineados con el contenido
/// de mock_contenidos.dart y con los títulos de mock_data_silabo.dart.
///
/// Por lección: cuatro de opción múltiple, dos de verdadero o falso y dos
/// de banco de palabras. La pantalla toma cuatro al azar en cada intento
/// y baraja también las opciones, así que el orden en que estén escritas
/// aquí da igual.
class MockPreguntas {
  static final Map<String, List<Ejercicio>> _preguntas = {

    // =================================================================
    // MUNDO 1 — METODOLOGÍAS DE DESARROLLO
    // =================================================================

    'cap-1-1-lec-1': [
      Ejercicio(
        id: 'q111a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es el ciclo de vida del software?',
        opciones: [
          'El orden en que ocurren las cosas, desde que alguien necesita algo '
              'hasta que el sistema se apaga',
          'Un lenguaje de programación para sistemas grandes',
          'Una herramienta que se instala en el servidor',
          'El tiempo que tarda un equipo en entregar una versión',
        ],
        respuestaCorrecta:
            'El orden en que ocurren las cosas, desde que alguien necesita algo '
            'hasta que el sistema se apaga',
        explicacion: [
          'Empieza antes de escribir código y termina mucho después de la '
              'entrega.',
        ],
        pista: 'No es algo que se descargue ni que se programe.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué norma internacional define los procesos del ciclo de vida '
            'del software?',
        opciones: [
          'ISO/IEC/IEEE 12207',
          'ISO 9001',
          'ISO/IEC 27001',
          'ISO/IEC 25010',
        ],
        respuestaCorrecta: 'ISO/IEC/IEEE 12207',
        explicacion: [
          'No impone un modelo concreto: sirve igual para cascada que para '
              'ágil.',
        ],
        pista: 'Lleva los tres prefijos: ISO, IEC e IEEE.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Scrum reemplaza al ciclo de vida del software.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Scrum es una forma de recorrer el ciclo, no un sustituto.',
          'Cascada, Kanban y DevOps recorren el mismo ciclo por otros caminos.',
        ],
        pista: 'Una metodología y un ciclo de vida son capas distintas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El ciclo de vida del software es un programa que se instala en el '
            'equipo de desarrollo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Es la estructura que evita que el equipo improvise.',
          'Git, Jira o Trello son herramientas que ayudan a recorrerlo. No son '
              'el ciclo.',
        ],
        pista: 'Confundirlo con una herramienta es el error más común.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La norma ISO/IEC/IEEE ___ define los procesos del ciclo de vida '
            'del software.',
        opciones: ['12207', '27001', '25010', '29119'],
        respuestaCorrecta: '12207',
        explicacion: [
          'La 27001 es de seguridad, la 25010 de calidad de producto y la '
              '29119 de pruebas.',
        ],
        pista: 'No es la de seguridad ni la de calidad de producto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111f',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo empieza el ciclo de vida de un sistema?',
        opciones: [
          'Antes de escribir la primera línea de código',
          'Cuando se entrega la primera versión al cliente',
          'Cuando se abre el editor para programar',
          'Cuando el sistema entra en producción',
        ],
        respuestaCorrecta: 'Antes de escribir la primera línea de código',
        explicacion: [
          'Empieza cuando alguien detecta una necesidad, y para entonces no '
              'hay nada programado todavía.',
        ],
        pista: 'Piensa en el caso del sistema de matrícula.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111g',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            '___ es la estructura que ordena el trabajo; ___ es una '
            'herramienta que ayuda a recorrerla.',
        opciones: ['El SDLC', 'Jira', 'La ISO 9001', 'El backlog'],
        respuestaCorrecta: 'El SDLC Jira',
        explicacion: [
          'Son cosas de naturaleza distinta: una organiza, la otra apoya.',
        ],
        pista: 'Una no se instala; la otra sí.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111h',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Según el profesional entrevistado, ¿cuál es el error más frecuente '
            'en quienes recién empiezan?',
        opciones: [
          'Pasar directo a programar sin hacer un análisis primero',
          'Escribir demasiada documentación antes de empezar',
          'Usar metodologías ágiles en proyectos grandes',
          'Elegir mal el lenguaje de programación',
        ],
        respuestaCorrecta:
            'Pasar directo a programar sin hacer un análisis primero',
        explicacion: [
          'Programar antes de analizar no es ir más rápido: es pagar el '
              'análisis más tarde y con intereses.',
        ],
        pista: 'Es justamente lo que el ciclo de vida existe para impedir.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-1-lec-2': [
      Ejercicio(
        id: 'q112a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿En qué fase se decide cómo va a estar construido el sistema, '
            'antes de construirlo?',
        opciones: ['Diseño', 'Requisitos', 'Construcción', 'Pruebas'],
        respuestaCorrecta: 'Diseño',
        explicacion: [
          'Es la fase donde las decisiones todavía son baratas de cambiar.',
        ],
        pista: 'Va después de saber qué se necesita y antes de programarlo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué hace que un requisito sea verificable?',
        opciones: [
          'Que exista una prueba capaz de decir, sin discusión, si se cumple',
          'Que esté redactado con lenguaje técnico preciso',
          'Que lo haya aprobado el cliente por escrito',
          'Que esté numerado dentro del documento de especificación',
        ],
        respuestaCorrecta:
            'Que exista una prueba capaz de decir, sin discusión, si se cumple',
        explicacion: [
          '«El sistema debe ser rápido» no lo es; «el 95 % de las consultas '
              'responde en menos de 500 ms» sí.',
        ],
        pista: 'Si dos personas razonables pueden discrepar, no lo es.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La fase de mantenimiento suele consumir menos esfuerzo que las '
            'demás fases.',
        respuestaCorrecta: 'false',
        explicacion: [
          'En la mayoría de los sistemas consume más que todas las anteriores '
              'juntas.',
          'Por eso la mantenibilidad es una característica de calidad de la '
              'ISO/IEC 25010 y no una virtud opcional.',
        ],
        pista: 'Es la fase más larga del ciclo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿De dónde se derivan las pruebas de aceptación?',
        opciones: [
          'De los requisitos de usuario',
          'Del código fuente escrito',
          'Del documento de arquitectura',
          'De las pruebas unitarias que ya pasaron',
        ],
        respuestaCorrecta: 'De los requisitos de usuario',
        explicacion: [
          'Cada nivel de prueba se deriva de un documento distinto. El de '
              'aceptación es el más cercano al cliente.',
        ],
        pista: 'Las escribe quien pidió el sistema, no quien lo programó.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Los requisitos ___ dicen qué debe hacer el sistema; los ___ dicen '
            'cómo debe comportarse.',
        opciones: ['funcionales', 'no funcionales', 'técnicos', 'de negocio'],
        respuestaCorrecta: 'funcionales no funcionales',
        explicacion: [
          'Los no funcionales son los que suelen quedarse sin escribir, y los '
              'que hunden proyectos.',
        ],
        pista: '«Registrar un pedido» frente a «responder en dos segundos».',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En los modelos ágiles desaparecen algunas fases del ciclo de vida.',
        respuestaCorrecta: 'false',
        explicacion: [
          'No desaparece ninguna: se repiten enteras cada pocas semanas en '
              'lugar de una sola vez.',
        ],
        pista: 'Lo que cambia es el recorrido, no las fases.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el orden correcto de los niveles de prueba?',
        opciones: [
          'Unitarias, integración, sistema, aceptación',
          'Integración, unitarias, aceptación, sistema',
          'Sistema, unitarias, integración, aceptación',
          'Aceptación, sistema, integración, unitarias',
        ],
        respuestaCorrecta: 'Unitarias, integración, sistema, aceptación',
        explicacion: [
          'Va de la pieza más pequeña al conjunto, y termina frente a lo que '
              'el usuario pidió.',
        ],
        pista: 'Empieza por lo más pequeño.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La ___ es una de las ocho características de calidad de producto '
            'que define la ISO/IEC 25010.',
        opciones: [
          'mantenibilidad',
          'trazabilidad',
          'productividad',
          'rentabilidad',
        ],
        respuestaCorrecta: 'mantenibilidad',
        explicacion: [
          'Se descompone en modularidad, reusabilidad, analizabilidad, '
              'modificabilidad y capacidad de ser probado.',
        ],
        pista: 'Tiene que ver con la fase más larga del ciclo.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // CAPÍTULO 1.2 — EL MODELO EN CASCADA
    // =================================================================

    'cap-1-2-lec-1': [
      Ejercicio(
        id: 'q121a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Winston Royce dibujó el esquema secuencial en 1970. ¿Para qué?',
        opciones: [
          'Para advertir de que, aplicado tal cual, era arriesgado',
          'Para proponerlo como el modelo definitivo de desarrollo',
          'Para documentar cómo trabajaban ya todas las empresas',
          'Para cumplir con una norma internacional de la época',
        ],
        respuestaCorrecta:
            'Para advertir de que, aplicado tal cual, era arriesgado',
        explicacion: [
          'Royce proponía iterar. La industria se quedó con el dibujo y olvidó '
              'la advertencia.',
        ],
        pista: 'La historia tiene una ironía.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué hay entre una fase y la siguiente en cascada?',
        opciones: [
          'Una revisión formal con un entregable que debe quedar aprobado',
          'Una reunión diaria de quince minutos',
          'Una retrospectiva del equipo',
          'Nada: las fases se solapan para ir más rápido',
        ],
        respuestaCorrecta:
            'Una revisión formal con un entregable que debe quedar aprobado',
        explicacion: [
          'Si el entregable no está aprobado, el proyecto no avanza. Esa '
              'rigidez es lo que se compra al elegir cascada.',
        ],
        pista: 'Sin firma no se pasa.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En cascada, el coste de cambiar un requisito baja a medida que '
            'avanza el proyecto.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Sube, y bastante. Cambiarlo al principio cuesta una conversación; '
              'al final, rehacer todo lo que dependía de él.',
          'Toda la lógica de la cascada sale de ahí: si cambiar al final es '
              'carísimo, más vale no equivocarse al principio.',
        ],
        pista: 'Piensa en cuántas cosas dependen del requisito al final.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué el control de un ascensor encaja bien con la cascada?',
        opciones: [
          'Porque la certificación exige documentación completa y trazabilidad',
          'Porque el equipo de desarrollo suele ser pequeño',
          'Porque el software es sencillo y tiene pocas pantallas',
          'Porque el cliente cambia de opinión con frecuencia',
        ],
        respuestaCorrecta:
            'Porque la certificación exige documentación completa y trazabilidad',
        explicacion: [
          'Sus requisitos no cambian cada semana: cambian cuando cambia la '
              'normativa de seguridad.',
        ],
        pista: 'Entregar la versión mínima viable de un freno no es opción.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'En cascada, cada fase termina produciendo un ___ aprobado que es '
            'la entrada de la fase siguiente.',
        opciones: ['documento', 'prototipo', 'incremento', 'sprint'],
        respuestaCorrecta: 'documento',
        explicacion: [
          'Esa cadena de entregables es lo que permite auditar el proyecto '
              'después.',
        ],
        pista: 'No es código ejecutable.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La cascada da previsibilidad a cambio de exigir requisitos '
            'estables desde el principio.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Plazos, costes y documentación completa, pero solo funciona si '
              'sabes desde el inicio lo que quieres.',
        ],
        pista: 'Todo modelo da algo a cambio de pedir algo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el orden de las fases en el modelo en cascada?',
        opciones: [
          'Requisitos, diseño, construcción, pruebas, mantenimiento',
          'Diseño, requisitos, pruebas, construcción, mantenimiento',
          'Requisitos, construcción, diseño, pruebas, mantenimiento',
          'Construcción, pruebas, diseño, requisitos, mantenimiento',
        ],
        respuestaCorrecta:
            'Requisitos, diseño, construcción, pruebas, mantenimiento',
        explicacion: [
          'Cada una termina por completo antes de que empiece la siguiente.',
        ],
        pista: 'Primero se entiende, después se planea, después se hace.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Royce publicó su artículo en ___, y la industria se quedó con el '
            '___ y olvidó la advertencia.',
        opciones: ['1970', 'dibujo', '2001', 'manifiesto'],
        respuestaCorrecta: '1970 dibujo',
        explicacion: [
          'En 2001, y con un manifiesto, pasó algo parecido con lo ágil: se '
              'citan los cuatro valores y se olvida la frase final.',
        ],
        pista: 'Una fecha y una imagen.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-2-lec-2': [
      Ejercicio(
        id: 'q122a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué pregunta resume el criterio para elegir entre cascada e '
            'iteraciones?',
        opciones: [
          '¿Qué cuesta más: equivocarse al final o tardar en salir?',
          '¿Cuántas personas tiene el equipo?',
          '¿Qué lenguaje de programación se va a usar?',
          '¿El cliente es público o privado?',
        ],
        respuestaCorrecta:
            '¿Qué cuesta más: equivocarse al final o tardar en salir?',
        explicacion: [
          'Si lo caro es descubrir un error tarde, conviene invertir por '
              'delante. Si lo caro es tardar, conviene entregar pronto y '
              'aprender.',
        ],
        pista: 'Se trata de riesgos, no de tamaños de equipo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿En cuál de estas situaciones la cascada juega en contra?',
        opciones: [
          'El cliente todavía no sabe exactamente qué quiere',
          'Hay una auditoría que exige documentación formal',
          'El contrato fija alcance, plazo y precio cerrados',
          'Los requisitos vienen de una normativa de seguridad',
        ],
        respuestaCorrecta: 'El cliente todavía no sabe exactamente qué quiere',
        explicacion: [
          'Vas a llegar al final con un sistema que cumple la especificación y '
              'no sirve.',
        ],
        pista: 'Tres de las cuatro son señales de que sí encaja.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La cascada está obsoleta y ya no se usa en ningún sector.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Sigue usándose, y en algunos sectores es obligatoria por '
              'certificación.',
          'Descartarla por moda es tan mal criterio como aplicarla a todo.',
        ],
        pista: 'Piensa en sistemas que deben certificarse antes de usarse.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Un sistema cumple toda su especificación pero no le sirve al '
            'cliente. ¿Qué ocurrió?',
        opciones: [
          'Se verificó con éxito, pero no se validó',
          'Se validó con éxito, pero no se verificó',
          'Falló la gestión de la configuración',
          'Faltaron pruebas unitarias',
        ],
        respuestaCorrecta: 'Se verificó con éxito, pero no se validó',
        explicacion: [
          'Verificar es comprobar que se construyó según la especificación. '
              'Validar es comprobar que esa especificación resolvía el problema '
              'real.',
        ],
        pista: '¿Lo construimos bien, o construimos lo correcto?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Un producto ___ con éxito puede no estar ___: se construyó bien lo '
            'que no había que construir.',
        opciones: ['verificado', 'validado', 'auditado', 'certificado'],
        respuestaCorrecta: 'verificado validado',
        explicacion: [
          'Es la distinción que pide la ISO/IEC/IEEE 12207 y la que más se '
              'confunde en los exámenes.',
        ],
        pista: 'Una mira el documento; la otra, la necesidad.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Según el profesional entrevistado, en la práctica las '
            'metodologías se combinan en lugar de aplicarse puras.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Un proyecto puede llevar los requisitos regulatorios en cascada y la '
              'interfaz en iteraciones.',
          'Saber por qué eliges cada cosa vale más que recitar el modelo '
              'completo.',
        ],
        pista: 'La realidad del sector rara vez es pura.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estas es una señal de que la cascada encaja?',
        opciones: [
          'Hay una certificación que exige documentación formal',
          'Se espera descubrir requisitos sobre la marcha',
          'El producto depende de cómo reaccione el mercado',
          'El equipo quiere entregar algo cada dos semanas',
        ],
        respuestaCorrecta:
            'Hay una certificación que exige documentación formal',
        explicacion: [
          'Las tres señales suelen aparecer juntas: requisitos estables, '
              'certificación y contrato cerrado.',
        ],
        pista: 'Busca la que habla de documentación obligatoria.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'En el control de un ___ conviene cascada; en una app de ___ '
            'convienen iteraciones cortas.',
        opciones: ['ascensor', 'reparto', 'hospital', 'banca'],
        respuestaCorrecta: 'ascensor reparto',
        explicacion: [
          'No es que un modelo sea mejor: responden a riesgos distintos.',
        ],
        pista: 'Uno puede herir a alguien; en el otro nadie sabe qué querrán '
            'los usuarios.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // CAPÍTULO 1.3 — DESARROLLO ÁGIL
    // =================================================================

    'cap-1-3-lec-1': [
      Ejercicio(
        id: 'q131a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué contiene el Manifiesto Ágil?',
        opciones: [
          'Cuatro valores y doce principios',
          'Tres roles, cinco eventos y tres artefactos',
          'Un modelo de madurez con cinco niveles',
          'Ocho características de calidad del producto',
        ],
        respuestaCorrecta: 'Cuatro valores y doce principios',
        explicacion: [
          'Cabe en una sola página. Las otras opciones son Scrum, el CMMI y la '
              'ISO/IEC 25010.',
        ],
        pista: 'Es sorprendentemente corto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'En «software funcionando sobre documentación extensiva», ¿qué '
            'significa la palabra «sobre»?',
        opciones: [
          'Las dos cosas se valoran, pero una pesa más cuando hay que elegir',
          'La segunda se elimina del proyecto',
          'La primera depende de que exista la segunda',
          'Las dos tienen exactamente el mismo peso',
        ],
        respuestaCorrecta:
            'Las dos cosas se valoran, pero una pesa más cuando hay que elegir',
        explicacion: [
          'El manifiesto lo dice al final: «aunque valoramos los elementos de '
              'la derecha, valoramos más los de la izquierda».',
        ],
        pista: 'Esa frase final casi nadie la cita.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Ser ágil significa trabajar sin documentación.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Los equipos ágiles que funcionan documentan menos, pero documentan '
              'lo que importa y lo mantienen al día.',
          'Trabajar sin requisitos, sin criterios de aceptación y sin pruebas '
              'no es agilidad: es desorden con nombre bonito.',
        ],
        pista: 'Recuerda qué significa la palabra «sobre».',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Según los principios ágiles, ¿cómo se mide el avance de un '
            'proyecto?',
        opciones: [
          'Por software funcionando',
          'Por tareas cerradas en el tablero',
          'Por horas trabajadas por el equipo',
          'Por documentos entregados y aprobados',
        ],
        respuestaCorrecta: 'Por software funcionando',
        explicacion: [
          'Un tablero lleno de tareas cerradas puede convivir con un producto '
              'que todavía no hace nada.',
        ],
        pista: 'Lo que cuenta es lo que el usuario podría usar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'El Manifiesto Ágil se escribió en ___ y recoge cuatro valores y '
            '___ principios.',
        opciones: ['2001', 'doce', '1970', 'cuatro'],
        respuestaCorrecta: '2001 doce',
        explicacion: [
          'Diecisiete personas en una estación de esquí en Utah, en febrero de '
              'ese año.',
        ],
        pista: 'El otro año que aparece es el del artículo de Royce.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Un equipo ágil puede cumplir igualmente la norma ISO/IEC/IEEE '
            '12207.',
        respuestaCorrecta: 'true',
        explicacion: [
          'La norma dice qué procesos deben existir, no en qué modelo se '
              'recorren.',
          'Un equipo ágil los recorre cada dos semanas en lugar de una vez por '
              'proyecto.',
        ],
        pista: 'Modelo y proceso son capas distintas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué está cambiando en el ciclo de vida por efecto de las '
            'herramientas de inteligencia artificial?',
        opciones: [
          'Las iteraciones se acortan de semanas a días u horas',
          'Desaparece la fase de pruebas',
          'Los requisitos dejan de ser necesarios',
          'Las normas internacionales ya no aplican',
        ],
        respuestaCorrecta: 'Las iteraciones se acortan de semanas a días u horas',
        explicacion: [
          'El principio de entregar con frecuencia no cambia. Lo que cambia es '
              'cuánto significa «con frecuencia».',
        ],
        pista: 'Es una cuestión de ritmo, no de eliminar etapas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Valoramos el software ___ sobre la documentación ___.',
        opciones: ['funcionando', 'extensiva', 'certificado', 'mínima'],
        respuestaCorrecta: 'funcionando extensiva',
        explicacion: [
          'Es el segundo de los cuatro valores del manifiesto.',
        ],
        pista: 'Las dos palabras aparecen literalmente en el manifiesto.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-3-lec-2': [
      Ejercicio(
        id: 'q132a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuántas responsabilidades define Scrum?',
        opciones: ['Tres', 'Cinco', 'Dos', 'Siete'],
        respuestaCorrecta: 'Tres',
        explicacion: [
          'Product Owner, Scrum Master y Desarrolladores. No son cargos de la '
              'empresa: son responsabilidades dentro del equipo.',
        ],
        pista: 'Menos de las que la gente suele pensar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Quién decide qué se construye y en qué orden?',
        opciones: [
          'El Product Owner',
          'El Scrum Master',
          'Los Desarrolladores',
          'El comité de dirección',
        ],
        respuestaCorrecta: 'El Product Owner',
        explicacion: [
          'Y es una sola persona, no un comité: si la prioridad la deciden '
              'cinco, nadie la decide.',
          'Los Desarrolladores deciden cómo se construye.',
        ],
        pista: 'El «qué» y el «cómo» tienen dueños distintos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Si el trabajo comprometido no cabe en el Sprint, se alarga el '
            'Sprint unos días.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La duración es fija. Lo que se recorta es el trabajo, no el plazo.',
        ],
        pista: 'Por algo se llama duración fija.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es la definición de hecho?',
        opciones: [
          'El acuerdo del equipo sobre qué condiciones debe cumplir algo para '
              'estar terminado',
          'La lista de tareas pendientes del Sprint',
          'El documento de requisitos aprobado por el cliente',
          'El informe que el Scrum Master entrega cada semana',
        ],
        respuestaCorrecta:
            'El acuerdo del equipo sobre qué condiciones debe cumplir algo para '
            'estar terminado',
        explicacion: [
          'Probado, revisado, documentado, desplegable. Evita la discusión '
              'sobre qué significa «ya está».',
        ],
        pista: 'Sirve para que «terminado» signifique lo mismo para todos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132e',
        tipo: TipoEjercicio.completarTexto,
        pregunta: 'El ___ decide qué se construye; los ___ deciden cómo.',
        opciones: [
          'Product Owner',
          'Desarrolladores',
          'Scrum Master',
          'interesados',
        ],
        respuestaCorrecta: 'Product Owner Desarrolladores',
        explicacion: [
          'El Scrum Master no decide ninguna de las dos: hace que el marco '
              'funcione y quita obstáculos.',
        ],
        pista: 'Son dos de las tres responsabilidades.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Un tablero en Jira, por sí solo, ya es trabajar con Scrum.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Sin los eventos y sin las responsabilidades, un tablero es solo un '
              'tablero.',
          'Scrum no se implanta con una herramienta.',
        ],
        pista: 'La herramienta no es el marco.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál es el mejor sitio para meter las exigencias de la norma '
            'dentro de un equipo Scrum?',
        opciones: [
          'En la definición de hecho',
          'En la reunión diaria',
          'En el informe mensual al cliente',
          'En el manual de la empresa',
        ],
        respuestaCorrecta: 'En la definición de hecho',
        explicacion: [
          'Si la definición de hecho exige trazabilidad, deja de depender de '
              'que alguien se acuerde y pasa a ser condición para cerrar una '
              'tarea.',
        ],
        pista: 'Donde se decide si algo está terminado.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La reunión diaria dura ___ minutos y sirve para ___ el día, no '
            'para reportar.',
        opciones: ['quince', 'coordinar', 'sesenta', 'planificar'],
        respuestaCorrecta: 'quince coordinar',
        explicacion: [
          'Convertirla en un informe de estado hacia el jefe es el error más '
              'común con este evento.',
        ],
        pista: 'Es corta, y es para el equipo.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // CAPÍTULO 1.4 — INTEGRACIÓN Y ENTREGA CONTINUAS
    // =================================================================

    'cap-1-4-lec-1': [
      Ejercicio(
        id: 'q141a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué problema resuelve la integración continua?',
        opciones: [
          'Que cuanto más se tarda en juntar el código, más caro sale juntarlo',
          'Que los programadores escriben código con errores',
          'Que el cliente cambia los requisitos a mitad del proyecto',
          'Que el servidor de producción se queda sin espacio',
        ],
        respuestaCorrecta:
            'Que cuanto más se tarda en juntar el código, más caro sale juntarlo',
        explicacion: [
          'Por eso se integra varias veces al día en lugar de una vez cada dos '
              'semanas.',
        ],
        pista: 'Tiene que ver con el tiempo entre integraciones.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál es la diferencia entre entrega continua y despliegue '
            'continuo?',
        opciones: [
          'Quién decide publicar: una persona o la propia tubería',
          'El lenguaje de programación que se usa',
          'Si las pruebas son manuales o automáticas',
          'Si el servidor está en la nube o en la empresa',
        ],
        respuestaCorrecta:
            'Quién decide publicar: una persona o la propia tubería',
        explicacion: [
          'En entrega continua la versión queda lista y alguien aprieta el '
              'botón. En despliegue continuo sale sola si pasa las pruebas.',
        ],
        pista: 'Las dos se abrevian CD y no significan lo mismo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Una tubería sin pruebas automáticas da una falsa sensación de '
            'seguridad.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Todo sale verde porque no se está comprobando nada: solo se '
              'automatizó la compilación.',
        ],
        pista: '¿Qué está comprobando realmente esa tubería?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué una tubería de CI/CD sirve como evidencia en una auditoría?',
        opciones: [
          'Porque deja registrado qué se probó, cuándo y sobre qué versión',
          'Porque reduce el número de personas en el equipo',
          'Porque obliga a usar un repositorio en la nube',
          'Porque genera documentación de usuario automáticamente',
        ],
        respuestaCorrecta:
            'Porque deja registrado qué se probó, cuándo y sobre qué versión',
        explicacion: [
          'Es exactamente lo que pide un auditor cuando pregunta cómo sabes que '
              'la versión en producción fue probada.',
          'La ISO 9001 exige registros, y a mano nadie los mantiene al día.',
        ],
        pista: 'Un auditor no pide opiniones: pide registros.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'En entrega continua alguien aprieta el ___; en despliegue continuo '
            'sale sin intervención ___.',
        opciones: ['botón', 'humana', 'servidor', 'automática'],
        respuestaCorrecta: 'botón humana',
        explicacion: [
          'En sistemas regulados, esa decisión casi nunca se automatiza.',
        ],
        pista: 'Lo que cambia es quién decide.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En sistemas regulados conviene automatizar siempre la decisión de '
            'publicar en producción.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Ahí casi nunca se automatiza: la publicación necesita una '
              'aprobación con nombre y apellido.',
        ],
        pista: 'Piensa en quién responde si algo sale mal.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué hace la tubería cada vez que alguien envía cambios?',
        opciones: [
          'Compila el proyecto y ejecuta las pruebas automáticas',
          'Envía un correo al cliente con el avance',
          'Crea una rama nueva para cada programador',
          'Despliega directamente en producción sin comprobar nada',
        ],
        respuestaCorrecta:
            'Compila el proyecto y ejecuta las pruebas automáticas',
        explicacion: [
          'Si algo se rompe se sabe en minutos, y se sabe por culpa de qué '
              'cambio.',
        ],
        pista: 'Lo importante es enterarse rápido.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Cuanto más tiempo pasa entre ___, más caro sale ___.',
        opciones: ['integraciones', 'integrar', 'despliegues', 'probar'],
        respuestaCorrecta: 'integraciones integrar',
        explicacion: [
          'En esa frase cabe toda la justificación de la integración continua.',
        ],
        pista: 'La misma palabra, en sustantivo y en verbo.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-4-lec-2': [
      Ejercicio(
        id: 'q142a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué consigues al automatizar un proceso que está mal?',
        opciones: [
          'Repetir el error más rápido y más veces',
          'Corregir el error automáticamente',
          'Reducir el coste del proceso a la mitad',
          'Cumplir con la norma ISO 9001',
        ],
        respuestaCorrecta: 'Repetir el error más rápido y más veces',
        explicacion: [
          'Primero se arregla el proceso, después se automatiza.',
        ],
        pista: 'Automatizar no arregla nada por sí solo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estas NO es una de las cuatro métricas DORA?',
        opciones: [
          'Número de líneas de código escritas',
          'Frecuencia de despliegue',
          'Porcentaje de despliegues que provocan un fallo',
          'Tiempo en restablecer el servicio tras un fallo',
        ],
        respuestaCorrecta: 'Número de líneas de código escritas',
        explicacion: [
          'Las líneas de código no miden valor entregado: miden cuánto se '
              'escribió, que no es lo mismo.',
        ],
        pista: 'Tres miden entrega; una mide volumen.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Las cuatro métricas DORA miden únicamente velocidad.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Dos miden velocidad y dos miden estabilidad, y se equilibran entre '
              'sí.',
          'Mirar solo una mitad es como se acaba desplegando rápido y mal.',
        ],
        pista: 'Si solo midieran velocidad, ¿qué impediría ir rápido y romper '
            'todo?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué distingue la observabilidad del monitoreo?',
        opciones: [
          'La observabilidad busca responder preguntas que no habías previsto',
          'La observabilidad solo funciona en la nube',
          'El monitoreo no necesita registros',
          'Son dos nombres para lo mismo',
        ],
        respuestaCorrecta:
            'La observabilidad busca responder preguntas que no habías previsto',
        explicacion: [
          'El monitoreo responde preguntas que ya sabías que ibas a hacer.',
        ],
        pista: 'La diferencia está en si la pregunta estaba prevista.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Dos métricas DORA miden ___ y las otras dos miden ___.',
        opciones: ['velocidad', 'estabilidad', 'calidad', 'esfuerzo'],
        respuestaCorrecta: 'velocidad estabilidad',
        explicacion: [
          'Frecuencia de despliegue y tiempo de entrega por un lado; tasa de '
              'fallos y tiempo de restauración por el otro.',
        ],
        pista: 'Son dos cosas que tiran en direcciones opuestas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Registrar todo lo que hace el sistema ya es monitorear.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Registrar todo y no mirar nada es tan inútil como no registrar.',
          'Monitorear es mirar lo que importa: disponibilidad, latencia, '
              'errores y saturación.',
        ],
        pista: 'Guardar no es lo mismo que vigilar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué conviene automatizar primero?',
        opciones: [
          'Lo que se repite en cada entrega y la gente se salta con prisa',
          'Lo que resulta más difícil de programar',
          'Lo que hace el programador con más experiencia',
          'Lo que el cliente ve en pantalla',
        ],
        respuestaCorrecta:
            'Lo que se repite en cada entrega y la gente se salta con prisa',
        explicacion: [
          'Las pruebas de regresión son el ejemplo típico: se repiten siempre y '
              'son las primeras en caerse cuando hay prisa.',
        ],
        pista: 'Repetitivo y fácil de olvidar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Que el ___ detecte los fallos antes que el equipo no es mala '
            'suerte: es no haber automatizado la ___.',
        opciones: ['usuario', 'detección', 'servidor', 'entrega'],
        respuestaCorrecta: 'usuario detección',
        explicacion: [
          'Faltan pruebas de regresión en la tubería y monitoreo que avise '
              'antes de que llame el cliente.',
        ],
        pista: 'Quien no debería enterarse primero, y lo que faltó automatizar.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // MUNDO 2 — NORMATIVAS Y CALIDAD
    // =================================================================

    'cap-2-1-lec-1': [
      Ejercicio(
        id: 'q211a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es una norma internacional?',
        opciones: [
          'Un acuerdo documentado al que llegan expertos de muchos países',
          'Una ley que obliga a todas las empresas de un sector',
          'La guía interna de buenas prácticas de una empresa grande',
          'Un programa que verifica automáticamente la calidad del código',
        ],
        respuestaCorrecta:
            'Un acuerdo documentado al que llegan expertos de muchos países',
        explicacion: [
          'No es la opinión de una empresa ni la moda de un año: es consenso '
              'tras años de discusión.',
        ],
        pista: 'Lo importante es quién se pone de acuerdo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: 'En «ISO/IEC/IEEE 12207:2017», ¿qué indica el 2017?',
        opciones: [
          'La edición de la norma',
          'El número de requisitos que contiene',
          'El año en que caduca',
          'La versión del software al que aplica',
        ],
        respuestaCorrecta: 'La edición de la norma',
        explicacion: [
          'Importa, porque entre ediciones pueden cambiar los nombres de los '
              'grupos de procesos.',
        ],
        pista: 'Citar una norma sin año es como citar un libro sin decir cuál.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Cumplir una norma ISO es obligatorio por ley.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Cumplirla es voluntario. Deja de serlo cuando lo exige un contrato, '
              'un regulador o una certificación.',
          'La obligación nunca viene de la norma: viene de fuera.',
        ],
        pista: 'Piensa de dónde sale la obligación.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estas normas NO se puede certificar?',
        opciones: [
          'ISO/IEC 25010',
          'ISO 9001',
          'ISO/IEC 27001',
          'Ninguna: todas se certifican',
        ],
        respuestaCorrecta: 'ISO/IEC 25010',
        explicacion: [
          'Es un modelo de calidad de producto, no un sistema de gestión: no '
              'hay organización ni procesos que auditar.',
          'Decir «estamos certificados en ISO 25010» es un error frecuente.',
        ],
        pista: 'Solo se certifican los sistemas de gestión.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La ___ certifica a la organización; la ___ es solo un modelo de '
            'referencia.',
        opciones: ['ISO 9001', 'ISO 25010', 'ISO 27001', 'ISO 12207'],
        respuestaCorrecta: 'ISO 9001 ISO 25010',
        explicacion: [
          'La 27001 también certifica; la 12207, como la 25010, es un marco de '
              'referencia.',
        ],
        pista: 'Una define un sistema de gestión de la calidad.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Cuando una norma lleva tres siglas en el nombre es porque la '
            'publicaron tres organismos juntos.',
        respuestaCorrecta: 'true',
        explicacion: [
          'ISO para normalización general, IEC para la parte electrotécnica e '
              'IEEE para la asociación de ingenieros eléctricos y '
              'electrónicos.',
        ],
        pista: 'Cuenta las siglas de la 12207.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo pasa a ser obligatorio cumplir una norma?',
        opciones: [
          'Cuando lo exige un contrato, un regulador o una certificación',
          'En cuanto la norma se publica oficialmente',
          'Cuando la empresa supera los cincuenta empleados',
          'Cuando el proyecto es de software crítico, siempre',
        ],
        respuestaCorrecta:
            'Cuando lo exige un contrato, un regulador o una certificación',
        explicacion: [
          'La obligación es externa a la norma.',
        ],
        pista: 'Alguien de fuera tiene que exigirla.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una norma define ___, describe procesos y fija requisitos ___.',
        opciones: ['términos', 'comprobables', 'precios', 'opcionales'],
        respuestaCorrecta: 'términos comprobables',
        explicacion: [
          'Si los requisitos no fueran comprobables, no habría forma de '
              'auditar nada.',
        ],
        pista: 'Lo primero evita discusiones de vocabulario.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-1-lec-2': [
      Ejercicio(
        id: 'q212a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué aporta tener un vocabulario normalizado en un equipo?',
        opciones: [
          'Las reuniones duran menos y quien entra nuevo no aprende un '
              'vocabulario inventado en casa',
          'El código se ejecuta más rápido',
          'Se necesitan menos programadores',
          'Desaparecen los defectos en producción',
        ],
        respuestaCorrecta:
            'Las reuniones duran menos y quien entra nuevo no aprende un '
            'vocabulario inventado en casa',
        explicacion: [
          'Cuando «requisito» o «línea base» significan lo mismo para todos, '
              'se discute el problema y no las palabras.',
        ],
        pista: 'Tiene que ver con entenderse.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué casi ninguna exigencia de una norma es caprichosa?',
        opciones: [
          'Porque detrás de cada una hay un proyecto que falló por no tenerla',
          'Porque las escriben organismos gubernamentales',
          'Porque se votan en asamblea cada año',
          'Porque las empresas grandes las imponen',
        ],
        respuestaCorrecta:
            'Porque detrás de cada una hay un proyecto que falló por no tenerla',
        explicacion: [
          'Si una exigencia parece absurda, normalmente es que todavía no '
              'viste el caso que la originó.',
        ],
        pista: 'Es conocimiento acumulado, no burocracia inventada.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Sin certificación, en un contrato público compites en desventaja '
            'pero puedes presentarte.',
        respuestaCorrecta: 'false',
        explicacion: [
          'En muchos casos la certificación es condición para licitar: sin '
              'ella no puedes presentarte en absoluto.',
        ],
        pista: 'No es cuestión de puntuar menos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: 'Si un cliente reclama, ¿qué papel juegan los registros?',
        opciones: [
          'Demuestran qué se acordó, qué se probó y cuándo',
          'Sirven para calcular el precio final del proyecto',
          'Permiten despedir al responsable del error',
          'No tienen ningún valor legal',
        ],
        respuestaCorrecta: 'Demuestran qué se acordó, qué se probó y cuándo',
        explicacion: [
          'Sin registros, la discusión es palabra contra palabra.',
        ],
        pista: 'Un auditor no pide opiniones.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Cuando el equipo documenta para pasar la ___ y no para trabajar '
            'mejor, la norma dejó de ___.',
        opciones: ['auditoría', 'servir', 'entrega', 'existir'],
        respuestaCorrecta: 'auditoría servir',
        explicacion: [
          'Es el síntoma de que las normas se están aplicando sin criterio.',
        ],
        pista: 'Documentar para alguien, en vez de para uno mismo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La norma especifica cuántas páginas de documentación hay que '
            'generar.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Dice qué hay que conseguir, no cuánto papel producir. El exceso lo '
              'añade la organización, no el estándar.',
        ],
        pista: '¿Quién decide realmente el volumen de papeleo?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el síntoma de que una norma se aplicó sin criterio?',
        opciones: [
          'Carpetas que nadie lee y reuniones que no deciden nada',
          'Que el equipo entregue antes de lo previsto',
          'Que se detecten defectos en las pruebas',
          'Que el cliente pida cambios al final',
        ],
        respuestaCorrecta:
            'Carpetas que nadie lee y reuniones que no deciden nada',
        explicacion: [
          'La norma se convirtió en trámite en lugar de en herramienta.',
        ],
        pista: 'Mira qué se produce y quién lo usa.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las normas son conocimiento ___ de muchas organizaciones durante '
            '___.',
        opciones: ['acumulado', 'décadas', 'teórico', 'meses'],
        respuestaCorrecta: 'acumulado décadas',
        explicacion: [
          'Sale más barato leerlo que repetir los errores que lo originaron.',
        ],
        pista: 'No se escribieron en una tarde.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-2-lec-1': [
      Ejercicio(
        id: 'q221a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿A qué tipo de organización aplica la ISO 9001?',
        opciones: [
          'A cualquiera, produzca lo que produzca',
          'Solo a empresas de software',
          'Solo a empresas con más de cien empleados',
          'Solo a fabricantes de productos físicos',
        ],
        respuestaCorrecta: 'A cualquiera, produzca lo que produzca',
        explicacion: [
          'Vale para una panadería, un hospital o una empresa de software. No '
              'habla de código: habla de gestión.',
        ],
        pista: 'No es una norma de software.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué propone el enfoque a procesos?',
        opciones: [
          'Controlar el proceso que produce el resultado, en vez del resultado '
              'al final',
          'Revisar el producto terminado con más detalle',
          'Contratar un auditor externo permanente',
          'Documentar el código línea por línea',
        ],
        respuestaCorrecta:
            'Controlar el proceso que produce el resultado, en vez del '
            'resultado al final',
        explicacion: [
          'Si el proceso está definido y se sigue, el resultado es repetible. '
              'Si depende de quién esté ese día, no lo es.',
        ],
        pista: 'Dónde se pone el control.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El ciclo PHVA son los pasos planificar, hacer, verificar y actuar.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es el motor de todo sistema de gestión de la calidad, y se repite '
              'sin parar.',
        ],
        pista: 'Son cuatro verbos en orden.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál es la diferencia entre una corrección y una acción '
            'correctiva?',
        opciones: [
          'La corrección repara el efecto; la acción correctiva ataca la causa',
          'La corrección la hace el equipo; la acción correctiva, el auditor',
          'La corrección es urgente; la acción correctiva es opcional',
          'No hay diferencia, son sinónimos',
        ],
        respuestaCorrecta:
            'La corrección repara el efecto; la acción correctiva ataca la causa',
        explicacion: [
          'Un auditor pregunta siempre por la segunda.',
        ],
        pista: 'Una evita que vuelva a pasar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Arreglar el error es ___; añadir la prueba automática que lo '
            'habría detectado es acción ___.',
        opciones: ['corrección', 'correctiva', 'auditoría', 'preventiva'],
        respuestaCorrecta: 'corrección correctiva',
        explicacion: [
          'La segunda es la que la ISO 9001 exige documentar.',
        ],
        pista: 'La misma raíz, en dos formas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La ISO 9001 explica cómo escribir requisitos y qué pruebas '
            'ejecutar en un proyecto de software.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Para eso están la 12207, la 29119 y la 25010.',
          'La 9001 se ocupa del marco de gestión; las otras, del contenido '
              'técnico.',
        ],
        pista: 'Recuerda que no es una norma de software.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estas NO es una exigencia de la ISO 9001?',
        opciones: [
          'Usar una metodología ágil para los proyectos',
          'Tener los procesos definidos por escrito',
          'Conservar registros de haberlos seguido',
          'Auditar periódicamente con alguien independiente',
        ],
        respuestaCorrecta: 'Usar una metodología ágil para los proyectos',
        explicacion: [
          'La norma no elige metodología: exige que haya procesos definidos y '
              'evidencia de que se siguen.',
        ],
        pista: 'Tres hablan de procesos y evidencias; una, de moda.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una retrospectiva que no cambia nada en el siguiente sprint se '
            'queda en ___ y nunca llega a ___.',
        opciones: ['verificar', 'actuar', 'planificar', 'hacer'],
        respuestaCorrecta: 'verificar actuar',
        explicacion: [
          'Son los dos últimos pasos del ciclo PHVA, y el segundo es el que da '
              'la mejora.',
        ],
        pista: 'Los dos últimos pasos del ciclo.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-2-lec-2': [
      Ejercicio(
        id: 'q222a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿En cuántas características divide la calidad del producto la '
            'ISO/IEC 25010?',
        opciones: ['Ocho', 'Cuatro', 'Doce', 'Cinco'],
        respuestaCorrecta: 'Ocho',
        explicacion: [
          'Adecuación funcional, eficiencia, compatibilidad, usabilidad, '
              'fiabilidad, seguridad, mantenibilidad y portabilidad.',
        ],
        pista: 'Más de cinco y menos de diez.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué distingue la calidad en uso de la calidad del producto?',
        opciones: [
          'La calidad en uso mira si una persona real logra su objetivo, y con '
              'cuánta frustración',
          'La calidad en uso solo aplica a aplicaciones móviles',
          'La calidad en uso se mide con pruebas unitarias',
          'Son dos nombres para lo mismo',
        ],
        respuestaCorrecta:
            'La calidad en uso mira si una persona real logra su objetivo, y '
            'con cuánta frustración',
        explicacion: [
          'Un producto puede puntuar bien en el modelo de producto y fracasar '
              'en uso.',
        ],
        pista: 'Una mira el software; la otra, a quien lo usa.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Una empresa puede obtener un certificado ISO/IEC 25010.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Es un modelo de referencia, no un sistema de gestión. Sirve para '
              'escribir requisitos y evaluar productos, pero no se certifica.',
        ],
        pista: '¿Qué habría que auditar exactamente?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿En qué se descompone la mantenibilidad?',
        opciones: [
          'Modularidad, reusabilidad, analizabilidad, modificabilidad y '
              'capacidad de ser probado',
          'Disponibilidad, tolerancia a fallos y recuperabilidad',
          'Confidencialidad, integridad y disponibilidad',
          'Velocidad, memoria y consumo de red',
        ],
        respuestaCorrecta:
            'Modularidad, reusabilidad, analizabilidad, modificabilidad y '
            'capacidad de ser probado',
        explicacion: [
          'Las subcaracterísticas son las que de verdad se miden con métricas '
              'concretas.',
        ],
        pista: 'Las otras tres opciones pertenecen a otras características.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Más ___ suele costar ___: por eso las características se '
            'priorizan en vez de pedirse todas al máximo.',
        opciones: ['seguridad', 'usabilidad', 'documentación', 'presupuesto'],
        respuestaCorrecta: 'seguridad usabilidad',
        explicacion: [
          'Igual que más portabilidad suele costar eficiencia, y más '
              'funcionalidad suele costar mantenibilidad.',
        ],
        pista: 'Piensa en el doble factor de la app de banca.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Las ocho características de calidad se pueden maximizar todas a '
            'la vez.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Subir una suele bajar otra. La norma no decide el equilibrio: '
              'obliga a decidirlo a conciencia y dejarlo escrito.',
        ],
        pista: 'Si fuera posible, no haría falta priorizar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Una app de banca pide doble factor en cada operación. ¿Qué pasó?',
        opciones: [
          'Subió la seguridad y se hundió la usabilidad',
          'Subieron las dos por igual',
          'Mejoró la portabilidad del sistema',
          'Se redujo la mantenibilidad del código',
        ],
        respuestaCorrecta: 'Subió la seguridad y se hundió la usabilidad',
        explicacion: [
          'Pedirlo solo al transferir equilibra las dos. Esa decisión hay que '
              'tomarla, no heredarla.',
        ],
        pista: 'Cuenta cuántas veces tendría que autenticarse el usuario.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La ISO/IEC 25010 convierte «que sea bueno» en requisitos que se '
            'pueden ___.',
        opciones: ['verificar', 'vender', 'resumir', 'traducir'],
        respuestaCorrecta: 'verificar',
        explicacion: [
          'Ese es el camino: de una palabra vaga a «el 95 % responde en menos '
              'de 500 ms».',
        ],
        pista: 'Lo que se puede comprobar con una prueba.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-3-lec-1': [
      Ejercicio(
        id: 'q231a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué protege la integridad de la información?',
        opciones: [
          'Que el dato no se altere sin autorización',
          'Que solo acceda quien debe',
          'Que esté accesible cuando haga falta',
          'Que se guarde cifrado en el servidor',
        ],
        respuestaCorrecta: 'Que el dato no se altere sin autorización',
        explicacion: [
          'Se protege con validaciones, registros de auditoría y sumas de '
              'verificación.',
        ],
        pista: 'Tiene que ver con que el dato siga siendo el mismo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Una base de datos se corrompe sola por un fallo de programación. '
            '¿Qué propiedad se rompió?',
        opciones: [
          'La integridad',
          'La confidencialidad',
          'La disponibilidad',
          'Ninguna: sin atacante no hay incidente',
        ],
        respuestaCorrecta: 'La integridad',
        explicacion: [
          'No hace falta un atacante. El dato se alteró sin autorización, y eso '
              'basta.',
        ],
        pista: 'La seguridad no habla solo de ataques.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La disponibilidad es la propiedad que más se olvida al hablar de '
            'seguridad.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Se protege con copias de respaldo, redundancia y planes de '
              'recuperación, y casi nadie la menciona primero.',
        ],
        pista: 'Piensa cuál se nombra siempre la última.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el fallo de confidencialidad más habitual?',
        opciones: [
          'Que un usuario tenga más permisos de los que su puesto requiere',
          'Que alguien entre por la fuerza al servidor',
          'Que el servidor se caiga durante una hora',
          'Que se pierda una copia de respaldo',
        ],
        respuestaCorrecta:
            'Que un usuario tenga más permisos de los que su puesto requiere',
        explicacion: [
          'De ahí el principio de dar a cada persona el mínimo permiso que '
              'necesita para su trabajo.',
        ],
        pista: 'Casi nunca es un ataque de película.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Cifrar todo y exigir doble factor sube la ___ y baja la ___.',
        opciones: [
          'confidencialidad',
          'disponibilidad',
          'integridad',
          'portabilidad',
        ],
        respuestaCorrecta: 'confidencialidad disponibilidad',
        explicacion: [
          'En urgencias de un hospital, noventa segundos para abrir un '
              'historial se miden en consecuencias reales.',
        ],
        pista: 'Más candados, más tiempo para abrir.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Tener seguridad significa poner al máximo las tres propiedades.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Las tres se estorban entre sí. Seguridad es decidir el equilibrio a '
              'conciencia y poder explicar por qué.',
        ],
        pista: 'Si se pudiera, no habría nada que decidir.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Dónde aparecen estas tres propiedades como punto de partida?',
        opciones: [
          'En la ISO/IEC 27001',
          'En la ISO 9001',
          'En el Manifiesto Ágil',
          'En la ISO/IEC/IEEE 29119',
        ],
        respuestaCorrecta: 'En la ISO/IEC 27001',
        explicacion: [
          'Cuando esa norma habla de proteger un activo, se refiere a proteger '
              'estas tres propiedades.',
        ],
        pista: 'La norma de seguridad de la información.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las tres propiedades de la seguridad son confidencialidad, ___ y '
            '___.',
        opciones: [
          'integridad',
          'disponibilidad',
          'trazabilidad',
          'usabilidad',
        ],
        respuestaCorrecta: 'integridad disponibilidad',
        explicacion: [
          'Cuando algo es un incidente de seguridad, es porque se rompió al '
              'menos una de las tres.',
        ],
        pista: 'Las dos que acompañan siempre a la primera.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-3-lec-2': [
      Ejercicio(
        id: 'q232a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es lo primero que se define al montar un SGSI?',
        opciones: [
          'El alcance: qué procesos, qué datos y qué sedes cubre',
          'La lista de contraseñas de los administradores',
          'El presupuesto anual de seguridad',
          'La herramienta de cifrado que se va a usar',
        ],
        respuestaCorrecta:
            'El alcance: qué procesos, qué datos y qué sedes cubre',
        explicacion: [
          'Suena burocrático y es la decisión más importante de todas: lo que '
              'queda fuera del alcance queda sin proteger.',
        ],
        pista: 'Antes de proteger hay que decir qué.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué puede ser un activo de información?',
        opciones: [
          'Cualquier elemento con valor que haya que proteger, incluido el '
              'conocimiento de una persona',
          'Únicamente las bases de datos del sistema',
          'Solo los servidores y equipos físicos',
          'Solo los documentos firmados por la dirección',
        ],
        respuestaCorrecta:
            'Cualquier elemento con valor que haya que proteger, incluido el '
            'conocimiento de una persona',
        explicacion: [
          'Bases de datos, código fuente, credenciales, documentación y lo que '
              'solo sabe alguien del equipo.',
        ],
        pista: 'La lista es más larga de lo que parece.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Mitigar es la única forma válida de tratar un riesgo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Hay cuatro: mitigar, transferir, aceptar y evitar.',
          'Aceptar un riesgo es perfectamente válido si queda por escrito y lo '
              'firma quien tiene autoridad para hacerlo.',
        ],
        pista: 'Son cuatro salidas, no una.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es la declaración de aplicabilidad?',
        opciones: [
          'La lista de todos los controles indicando si se aplican y por qué',
          'El contrato que firma el cliente al aceptar el sistema',
          'El informe final de la auditoría de certificación',
          'La política de contraseñas de la organización',
        ],
        respuestaCorrecta:
            'La lista de todos los controles indicando si se aplican y por qué',
        explicacion: [
          'Justificar por qué dejas un control fuera es tan obligatorio como '
              'justificar los que pones.',
        ],
        pista: 'Incluye también lo que decides no hacer.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La ___ es la debilidad que lo permitiría; la ___ es el suceso que '
            'puede causar daño.',
        opciones: ['vulnerabilidad', 'amenaza', 'auditoría', 'política'],
        respuestaCorrecta: 'vulnerabilidad amenaza',
        explicacion: [
          'El riesgo combina lo probable que es con el daño que haría.',
          'Amenaza: que roben credenciales. Vulnerabilidad: que estén sin '
              'cifrar.',
        ],
        pista: 'Una está dentro del sistema; la otra viene de fuera.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Aceptar un riesgo es válido si queda por escrito y lo firma quien '
            'tiene autoridad.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Lo que no vale es aceptarlo de hecho, sin decidirlo ni dejar '
              'constancia.',
        ],
        pista: 'La clave está en que sea una decisión y no un descuido.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Te encargan la historia clínica electrónica de un hospital. ¿Cuál '
            'es el primer paso?',
        opciones: [
          'Definir el alcance del SGSI y hacer el análisis de riesgos',
          'Elegir el framework de desarrollo',
          'Diseñar las pantallas del módulo de pacientes',
          'Contratar el servidor donde se alojará',
        ],
        respuestaCorrecta:
            'Definir el alcance del SGSI y hacer el análisis de riesgos',
        explicacion: [
          'Todo lo técnico viene después y depende de eso.',
          'Omitir la matriz de riesgos es uno de los cinco errores que señaló '
              'el profesional entrevistado.',
        ],
        pista: 'Nada de lo que se programe tiene sentido antes de eso.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las cuatro salidas ante un riesgo son mitigar, transferir, ___ y '
            '___.',
        opciones: ['aceptar', 'evitar', 'ignorar', 'auditar'],
        respuestaCorrecta: 'aceptar evitar',
        explicacion: [
          'Evitar significa no hacer la actividad que genera el riesgo.',
        ],
        pista: 'Una asume el riesgo; la otra lo elimina de raíz.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-4-lec-1': [
      Ejercicio(
        id: 'q241a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué encontrarás dos clasificaciones distintas de los '
            'procesos de la ISO/IEC 12207?',
        opciones: [
          'Porque la edición de 2008 y la de 2017 los agrupan de forma distinta',
          'Porque cada país adapta la norma a su manera',
          'Porque una es para software y otra para hardware',
          'Porque depende del tamaño de la organización',
        ],
        respuestaCorrecta:
            'Porque la edición de 2008 y la de 2017 los agrupan de forma distinta',
        explicacion: [
          'La de 2008 hablaba de primarios, de soporte y organizacionales. La '
              'de 2017 los reorganizó en cuatro grupos.',
        ],
        pista: 'Vuelve a mirar para qué sirve el año en el nombre.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es un proceso según la norma?',
        opciones: [
          'Un conjunto de actividades con entradas definidas y resultados '
              'exigibles',
          'Un diagrama que representa el flujo de trabajo',
          'Una reunión periódica del equipo de proyecto',
          'Un documento aprobado por la dirección',
        ],
        respuestaCorrecta:
            'Un conjunto de actividades con entradas definidas y resultados '
            'exigibles',
        explicacion: [
          'Si no produce un resultado comprobable, el proceso no está '
              'completo.',
        ],
        pista: 'Lo que lo define es lo que entra y lo que sale.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La ISO/IEC/IEEE 12207 impone el orden en que deben recorrerse los '
            'procesos.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Dice qué procesos deben existir y qué debe producir cada uno, no en '
              'qué secuencia.',
          'Por eso sirve igual para cascada que para un equipo que itera cada '
              'dos semanas.',
        ],
        pista: 'Si impusiera el orden, no valdría para ágil.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué cubren los procesos de adquisición y suministro?',
        opciones: [
          'La relación entre quien encarga el sistema y quien lo construye',
          'La compra de servidores y licencias',
          'La contratación del personal del proyecto',
          'El despliegue del sistema en producción',
        ],
        respuestaCorrecta:
            'La relación entre quien encarga el sistema y quien lo construye',
        explicacion: [
          'Cómo se define lo que se pide, cómo se acuerda y cómo se acepta la '
              'entrega.',
          'Buena parte de los conflictos de un proyecto nacen ahí y no en lo '
              'técnico.',
        ],
        pista: 'Tiene que ver con el acuerdo, no con las compras.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Si te preguntan por «procesos primarios» se refieren a la '
            'clasificación de ___; la edición de ___ los reorganizó.',
        opciones: ['2008', '2017', '1970', '2001'],
        respuestaCorrecta: '2008 2017',
        explicacion: [
          'Decirlo al responder suma en lugar de restar: demuestra que sabes '
              'que hay dos ediciones.',
        ],
        pista: 'Las otras dos fechas son las de Royce y el Manifiesto Ágil.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Buena parte de los conflictos de un proyecto nacen de un acuerdo '
            'mal definido al principio, no de problemas técnicos.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Por eso la relación entre cliente y proveedor también está '
              'normalizada como proceso.',
        ],
        pista: 'Piensa en de qué se discute realmente al final de un proyecto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Al reemplazar un sistema que lleva doce años funcionando, ¿qué '
            'procesos dejan de ser teoría?',
        opciones: [
          'Transición y retiro',
          'Análisis de requisitos de negocio',
          'Diseño detallado',
          'Implementación',
        ],
        respuestaCorrecta: 'Transición y retiro',
        explicacion: [
          'Hay que decidir cómo convive lo viejo con lo nuevo, cómo se migran '
              'los datos y cuándo se apaga lo anterior.',
          'Nada de eso es programación, y todo puede hundir el proyecto.',
        ],
        pista: 'Lo difícil no es construir lo nuevo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Un proceso tiene entradas, actividades y ___ exigibles; si no '
            'produce un resultado ___, no está completo.',
        opciones: ['resultados', 'comprobable', 'diagramas', 'aprobado'],
        respuestaCorrecta: 'resultados comprobable',
        explicacion: [
          'Esa es la diferencia entre un proceso de la norma y un diagrama '
              'bonito.',
        ],
        pista: 'Lo que sale, y cómo se sabe que salió.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-4-lec-2': [
      Ejercicio(
        id: 'q242a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué se llaman «procesos de soporte»?',
        opciones: [
          'Porque atraviesan a todos los demás, no porque importen menos',
          'Porque los ejecuta el departamento de soporte técnico',
          'Porque solo se aplican si sobra presupuesto',
          'Porque son opcionales según la norma',
        ],
        respuestaCorrecta:
            'Porque atraviesan a todos los demás, no porque importen menos',
        explicacion: [
          'Son los primeros que se saltan cuando hay prisa, y los que más caro '
              'se pagan después.',
        ],
        pista: 'El nombre engaña.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué permite la gestión de la configuración?',
        opciones: [
          'Saber qué versiones componen el sistema en cada momento y qué cambió',
          'Configurar los parámetros de la aplicación en producción',
          'Instalar el software en los equipos de los usuarios',
          'Definir los permisos de cada usuario del sistema',
        ],
        respuestaCorrecta:
            'Saber qué versiones componen el sistema en cada momento y qué '
            'cambió',
        explicacion: [
          'Es lo que permite responder a «qué exactamente había desplegado el '
              'martes a las tres».',
        ],
        pista: 'No tiene que ver con configurar la app.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El aseguramiento de la calidad es lo mismo que probar el '
            'software.',
        respuestaCorrecta: 'false',
        explicacion: [
          'El aseguramiento audita que los procesos se estén siguiendo. Las '
              'pruebas comprueban el producto.',
          'Uno mira cómo se trabaja; las otras, qué salió.',
        ],
        pista: 'Uno de los dos no toca el producto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué define el proceso de resolución de problemas?',
        opciones: [
          'Qué ocurre desde que alguien reporta un fallo hasta que se cierra, '
              'con registro',
          'Cómo se corrige un error en el código fuente',
          'Quién es responsable de cada módulo del sistema',
          'Cuántos defectos se permiten antes de entregar',
        ],
        respuestaCorrecta:
            'Qué ocurre desde que alguien reporta un fallo hasta que se cierra, '
            'con registro',
        explicacion: [
          'Sin él, los fallos se arreglan por mensaje privado y nadie sabe '
              'cuántos hubo.',
        ],
        pista: 'Es un recorrido completo, no el arreglo en sí.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            '___ es comprobar que se construyó según la especificación; ___ es '
            'comprobar que esa especificación resolvía el problema real.',
        opciones: ['Verificar', 'validar', 'auditar', 'certificar'],
        respuestaCorrecta: 'Verificar validar',
        explicacion: [
          'Se puede verificar con éxito un sistema que no le sirve a nadie. '
              'Por eso son dos procesos y no uno.',
        ],
        pista: '¿Lo construimos bien, o construimos lo correcto?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Los procesos de soporte se notan cuando están presentes.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Se notan cuando faltan. Un equipo entrega sin ellos y lo descubre '
              'seis meses después, cuando hay que corregir algo y nadie sabe '
              'qué versión está corriendo.',
        ],
        pista: 'Igual que los frenos de un coche.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué define el proceso de documentación?',
        opciones: [
          'Qué se escribe, quién lo mantiene y dónde vive',
          'El formato de letra de los informes',
          'Cuántas páginas debe tener el manual de usuario',
          'Quién firma la entrega al cliente',
        ],
        respuestaCorrecta: 'Qué se escribe, quién lo mantiene y dónde vive',
        explicacion: [
          'Sin eso, la documentación envejece y deja de consultarse, que es '
              'peor que no tenerla.',
        ],
        pista: 'Lo importante es quién la mantiene viva.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Sin gestión de la ___, un fallo en producción se investiga a '
            '___.',
        opciones: ['configuración', 'ciegas', 'calidad', 'tiempo'],
        respuestaCorrecta: 'configuración ciegas',
        explicacion: [
          'No se puede corregir lo que no se sabe qué versión es.',
        ],
        pista: 'El proceso que registra las versiones.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // MUNDO 3 — PRUEBAS, DESPLIEGUE Y MANTENIMIENTO
    // =================================================================

    'cap-3-1-lec-1': [
      Ejercicio(
        id: 'q311a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué comprueba una prueba unitaria?',
        opciones: [
          'Una sola pieza de código aislada del resto',
          'El sistema completo funcionando de principio a fin',
          'La comunicación entre dos módulos',
          'Que el cliente acepte la entrega',
        ],
        respuestaCorrecta: 'Una sola pieza de código aislada del resto',
        explicacion: [
          'Si falla, sabes exactamente dónde mirar, porque no hay nada más '
              'involucrado.',
        ],
        pista: 'Es el nivel más pequeño de todos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuáles son las tres partes de una prueba unitaria?',
        opciones: [
          'Preparar, actuar y comprobar',
          'Diseñar, programar y desplegar',
          'Planificar, ejecutar y documentar',
          'Analizar, corregir y cerrar',
        ],
        respuestaCorrecta: 'Preparar, actuar y comprobar',
        explicacion: [
          'La estructura es la misma en cualquier lenguaje.',
        ],
        pista: 'Escenario, acción y afirmación.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Una prueba unitaria puede consultar la base de datos real del '
            'sistema.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Las dependencias se sustituyen por dobles de prueba.',
          'Una prueba que falla porque se cayó la red no dice nada sobre tu '
              'código.',
        ],
        pista: 'La palabra clave es «aislada».',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué conviene una sola afirmación por prueba unitaria?',
        opciones: [
          'Porque si comprueba cinco cosas y falla, vuelves a no saber cuál se '
              'rompió',
          'Porque las pruebas con varias afirmaciones tardan más',
          'Porque el lenguaje no permite más de una',
          'Porque así se escribe menos código',
        ],
        respuestaCorrecta:
            'Porque si comprueba cinco cosas y falla, vuelves a no saber cuál '
            'se rompió',
        explicacion: [
          'Perderías la ventaja principal de la prueba unitaria, que es '
              'señalar el sitio exacto.',
        ],
        pista: 'Piensa en qué te dice el fallo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una buena prueba unitaria tarda ___ y da ___ el mismo resultado.',
        opciones: ['milisegundos', 'siempre', 'minutos', 'casi nunca'],
        respuestaCorrecta: 'milisegundos siempre',
        explicacion: [
          'Si tarda, el equipo deja de ejecutarlas. Si a veces pasa y a veces '
              'no, deja de creerlas, que es peor.',
        ],
        pista: 'Rápida y repetible.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En una estrategia sana de pruebas hay más pruebas unitarias que '
            'de interfaz.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es cuestión de coste: las de abajo son baratas y rápidas, las de '
              'arriba lentas y frágiles.',
        ],
        pista: 'Piensa en la forma de una pirámide.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué la función que decide a qué piso va un ascensor es buen '
            'candidato a prueba unitaria?',
        opciones: [
          'Porque entra un estado y sale una decisión, sin mover ningún motor',
          'Porque es la parte más difícil de programar',
          'Porque la exige la normativa de seguridad',
          'Porque solo la entiende un programador experto',
        ],
        respuestaCorrecta:
            'Porque entra un estado y sale una decisión, sin mover ningún motor',
        explicacion: [
          'Probar eso con el ascensor real sería caro, lento y peligroso.',
        ],
        pista: 'Mira qué entra y qué sale.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las dependencias externas se sustituyen por ___ de prueba, que '
            'devuelven lo que el caso ___.',
        opciones: ['dobles', 'necesita', 'bases', 'produce'],
        respuestaCorrecta: 'dobles necesita',
        explicacion: [
          'Así la prueba solo puede fallar por culpa del código que se está '
              'probando.',
        ],
        pista: 'Suplentes que hacen el papel de la dependencia.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-1-lec-2': [
      Ejercicio(
        id: 'q312a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué comprueban las pruebas de integración?',
        opciones: [
          'Las conversaciones entre piezas, no las piezas en sí',
          'Que cada función devuelva el valor correcto',
          'Que el cliente apruebe la entrega',
          'Que el código cumpla el estilo acordado',
        ],
        respuestaCorrecta: 'Las conversaciones entre piezas, no las piezas en sí',
        explicacion: [
          'Todas las piezas pueden pasar sus unitarias y fallar al juntarse.',
        ],
        pista: 'Lo que se prueba está entre los módulos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es un fallo típico de integración?',
        opciones: [
          'Una parte envía una fecha y la otra espera un texto',
          'Una función devuelve un número negativo por error de cálculo',
          'El servidor se queda sin memoria',
          'El usuario no entiende la pantalla',
        ],
        respuestaCorrecta:
            'Una parte envía una fecha y la otra espera un texto',
        explicacion: [
          'Casi siempre son malentendidos en los bordes: formatos, nulos y '
              'quién valida qué.',
        ],
        pista: 'El problema está en el punto de encuentro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Integrar todo de golpe al final es la forma recomendada de '
            'integrar.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Cuando algo falla, el fallo puede estar en cualquiera de las '
              'decenas de conexiones nuevas.',
          'Esa es justamente la razón de ser de la integración continua.',
        ],
        pista: 'El nombre que recibe esa práctica ya suena mal.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Dos equipos distintos construyen dos módulos que deben hablarse. '
            '¿Qué evita el choque?',
        opciones: [
          'Acordar por escrito el formato del intercambio antes de programar',
          'Que los dos usen el mismo lenguaje de programación',
          'Integrar únicamente al final del proyecto',
          'Que un mismo programador revise los dos módulos',
        ],
        respuestaCorrecta:
            'Acordar por escrito el formato del intercambio antes de programar',
        explicacion: [
          'Qué campos, de qué tipo y qué pasa si falta uno.',
        ],
        pista: 'La solución es anterior al código.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La integración comprueba que dos componentes se ___; la prueba de '
            'sistema mira el producto ___.',
        opciones: ['entienden', 'entero', 'compilan', 'aislado'],
        respuestaCorrecta: 'entienden entero',
        explicacion: [
          'Son dos niveles distintos y la integración sigue siendo una prueba '
              'técnica.',
        ],
        pista: 'Una mira el borde; la otra, el conjunto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La integración se puede hacer de arriba abajo o de abajo arriba, '
            'y conviene que sea una decisión consciente.',
        respuestaCorrecta: 'true',
        explicacion: [
          'En un caso se usan sustitutos de los módulos inferiores; en el '
              'otro, arneses que llamen a los de abajo.',
        ],
        pista: 'Hay dos direcciones posibles.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué pueden fallar módulos que pasaron todas sus pruebas '
            'unitarias?',
        opciones: [
          'Porque cada uno se probó contra lo que su autor creía que hacía el '
              'de al lado',
          'Porque las pruebas unitarias no sirven para nada',
          'Porque el compilador introduce errores al unir el código',
          'Porque siempre falta memoria al juntarlos',
        ],
        respuestaCorrecta:
            'Porque cada uno se probó contra lo que su autor creía que hacía '
            'el de al lado',
        explicacion: [
          'La suposición de cada lado puede ser razonable y aun así '
              'incompatible con la del otro.',
        ],
        pista: 'El problema es una suposición, no un error de cálculo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La integración continua propone juntar ___ y a ___, para saber '
            'qué cambio rompió qué.',
        opciones: ['poco', 'menudo', 'todo', 'destiempo'],
        respuestaCorrecta: 'poco menudo',
        explicacion: [
          'Lo contrario es el «big bang», y encontrar el fallo cuesta mucho '
              'más.',
        ],
        pista: 'Dos adverbios que van juntos siempre.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-1-lec-3': [
      Ejercicio(
        id: 'q313a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Contra qué se comprueba una prueba de sistema?',
        opciones: [
          'Contra la especificación, con el producto completo',
          'Contra el código fuente de cada módulo',
          'Contra la opinión del equipo de desarrollo',
          'Contra las pruebas unitarias que ya pasaron',
        ],
        respuestaCorrecta: 'Contra la especificación, con el producto completo',
        explicacion: [
          'Aquí se comprueban también los requisitos no funcionales: '
              'rendimiento, seguridad, comportamiento bajo carga.',
        ],
        pista: 'El documento que dice qué debía hacer el sistema.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Quién decide el resultado de una prueba de aceptación?',
        opciones: [
          'El cliente, o quien represente al usuario',
          'El programador que escribió el módulo',
          'El responsable de la tubería de despliegue',
          'El equipo de operaciones',
        ],
        respuestaCorrecta: 'El cliente, o quien represente al usuario',
        explicacion: [
          'Se deriva de los requisitos de usuario, no del código ni del '
              'diseño.',
        ],
        pista: 'Quien pidió el sistema.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Los criterios de aceptación se pueden definir al terminar el '
            'desarrollo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Deben estar escritos al definir el requisito.',
          'Si se negocian al final, lo que se discute es el alcance, no la '
              'calidad.',
        ],
        pista: '¿En qué momento todavía se puede negociar de buena fe?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué diferencia una prueba alfa de una beta?',
        opciones: [
          'La alfa se hace en las instalaciones de quien desarrolla; la beta, '
              'en el entorno del usuario',
          'La alfa la hacen programadores; la beta, el cliente',
          'La alfa es automática y la beta es manual',
          'La alfa prueba el código y la beta la documentación',
        ],
        respuestaCorrecta:
            'La alfa se hace en las instalaciones de quien desarrolla; la '
            'beta, en el entorno del usuario',
        explicacion: [
          'En las dos prueban usuarios reales. Lo que cambia es dónde.',
        ],
        pista: 'La diferencia es el lugar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las pruebas de sistema ___ el producto; las de aceptación lo ___.',
        opciones: ['verifican', 'validan', 'compilan', 'despliegan'],
        respuestaCorrecta: 'verifican validan',
        explicacion: [
          'Unas comprueban contra la especificación; las otras, contra la '
              'necesidad real.',
        ],
        pista: 'Los dos verbos de siempre.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La norma que cubre el proceso de pruebas y la documentación de '
            'pruebas es la ISO/IEC/IEEE 29119.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Los niveles de prueba y su relación con los requisitos vienen de la '
              'ISO/IEC/IEEE 12207.',
        ],
        pista: 'No es la 12207 ni la 25010.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'En el ascensor, ¿quién hace la prueba de aceptación y contra qué?',
        opciones: [
          'El organismo certificador, contra la normativa de seguridad',
          'El programador, contra el código escrito',
          'El cliente, contra el presupuesto acordado',
          'El equipo de pruebas, contra el diseño detallado',
        ],
        respuestaCorrecta:
            'El organismo certificador, contra la normativa de seguridad',
        explicacion: [
          'La prueba de sistema comprueba la precisión de parada; la de '
              'aceptación, que se puede poner en servicio.',
        ],
        pista: 'Es quien autoriza que funcione con gente dentro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La prueba ___ la hace el equipo que va a mantener el sistema.',
        opciones: ['operativa', 'alfa', 'beta', 'unitaria'],
        respuestaCorrecta: 'operativa',
        explicacion: [
          'Comprueba que el sistema se puede operar, respaldar y recuperar en '
              'el día a día.',
        ],
        pista: 'El nombre viene de quién lo va a operar.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-2-lec-1': [
      Ejercicio(
        id: 'q321a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿De dónde salen los casos en una prueba de caja blanca?',
        opciones: [
          'De la estructura interna del programa: condiciones, bucles y caminos',
          'De la especificación de requisitos',
          'De la experiencia del usuario final',
          'De los defectos encontrados en producción',
        ],
        respuestaCorrecta:
            'De la estructura interna del programa: condiciones, bucles y '
            'caminos',
        explicacion: [
          'Quien las escribe ve el código.',
        ],
        pista: 'El nombre de la técnica ya lo dice.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estos niveles de cobertura es el más exigente?',
        opciones: [
          'De caminos',
          'De sentencias',
          'De decisiones',
          'Los tres exigen lo mismo',
        ],
        respuestaCorrecta: 'De caminos',
        explicacion: [
          'Van de menos a más: sentencias, decisiones o ramas, y caminos.',
        ],
        pista: 'El que cubre cada recorrido posible del flujo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Alcanzar el 100 % de cobertura de sentencias garantiza que se '
            'probaron todas las ramas.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Una función con un «si» sin «si no» se recorre entera con un solo '
              'caso que entre en el «si».',
          'Tendrías cobertura total de líneas sin haber probado nunca la '
              'condición falsa.',
        ],
        pista: 'Piensa en un «si» que no tiene «si no».',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué tipo de problema detecta bien la caja blanca?',
        opciones: [
          'Código inalcanzable y ramas que nadie pensó',
          'Requisitos que faltan por implementar',
          'Que el usuario no entienda la interfaz',
          'Que el contrato esté mal redactado',
        ],
        respuestaCorrecta: 'Código inalcanzable y ramas que nadie pensó',
        explicacion: [
          'Son cosas que desde fuera, sin ver el código, no se sospechan.',
        ],
        pista: 'Algo que solo se ve mirando dentro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La caja blanca no detecta lo que ___, porque los casos salen del '
            'código ya ___.',
        opciones: ['falta', 'escrito', 'sobra', 'probado'],
        respuestaCorrecta: 'falta escrito',
        explicacion: [
          'Si una funcionalidad no se programó, no hay rama que la represente.',
        ],
        pista: 'Su punto ciego es la ausencia.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Se puede llegar al 100 % de cobertura con pruebas que no '
            'comprueban nada.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Sin afirmaciones, la cobertura mide qué se ejecutó, no qué se '
              'verificó.',
        ],
        pista: '¿Qué pasa si la prueba ejecuta el código y no afirma nada?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué exige la cobertura de decisiones o de ramas?',
        opciones: [
          'Que cada condición se evalúe como verdadera y como falsa',
          'Que cada línea se ejecute al menos una vez',
          'Que se recorran todos los caminos posibles del flujo',
          'Que cada función tenga al menos una prueba',
        ],
        respuestaCorrecta:
            'Que cada condición se evalúe como verdadera y como falsa',
        explicacion: [
          'Cuesta más que la de sentencias y detecta mucho más.',
        ],
        pista: 'Cada condición, en sus dos resultados.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La caja ___ mira si lo escrito funciona; la caja ___ mira si está '
            'todo lo que debía estar.',
        opciones: ['blanca', 'negra', 'gris', 'cerrada'],
        respuestaCorrecta: 'blanca negra',
        explicacion: [
          'No compiten: cubren huecos distintos.',
        ],
        pista: 'Dos colores.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-2-lec-2': [
      Ejercicio(
        id: 'q322a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿De dónde salen los casos en una prueba de caja negra?',
        opciones: [
          'De la especificación: qué entra y qué debe salir',
          'Del diagrama de flujo del programa',
          'Del número de líneas de cada función',
          'De los registros del servidor en producción',
        ],
        respuestaCorrecta: 'De la especificación: qué entra y qué debe salir',
        explicacion: [
          'Cómo esté hecho por dentro no importa, y eso permite que las '
              'escriba alguien que no programó el sistema.',
        ],
        pista: 'No se mira el código.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Un campo acepta edades de 18 a 65. ¿Qué propone la técnica de '
            'particiones de equivalencia?',
        opciones: [
          'Agrupar las entradas en clases que el sistema trata igual y probar '
              'una de cada clase',
          'Probar todos los valores entre 0 y 120',
          'Probar solo los valores válidos',
          'Probar únicamente con valores decimales',
        ],
        respuestaCorrecta:
            'Agrupar las entradas en clases que el sistema trata igual y '
            'probar una de cada clase',
        explicacion: [
          'Probar 19, 20 y 21 es probar tres veces lo mismo.',
        ],
        pista: 'Se trata de no repetir el mismo caso con otro número.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Los defectos de validación se concentran en los bordes de cada '
            'clase.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es donde se confunde «mayor que» con «mayor o igual».',
          'Por eso la técnica de valores límite es la que más defectos '
              'encuentra.',
        ],
        pista: 'Piensa en qué se equivoca al escribir una comparación.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Para un rango válido de 18 a 65, ¿cuáles son los valores límite '
            'interesantes?',
        opciones: [
          '17, 18, 19, 64, 65 y 66',
          'Solo 18 y 65',
          '0, 50 y 100',
          'Cualquier valor entre 18 y 65',
        ],
        respuestaCorrecta: '17, 18, 19, 64, 65 y 66',
        explicacion: [
          'Los extremos y sus vecinos inmediatos, a cada lado de la frontera.',
        ],
        pista: 'Justo antes, justo en el borde y justo después.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Cuando el resultado depende de varias condiciones combinadas se '
            'usa una tabla de ___, que recoge todas las ___.',
        opciones: ['decisión', 'combinaciones', 'cobertura', 'entradas'],
        respuestaCorrecta: 'decisión combinaciones',
        explicacion: [
          'Es tedioso y es la única forma de no olvidarse ninguna.',
        ],
        pista: 'Una tabla con todos los casos posibles.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Una ventaja de la caja negra es que puede escribirla alguien que '
            'no programó el sistema.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Y por eso no hereda las suposiciones de quien lo construyó.',
        ],
        pista: 'Piensa en qué sesgo se evita.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'El descuento de una tienda depende de tres condiciones '
            'independientes. ¿Cuántas combinaciones hay que considerar?',
        opciones: ['Ocho', 'Tres', 'Seis', 'Nueve'],
        respuestaCorrecta: 'Ocho',
        explicacion: [
          'Tres condiciones con dos valores cada una dan dos elevado a tres.',
          'A mano siempre se olvida alguna; con tabla de decisión, ninguna.',
        ],
        pista: 'Dos valores posibles por cada condición.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una estrategia seria usa caja ___ para cubrir lo que el sistema '
            'debe hacer y caja ___ para que no queden rincones sin probar.',
        opciones: ['negra', 'blanca', 'gris', 'abierta'],
        respuestaCorrecta: 'negra blanca',
        explicacion: [
          'Elegir solo una deja un hueco distinto en cada caso.',
        ],
        pista: 'Primero la que mira la especificación.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-3-lec-1': [
      Ejercicio(
        id: 'q331a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es un defecto?',
        opciones: [
          'La huella de un error humano en el código o en un documento',
          'El comportamiento incorrecto que percibe el usuario',
          'La equivocación que comete una persona',
          'Un requisito mal priorizado',
        ],
        respuestaCorrecta:
            'La huella de un error humano en el código o en un documento',
        explicacion: [
          'El error es la equivocación de la persona; el fallo, lo que el '
              'usuario percibe.',
        ],
        pista: 'Está en el artefacto, no en la persona ni en la pantalla.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué significa el estado «verificado» en el ciclo de un defecto?',
        opciones: [
          'Quien lo reportó confirmó que la corrección funciona',
          'El programador dice que ya lo arregló',
          'El defecto se asignó a un responsable',
          'Se decidió no corregirlo',
        ],
        respuestaCorrecta: 'Quien lo reportó confirmó que la corrección funciona',
        explicacion: [
          'Que quien arregla diga «resuelto» no basta: cierra quien lo '
              'reportó.',
        ],
        pista: 'Hay dos personas distintas implicadas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Que un sistema nunca haya fallado prueba que no tiene defectos.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Un defecto puede existir años sin producir ningún fallo, hasta que '
              'alguien recorre ese camino.',
        ],
        pista: 'Defecto y fallo no son lo mismo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué hace falta para que un reporte de defecto sirva?',
        opciones: [
          'Pasos para reproducirlo, qué esperabas, qué pasó, versión y entorno',
          'Una captura de pantalla y poco más',
          'El nombre del programador responsable',
          'La estimación de cuánto costará arreglarlo',
        ],
        respuestaCorrecta:
            'Pasos para reproducirlo, qué esperabas, qué pasó, versión y '
            'entorno',
        explicacion: [
          'Sirve cuando otra persona puede reproducirlo sin preguntar nada.',
          '«No funciona el login» no es un reporte: es una queja.',
        ],
        pista: 'Lo clave es que otro pueda repetirlo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'El ___ es la equivocación de la persona; el ___ es lo que el '
            'usuario percibe.',
        opciones: ['error', 'fallo', 'defecto', 'incidente'],
        respuestaCorrecta: 'error fallo',
        explicacion: [
          'En medio queda el defecto, que es la huella del error en el '
              'artefacto.',
        ],
        pista: 'El principio y el final de la cadena.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Un defecto cerrado como «no reproducible» debe quedar registrado '
            'igual.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Todas las salidas legítimas se registran con su motivo: duplicado, '
              'no es un defecto, no reproducible o diferido.',
        ],
        pista: 'Lo que no se registra, a efectos de métricas no existió.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Si los defectos se arreglan por mensaje privado, ¿qué se pierde?',
        opciones: [
          'La posibilidad de saber cuántos hubo y dónde se concentran',
          'La velocidad de corrección',
          'La relación con el cliente',
          'La cobertura de las pruebas',
        ],
        respuestaCorrecta:
            'La posibilidad de saber cuántos hubo y dónde se concentran',
        explicacion: [
          'El registro de defectos es la materia prima de las métricas de '
              'calidad.',
        ],
        pista: 'Sin dato no hay métrica.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Cuando los fallos los descubre el ___, el ciclo del defecto está '
            'empezando demasiado ___.',
        opciones: ['usuario', 'tarde', 'equipo', 'pronto'],
        respuestaCorrecta: 'usuario tarde',
        explicacion: [
          'Suelen faltar pruebas de regresión automatizadas y un criterio '
              'claro de qué se puede liberar.',
        ],
        pista: 'Quién no debería enterarse primero.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-3-lec-2': [
      Ejercicio(
        id: 'q332a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué mide la severidad de un defecto?',
        opciones: [
          'El daño técnico que causa',
          'La urgencia con que el negocio quiere arreglarlo',
          'El tiempo que llevará corregirlo',
          'El número de usuarios que lo reportaron',
        ],
        respuestaCorrecta: 'El daño técnico que causa',
        explicacion: [
          'La urgencia es la prioridad, y la decide otra persona.',
        ],
        pista: 'Una describe; la otra decide.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Quién pone normalmente la prioridad de un defecto?',
        opciones: [
          'Quien decide el producto',
          'Quien lo encontró probando',
          'Quien va a corregirlo',
          'El responsable de infraestructura',
        ],
        respuestaCorrecta: 'Quien decide el producto',
        explicacion: [
          'La severidad la pone quien prueba; la prioridad, el negocio.',
        ],
        pista: 'Depende de para qué sirve el sistema, no de cómo está roto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Un defecto de severidad baja puede tener prioridad alta.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Una errata en el nombre del cliente en la portada es cosmética, y '
              'si la demo es mañana ante su directorio, es lo primero que se '
              'arregla.',
        ],
        pista: 'Son independientes, así que se dan las cuatro combinaciones.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué caracteriza a un defecto de severidad crítica?',
        opciones: [
          'El sistema no se puede usar o se pierden datos',
          'Una pantalla tiene los colores cambiados',
          'El cliente lo reportó por teléfono',
          'Hay que corregirlo esta semana',
        ],
        respuestaCorrecta: 'El sistema no se puede usar o se pierden datos',
        explicacion: [
          'Que haya que corregirlo esta semana es prioridad, no severidad.',
        ],
        pista: 'Mide el daño, no el plazo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La ___ describe el daño; la ___ decide qué se arregla primero.',
        opciones: ['severidad', 'prioridad', 'urgencia', 'cobertura'],
        respuestaCorrecta: 'severidad prioridad',
        explicacion: [
          'Mantenerlas separadas permite discutir el orden sin discutir la '
              'gravedad.',
        ],
        pista: 'Una es técnica y la otra de negocio.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Si la mitad de los defectos abiertos están marcados como '
            'críticos, la clasificación sigue siendo útil.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Una escala en la que todo es urgente no ordena nada: traslada la '
              'decisión a quien grite más fuerte.',
          'Suele pasar cuando se usa la severidad para que hagan caso antes.',
        ],
        pista: 'Si todo es prioritario, nada lo es.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Un defecto grave en una pantalla que usa una persona al año. '
            '¿Cómo se clasifica?',
        opciones: [
          'Severidad alta y prioridad baja',
          'Severidad alta y prioridad alta',
          'Severidad baja y prioridad alta',
          'Severidad baja y prioridad baja',
        ],
        respuestaCorrecta: 'Severidad alta y prioridad baja',
        explicacion: [
          'El daño es real, pero el impacto de negocio de arreglarlo ya es '
              'otra conversación.',
        ],
        pista: 'El daño no cambia por cuánta gente lo sufra.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Un defecto ___ no rompe nada funcionalmente, y aun así puede ser '
            'lo ___ que se arregle.',
        opciones: ['cosmético', 'primero', 'crítico', 'último'],
        respuestaCorrecta: 'cosmético primero',
        explicacion: [
          'El ejemplo clásico es la errata en el nombre del cliente antes de '
              'una presentación.',
        ],
        pista: 'Severidad mínima, prioridad máxima.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-4-lec-1': [
      Ejercicio(
        id: 'q341a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué desventaja tiene el reemplazo directo de la versión en '
            'producción?',
        opciones: [
          'Hay interrupción del servicio y, si falla, lo sufren todos a la vez',
          'Requiere mantener dos entornos completos',
          'Solo funciona con bases de datos pequeñas',
          'Obliga a usar interruptores de funcionalidad',
        ],
        respuestaCorrecta:
            'Hay interrupción del servicio y, si falla, lo sufren todos a la '
            'vez',
        explicacion: [
          'A cambio es la estrategia más simple y la más barata.',
        ],
        pista: 'Se apaga lo viejo antes de encender lo nuevo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿En qué consiste el despliegue azul y verde?',
        opciones: [
          'Dos entornos completos: uno atiende y el otro recibe la versión '
              'nueva',
          'Desplegar primero al 1 % de los usuarios',
          'Reemplazar las instancias de poco en poco',
          'Desplegar el código apagado detrás de un interruptor',
        ],
        respuestaCorrecta:
            'Dos entornos completos: uno atiende y el otro recibe la versión '
            'nueva',
        explicacion: [
          'Tiene la vuelta atrás más rápida que existe, y es la más cara: hay '
              'que pagar dos entornos.',
        ],
        pista: 'Son dos, y gemelos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En el despliegue progresivo pueden convivir dos versiones durante '
            'un rato.',
        respuestaCorrecta: 'true',
        explicacion: [
          'No hay caída de servicio, pero esa convivencia hay que tenerla '
              'prevista en el diseño.',
        ],
        pista: 'Las instancias se reemplazan de poco en poco.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué caracteriza a un despliegue canario?',
        opciones: [
          'La versión nueva se abre primero a un porcentaje pequeño de usuarios',
          'Se despliega de noche para que nadie lo note',
          'Se mantienen dos entornos idénticos en paralelo',
          'Se publica solo después de certificar el sistema',
        ],
        respuestaCorrecta:
            'La versión nueva se abre primero a un porcentaje pequeño de '
            'usuarios',
        explicacion: [
          'Se vigilan errores y latencia, y si todo va bien se amplía por '
              'etapas.',
          'El nombre viene de los canarios que los mineros bajaban al túnel.',
        ],
        pista: 'Descubrir el problema con pocos en vez de con todos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Los interruptores de funcionalidad separan ___ de ___, que son '
            'dos decisiones distintas.',
        opciones: ['desplegar', 'publicar', 'probar', 'compilar'],
        respuestaCorrecta: 'desplegar publicar',
        explicacion: [
          'El código viaja apagado y se enciende cuando conviene.',
        ],
        pista: 'Subir el código y mostrarlo al usuario.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En el sistema de control de un ascensor tiene sentido hacer un '
            'despliegue canario.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Se certifica y se instala. No se abre al 1 % de los usuarios a ver '
              'qué pasa.',
        ],
        pista: 'Piensa qué significaría ese 1 % ahí.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué criterio decide la estrategia de despliegue?',
        opciones: [
          'El coste de que algo salga mal',
          'El tamaño del equipo de desarrollo',
          'El lenguaje de programación usado',
          'La antigüedad del sistema',
        ],
        respuestaCorrecta: 'El coste de que algo salga mal',
        explicacion: [
          'Cada estrategia reparte distinto el riesgo entre los usuarios.',
        ],
        pista: 'Lo mismo que decidía entre cascada e iteraciones.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'El despliegue azul y verde tiene la vuelta atrás más ___ y es '
            'también el más ___.',
        opciones: ['rápida', 'caro', 'lenta', 'simple'],
        respuestaCorrecta: 'rápida caro',
        explicacion: [
          'Volver atrás es cambiar el tráfico otra vez, pero hay que pagar dos '
              'entornos completos.',
        ],
        pista: 'Lo que ganas y lo que cuesta.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-4-lec-2': [
      Ejercicio(
        id: 'q342a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo se escribe el plan de vuelta atrás?',
        opciones: [
          'Antes de desplegar',
          'Cuando el despliegue empieza a fallar',
          'Al día siguiente del despliegue',
          'Solo si el cliente lo exige por contrato',
        ],
        respuestaCorrecta: 'Antes de desplegar',
        explicacion: [
          'Improvisarlo a las once de la noche con el sistema caído es cómo se '
              'empeoran las cosas.',
        ],
        pista: 'Cuando todavía se razona con calma.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué suele impedir que una vuelta atrás funcione, aunque el '
            'código sí se pueda revertir?',
        opciones: [
          'Una migración de base de datos que ya eliminó una columna',
          'Que el servidor esté en la nube',
          'Que el equipo use integración continua',
          'Que haya interruptores de funcionalidad',
        ],
        respuestaCorrecta:
            'Una migración de base de datos que ya eliminó una columna',
        explicacion: [
          'Por eso los cambios de esquema se hacen compatibles hacia atrás: '
              'primero se añade, y solo mucho después se elimina lo viejo.',
        ],
        pista: 'El código se revierte; los datos no siempre.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Tener copias de respaldo basta para garantizar que se puede '
            'restaurar el sistema.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Una copia que nunca se restauró es una suposición, no un respaldo.',
        ],
        pista: '¿Alguien lo ha probado alguna vez?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué hay que fijar antes el criterio de vuelta atrás?',
        opciones: [
          'Porque sin criterio la decisión se toma por nervios',
          'Porque lo exige la ISO 9001',
          'Porque así se despliega más rápido',
          'Porque evita tener que hacer copias de respaldo',
        ],
        respuestaCorrecta: 'Porque sin criterio la decisión se toma por nervios',
        explicacion: [
          'Qué nivel de errores, qué latencia o qué fallo concreto dispara la '
              'vuelta atrás.',
        ],
        pista: 'Decidir en caliente nunca sale bien.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Los cambios de esquema se hacen compatibles hacia ___: primero se '
            '___ y solo mucho después se elimina lo viejo.',
        opciones: ['atrás', 'añade', 'adelante', 'borra'],
        respuestaCorrecta: 'atrás añade',
        explicacion: [
          'Así la versión anterior sigue funcionando mientras conviven las '
              'dos.',
        ],
        pista: 'Añadir nunca rompe; eliminar sí.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Corregir hacia adelante con un parche pequeño puede ser mejor que '
            'volver atrás.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es una decisión legítima, siempre que sea una decisión y no la '
              'excusa de no tener plan.',
        ],
        pista: 'No siempre retroceder es lo más seguro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué toca hacer al día siguiente de una vuelta atrás?',
        opciones: [
          'Entender qué pasó para que el fallo se detecte antes la próxima vez',
          'Identificar al responsable del error',
          'Desplegar otra vez la misma versión',
          'Suspender los despliegues durante un mes',
        ],
        respuestaCorrecta:
            'Entender qué pasó para que el fallo se detecte antes la próxima '
            'vez',
        explicacion: [
          'En la tubería, en las pruebas o en el despliegue canario.',
        ],
        pista: 'No es buscar culpables.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Un plan de vuelta atrás que nadie ha ___ no es un plan: es una '
            '___.',
        opciones: ['ensayado', 'intención', 'escrito', 'aprobado'],
        respuestaCorrecta: 'ensayado intención',
        explicacion: [
          'Lo mismo vale para las copias de respaldo que nunca se '
              'restauraron.',
        ],
        pista: 'Falta haberlo probado.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-5-lec-1': [
      Ejercicio(
        id: 'q351a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuántos tipos de mantenimiento distingue la ISO/IEC 14764?',
        opciones: ['Cuatro', 'Dos', 'Tres', 'Seis'],
        respuestaCorrecta: 'Cuatro',
        explicacion: [
          'Correctivo, adaptativo, perfectivo y preventivo.',
        ],
        pista: 'Más de tres y menos de cinco.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Una versión nueva del sistema operativo obliga a ajustar el '
            'software, que seguía funcionando bien. ¿Qué mantenimiento es?',
        opciones: ['Adaptativo', 'Correctivo', 'Perfectivo', 'Preventivo'],
        respuestaCorrecta: 'Adaptativo',
        explicacion: [
          'No hay ningún defecto: el software estaba bien y el entorno cambió '
              'alrededor.',
        ],
        pista: 'Cambió el mundo, no el programa.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El mantenimiento correctivo es el que más esfuerzo consume en un '
            'sistema maduro.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Es solo una cuarta parte de los tipos y suele ser el que menos '
              'horas consume.',
          'El perfectivo suele ser el más grande.',
        ],
        pista: 'Mantener no es sobre todo arreglar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Actualizar una dependencia con una vulnerabilidad conocida, antes '
            'de que pase nada. ¿Qué mantenimiento es?',
        opciones: ['Preventivo', 'Correctivo', 'Adaptativo', 'Perfectivo'],
        respuestaCorrecta: 'Preventivo',
        explicacion: [
          'Actúa sobre problemas que todavía no se manifestaron.',
          'Es el primero que se recorta cuando hay prisa, y el que más cuesta '
              'cuando se recorta.',
        ],
        pista: 'Todavía no ha fallado nada.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'El mantenimiento ___ repara defectos; el ___ mejora lo que ya '
            'funciona.',
        opciones: ['correctivo', 'perfectivo', 'adaptativo', 'preventivo'],
        respuestaCorrecta: 'correctivo perfectivo',
        explicacion: [
          'El adaptativo responde a cambios del entorno y el preventivo actúa '
              'antes de que haya problema.',
        ],
        pista: 'Uno arregla y el otro mejora.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Añadir una función nueva pedida por los usuarios es mantenimiento '
            'perfectivo.',
        respuestaCorrecta: 'true',
        explicacion: [
          'El perfectivo incluye funciones nuevas, mejoras de rendimiento y '
              'reorganización del código.',
        ],
        pista: 'El sistema funcionaba y se quiere que haga más.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué dos preguntas bastan para clasificar un mantenimiento?',
        opciones: [
          'Si hay defecto o no, y si cambió el entorno, lo pide el usuario o '
              'se hace por prudencia',
          'Cuánto cuesta y cuánto tarda',
          'Quién lo pide y quién lo paga',
          'Si afecta al código o a la documentación',
        ],
        respuestaCorrecta:
            'Si hay defecto o no, y si cambió el entorno, lo pide el usuario o '
            'se hace por prudencia',
        explicacion: [
          'Con esas dos respuestas, los cuatro tipos quedan separados.',
        ],
        pista: 'Primero mira si algo está roto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'El mantenimiento ___ es el primero que se recorta cuando hay '
            'prisa, y el que más ___ cuando se recorta.',
        opciones: ['preventivo', 'cuesta', 'correctivo', 'ahorra'],
        respuestaCorrecta: 'preventivo cuesta',
        explicacion: [
          'Porque los problemas que evitaba aparecen después, y ya '
              'manifestados.',
        ],
        pista: 'El que actúa antes de que pase nada.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-5-lec-2': [
      Ejercicio(
        id: 'q352a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué pasa si las peticiones de cambio no entran por una única '
            'puerta?',
        opciones: [
          'Se trabaja en lo que pide quien insiste más',
          'Se resuelven más rápido',
          'El equipo se reparte mejor el trabajo',
          'Disminuye la deuda técnica',
        ],
        respuestaCorrecta: 'Se trabaja en lo que pide quien insiste más',
        explicacion: [
          'En un sistema en producción las peticiones llegan de usuarios, '
              'soporte, dirección y del propio equipo.',
        ],
        pista: 'Sin orden, decide el volumen de la voz.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué responde un análisis de impacto?',
        opciones: [
          'Qué módulos toca el cambio, qué pruebas hay que rehacer y cuánto '
              'cuesta',
          'Quién cometió el error original',
          'Cuántos usuarios reportaron el problema',
          'Qué versión está desplegada en producción',
        ],
        respuestaCorrecta:
            'Qué módulos toca el cambio, qué pruebas hay que rehacer y cuánto '
            'cuesta',
        explicacion: [
          'Sin trazabilidad, ese análisis es una conjetura de alguien con '
              'buena memoria.',
        ],
        pista: 'Se hace antes de aceptar el cambio.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El comité que prioriza los cambios debería estar formado solo por '
            'programadores.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La decisión no es solo técnica: entran el coste, el riesgo y la '
              'urgencia del negocio.',
        ],
        pista: '¿Quién sabe cuánto vale cada cambio para la organización?',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué efecto tienen los acuerdos de nivel de servicio sobre la '
            'clasificación de defectos?',
        opciones: [
          'Le dan consecuencias económicas, porque fijan plazos según la '
              'severidad',
          'La hacen innecesaria',
          'Obligan a clasificar todo como crítico',
          'Solo afectan a la documentación',
        ],
        respuestaCorrecta:
            'Le dan consecuencias económicas, porque fijan plazos según la '
            'severidad',
        explicacion: [
          'Por eso inflar la severidad deja de ser gratis.',
        ],
        pista: 'Lo que se promete por contrato.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Cada atajo para entregar a tiempo genera deuda ___: el cambio '
            'siguiente cuesta un poco ___.',
        opciones: ['técnica', 'más', 'funcional', 'menos'],
        respuestaCorrecta: 'técnica más',
        explicacion: [
          'No toda deuda es mala. La mala es la que se contrae sin registrarla '
              'y sin plan de pago.',
        ],
        pista: 'Como una deuda financiera, genera intereses.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Toda deuda técnica es mala y hay que evitarla siempre.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La mala es la que se contrae sin registrarla y sin plan de pago.',
          'Tomar un atajo consciente y anotado puede ser una decisión '
              'correcta.',
        ],
        pista: 'Lo que importa es si se decidió o simplemente ocurrió.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Con qué se decide si conviene reemplazar un sistema en lugar de '
            'seguir manteniéndolo?',
        opciones: [
          'Con datos: horas de mantenimiento, defectos que reaparecen, tiempo '
              'de un cambio pequeño',
          'Con la antigüedad del sistema en años',
          'Con la opinión del programador más veterano',
          'Con el lenguaje en que está escrito',
        ],
        respuestaCorrecta:
            'Con datos: horas de mantenimiento, defectos que reaparecen, '
            'tiempo de un cambio pequeño',
        explicacion: [
          'De medir todo eso trata el Mundo 4.',
        ],
        pista: 'No es cuestión de edad.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Sin ___, el análisis de impacto es una conjetura de alguien con '
            'buena ___.',
        opciones: ['trazabilidad', 'memoria', 'presupuesto', 'suerte'],
        respuestaCorrecta: 'trazabilidad memoria',
        explicacion: [
          'Aquí es donde la trazabilidad de requisitos se paga sola.',
        ],
        pista: 'Lo que permite seguir un requisito hasta sus pruebas.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // MUNDO 4 — MÉTRICAS, SEGUIMIENTO Y MEJORA CONTINUA
    // =================================================================

    'cap-4-1-lec-1': [
      Ejercicio(
        id: 'q411a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es una medida?',
        opciones: [
          'Un valor crudo obtenido de la realidad, sin interpretar',
          'La relación entre dos o más valores',
          'Un valor con un umbral y una decisión asociada',
          'El resultado de una auditoría',
        ],
        respuestaCorrecta:
            'Un valor crudo obtenido de la realidad, sin interpretar',
        explicacion: [
          'Número de defectos, líneas de código, horas trabajadas. Por sí sola '
              'casi nunca dice nada.',
        ],
        pista: 'Es el escalón más bajo de los tres.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué diferencia a un indicador de una métrica?',
        opciones: [
          'El indicador lleva pegado un umbral y la acción que hay que tomar',
          'El indicador se calcula con dos medidas y la métrica con una',
          'El indicador lo define el cliente y la métrica el equipo',
          'El indicador se mide cada mes y la métrica cada semana',
        ],
        respuestaCorrecta:
            'El indicador lleva pegado un umbral y la acción que hay que tomar',
        explicacion: [
          '«Más de 3 defectos por cada mil líneas: no se libera.» Eso ya no '
              'informa: ordena.',
        ],
        pista: 'Uno informa y el otro manda.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: '«Encontramos 40 defectos» es una métrica.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Es una medida. No significa nada hasta saber en cuánto código y en '
              'cuánto tiempo.',
        ],
        pista: 'Falta relacionarlo con algo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál de estas cuatro cosas NO hace falta para definir bien una '
            'métrica?',
        opciones: [
          'Quién tuvo la culpa de que el valor empeorara',
          'Qué se mide exactamente',
          'Cómo se obtiene el dato y cada cuánto',
          'Qué se hace si se pasa del umbral',
        ],
        respuestaCorrecta: 'Quién tuvo la culpa de que el valor empeorara',
        explicacion: [
          'La cuarta que sí hace falta es contra qué valor se compara.',
        ],
        pista: 'Tres describen el dato; una busca culpables.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La ___ es un valor crudo; la ___ relaciona dos o más para '
            'producir algo comparable.',
        opciones: ['medida', 'métrica', 'escala', 'muestra'],
        respuestaCorrecta: 'medida métrica',
        explicacion: [
          'Encima de las dos está el indicador, que añade umbral y decisión.',
        ],
        pista: 'De abajo hacia arriba.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Si una métrica nunca ha cambiado una decisión, probablemente se '
            'puede dejar de medir.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Un tablero lleno de gráficos que nadie usa para decidir es '
              'decoración cara.',
        ],
        pista: 'Medir no es mejorar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '«Defectos por cada mil líneas de código». ¿Qué es exactamente?',
        opciones: [
          'Una métrica',
          'Una medida',
          'Un indicador',
          'Una línea base',
        ],
        respuestaCorrecta: 'Una métrica',
        explicacion: [
          'Relaciona dos medidas y ya se puede comparar; sería indicador si '
              'llevara umbral.',
        ],
        pista: 'Son dos medidas puestas en relación, y nada más.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Un ___ es una métrica con un ___ acordado que dispara una '
            'decisión.',
        opciones: ['indicador', 'umbral', 'informe', 'promedio'],
        respuestaCorrecta: 'indicador umbral',
        explicacion: [
          'Sin ese valor de referencia, el número informa pero no obliga a '
              'nada.',
        ],
        pista: 'El tercer escalón y lo que lo distingue.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-1-lec-2': [
      Ejercicio(
        id: 'q412a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuáles son las tres familias de métricas?',
        opciones: [
          'De producto, de proceso y de proyecto',
          'Directas, indirectas y compuestas',
          'De calidad, de coste y de plazo',
          'Internas, externas y en uso',
        ],
        respuestaCorrecta: 'De producto, de proceso y de proyecto',
        explicacion: [
          'Mezclarlas al razonar lleva a conclusiones falsas.',
        ],
        pista: 'Las tres empiezan por la misma sílaba.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Tiempo desde que un cambio se escribe hasta que llega a '
            'producción. ¿Qué tipo de métrica es?',
        opciones: ['De proceso', 'De producto', 'De proyecto', 'Directa'],
        respuestaCorrecta: 'De proceso',
        explicacion: [
          'Las de proceso dicen si la forma de trabajar está mejorando.',
        ],
        pista: 'No mira el software: mira cómo se trabaja.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Las cuatro métricas DORA son todas de proceso.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Por eso sirven para comparar equipos que construyen productos '
              'distintos.',
        ],
        pista: 'Describen cómo se entrega, no qué se entrega.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el orden correcto al elegir una métrica?',
        opciones: [
          'Qué quieres saber, qué métrica lo responde y qué medidas recoger',
          'Qué datos tienes, qué métrica sale y qué pregunta responde',
          'Qué métrica usan otros equipos y adaptarla',
          'Qué herramienta hay instalada y qué puede reportar',
        ],
        respuestaCorrecta:
            'Qué quieres saber, qué métrica lo responde y qué medidas recoger',
        explicacion: [
          'Al revés se acaba midiendo lo que es fácil de medir en vez de lo '
              'que importa.',
        ],
        pista: 'Primero la pregunta.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las métricas ___ se cuentan; las ___ se calculan y siempre llevan '
            'una suposición dentro.',
        opciones: ['directas', 'indirectas', 'internas', 'externas'],
        respuestaCorrecta: 'directas indirectas',
        explicacion: [
          'Líneas, defectos y horas frente a productividad, mantenibilidad y '
              'calidad.',
        ],
        pista: 'Una pareja de opuestos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Cuanto más indirecta es una métrica, más fácil es discutirla.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Conviene saber qué suposición lleva dentro antes de defenderla en '
              'una reunión.',
        ],
        pista: 'Se discute la suposición, no el dato.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Desviación de coste y rotación del equipo. ¿A qué familia '
            'pertenecen?',
        opciones: [
          'De proyecto',
          'De producto',
          'De proceso',
          'A ninguna de las tres',
        ],
        respuestaCorrecta: 'De proyecto',
        explicacion: [
          'Son las que interesan a quien paga y las que se reportan hacia '
              'arriba.',
        ],
        pista: 'Miran el plan, no el software.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Las métricas de ___ son las que mejor se automatizan, porque '
            'salen del ___ y de las pruebas.',
        opciones: ['producto', 'código', 'proyecto', 'cliente'],
        respuestaCorrecta: 'producto código',
        explicacion: [
          'Tamaño, complejidad, acoplamiento, cobertura y densidad de '
              'defectos.',
        ],
        pista: 'La familia que mira al software en sí.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-2-lec-1': [
      Ejercicio(
        id: 'q421a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es una línea base?',
        opciones: [
          'Una versión aprobada que solo cambia mediante control de cambios',
          'La primera versión que se entregó al cliente',
          'El presupuesto inicial del proyecto',
          'La rama principal del repositorio',
        ],
        respuestaCorrecta:
            'Una versión aprobada que solo cambia mediante control de cambios',
        explicacion: [
          'Congelar no significa prohibir cambios: significa que se ven, se '
              'valoran y se aprueban.',
        ],
        pista: 'Lo importante no es que no cambie, sino cómo cambia.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuáles son las tres líneas base clásicas?',
        opciones: [
          'Alcance, cronograma y coste',
          'Requisitos, diseño y código',
          'Calidad, riesgo y comunicación',
          'Análisis, desarrollo y pruebas',
        ],
        respuestaCorrecta: 'Alcance, cronograma y coste',
        explicacion: [
          'Qué se va a construir, en qué fechas y con qué presupuesto.',
        ],
        pista: 'Qué, cuándo y con cuánto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Al aprobar un cambio hay que actualizar las líneas base '
            'afectadas.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es el paso que más se olvida, y así es como un proyecto acaba '
              '«retrasado» cuando en realidad se le añadió trabajo.',
        ],
        pista: 'El cambio aprobado mueve la referencia.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es una línea base de configuración?',
        opciones: [
          'Una versión etiquetada con sus dependencias, reconstruible años '
              'después',
          'La copia de respaldo semanal del servidor',
          'El documento de requisitos firmado',
          'El entorno de pruebas del equipo',
        ],
        respuestaCorrecta:
            'Una versión etiquetada con sus dependencias, reconstruible años '
            'después',
        explicacion: [
          'De eso se ocupa la gestión de la configuración.',
        ],
        pista: 'Es el mismo concepto, pero aplicado al producto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Decir que un proyecto va ___ exige saber respecto a ___, y eso es '
            'la línea base.',
        opciones: ['retrasado', 'qué', 'bien', 'quién'],
        respuestaCorrecta: 'retrasado qué',
        explicacion: [
          'Sin referencia no hay desviación que medir.',
        ],
        pista: 'La queja habitual y lo que le falta.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Congelar una línea base significa que ya no se admiten cambios en '
            'el proyecto.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Significa que los cambios pasan por un procedimiento en lugar de '
              'colarse sin que nadie los vea.',
        ],
        pista: 'Congelar es sobre el cómo, no sobre el si.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'El cliente dice que una función siempre estuvo en el alcance y el '
            'equipo lo niega. ¿Qué habría resuelto la discusión?',
        opciones: [
          'Una línea base de alcance aprobada al inicio',
          'Un contrato con penalizaciones',
          'Más reuniones de seguimiento',
          'Un equipo de pruebas independiente',
        ],
        respuestaCorrecta: 'Una línea base de alcance aprobada al inicio',
        explicacion: [
          'Sin un punto de referencia congelado, esa discusión no tiene forma '
              'de resolverse.',
        ],
        pista: 'Hace falta algo escrito y aprobado antes.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una petición de cambio se registra, se analiza su ___ y, si se '
            'aprueba, se ___ las líneas base.',
        opciones: ['impacto', 'actualizan', 'coste', 'archivan'],
        respuestaCorrecta: 'impacto actualizan',
        explicacion: [
          'Ese último paso es el que más se olvida.',
        ],
        pista: 'Lo que se analiza y lo que casi nadie hace después.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-2-lec-2': [
      Ejercicio(
        id: 'q422a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué «vamos al ochenta por ciento» no informa de nada?',
        opciones: [
          'Porque el avance se estima a ojo en vez de medirse contra algo '
              'terminado',
          'Porque el porcentaje debería darse con decimales',
          'Porque solo vale en proyectos ágiles',
          'Porque el cliente no entiende los porcentajes',
        ],
        respuestaCorrecta:
            'Porque el avance se estima a ojo en vez de medirse contra algo '
            'terminado',
        explicacion: [
          'Es el famoso ochenta por ciento que dura tres meses.',
        ],
        pista: 'El problema está en cómo se calculó ese número.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué tres cantidades compara el valor ganado?',
        opciones: [
          'Lo planificado, lo completado y lo gastado',
          'El alcance, el plazo y el coste',
          'Las horas, los defectos y las líneas',
          'Lo pedido, lo entregado y lo aceptado',
        ],
        respuestaCorrecta: 'Lo planificado, lo completado y lo gastado',
        explicacion: [
          'De ahí salen el índice de cronograma y el de coste.',
        ],
        pista: 'Las tres se miden en el mismo momento del proyecto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En los índices de valor ganado, un valor por debajo de 1 '
            'significa que vas peor de lo planificado.',
        respuestaCorrecta: 'true',
        explicacion: [
          'El 1 es la línea de «según lo previsto», y por encima vas mejor.',
        ],
        pista: 'Uno es la referencia.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué dibuja un gráfico de trabajo pendiente?',
        opciones: [
          'Cuánto trabajo queda frente al tiempo que queda',
          'El porcentaje de avance acumulado',
          'Los defectos abiertos por semana',
          'El coste real frente al presupuestado',
        ],
        respuestaCorrecta: 'Cuánto trabajo queda frente al tiempo que queda',
        explicacion: [
          'Si la línea real va por encima de la ideal, no se va a llegar, y se '
              've sin calcular nada.',
        ],
        pista: 'Lo que baja es lo que falta.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Diez tareas al 50 % no son cinco tareas ___: son cero ___.',
        opciones: ['hechas', 'entregables', 'pendientes', 'defectos'],
        respuestaCorrecta: 'hechas entregables',
        explicacion: [
          'Una tarea cuenta cuando cumple la definición de hecho, y no hay '
              'medio terminado.',
        ],
        pista: 'La aritmética del avance no funciona así.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Si el equipo cuida más que el gráfico se vea bien que terminar '
            'trabajo, el seguimiento sigue cumpliendo su función.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Dejó de medir y empezó a distorsionar. El informe no es el '
              'proyecto.',
        ],
        pista: 'Es la ley de Goodhart otra vez.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué compara el índice de coste?',
        opciones: [
          'El avance real frente al dinero gastado',
          'El avance real frente al avance planificado',
          'El presupuesto inicial frente al final',
          'Las horas estimadas frente a las reales',
        ],
        respuestaCorrecta: 'El avance real frente al dinero gastado',
        explicacion: [
          'El otro índice, el de cronograma, compara el avance real con el '
              'planificado.',
        ],
        pista: 'El nombre dice contra qué se compara.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una tarea cuenta cuando cumple la definición de ___; no existe el '
            'medio ___.',
        opciones: ['hecho', 'terminado', 'listo', 'empezado'],
        respuestaCorrecta: 'hecho terminado',
        explicacion: [
          'Parece duro y es lo único que evita que el avance reportado se '
              'despegue de la realidad.',
        ],
        pista: 'La regla binaria del seguimiento.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-3-lec-1': [
      Ejercicio(
        id: 'q431a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cómo se calcula la densidad de defectos?',
        opciones: [
          'Defectos divididos por el tamaño del software',
          'Defectos divididos por el número de pruebas',
          'Defectos encontrados en producción entre el total',
          'Defectos divididos por las horas de prueba',
        ],
        respuestaCorrecta: 'Defectos divididos por el tamaño del software',
        explicacion: [
          'Normalmente por cada mil líneas de código o por punto función.',
        ],
        pista: 'Convierte un número suelto en algo comparable.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué mide la fuga de defectos?',
        opciones: [
          'Qué proporción de los defectos llegó hasta el usuario',
          'Cuántos defectos hay por cada mil líneas',
          'Cuánto tarda el equipo en corregir un defecto',
          'Cuántos defectos se reabren tras corregirlos',
        ],
        respuestaCorrecta: 'Qué proporción de los defectos llegó hasta el usuario',
        explicacion: [
          'No mide cuántos defectos hay, sino quién los encuentra primero.',
        ],
        pista: 'El nombre sugiere algo que se escapó.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Una densidad de defectos muy baja siempre es buena noticia.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Puede significar un código excelente, o que casi no se ha probado.',
          'Sin saber la cobertura, el número no se puede leer.',
        ],
        pista: 'Falta un dato para poder interpretarlo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Un equipo tiene buena densidad y mala fuga. ¿Qué le pasa?',
        opciones: [
          'Encuentra los defectos, pero demasiado tarde',
          'No encuentra casi ningún defecto',
          'Escribe demasiado código por función',
          'Corrige los defectos sin registrarlos',
        ],
        respuestaCorrecta: 'Encuentra los defectos, pero demasiado tarde',
        explicacion: [
          'La solución no es probar más: es probar antes.',
        ],
        pista: 'El problema es el momento, no la cantidad.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Calcular la densidad por ___ en lugar de para todo el sistema '
            'señala dónde reforzar las ___.',
        opciones: ['módulo', 'pruebas', 'semana', 'métricas'],
        respuestaCorrecta: 'módulo pruebas',
        explicacion: [
          'Los defectos casi nunca se reparten de forma pareja.',
        ],
        pista: 'Hay que bajar de nivel para ver dónde se concentran.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El coste de un defecto crece cuanto más tarde se detecta.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Detectado al revisar requisitos cuesta una conversación; detectado '
              'por un usuario cuesta soporte, parche, despliegue de urgencia y '
              'confianza.',
        ],
        pista: 'Por eso la fuga importa tanto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Cuarenta defectos en diez mil líneas y cuarenta en cien mil. '
            '¿Qué métrica las distingue?',
        opciones: [
          'La densidad de defectos',
          'La fuga de defectos',
          'La cobertura de requisitos',
          'El tiempo medio de reparación',
        ],
        respuestaCorrecta: 'La densidad de defectos',
        explicacion: [
          'El número suelto es el mismo; relacionado con el tamaño, describe '
              'dos situaciones completamente distintas.',
        ],
        pista: 'Hay que dividir por el tamaño.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'La fuga se calcula dividiendo los defectos encontrados en ___ '
            'entre el ___ de encontrados.',
        opciones: ['producción', 'total', 'pruebas', 'promedio'],
        respuestaCorrecta: 'producción total',
        explicacion: [
          'Es la métrica que mejor resume si el proceso de pruebas está '
              'funcionando.',
        ],
        pista: 'Dónde aparecieron, sobre cuántos hubo.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-3-lec-2': [
      Ejercicio(
        id: 'q432a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué mide el MTBF?',
        opciones: [
          'Cuánto aguanta el sistema entre un fallo y el siguiente',
          'Cuánto se tarda en restablecer el servicio',
          'Cuántos fallos hay por cada mil líneas',
          'Qué porcentaje del tiempo está operativo el sistema',
        ],
        respuestaCorrecta: 'Cuánto aguanta el sistema entre un fallo y el siguiente',
        explicacion: [
          'Cuanto más alto, más fiable. Es una métrica de fiabilidad, una de '
              'las ocho características de la ISO/IEC 25010.',
        ],
        pista: 'Mide el tiempo que pasa entre dos caídas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Un sistema falla poco pero tarda ocho horas en volver. ¿Qué '
            'métrica tiene mal?',
        opciones: [
          'El MTTR',
          'El MTBF',
          'La densidad de defectos',
          'La cobertura de ramas',
        ],
        respuestaCorrecta: 'El MTTR',
        explicacion: [
          'Puede ser peor que uno que falla más y se recupera en dos minutos.',
        ],
        pista: 'El problema es la recuperación.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'La cobertura mide ejecución, no verificación.',
        respuestaCorrecta: 'true',
        explicacion: [
          'El 100 % de cobertura con afirmaciones vacías no prueba nada.',
          'Es un indicador de lo que no se ha probado, no una garantía sobre '
              'lo que sí.',
        ],
        pista: 'Dice qué se recorrió, no qué se comprobó.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿De dónde sale la cobertura de requisitos?',
        opciones: [
          'De la matriz de trazabilidad',
          'De la herramienta de cobertura de código',
          'Del registro de defectos',
          'Del gráfico de trabajo pendiente',
        ],
        respuestaCorrecta: 'De la matriz de trazabilidad',
        explicacion: [
          'Cuenta qué proporción de los requisitos tiene al menos un caso de '
              'prueba asociado, y es la que un auditor pide.',
        ],
        pista: 'Es la que enlaza requisitos con pruebas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'El MTBF dice cada cuánto te ___ y el MTTR cuánto tardas en ___.',
        opciones: ['rompes', 'levantarte', 'caes', 'repararlo'],
        respuestaCorrecta: 'rompes levantarte',
        explicacion: [
          'De la relación entre los dos sale la disponibilidad.',
        ],
        pista: 'Dos cosas distintas, en ese orden.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La disponibilidad prometida en un acuerdo de nivel de servicio '
            'sale de combinar MTBF y MTTR.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es el porcentaje de tiempo que el sistema está operativo.',
        ],
        pista: 'Las dos juntas dan el porcentaje.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Hacia dónde mira cada una de estas métricas?',
        opciones: [
          'La cobertura, al trabajo de pruebas; MTBF y MTTR, a producción',
          'Las tres miran el comportamiento en producción',
          'Las tres miran el trabajo de pruebas',
          'La cobertura mira a producción y las otras dos al código',
        ],
        respuestaCorrecta:
            'La cobertura, al trabajo de pruebas; MTBF y MTTR, a producción',
        explicacion: [
          'Una mira hacia atrás y las otras dos hacia adelante. Un equipo '
              'maduro vigila las tres.',
        ],
        pista: 'Una se calcula antes de publicar y dos después.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'En el MTBF, cuanto más ___ mejor; en el MTTR, cuanto más ___ '
            'mejor.',
        opciones: ['alto', 'bajo', 'estable', 'frecuente'],
        respuestaCorrecta: 'alto bajo',
        explicacion: [
          'Uno cuenta tiempo de buen funcionamiento y el otro tiempo de '
              'avería.',
        ],
        pista: 'Van en direcciones opuestas.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-4-lec-1': [
      Ejercicio(
        id: 'q441a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué diferencia la velocidad de la capacidad?',
        opciones: [
          'La velocidad es historia y la capacidad es pronóstico',
          'La velocidad se mide en horas y la capacidad en puntos',
          'La velocidad la fija el cliente y la capacidad el equipo',
          'La velocidad es de proceso y la capacidad de producto',
        ],
        respuestaCorrecta: 'La velocidad es historia y la capacidad es pronóstico',
        explicacion: [
          'Una mira los sprints anteriores; la otra, quién estará disponible '
              'en el siguiente.',
        ],
        pista: 'Una mira atrás y la otra adelante.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo empieza a ser fiable la velocidad de un equipo?',
        opciones: [
          'Tras tres o cuatro sprints',
          'Desde el primer sprint',
          'Al terminar el proyecto',
          'Cuando la aprueba el cliente',
        ],
        respuestaCorrecta: 'Tras tres o cuatro sprints',
        explicacion: [
          'Antes de eso, el número no significa nada.',
        ],
        pista: 'Necesita estabilizarse.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Un equipo con velocidad 40 produce el doble que uno con velocidad '
            '20.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Cada equipo estima con su propia escala: dice que miden con reglas '
              'distintas, no que uno produzca más.',
          'Comparar velocidades entre equipos es la forma más rápida de que '
              'ambos empiecen a inflar sus estimaciones.',
        ],
        pista: 'Las escalas no son la misma.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué hay que descontar al calcular la capacidad de un sprint?',
        opciones: [
          'Vacaciones, formación, soporte a producción y las reuniones de Scrum',
          'Solo las vacaciones del equipo',
          'El tiempo dedicado a pruebas',
          'Nada: es el equipo completo por los días del sprint',
        ],
        respuestaCorrecta:
            'Vacaciones, formación, soporte a producción y las reuniones de '
            'Scrum',
        explicacion: [
          'La capacidad no es el equipo completo por los días del sprint.',
        ],
        pista: 'Todo lo que ocupa tiempo y no es trabajo del sprint.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Si alguien usa la velocidad como ___, subirá sin que se entregue '
            'más ___.',
        opciones: ['objetivo', 'valor', 'referencia', 'trabajo'],
        respuestaCorrecta: 'objetivo valor',
        explicacion: [
          'Basta con estimar más alto lo mismo: el número mejora y el producto '
              'no.',
        ],
        pista: 'Es la ley de Goodhart aplicada a Scrum.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Un equipo nuevo planifica sus primeros sprints con capacidad, no '
            'con velocidad.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Todavía no tiene velocidad histórica, así que se ajusta sobre la '
              'marcha.',
        ],
        pista: 'Falta el histórico.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Para qué sirve la velocidad?',
        opciones: [
          'Para que el equipo decida cuánto cabe en el próximo sprint',
          'Para evaluar el rendimiento de cada persona',
          'Para comparar el equipo con los demás de la empresa',
          'Para fijar el presupuesto del proyecto',
        ],
        respuestaCorrecta:
            'Para que el equipo decida cuánto cabe en el próximo sprint',
        explicacion: [
          'Para planificar, no para premiar.',
        ],
        pista: 'Es una herramienta del propio equipo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Prometer una fecha de entrega el primer día, sin velocidad ___, '
            'es ___.',
        opciones: ['histórica', 'inventar', 'estimada', 'planificar'],
        respuestaCorrecta: 'histórica inventar',
        explicacion: [
          'Sin sprints anteriores no hay base sobre la que pronosticar nada.',
        ],
        pista: 'Lo que falta y lo que se acaba haciendo.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-4-lec-2': [
      Ejercicio(
        id: 'q442a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué dice la ley de Goodhart?',
        opciones: [
          'Cuando una medida se convierte en objetivo, deja de ser una buena '
              'medida',
          'Todo lo que se puede medir se debe medir',
          'Las métricas indirectas siempre son discutibles',
          'Un equipo rinde según cómo se le evalúe',
        ],
        respuestaCorrecta:
            'Cuando una medida se convierte en objetivo, deja de ser una buena '
            'medida',
        explicacion: [
          'En cuanto un número se usa para evaluar a alguien, esa persona '
              'empieza a trabajar para el número. No por mala fe: porque es lo '
              'que se le está pidiendo.',
        ],
        pista: 'Habla de lo que pasa al convertir una medida en meta.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Si se premia el número de defectos corregidos, ¿qué suele pasar?',
        opciones: [
          'Se reportan defectos triviales para subir la cuenta',
          'Bajan los defectos en producción',
          'Mejora la cobertura de pruebas',
          'Se reduce el tiempo de despliegue',
        ],
        respuestaCorrecta: 'Se reportan defectos triviales para subir la cuenta',
        explicacion: [
          'Cada métrica usada como objetivo individual tiene su forma de '
              'romperse, y no hace falta mala intención para encontrarla.',
        ],
        pista: 'La forma más barata de subir una cuenta es bajar el listón.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Las métricas de software son útiles para comparar el rendimiento '
            'de personas concretas.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Son útiles para que un equipo observe su propio trabajo y decida '
              'qué cambiar. Dejan de serlo en cuanto se usan para comparar '
              'personas.',
        ],
        pista: 'Del equipo, no de la persona.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué las cuatro métricas DORA van siempre juntas?',
        opciones: [
          'Porque dos son de velocidad y dos de estabilidad, y tiran en '
              'direcciones opuestas',
          'Porque las publica la misma organización',
          'Porque se calculan con los mismos datos',
          'Porque las exige la ISO/IEC 25010',
        ],
        respuestaCorrecta:
            'Porque dos son de velocidad y dos de estabilidad, y tiran en '
            'direcciones opuestas',
        explicacion: [
          'Toda métrica de velocidad necesita al lado una de calidad, o se '
              'despliega rápido y mal.',
        ],
        pista: 'Se hacen de contrapeso entre ellas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Si una métrica es fácil de hacer subir haciendo ___, no sirve '
            'como ___.',
        opciones: ['trampa', 'objetivo', 'pruebas', 'informe'],
        respuestaCorrecta: 'trampa objetivo',
        explicacion: [
          'Es la pregunta de control ante cualquier métrica nueva.',
        ],
        pista: 'Pregúntate cómo la subirías sin trabajar más.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La claridad de los requisitos o la confianza del equipo son menos '
            'reales por no tener número.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Que no se puedan medir no las hace menos reales, y olvidarlo es el '
              'error clásico de quien gestiona solo con tableros.',
        ],
        pista: 'No todo lo importante sale en el gráfico.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Si solo se mide la cobertura, ¿cómo se rompe la métrica?',
        opciones: [
          'Se añaden pruebas sin afirmaciones',
          'Se escriben funciones más cortas',
          'Se reportan menos defectos',
          'Se despliega con menos frecuencia',
        ],
        respuestaCorrecta: 'Se añaden pruebas sin afirmaciones',
        explicacion: [
          'El porcentaje sube y no se verifica nada nuevo.',
        ],
        pista: 'La cobertura mide ejecución, no verificación.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Toda métrica de ___ necesita al lado una de ___, o el equipo se '
            'desequilibra.',
        opciones: ['velocidad', 'calidad', 'coste', 'alcance'],
        respuestaCorrecta: 'velocidad calidad',
        explicacion: [
          'Si solo miras frecuencia de despliegue, se despliega rápido y mal; '
              'si solo miras defectos, nadie se atreve a entregar.',
        ],
        pista: 'Nunca una sola.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-5-lec-1': [
      Ejercicio(
        id: 'q451a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué tres partes tiene una lección aprendida?',
        opciones: [
          'Qué ocurrió, por qué ocurrió y qué recomendamos la próxima vez',
          'Problema, responsable y sanción',
          'Fecha, proyecto y persona que la registró',
          'Riesgo, impacto y probabilidad',
        ],
        respuestaCorrecta:
            'Qué ocurrió, por qué ocurrió y qué recomendamos la próxima vez',
        explicacion: [
          'Las tres son necesarias: sin la tercera es una anécdota.',
        ],
        pista: 'La última parte es la que la hace útil.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo se recogen las lecciones aprendidas?',
        opciones: [
          'Al terminar cada fase o iteración, en caliente',
          'Solo al cerrar el proyecto',
          'Cuando el cliente lo solicita',
          'En la auditoría anual de calidad',
        ],
        respuestaCorrecta: 'Al terminar cada fase o iteración, en caliente',
        explicacion: [
          'Esperar al cierre garantiza que se olviden los detalles y que la '
              'lección llegue tarde para el propio proyecto.',
        ],
        pista: 'Cuanto antes, más causa se conserva.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: '«Hay que comunicar mejor» es una lección aprendida válida.',
        respuestaCorrecta: 'false',
        explicacion: [
          'No se puede hacer nada con eso. «Acordar por escrito el formato del '
              'intercambio antes de programar la integración» sí lo es.',
        ],
        pista: 'Falta que sea accionable.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué hace falta para que un repositorio de lecciones sirva de '
            'algo?',
        opciones: [
          'Que revisarlo sea un paso obligatorio al planificar el próximo '
              'proyecto',
          'Que esté en una herramienta con buscador',
          'Que lo mantenga una persona dedicada',
          'Que se exporte a PDF cada trimestre',
        ],
        respuestaCorrecta:
            'Que revisarlo sea un paso obligatorio al planificar el próximo '
            'proyecto',
        explicacion: [
          'Es famoso por llenarse y no consultarse nunca.',
        ],
        pista: 'El problema no es escribirlas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una lección recogida a los seis meses conserva el ___ y pierde la '
            '___.',
        opciones: ['titular', 'causa', 'fecha', 'solución'],
        respuestaCorrecta: 'titular causa',
        explicacion: [
          'Y la causa es justo la parte útil.',
        ],
        pista: 'Lo que se recuerda y lo que se olvida.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Lo que salió bien también se registra como lección.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es la que menos se registra. Si una práctica ahorró dos semanas, '
              'conviene que el siguiente equipo la conozca y no la reinvente.',
        ],
        pista: 'No solo de errores.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Dos años después, otro equipo tropieza con el mismo proveedor que '
            'ya falló. ¿Qué falló aquí?',
        opciones: [
          'No había dónde enterarse de lo ocurrido',
          'El proveedor incumplió el contrato',
          'El equipo no hizo análisis de riesgos',
          'La línea base de coste estaba mal fijada',
        ],
        respuestaCorrecta: 'No había dónde enterarse de lo ocurrido',
        explicacion: [
          'Nadie actuó de mala fe: la organización no conservó la lección ni '
              'la puso al alcance.',
        ],
        pista: 'El fallo es de memoria organizativa.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una lección que no se ___ cuesta lo mismo que no haberla ___, '
            'más el tiempo invertido.',
        opciones: ['consulta', 'escrito', 'aprueba', 'medido'],
        respuestaCorrecta: 'consulta escrito',
        explicacion: [
          'Por eso la consulta tiene que estar dentro del proceso, no al buen '
              'criterio de cada quien.',
        ],
        pista: 'El problema está en el uso, no en la redacción.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-5-lec-2': [
      Ejercicio(
        id: 'q452a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué diferencia la retrospectiva de la revisión del sprint?',
        opciones: [
          'La revisión mira el producto con el cliente; la retrospectiva, cómo '
              'trabajó el equipo',
          'La revisión es semanal y la retrospectiva mensual',
          'La revisión la dirige el Scrum Master y la retrospectiva el Product '
              'Owner',
          'La revisión es obligatoria y la retrospectiva opcional',
        ],
        respuestaCorrecta:
            'La revisión mira el producto con el cliente; la retrospectiva, '
            'cómo trabajó el equipo',
        explicacion: [
          'Confundirlas hace que la retrospectiva se convierta en un informe '
              'de estado.',
        ],
        pista: 'Una mira qué se hizo y la otra cómo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuáles son los cuatro pasos de una buena retrospectiva?',
        opciones: [
          'Recoger datos, buscar qué los explica, elegir una mejora y asignar '
              'dueño y fecha',
          'Revisar el producto, aprobar entregables, firmar y cerrar',
          'Medir, comparar, reportar y archivar',
          'Identificar culpables, corregir, documentar y comunicar',
        ],
        respuestaCorrecta:
            'Recoger datos, buscar qué los explica, elegir una mejora y '
            'asignar dueño y fecha',
        explicacion: [
          'Hay muchos formatos, y casi todos los buenos siguen ese esqueleto.',
        ],
        pista: 'Empieza por los datos y termina por un responsable.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Conviene elegir una sola mejora por retrospectiva, no diez.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Es mejor un acuerdo cumplido que diez apuntados.',
        ],
        pista: 'La que tenga mayor impacto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué el jefe directo rara vez debería estar en la '
            'retrospectiva?',
        opciones: [
          'Porque si decir «esto no funciona» tiene coste, se vuelve un trámite '
              'cortés',
          'Porque no conoce los detalles técnicos',
          'Porque la reunión es responsabilidad del Product Owner',
          'Porque lo prohíbe la guía de Scrum',
        ],
        respuestaCorrecta:
            'Porque si decir «esto no funciona» tiene coste, se vuelve un '
            'trámite cortés',
        explicacion: [
          'Por lo mismo se habla de procesos y no de personas.',
        ],
        pista: 'La condición de partida es la seguridad para hablar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452e',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'Una retrospectiva que produce acuerdos sin ___ ni ___ no cambia '
            'nada.',
        opciones: ['responsable', 'fecha', 'datos', 'cliente'],
        respuestaCorrecta: 'responsable fecha',
        explicacion: [
          'A la tercera, el equipo deja de tomársela en serio.',
        ],
        pista: 'Quién y cuándo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452f',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La retrospectiva es el mecanismo con el que un equipo cierra el '
            'ciclo PHVA.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Mira los datos, decide un cambio y lo aplica. Todo lo medido acaba '
              'ahí o no sirve de nada.',
        ],
        pista: 'Planificar, hacer, verificar y actuar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452g',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cómo se sabe si las retrospectivas de un equipo sirven?',
        opciones: [
          'Mirando si el acuerdo de la anterior se cumplió y se nota',
          'Contando cuántas ideas se propusieron',
          'Preguntando al cliente si está satisfecho',
          'Revisando que se hagan todas las semanas',
        ],
        respuestaCorrecta: 'Mirando si el acuerdo de la anterior se cumplió y se nota',
        explicacion: [
          'Si nadie lo recuerda, lo que hay es una reunión periódica, no '
              'mejora continua.',
        ],
        pista: 'La prueba está en la retrospectiva anterior.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452h',
        tipo: TipoEjercicio.completarTexto,
        pregunta:
            'En la retrospectiva se habla de ___ y no de ___, para que sea '
            'seguro decir lo que no funciona.',
        opciones: ['procesos', 'personas', 'métricas', 'costes'],
        respuestaCorrecta: 'procesos personas',
        explicacion: [
          'Es la misma regla que gobierna el uso de las métricas: del equipo, '
              'no del individuo.',
        ],
        pista: 'Lo que se revisa y lo que no se juzga.',
        xpPorRespuesta: 10,
      ),
    ],
  };

  /// Preguntas de respaldo cuando una lección no tiene banco propio.
  static final List<Ejercicio> _porDefecto = [
    Ejercicio(
      id: 'qdef1',
      tipo: TipoEjercicio.verdaderoFalso,
      pregunta:
          'Las normas ISO son voluntarias, pero los contratos suelen exigirlas.',
      respuestaCorrecta: 'true',
      explicacion: [
        'Nadie te multa por no cumplirlas, pero sin ellas quedas fuera de muchas licitaciones.',
      ],
      pista: 'Voluntarias en el papel, necesarias en la práctica.',
      xpPorRespuesta: 5,
    ),
    Ejercicio(
      id: 'qdef2',
      tipo: TipoEjercicio.multipleChoice,
      pregunta: '¿Qué norma define los procesos del ciclo de vida del software?',
      opciones: [
        'ISO/IEC/IEEE 12207',
        'ISO/IEC 27001',
        'ISO/IEC 25010',
        'ISO 14001',
      ],
      respuestaCorrecta: 'ISO/IEC/IEEE 12207',
      explicacion: ['Agrupa los procesos en técnicos, de gestión y organizacionales.'],
      pista: 'Lleva los tres prefijos.',
      xpPorRespuesta: 5,
    ),
    Ejercicio(
      id: 'qdef3',
      tipo: TipoEjercicio.multipleChoice,
      pregunta: '¿Qué significa el ciclo PHVA?',
      opciones: [
        'Planificar, Hacer, Verificar y Actuar',
        'Producir, Hacer, Validar y Auditar',
        'Prever, Habilitar, Verificar y Aprobar',
        'Planear, Habilitar, Validar y Ajustar',
      ],
      respuestaCorrecta: 'Planificar, Hacer, Verificar y Actuar',
      explicacion: ['Es la herramienta central de ISO 9001 para la mejora continua.'],
      pista: 'También se conoce como ciclo de Deming.',
      xpPorRespuesta: 5,
    ),
  ];

  /// Devuelve las preguntas de una lección. Si no existen, entrega el
  /// banco por defecto.
  static List<Ejercicio> obtenerPreguntasLeccion(String leccionId) {
    return _preguntas[leccionId] ?? _porDefecto;
  }

  /// Lecciones que tienen banco propio de preguntas.
  static List<String> obtenerLeccionesConPreguntas() =>
      _preguntas.keys.toList();

  /// Total de preguntas cargadas.
  static int get totalPreguntas =>
      _preguntas.values.fold(0, (suma, lista) => suma + lista.length);
}