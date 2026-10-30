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
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Empecemos por el principio',
          titulo: 'Todo proyecto tiene un orden',
          texto:
              'Un equipo recibe el encargo de un sistema de matrícula. Hay '
              'prisa, así que abren el editor y empiezan a programar pantallas. '
              'A las tres semanas aparece la pregunta: ¿qué pasa con un '
              'estudiante que debe dinero del semestre anterior? Nadie lo '
              'definió. Hay que rehacer media aplicación.',
          destacado:
              'No fue un fallo de programación. Fue que nadie puso en orden el '
              'trabajo antes de empezar.',
        ),
        TarjetaTeoria(
          mensaje: 'Esto es lo que vamos a ver',
          titulo: 'El ciclo de vida del software',
          texto:
              'Es el orden en que ocurren las cosas, desde que alguien necesita '
              'algo hasta que el sistema se apaga para siempre. En inglés se '
              'abrevia SDLC, por Software Development Life Cycle.',
          vinetas: [
            'Empieza antes de escribir código',
            'Termina mucho después de la entrega',
            'Vale igual para un sistema enorme que para una app pequeña',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Ojo con esto',
          titulo: 'No es una herramienta',
          texto:
              'El SDLC no se instala, no se descarga y no se programa. Es la '
              'estructura que evita que el equipo improvise. Confundirlo con un '
              'programa es el malentendido más frecuente al estudiar el tema.',
          destacado:
              'Jira, Git o Trello son herramientas que te ayudan a recorrer el '
              'ciclo. No son el ciclo.',
        ),
        TarjetaTeoria(
          mensaje: 'Las cuatro preguntas',
          titulo: 'Para qué sirve, en concreto',
          texto:
              'Tener un ciclo definido te obliga a responder cuatro cosas antes '
              'de que te exploten en la cara.',
          vinetas: [
            'Qué hay que construir, y quién lo decidió',
            'En qué orden, y qué depende de qué',
            'Cómo se comprueba que está bien hecho',
            'Qué pasa con el sistema cuando ya está en uso',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Aquí entra la norma',
          titulo: 'ISO/IEC/IEEE 12207',
          texto:
              'Es el estándar internacional que define los procesos del ciclo '
              'de vida del software. No te obliga a usar un modelo concreto: '
              'sirve igual para cascada que para ágil. Lo que hace es decir qué '
              'procesos deben existir y qué resultados tiene que producir cada '
              'uno.',
          vinetas: [
            'Procesos técnicos: construir el producto',
            'Procesos de gestión técnica: planificar y controlar',
            'Procesos organizacionales: sostener el proyecto desde la empresa',
            'Procesos de acuerdo: la relación entre cliente y proveedor',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Volvamos a la matrícula',
          titulo: 'Qué habría cambiado',
          texto:
              'Con un ciclo definido, la pregunta sobre el estudiante deudor '
              'aparece en el proceso de requisitos, que va antes del de '
              'construcción. Se resuelve en una reunión de media hora en lugar '
              'de en tres semanas de reprogramar.',
        ),
        TarjetaTeoria(
          mensaje: 'Para cerrar',
          titulo: 'El error que la norma intenta impedir',
          texto:
              'Un profesional del sector, entrevistado para este proyecto, lo '
              'resumió así: lo primero que nota en quien recién empieza es que '
              'se pasa directo a programar en vez de hacer un análisis primero.',
          destacado:
              'Programar antes de analizar no es ir más rápido. Es pagar el '
              'análisis más tarde y con intereses.',
        ),
      ],
    ),
 
    'cap-1-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-1-lec-2',
      titulo: 'Fases del SDLC',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Vamos por partes',
          titulo: 'Las fases no son papeleo',
          texto:
              'Cada fase del ciclo existe porque alguien, alguna vez, se la '
              'saltó y le salió caro. Verlas como trámite es lo que lleva a '
              'tratarlas como un formulario que hay que rellenar al final.',
        ),
        TarjetaTeoria(
          mensaje: 'Fase uno',
          titulo: 'Requisitos',
          texto:
              'Se averigua qué necesita de verdad el usuario, que casi nunca es '
              'lo mismo que lo que pide. Aquí se separan los requisitos '
              'funcionales, lo que el sistema debe hacer, de los no '
              'funcionales, cómo debe comportarse.',
          destacado:
              'Un requisito sirve si existe una prueba capaz de decir si se '
              'cumple. «El sistema debe ser rápido» no sirve; «el 95 % de las '
              'consultas responde en menos de 500 ms» sí.',
        ),
        TarjetaTeoria(
          mensaje: 'Fase dos',
          titulo: 'Diseño',
          texto:
              'Se decide cómo va a estar construido el sistema antes de '
              'construirlo: qué piezas lo componen, cómo se comunican y qué '
              'datos guarda cada una. Es la fase donde las decisiones son '
              'baratas de cambiar.',
          vinetas: [
            'Arquitectura: las piezas grandes y sus relaciones',
            'Detalle: cómo funciona cada pieza por dentro',
            'Datos: qué se guarda, dónde y con qué forma',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Fase tres',
          titulo: 'Construcción',
          texto:
              'Es la única fase donde se escribe código, y suele ser bastante '
              'más corta de lo que la gente imagina. Cuando las dos anteriores '
              'se hicieron bien, programar es casi transcribir decisiones ya '
              'tomadas.',
        ),
        TarjetaTeoria(
          mensaje: 'Fase cuatro',
          titulo: 'Pruebas',
          texto:
              'No es «probar a ver si funciona». Es comprobar, nivel por nivel, '
              'que el sistema hace lo que los requisitos dijeron que haría.',
          vinetas: [
            'Unitarias: cada pieza por separado',
            'Integración: las piezas hablando entre sí',
            'Sistema: el conjunto completo',
            'Aceptación: frente a lo que el usuario pidió',
          ],
          destacado:
              'Cada nivel se deriva de un documento distinto. Las de aceptación '
              'salen de los requisitos de usuario, no del código.',
        ),
        TarjetaTeoria(
          mensaje: 'Y la que todos olvidan',
          titulo: 'Operación y mantenimiento',
          texto:
              'El sistema entra en uso y empieza la fase más larga de todas. Se '
              'corrigen defectos, se adapta a cambios del entorno y se mejora. '
              'En la mayoría de los sistemas, la fase de mantenimiento consume '
              'más esfuerzo que todas las anteriores juntas.',
          destacado:
              'Por eso la mantenibilidad es una de las ocho características de '
              'calidad de la ISO/IEC 25010, y no una virtud opcional.',
        ),
        TarjetaTeoria(
          mensaje: 'Antes de pasar',
          titulo: 'El orden no siempre es en línea recta',
          texto:
              'Estas fases existen en todos los modelos, pero no todos las '
              'recorren igual. En cascada van una detrás de otra; en ágil se '
              'repiten enteras cada pocas semanas. Lo que no cambia es que '
              'ninguna desaparece.',
        ),
      ],
    ),
 
    'cap-1-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-2-lec-1',
      titulo: 'Modelo Waterfall paso a paso',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Un poco de historia',
          titulo: 'De dónde salió la cascada',
          texto:
              'El modelo se asocia a un artículo de Winston Royce de 1970. '
              'Tiene gracia: Royce dibujó el esquema secuencial para explicar '
              'por qué, tal cual, era arriesgado, y proponía iterar. La '
              'industria se quedó con el dibujo y olvidó la advertencia.',
        ),
        TarjetaTeoria(
          mensaje: 'Cómo funciona',
          titulo: 'Una fase detrás de otra',
          texto:
              'Cada fase termina por completo antes de que empiece la '
              'siguiente, y termina produciendo un documento aprobado. Ese '
              'documento es la entrada de la fase que viene.',
          vinetas: [
            'Requisitos, hasta tener la especificación aprobada',
            'Diseño, hasta tener la arquitectura aprobada',
            'Construcción, hasta tener el código completo',
            'Pruebas, hasta tener el acta de aceptación',
            'Operación y mantenimiento',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Las puertas',
          titulo: 'Nadie pasa sin firma',
          texto:
              'Entre fase y fase hay una revisión formal. Si el entregable no '
              'está aprobado, el proyecto no avanza. Suena rígido, y lo es: esa '
              'rigidez es justamente lo que se compra al elegir cascada.',
        ),
        TarjetaTeoria(
          mensaje: 'Esto es lo importante',
          titulo: 'El coste de cambiar sube con el tiempo',
          texto:
              'Cambiar un requisito mientras se está escribiendo la '
              'especificación cuesta una conversación. Cambiarlo cuando ya hay '
              'código, pruebas y documentación cuesta rehacer todo lo que '
              'dependía de él. En cascada esa curva es especialmente empinada, '
              'porque no hay ninguna entrega intermedia donde detectar el error '
              'antes.',
          destacado:
              'Toda la lógica de la cascada se entiende con esta idea: si '
              'cambiar al final es carísimo, más vale no equivocarse al '
              'principio.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso donde sí encaja',
          titulo: 'El control de un ascensor',
          texto:
              'Un sistema que gobierna un ascensor tiene que certificarse antes '
              'de ponerse en servicio, y la certificación exige documentación '
              'completa y trazabilidad desde cada requisito hasta la prueba que '
              'lo valida. Aquí los requisitos no cambian cada semana: cambian '
              'cuando cambia la normativa de seguridad.',
          destacado:
              'Entregar «la versión mínima viable» de un freno de emergencia no '
              'es una opción.',
        ),
        TarjetaTeoria(
          mensaje: 'Resumiendo',
          titulo: 'Qué exige y qué garantiza',
          texto:
              'La cascada exige saber desde el principio lo que se quiere, y a '
              'cambio da previsibilidad: plazos, costes y documentación '
              'completa. El problema aparece cuando se usa en proyectos donde '
              'ese requisito de partida no se cumple.',
        ),
      ],
    ),
 
    'cap-1-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-2-lec-2',
      titulo: 'Cuándo usar Waterfall',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Pregunta incómoda',
          titulo: 'La cascada no está muerta',
          texto:
              'En clase suele contarse como el modelo antiguo que vino a '
              'sustituir lo ágil. En la práctica sigue usándose, y en algunos '
              'sectores es obligatoria. Descartarla por moda es tan mal '
              'criterio como aplicarla a todo.',
        ),
        TarjetaTeoria(
          mensaje: 'Cuándo sí',
          titulo: 'Las tres señales',
          texto:
              'Hay tres situaciones donde la cascada es la elección correcta, y '
              'suelen aparecer juntas.',
          vinetas: [
            'Los requisitos son estables y se conocen desde el inicio',
            'Hay una certificación o auditoría que exige documentación formal',
            'El contrato fija alcance, plazo y precio cerrados de antemano',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Cuándo no',
          titulo: 'Las señales contrarias',
          texto:
              'Si el cliente no sabe todavía qué quiere, si el producto depende '
              'de cómo reaccione el mercado, o si se espera descubrir cosas '
              'sobre la marcha, la cascada juega en contra. Vas a llegar al '
              'final con un sistema que cumple la especificación y no sirve.',
          destacado:
              'Ese es el caso clásico de un producto verificado con éxito y no '
              'validado: se construyó bien lo que no había que construir.',
        ),
        TarjetaTeoria(
          mensaje: 'El criterio de verdad',
          titulo: 'Qué cuesta más, ¿equivocarse o tardar?',
          texto:
              'Todas las señales anteriores se reducen a una sola pregunta. Si '
              'lo caro es descubrir un error tarde, hay que invertir por '
              'delante y la cascada ayuda. Si lo caro es tardar en salir, hay '
              'que entregar pronto y aprender, y entonces estorba.',
        ),
        TarjetaTeoria(
          mensaje: 'Dos proyectos, dos respuestas',
          titulo: 'El ascensor y la app de reparto',
          texto:
              'En el control del ascensor, un fallo descubierto tarde puede '
              'herir a alguien y la normativa no se negocia: cascada. En una '
              'app de reparto, nadie sabe si los usuarios van a querer propinas '
              'o programar pedidos hasta que lo prueben: iteraciones cortas.',
          destacado:
              'No es que un modelo sea mejor. Es que responden a riesgos '
              'distintos.',
        ),
        TarjetaTeoria(
          mensaje: 'Un matiz del sector',
          titulo: 'En la práctica se mezclan',
          texto:
              'El profesional entrevistado para este proyecto señaló que las '
              'metodologías rara vez se aplican puras: lo habitual es combinar. '
              'Un proyecto puede llevar los requisitos regulatorios en cascada '
              'y la interfaz en iteraciones. Saber por qué eliges cada cosa '
              'vale más que recitar el modelo completo.',
        ),
      ],
    ),
 
    'cap-1-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-3-lec-1',
      titulo: 'Principios Ágiles',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Dónde empezó esto',
          titulo: 'Febrero de 2001',
          texto:
              'Diecisiete personas que venían de formas de trabajar distintas '
              'se reunieron en una estación de esquí en Utah. No querían '
              'inventar un método: querían escribir en qué estaban de acuerdo. '
              'De ahí salió el Manifiesto Ágil, que son cuatro valores y doce '
              'principios en una sola página.',
        ),
        TarjetaTeoria(
          mensaje: 'Los cuatro valores',
          titulo: 'Qué se valora más',
          texto:
              'Cada valor enfrenta dos cosas buenas y dice cuál pesa más cuando '
              'hay que elegir.',
          vinetas: [
            'Individuos e interacciones, sobre procesos y herramientas',
            'Software funcionando, sobre documentación extensiva',
            'Colaboración con el cliente, sobre negociación contractual',
            'Respuesta ante el cambio, sobre seguir un plan',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Aquí se equivoca casi todo el mundo',
          titulo: 'La palabra «sobre»',
          texto:
              'El manifiesto termina con una frase que casi nadie cita: «aunque '
              'valoramos los elementos de la derecha, valoramos más los de la '
              'izquierda». Los de la derecha no se eliminan.',
          destacado:
              '«Ágil» no significa que no haya documentación, ni plan, ni '
              'contrato. Significa que ninguna de esas tres cosas manda sobre '
              'entregar software que funcione.',
        ),
        TarjetaTeoria(
          mensaje: 'De los doce principios',
          titulo: 'Los cuatro con más consecuencias',
          texto:
              'Los doce principios desarrollan los valores. Estos son los que '
              'más cambian el día a día de un equipo.',
          vinetas: [
            'Entregar software funcionando con frecuencia, de semanas a meses',
            'Aceptar cambios de requisitos incluso al final del desarrollo',
            'Medir el avance por software funcionando, no por tareas cerradas',
            'A intervalos regulares, el equipo revisa cómo trabaja y se ajusta',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Un malentendido caro',
          titulo: 'Ágil no es improvisar',
          texto:
              'Trabajar sin requisitos escritos, sin criterios de aceptación y '
              'sin pruebas no es agilidad: es desorden con nombre bonito. Los '
              'equipos ágiles que funcionan documentan menos, pero documentan '
              'lo que importa y lo mantienen al día.',
        ),
        TarjetaTeoria(
          mensaje: 'Y conecta con la norma',
          titulo: 'Ágil y la ISO conviven',
          texto:
              'La ISO/IEC/IEEE 12207 no impone un modelo de ciclo de vida: dice '
              'qué procesos deben existir. Un equipo ágil los cumple igual, solo '
              'que los recorre cada dos semanas en lugar de una vez por '
              'proyecto.',
          destacado:
              'Decir «somos ágiles, no aplicamos normas» es confundir el modelo '
              'con el proceso. Son capas distintas.',
        ),
        TarjetaTeoria(
          mensaje: 'Último apunte',
          titulo: 'Qué está cambiando ahora',
          texto:
              'Las herramientas de inteligencia artificial están acortando el '
              'ciclo: lo que antes ocupaba un sprint de dos semanas hoy puede '
              'caber en días. El principio de entregar con frecuencia no cambia; '
              'lo que cambia es cuánto significa «con frecuencia».',
        ),
      ],
    ),
 
    'cap-1-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-3-lec-2',
      titulo: 'Scrum en detalle',
      tiempoLectura: 5,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Vamos al más usado',
          titulo: 'Scrum es un marco, no un método',
          texto:
              'Scrum define muy pocas cosas y deja fuera casi todo a propósito. '
              'No te dice cómo programar, ni cómo estimar, ni qué herramientas '
              'usar. Solo monta la estructura dentro de la cual el equipo '
              'decide.',
          destacado:
              'Por eso Scrum no se «implanta» con una herramienta. Sin los '
              'eventos y sin las responsabilidades, un tablero en Jira no es '
              'Scrum.',
        ),
        TarjetaTeoria(
          mensaje: 'Quién hace qué',
          titulo: 'Tres responsabilidades',
          texto:
              'No son cargos de la empresa: son responsabilidades dentro del '
              'equipo Scrum.',
          vinetas: [
            'Product Owner: decide qué se construye y en qué orden',
            'Scrum Master: hace que el marco funcione y quita obstáculos',
            'Desarrolladores: deciden cómo se construye y lo construyen',
          ],
          destacado:
              'El Product Owner es una sola persona, no un comité. Si la '
              'prioridad la deciden cinco, nadie la decide.',
        ),
        TarjetaTeoria(
          mensaje: 'El corazón',
          titulo: 'El Sprint',
          texto:
              'Un periodo de duración fija, normalmente de una a cuatro '
              'semanas, al final del cual hay algo utilizable. Su duración no '
              'se alarga porque el trabajo no quepa: se recorta el trabajo.',
        ),
        TarjetaTeoria(
          mensaje: 'Los eventos',
          titulo: 'Cuatro reuniones dentro del Sprint',
          texto:
              'Cada una tiene un propósito distinto y confundirlas es el error '
              'más común al empezar.',
          vinetas: [
            'Planificación: qué entra en este Sprint y para qué',
            'Diaria: quince minutos para coordinar el día, no para reportar',
            'Revisión: se enseña el incremento y se recoge retroalimentación',
            'Retrospectiva: cómo trabajamos y qué cambiamos',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Los artefactos',
          titulo: 'Tres cosas y su compromiso',
          texto:
              'Cada artefacto lleva asociado un compromiso que lo hace '
              'medible.',
          vinetas: [
            'Backlog del producto, con su objetivo de producto',
            'Backlog del Sprint, con su objetivo de Sprint',
            'Incremento, con su definición de hecho',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Esto te va a servir',
          titulo: 'La definición de hecho',
          texto:
              'Es el acuerdo del equipo sobre qué condiciones debe cumplir algo '
              'para considerarse terminado: probado, revisado, documentado, '
              'desplegable. Y es el mejor sitio para meter las exigencias de la '
              'norma.',
          destacado:
              'Si la definición de hecho exige trazabilidad, deja de depender '
              'de que alguien se acuerde y pasa a ser condición para cerrar una '
              'tarea.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso concreto',
          titulo: 'El equipo que no llega nunca',
          texto:
              'Un equipo nuevo monta una app de reparto. Nadie sabe qué va a '
              'estar listo el viernes, las tareas se acumulan y cada semana se '
              'promete lo mismo. No les falta talento: les falta un backlog '
              'priorizado, un objetivo de Sprint y una definición de hecho.',
        ),
      ],
    ),
 
    'cap-1-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-1-4-lec-1',
      titulo: 'CI/CD Pipelines',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Seguro te ha pasado',
          titulo: '«En mi máquina funciona»',
          texto:
              'Cuatro personas trabajan dos semanas cada una por su lado. '
              'Llega el día de juntar el código y aparecen conflictos, '
              'funciones duplicadas y dependencias que no coinciden. Integrar '
              'cuesta más que haber programado.',
          destacado:
              'Cuanto más tiempo pasa entre integraciones, más caro sale '
              'integrar. Esa es toda la idea.',
        ),
        TarjetaTeoria(
          mensaje: 'La primera mitad',
          titulo: 'Integración continua',
          texto:
              'Cada persona lleva sus cambios a la rama principal varias veces '
              'al día, y en cada envío una tubería automática compila el '
              'proyecto y ejecuta las pruebas. Si algo se rompe, se sabe en '
              'minutos y se sabe por culpa de qué cambio.',
        ),
        TarjetaTeoria(
          mensaje: 'Aquí hay una trampa de examen',
          titulo: 'Entrega y despliegue no son lo mismo',
          texto:
              'Las dos se abrevian CD y significan cosas distintas.',
          vinetas: [
            'Entrega continua: cada versión queda lista para desplegarse, pero '
                'alguien aprieta el botón',
            'Despliegue continuo: si pasa todas las pruebas, sale a producción '
                'sin intervención humana',
          ],
          destacado:
              'La diferencia es quién decide publicar. En sistemas regulados, '
              'esa decisión casi nunca se automatiza.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué hay dentro',
          titulo: 'Las etapas de la tubería',
          texto:
              'Una tubería típica encadena estas etapas, y se detiene en cuanto '
              'una falla.',
          vinetas: [
            'Compilar el proyecto',
            'Ejecutar las pruebas automáticas',
            'Analizar la calidad del código y las dependencias',
            'Empaquetar la versión',
            'Desplegar en un entorno de prueba',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Esto no te lo esperabas',
          titulo: 'La tubería es evidencia',
          texto:
              'Cada ejecución deja registrado qué se compiló, qué pruebas '
              'pasaron, cuándo y a partir de qué versión del código. Eso es '
              'exactamente lo que pide un auditor cuando pregunta cómo sabes '
              'que la versión en producción fue probada.',
          destacado:
              'Automatizar no solo ahorra trabajo: produce los registros que la '
              'ISO 9001 exige y que a mano nadie mantiene al día.',
        ),
        TarjetaTeoria(
          mensaje: 'Antes de los ejercicios',
          titulo: 'Lo que hace falta antes',
          texto:
              'Una tubería sin pruebas automáticas solo automatiza la '
              'compilación, y da una falsa sensación de seguridad: todo sale '
              'verde porque no se está comprobando nada.',
        ),
      ],
    ),
 
    'cap-1-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-1-4-lec-2',
      titulo: 'Automatización y Monitoreo',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Una advertencia primero',
          titulo: 'Automatizar no es el objetivo',
          texto:
              'Automatizar un proceso malo lo único que consigue es repetir el '
              'error más rápido y más veces. Primero se arregla el proceso, '
              'después se automatiza.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué conviene automatizar',
          titulo: 'Lo repetitivo y lo que se olvida',
          texto:
              'La regla es sencilla: si se hace en cada entrega y siempre igual, '
              'es candidato. Si además es de los pasos que la gente se salta con '
              'prisa, es prioritario.',
          vinetas: [
            'Pruebas de regresión, que se repiten en cada versión',
            'Revisión de estilo y de dependencias con vulnerabilidades',
            'Generación de la versión y del registro de cambios',
            'Despliegue al entorno de prueba',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Ya en producción',
          titulo: 'Monitorear es mirar lo que importa',
          texto:
              'Una vez el sistema está en uso, hace falta saber si está sano sin '
              'esperar a que un usuario se queje. Registrar todo y no mirar nada '
              'es tan inútil como no registrar.',
          vinetas: [
            'Disponibilidad: ¿responde?',
            'Latencia: ¿cuánto tarda en responder?',
            'Errores: ¿cuántas peticiones fallan y cuáles?',
            'Saturación: ¿cuánto margen queda antes de caerse?',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Cuatro números',
          titulo: 'Cómo se mide un equipo',
          texto:
              'Las métricas DORA son las más usadas para medir el rendimiento '
              'de la entrega de software. Lo interesante es que son cuatro y se '
              'equilibran entre sí.',
          vinetas: [
            'Frecuencia de despliegue',
            'Tiempo desde que se escribe un cambio hasta que está en producción',
            'Porcentaje de despliegues que provocan un fallo',
            'Tiempo que se tarda en restablecer el servicio tras un fallo',
          ],
          destacado:
              'Las dos primeras miden velocidad y las dos últimas estabilidad. '
              'Mirar solo una mitad es cómo se acaba desplegando rápido y mal.',
        ),
        TarjetaTeoria(
          mensaje: 'Un matiz útil',
          titulo: 'Monitoreo y observabilidad',
          texto:
              'El monitoreo responde preguntas que ya sabías que ibas a hacer. '
              'La observabilidad busca poder responder las que no habías '
              'previsto, a partir de los registros, las métricas y las trazas '
              'que el sistema emite.',
        ),
        TarjetaTeoria(
          mensaje: 'Y ya está',
          titulo: 'Cuando los defectos llegan al usuario',
          texto:
              'Un equipo descubre que varios errores aparecen en producción '
              'después de cada entrega. Casi siempre falta lo mismo: pruebas de '
              'regresión automatizadas en la tubería y monitoreo que avise antes '
              'de que llame el cliente.',
          destacado:
              'Que el usuario sea quien detecta los fallos no es mala suerte: '
              'es una decisión de no haber automatizado la detección.',
        ),
      ],
    ),

    // =================================================================
    // MUNDO 2 — NORMATIVAS Y CALIDAD
    // =================================================================

    'cap-2-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-1-lec-1',
      titulo: 'Definición de Norma ISO',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Un problema viejo',
          titulo: 'Dos equipos, dos respuestas',
          texto:
              'Dos empresas construyen el mismo tipo de sistema. Una llama '
              '«prueba de aceptación» a lo que la otra llama «prueba final de '
              'usuario». Cuando tienen que trabajar juntas, pasan dos semanas '
              'discutiendo qué significa cada palabra antes de poder empezar.',
          destacado:
              'Las normas existen para que esa conversación no haya que '
              'tenerla cada vez.',
        ),
        TarjetaTeoria(
          mensaje: 'Entonces, qué es',
          titulo: 'Un acuerdo documentado',
          texto:
              'Una norma es un acuerdo escrito sobre cómo hacer algo, al que '
              'llegan expertos de muchos países tras años de discusión. No es '
              'la opinión de una empresa ni la moda de un año.',
          vinetas: [
            'Define términos, para que todos signifiquen lo mismo',
            'Describe procesos, con sus entradas y sus resultados',
            'Fija requisitos comprobables, no recomendaciones vagas',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Quién las escribe',
          titulo: 'ISO, IEC e IEEE',
          texto:
              'Cuando ves tres siglas en el nombre de una norma, es porque tres '
              'organismos la publicaron juntos.',
          vinetas: [
            'ISO: organización internacional de normalización, de todo tipo',
            'IEC: la parte electrotécnica y electrónica',
            'IEEE: la asociación de ingenieros eléctricos y electrónicos',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Leer el código',
          titulo: 'ISO/IEC/IEEE 12207:2017',
          texto:
              'Ese nombre no es un número al azar. Las siglas dicen quién la '
              'publicó, el número identifica la norma dentro del catálogo, y '
              'el año es la edición.',
          destacado:
              'El año importa. Citar «ISO/IEC 12207» sin edición es como citar '
              'un libro sin decir cuál, porque entre una edición y otra pueden '
              'cambiar los nombres de los grupos de procesos.',
        ),
        TarjetaTeoria(
          mensaje: 'Aquí hay una confusión muy común',
          titulo: 'Una norma no es una ley',
          texto:
              'Cumplir una norma es voluntario. Deja de serlo cuando un '
              'contrato la exige, cuando un regulador la impone para un sector '
              'o cuando una certificación la pide. Entonces la obligación no '
              'viene de la norma: viene del contrato o del regulador.',
        ),
        TarjetaTeoria(
          mensaje: 'Y otra todavía peor',
          titulo: 'No todas se certifican',
          texto:
              'Solo se certifican las normas que definen un sistema de '
              'gestión, porque hay algo que auditar: una organización y sus '
              'procesos. Las que son modelos de referencia no se certifican.',
          vinetas: [
            'ISO 9001 y ISO/IEC 27001: certifican a la organización',
            'ISO/IEC 25010 e ISO/IEC/IEEE 12207: son marcos de referencia',
          ],
          destacado:
              'Decir «estamos certificados en ISO 25010» es un error que se '
              'oye a menudo. Esa norma no tiene certificación posible: es un '
              'modelo de calidad, no un sistema de gestión.',
        ),
        TarjetaTeoria(
          mensaje: 'Para quedarnos con esto',
          titulo: 'Qué llevarte',
          texto:
              'Una norma es vocabulario compartido y procesos acordados. Lo '
              'que la hace obligatoria siempre está fuera de ella, y solo '
              'algunas pueden certificarse.',
        ),
      ],
    ),
 
    'cap-2-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-1-lec-2',
      titulo: 'Beneficios de las Normas',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La pregunta honesta',
          titulo: 'Si dan trabajo, ¿para qué?',
          texto:
              'Aplicar una norma cuesta tiempo: hay que documentar, registrar y '
              'revisar. Si nadie te obliga, la pregunta es legítima. La '
              'respuesta es que ese trabajo se paga en cuatro sitios distintos.',
        ),
        TarjetaTeoria(
          mensaje: 'El primero',
          titulo: 'Un idioma común',
          texto:
              'Cuando todos entienden lo mismo por «requisito», «defecto» o '
              '«línea base», las reuniones duran la mitad. Y cuando entra '
              'alguien nuevo al equipo, no hay que explicarle un vocabulario '
              'inventado en casa.',
        ),
        TarjetaTeoria(
          mensaje: 'El segundo',
          titulo: 'No reinventar lo ya resuelto',
          texto:
              'Detrás de cada requisito de una norma hay un proyecto que falló '
              'por no tenerlo. Es conocimiento acumulado de muchas '
              'organizaciones durante décadas, y sale más barato leerlo que '
              'repetir el error.',
          destacado:
              'Casi ninguna exigencia de una norma es caprichosa. Si parece '
              'absurda, normalmente es que todavía no viste el caso que la '
              'originó.',
        ),
        TarjetaTeoria(
          mensaje: 'El tercero',
          titulo: 'Abre puertas',
          texto:
              'Muchos contratos públicos y muchos clientes grandes exigen '
              'certificación como condición para licitar. Sin ella no es que '
              'compitas en desventaja: es que no puedes presentarte.',
        ),
        TarjetaTeoria(
          mensaje: 'El cuarto',
          titulo: 'Sirve como prueba',
          texto:
              'Si un cliente reclama, los registros que la norma obliga a '
              'mantener son lo que demuestra qué se acordó, qué se probó y '
              'cuándo. Sin ellos, la discusión es palabra contra palabra.',
        ),
        TarjetaTeoria(
          mensaje: 'Y ahora el otro lado',
          titulo: 'Cuándo se vuelven en contra',
          texto:
              'Aplicadas sin criterio, las normas producen carpetas que nadie '
              'lee y reuniones que no deciden nada. El síntoma es claro: '
              'cuando el equipo documenta para pasar la auditoría y no para '
              'trabajar mejor, la norma dejó de servir.',
          destacado:
              'La norma dice qué hay que conseguir, no cuánto papel hay que '
              'generar. Ese exceso casi siempre lo añade la organización, no '
              'el estándar.',
        ),
      ],
    ),
 
    'cap-2-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-2-lec-1',
      titulo: 'ISO 9001: Sistema de Gestión de Calidad',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Empecemos por ubicarla',
          titulo: 'No es una norma de software',
          texto:
              'La ISO 9001 vale para una panadería, un hospital o una empresa '
              'de software. No habla de código: habla de cómo una organización '
              'gestiona la calidad de lo que sea que produzca.',
        ),
        TarjetaTeoria(
          mensaje: 'La idea central',
          titulo: 'Enfoque a procesos',
          texto:
              'En lugar de controlar el producto al final, la norma pide '
              'controlar el proceso que lo produce. Si el proceso está '
              'definido y se sigue, el resultado es repetible; si depende de '
              'quién esté ese día, no lo es.',
        ),
        TarjetaTeoria(
          mensaje: 'El motor',
          titulo: 'El ciclo PHVA',
          texto:
              'Todo sistema de gestión de la calidad gira alrededor de cuatro '
              'pasos que se repiten sin parar.',
          vinetas: [
            'Planificar: definir qué se va a hacer y cómo se medirá',
            'Hacer: ejecutarlo tal como se planificó',
            'Verificar: comparar el resultado con lo esperado',
            'Actuar: corregir el proceso a partir de lo medido',
          ],
          destacado:
              'Una retrospectiva de Scrum que no cambia nada en el siguiente '
              'sprint se queda en «verificar» y nunca llega a «actuar».',
        ),
        TarjetaTeoria(
          mensaje: 'Qué te va a pedir',
          titulo: 'Las cuatro exigencias',
          texto:
              'Resumidas, y sin el lenguaje de la norma.',
          vinetas: [
            'Que los procesos estén definidos por escrito',
            'Que queden registros de haberlos seguido',
            'Que alguien independiente lo audite periódicamente',
            'Que lo que se detecte alimente una mejora',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Dos palabras que se confunden',
          titulo: 'Corrección y acción correctiva',
          texto:
              'La corrección repara el efecto. La acción correctiva ataca la '
              'causa para que no vuelva a pasar. Un auditor pregunta siempre '
              'por la segunda.',
          destacado:
              'Arreglar el error es corrección. Añadir la prueba automática '
              'que lo habría detectado es acción correctiva.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso de los marcadores',
          titulo: 'La tienda de la PYME',
          texto:
              'Antes de automatizar el proceso de pedidos de una pequeña '
              'empresa, lo primero es documentar cómo ocurre hoy de verdad, '
              'con sus excepciones y sus apaños. Programar sobre el proceso '
              'que uno imagina, y no sobre el que existe, es la forma más '
              'rápida de entregar algo que nadie puede usar.',
        ),
        TarjetaTeoria(
          mensaje: 'Un apunte mas',
          titulo: 'Lo que la 9001 no hace',
          texto:
              'No te dice cómo escribir requisitos, ni qué pruebas ejecutar, '
              'ni cómo estructurar el código. Para eso están la 12207, la '
              '29119 y la 25010. La 9001 se ocupa del marco; las otras, del '
              'contenido.',
        ),
      ],
    ),
 
    'cap-2-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-2-lec-2',
      titulo: 'ISO 25010: Calidad del Producto',
      tiempoLectura: 5,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El problema de siempre',
          titulo: '«Que sea de calidad»',
          texto:
              'Un cliente pide un sistema «de calidad». Dos personas del '
              'equipo entienden cosas distintas: una piensa en que no se '
              'caiga, la otra en que sea fácil de usar. Sin un modelo, la '
              'palabra no significa nada operativo.',
        ),
        TarjetaTeoria(
          mensaje: 'Para eso está',
          titulo: 'Ocho características',
          texto:
              'La ISO/IEC 25010 parte la calidad del producto en ocho '
              'dimensiones. Nombrarlas ya resuelve la mitad del problema, '
              'porque obliga a decir de cuál se está hablando.',
          vinetas: [
            'Adecuación funcional, eficiencia de desempeño y compatibilidad',
            'Usabilidad, fiabilidad y seguridad',
            'Mantenibilidad y portabilidad',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y se bajan a tierra',
          titulo: 'De la característica a la métrica',
          texto:
              'Cada característica se divide en subcaracterísticas, y esas sí '
              'se miden. La mantenibilidad, por ejemplo, se descompone en '
              'modularidad, reusabilidad, analizabilidad, modificabilidad y '
              'capacidad de ser probado.',
          destacado:
              'Ese es el camino completo: de «que sea bueno» a «el 95 % de las '
              'consultas responde en menos de 500 ms». Lo primero no se '
              'verifica; lo segundo sí.',
        ),
        TarjetaTeoria(
          mensaje: 'Un matiz importante',
          titulo: 'Calidad del producto y calidad en uso',
          texto:
              'El modelo del producto mira el software en sí. La calidad en '
              'uso mira qué le pasa a una persona real usándolo: si logra su '
              'objetivo, en cuánto tiempo y con qué nivel de frustración. Un '
              'producto puede puntuar bien y fracasar en uso.',
        ),
        TarjetaTeoria(
          mensaje: 'Esto te lo van a preguntar',
          titulo: 'Las características compiten',
          texto:
              'Subir una suele bajar otra, y por eso hay que priorizarlas en '
              'lugar de pedirlas todas al máximo.',
          vinetas: [
            'Más seguridad suele costar usabilidad',
            'Más portabilidad suele costar eficiencia',
            'Más funcionalidad suele costar mantenibilidad',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'En un caso real',
          titulo: 'La app de banca móvil',
          texto:
              'Pedir doble factor en cada operación sube la seguridad y hunde '
              'la usabilidad. Pedirlo solo al transferir equilibra las dos. Esa '
              'decisión no la toma la norma: la norma solo obliga a tomarla a '
              'conciencia y dejarla escrita.',
        ),
        TarjetaTeoria(
          mensaje: 'Nos quedamos con esto',
          titulo: 'No se certifica',
          texto:
              'La 25010 es un modelo de referencia, no un sistema de gestión. '
              'Sirve para escribir requisitos y para evaluar productos, pero '
              'no existe un certificado de cumplirla.',
        ),
      ],
    ),
 
    'cap-2-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-3-lec-1',
      titulo: 'Confidencialidad, Integridad, Disponibilidad',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Las tres de siempre',
          titulo: 'Sobre qué se construye la seguridad',
          texto:
              'Toda la seguridad de la información se apoya en tres '
              'propiedades. Cuando algo se considera un incidente de '
              'seguridad, es porque al menos una de las tres se rompió.',
        ),
        TarjetaTeoria(
          mensaje: 'La primera',
          titulo: 'Confidencialidad',
          texto:
              'Solo accede a la información quien debe. Se protege con control '
              'de acceso, cifrado y el principio de dar a cada persona el '
              'mínimo permiso que necesita para su trabajo.',
          destacado:
              'El fallo típico no es que alguien entre por la fuerza: es que '
              'un usuario tenía más permisos de los que su puesto requería.',
        ),
        TarjetaTeoria(
          mensaje: 'La segunda',
          titulo: 'Integridad',
          texto:
              'El dato no se altera sin autorización, ni por un ataque ni por '
              'un error del propio sistema. Se protege con validaciones, '
              'registros de auditoría y firmas o sumas de verificación.',
          destacado:
              'Una base de datos que se corrompe sola por un fallo de '
              'programación es un problema de integridad, aunque no haya '
              'ningún atacante.',
        ),
        TarjetaTeoria(
          mensaje: 'La tercera',
          titulo: 'Disponibilidad',
          texto:
              'La información está accesible cuando hace falta. Se protege con '
              'copias de respaldo, redundancia y planes de recuperación. Es la '
              'que más se olvida al hablar de seguridad.',
        ),
        TarjetaTeoria(
          mensaje: 'Y aquí está lo interesante',
          titulo: 'Las tres se estorban',
          texto:
              'En el sistema de historia clínica de un hospital, cifrar todo y '
              'exigir doble factor sube la confidencialidad. Pero si un médico '
              'en urgencias tarda noventa segundos en abrir un historial, la '
              'disponibilidad cayó, y en urgencias eso se mide en consecuencias '
              'reales.',
          destacado:
              'Seguridad no es poner el máximo en las tres: es decidir el '
              'equilibrio a conciencia, y poder explicar por qué.',
        ),
        TarjetaTeoria(
          mensaje: 'Un apunte final',
          titulo: 'Dónde aparecen',
          texto:
              'Estas tres propiedades son el punto de partida de la ISO/IEC '
              '27001: cuando esa norma habla de proteger un activo de '
              'información, se refiere a proteger su confidencialidad, su '
              'integridad y su disponibilidad.',
        ),
      ],
    ),
 
    'cap-2-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-3-lec-2',
      titulo: 'ISO 27001: Sistema de Gestión de Seguridad',
      tiempoLectura: 5,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Vamos con la grande',
          titulo: 'Qué es un SGSI',
          texto:
              'Un sistema de gestión de seguridad de la información es el '
              'conjunto de políticas, procedimientos y controles con los que '
              'una organización protege su información. La ISO/IEC 27001 dice '
              'cómo montarlo y cómo demostrar que funciona.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo primero de todo',
          titulo: 'Definir el alcance',
          texto:
              'Antes que nada hay que decir qué cubre el sistema: qué '
              'procesos, qué datos, qué sedes. Suena burocrático y es la '
              'decisión más importante de todas.',
          destacado:
              'Si el SGSI del hospital no incluye al laboratorio externo que '
              'recibe las muestras, ahí queda el agujero, por muy bien '
              'protegido que esté el resto.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué se protege',
          titulo: 'Activos de información',
          texto:
              'Un activo es cualquier cosa con valor que haya que proteger, y '
              'la lista es más larga de lo que parece.',
          vinetas: [
            'Bases de datos y copias de respaldo',
            'Código fuente y credenciales de acceso',
            'Documentación y contratos',
            'El conocimiento que solo tiene una persona del equipo',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Tres palabras que no son sinónimas',
          titulo: 'Amenaza, vulnerabilidad y riesgo',
          texto:
              'La amenaza es el suceso que puede causar daño. La '
              'vulnerabilidad es la debilidad que lo permitiría. El riesgo '
              'combina lo probable que es con el daño que haría.',
          destacado:
              'Amenaza: que roben credenciales. Vulnerabilidad: que estén sin '
              'cifrar. Riesgo: alto, porque son datos de salud.',
        ),
        TarjetaTeoria(
          mensaje: 'Y qué se hace con el riesgo',
          titulo: 'Cuatro salidas, no una',
          texto:
              'Identificado un riesgo, hay que decidir qué hacer con él. '
              'Mitigarlo no es la única opción válida.',
          vinetas: [
            'Mitigar: aplicar controles que lo reduzcan',
            'Transferir: contratar un seguro o externalizar',
            'Aceptar: asumirlo por escrito, con firma de quien puede hacerlo',
            'Evitar: no hacer la actividad que lo genera',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'El documento que lo resume',
          titulo: 'Declaración de aplicabilidad',
          texto:
              'Lista todos los controles de referencia e indica, uno por uno, '
              'si se aplica y por qué. Justificar por qué dejas uno fuera es '
              'tan obligatorio como justificar los que pones.',
        ),
        TarjetaTeoria(
          mensaje: 'El caso del hospital',
          titulo: 'Por dónde se empieza',
          texto:
              'Ante el encargo de una historia clínica electrónica, el primer '
              'paso no es escribir código ni elegir el framework: es definir '
              'el alcance del SGSI y hacer el análisis de riesgos. Todo lo '
              'técnico viene después y depende de eso.',
          destacado:
              'Omitir la matriz de riesgos es uno de los cinco errores que '
              'señaló el profesional entrevistado para este proyecto.',
        ),
      ],
    ),
 
    'cap-2-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-2-4-lec-1',
      titulo: 'Procesos Primarios de Desarrollo',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Aclaremos algo primero',
          titulo: 'Por qué verás dos nombres distintos',
          texto:
              'La edición de 2008 de la ISO/IEC 12207 agrupaba los procesos en '
              'primarios, de soporte y organizacionales. La edición de 2017 los '
              'reorganizó en cuatro grupos. Vas a encontrarte las dos '
              'clasificaciones según la antigüedad del material que leas.',
          destacado:
              'Si en un examen te preguntan por «procesos primarios», se '
              'refieren a la clasificación de 2008. Decirlo al responder suma '
              'en lugar de restar.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué es un proceso aquí',
          titulo: 'Entradas, actividades, resultados',
          texto:
              'En la norma, un proceso no es un diagrama bonito: es un '
              'conjunto de actividades con entradas definidas y resultados '
              'exigibles. Si no produce un resultado comprobable, no está '
              'completo.',
        ),
        TarjetaTeoria(
          mensaje: 'Los del desarrollo',
          titulo: 'Qué cubren los procesos técnicos',
          texto:
              'Son los que llevan el sistema desde la necesidad hasta el '
              'retiro, y son los que un estudiante reconoce enseguida porque '
              'coinciden con las fases del ciclo.',
          vinetas: [
            'Análisis de requisitos de negocio y de sistema',
            'Diseño de la arquitectura y diseño detallado',
            'Implementación',
            'Integración, verificación, transición y validación',
            'Operación, mantenimiento y retiro',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y los que suelen ignorarse',
          titulo: 'Adquisición y suministro',
          texto:
              'La relación entre quien encarga el sistema y quien lo construye '
              'también es un proceso normalizado: cómo se define lo que se '
              'pide, cómo se acuerda y cómo se acepta la entrega.',
          destacado:
              'Buena parte de los conflictos de un proyecto no son técnicos: '
              'nacen de un acuerdo mal definido al principio.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso para verlo',
          titulo: 'Migrar un sistema heredado',
          texto:
              'Al reemplazar un sistema que lleva doce años funcionando, los '
              'procesos de transición y de retiro dejan de ser teoría: hay que '
              'decidir cómo convive lo viejo con lo nuevo, cómo se migran los '
              'datos y cuándo se apaga lo anterior. Nada de eso es '
              'programación, y todo puede hundir el proyecto.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo que hay que recordar',
          titulo: 'La norma no impone el orden',
          texto:
              'Dice qué procesos deben existir y qué debe producir cada uno, '
              'no en qué secuencia recorrerlos. Por eso sirve igual para '
              'cascada que para un equipo que itera cada dos semanas.',
        ),
      ],
    ),
 
    'cap-2-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-2-4-lec-2',
      titulo: 'Procesos de Soporte',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Cuidado con el nombre',
          titulo: '«Soporte» no quiere decir secundario',
          texto:
              'Se llaman así porque atraviesan a los demás, no porque importen '
              'menos. De hecho son los primeros que se saltan cuando hay prisa, '
              'y los que más caro se pagan después.',
        ),
        TarjetaTeoria(
          mensaje: 'Empecemos por este',
          titulo: 'Gestión de la configuración',
          texto:
              'Controla qué versiones de qué elementos componen el sistema en '
              'cada momento, quién las cambió y por qué. Incluye control de '
              'versiones, gestión de cambios y liberaciones.',
          destacado:
              'Es lo que permite responder a «qué exactamente había desplegado '
              'el martes a las tres». Sin eso, un fallo en producción se '
              'investiga a ciegas.',
        ),
        TarjetaTeoria(
          mensaje: 'Y el siguiente',
          titulo: 'Aseguramiento de la calidad',
          texto:
              'Comprueba que los procesos se están siguiendo de verdad y que '
              'los productos cumplen lo acordado. Es distinto de probar el '
              'software: aquí se audita el proceso, no solo el resultado.',
        ),
        TarjetaTeoria(
          mensaje: 'El tercero y el cuarto',
          titulo: 'Verificación y validación',
          texto:
              'Verificar es comprobar que el producto se construyó conforme a '
              'su especificación. Validar es comprobar que esa especificación '
              'resolvía el problema real.',
          destacado:
              'Se puede verificar con éxito un sistema que no le sirve a '
              'nadie. Por eso son dos procesos y no uno.',
        ),
        TarjetaTeoria(
          mensaje: 'Y los que nadie nombra',
          titulo: 'Documentación y resolución de problemas',
          texto:
              'El proceso de documentación define qué se escribe, quién lo '
              'mantiene y dónde vive. El de resolución de problemas define qué '
              'pasa desde que alguien reporta un fallo hasta que se cierra, con '
              'registro de por medio.',
          vinetas: [
            'Sin el primero, la documentación envejece y deja de consultarse',
            'Sin el segundo, los fallos se arreglan por mensaje privado y '
                'nadie sabe cuántos hubo',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y con esto cerramos',
          titulo: 'Son los que duelen al faltar',
          texto:
              'Un equipo puede entregar sin gestión de la configuración ni '
              'registro de problemas. Lo nota seis meses después, cuando hay '
              'que corregir algo y nadie sabe qué versión está corriendo ni '
              'qué se cambió.',
          destacado:
              'Los procesos de soporte no se notan cuando están. Se notan '
              'cuando faltan.',
        ),
      ],
    ),

    // =================================================================
    // MUNDO 3 — PRUEBAS, IMPLEMENTACIÓN Y MANTENIMIENTO
    // =================================================================

    'cap-3-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-1-lec-1',
      titulo: 'Pruebas Unitarias',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Arrancamos con las pruebas',
          titulo: 'La pieza más pequeña',
          texto:
              'Una prueba unitaria comprueba una sola pieza de código aislada '
              'del resto: una función, un método, una clase. Si falla, sabes '
              'exactamente dónde mirar, porque no hay nada más involucrado.',
        ),
        TarjetaTeoria(
          mensaje: 'La estructura siempre es la misma',
          titulo: 'Preparar, actuar, comprobar',
          texto:
              'Toda prueba unitaria tiene tres partes, aunque el lenguaje '
              'cambie.',
          vinetas: [
            'Preparar: dejar el escenario listo y los datos de entrada',
            'Actuar: llamar a lo que se quiere probar, una sola vez',
            'Comprobar: afirmar que el resultado es el esperado',
          ],
          destacado:
              'Si una prueba comprueba cinco cosas distintas y falla, vuelves a '
              'no saber cuál se rompió. Una afirmación por prueba.',
        ),
        TarjetaTeoria(
          mensaje: 'Aquí está la clave',
          titulo: 'Aislar significa aislar',
          texto:
              'Una prueba unitaria no habla con la base de datos, ni con la '
              'red, ni con el reloj del sistema. Esas dependencias se '
              'sustituyen por dobles de prueba que devuelven lo que el caso '
              'necesita.',
          destacado:
              'Una prueba que falla porque se cayó internet no te está '
              'diciendo nada sobre tu código.',
        ),
        TarjetaTeoria(
          mensaje: 'Para que sirvan',
          titulo: 'Rápidas y repetibles',
          texto:
              'Una buena prueba unitaria tarda milisegundos y da el mismo '
              'resultado siempre. Si tarda segundos, el equipo deja de '
              'ejecutarlas; si a veces pasa y a veces no, el equipo deja de '
              'creerlas, que es peor.',
        ),
        TarjetaTeoria(
          mensaje: 'El reparto habitual',
          titulo: 'La base de la pirámide',
          texto:
              'En una estrategia sana hay muchas pruebas unitarias, bastantes '
              'menos de integración y muy pocas de interfaz. Es cuestión de '
              'coste: las de abajo son baratas y rápidas, las de arriba lentas '
              'y frágiles.',
        ),
        TarjetaTeoria(
          mensaje: 'Bajemos a un caso',
          titulo: 'El cálculo del ascensor',
          texto:
              'La función que decide a qué piso va la cabina cuando hay tres '
              'llamadas simultáneas es el ejemplo perfecto de prueba unitaria: '
              'entra un estado, sale una decisión, y se puede comprobar sin '
              'mover un solo motor.',
          destacado:
              'Probar eso con el ascensor real sería caro, lento y peligroso. '
              'Esa es toda la justificación de las pruebas unitarias.',
        ),
      ],
    ),
 
    'cap-3-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-1-lec-2',
      titulo: 'Pruebas de Integración',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Subimos un escalón',
          titulo: 'Cuando las piezas se juntan',
          texto:
              'Todas las piezas pasan sus pruebas unitarias y, al unirlas, el '
              'sistema falla. No es raro: las unitarias comprueban cada pieza '
              'contra lo que el programador creía que hacía la de al lado.',
          destacado:
              'Las pruebas de integración comprueban las conversaciones entre '
              'piezas, no las piezas.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué se rompe aquí',
          titulo: 'Los fallos típicos de integración',
          texto:
              'Casi siempre son malentendidos en los bordes.',
          vinetas: [
            'Una parte envía una fecha y la otra espera un texto',
            'Una devuelve una lista vacía donde la otra espera un nulo',
            'Dos módulos asumen distinto quién valida los datos',
            'El orden de las llamadas importa y nadie lo escribió',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Dos formas de hacerlo',
          titulo: 'De arriba abajo o de abajo arriba',
          texto:
              'Se puede empezar por los módulos de más alto nivel usando '
              'sustitutos de los de abajo, o al revés, usando arneses que '
              'llamen a los de abajo. Lo importante es que la decisión sea '
              'consciente y no el resultado del azar.',
        ),
        TarjetaTeoria(
          mensaje: 'Y la trampa clásica',
          titulo: 'El «big bang»',
          texto:
              'Integrar todo de golpe al final y ver qué pasa. Cuando algo '
              'falla, el fallo puede estar en cualquiera de las decenas de '
              'conexiones nuevas, y encontrarlo cuesta más que haber integrado '
              'poco a poco.',
          destacado:
              'Esta es exactamente la razón de la integración continua: juntar '
              'poco y a menudo, para que cuando se rompa sepas qué cambio lo '
              'rompió.',
        ),
        TarjetaTeoria(
          mensaje: 'Un consejo práctico',
          titulo: 'Los contratos entre partes',
          texto:
              'Cuando dos equipos distintos construyen las dos piezas, lo que '
              'evita el choque es acordar por escrito el formato del '
              'intercambio antes de programar: qué campos, de qué tipo, qué '
              'pasa si falta uno.',
        ),
        TarjetaTeoria(
          mensaje: 'Para no confundirlo',
          titulo: 'No es una prueba de sistema',
          texto:
              'La integración sigue siendo una prueba técnica: comprueba que '
              'dos o más componentes se entienden. La prueba de sistema mira '
              'el producto entero funcionando como lo vería un usuario.',
        ),
      ],
    ),
 
    'cap-3-1-lec-3': ContenidoLeccion(
      leccionId: 'cap-3-1-lec-3',
      titulo: 'Pruebas de Sistema y Aceptación',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Ya con todo montado',
          titulo: 'La prueba de sistema',
          texto:
              'Se prueba el producto completo, en un entorno lo más parecido '
              'posible al real, contra la especificación. Aquí se comprueban '
              'también los requisitos no funcionales: rendimiento, seguridad, '
              'comportamiento bajo carga.',
        ),
        TarjetaTeoria(
          mensaje: 'Y la última',
          titulo: 'La prueba de aceptación',
          texto:
              'La ejecuta o la acuerda el cliente, y decide si el sistema '
              'cubre lo que necesitaba. Se deriva de los requisitos de '
              'usuario, no del código ni del diseño.',
          destacado:
              'Sus criterios deben estar escritos al definir el requisito. Si '
              'se negocian al final, lo que se está discutiendo es el alcance, '
              'no la calidad.',
        ),
        TarjetaTeoria(
          mensaje: 'La distinción importante',
          titulo: 'Verificación y validación otra vez',
          texto:
              'Las pruebas de sistema verifican: comprueban el producto contra '
              'la especificación. Las de aceptación validan: comprueban que esa '
              'especificación resolvía el problema real.',
        ),
        TarjetaTeoria(
          mensaje: 'Variantes que vas a oír',
          titulo: 'Alfa, beta y operativa',
          texto:
              'La aceptación tiene formas distintas según quién prueba y '
              'dónde.',
          vinetas: [
            'Alfa: usuarios reales, pero en las instalaciones del que desarrolla',
            'Beta: usuarios reales, en su propio entorno',
            'Operativa: la prueba el equipo que va a mantener el sistema',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Un caso que lo explica',
          titulo: 'El ascensor otra vez',
          texto:
              'La prueba de sistema comprueba que la cabina para en el piso '
              'pedido con la precisión especificada. La de aceptación la hace '
              'el organismo certificador, y comprueba que el conjunto cumple la '
              'normativa de seguridad que permite ponerlo en servicio.',
          destacado:
              'Son dos pruebas distintas, con dos dueños distintos y dos '
              'documentos de origen distintos.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo que deja la norma',
          titulo: 'Dónde está escrito todo esto',
          texto:
              'La ISO/IEC/IEEE 29119 cubre el proceso de pruebas, la '
              'documentación y las técnicas de diseño de casos. Los niveles de '
              'prueba y su relación con los requisitos vienen de la '
              'ISO/IEC/IEEE 12207.',
        ),
      ],
    ),
 
    'cap-3-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-2-lec-1',
      titulo: 'Pruebas de Caja Blanca',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Cambiamos de enfoque',
          titulo: 'Mirando el código por dentro',
          texto:
              'En caja blanca se diseñan los casos a partir de la estructura '
              'interna del programa: sus condiciones, sus bucles, sus caminos. '
              'Quien las escribe ve el código.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué se busca cubrir',
          titulo: 'Tres niveles de cobertura',
          texto:
              'No es lo mismo pasar por todas las líneas que probar todas las '
              'combinaciones. Van de menos a más exigente.',
          vinetas: [
            'De sentencias: cada línea se ejecuta al menos una vez',
            'De decisiones o ramas: cada condición se evalúa verdadera y falsa',
            'De caminos: cada recorrido posible del flujo se prueba',
          ],
          destacado:
              'Cubrir todas las líneas es fácil y engaña. Cubrir todas las '
              'ramas ya cuesta, y detecta mucho más.',
        ),
        TarjetaTeoria(
          mensaje: 'Un ejemplo corto',
          titulo: 'Por qué las ramas importan',
          texto:
              'Una función con un «si» sin «si no» se recorre entera con un '
              'solo caso que entre en el «si». Tendrás el 100 % de cobertura '
              'de sentencias y nunca habrás probado qué pasa cuando la '
              'condición es falsa.',
        ),
        TarjetaTeoria(
          mensaje: 'Para qué sirve de verdad',
          titulo: 'Encuentra lo que nadie pidió',
          texto:
              'La caja blanca detecta código inalcanzable, bucles que no '
              'terminan en algún caso y ramas que nadie pensó. Son cosas que '
              'desde fuera, sin ver el código, no se sospechan.',
        ),
        TarjetaTeoria(
          mensaje: 'Y su límite',
          titulo: 'No ve lo que falta',
          texto:
              'Como los casos salen del código escrito, si una funcionalidad '
              'no se programó, no hay rama que la represente y ninguna prueba '
              'de caja blanca la va a echar de menos.',
          destacado:
              'Por eso caja blanca y caja negra no compiten: una mira si lo '
              'escrito funciona, la otra si está todo lo que debía estar.',
        ),
        TarjetaTeoria(
          mensaje: 'Un aviso sobre la métrica',
          titulo: 'El 100 % que no prueba nada',
          texto:
              'Se puede alcanzar cobertura total ejecutando todo el código con '
              'pruebas que no comprueban nada: sin afirmaciones, la cobertura '
              'mide qué se ejecutó, no qué se verificó.',
        ),
      ],
    ),
 
    'cap-3-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-2-lec-2',
      titulo: 'Pruebas de Caja Negra',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El enfoque contrario',
          titulo: 'Sin mirar dentro',
          texto:
              'En caja negra los casos se diseñan a partir de la '
              'especificación, no del código. Entra una cosa, debe salir otra, '
              'y cómo esté hecho por dentro no importa.',
          destacado:
              'Tiene una ventaja práctica: puede escribirlas alguien que no '
              'programó el sistema, y por eso no hereda sus suposiciones.',
        ),
        TarjetaTeoria(
          mensaje: 'La primera técnica',
          titulo: 'Particiones de equivalencia',
          texto:
              'Si un campo acepta edades de 18 a 65, probar 19, 20 y 21 es '
              'probar tres veces lo mismo. Se agrupan las entradas en clases '
              'que el sistema debería tratar igual y se prueba una de cada '
              'clase.',
          vinetas: [
            'Menores de 18: clase inválida',
            'De 18 a 65: clase válida',
            'Mayores de 65: clase inválida',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y la que más defectos encuentra',
          titulo: 'Valores límite',
          texto:
              'Los errores se concentran en los bordes de cada clase, porque '
              'ahí es donde se confunde «mayor que» con «mayor o igual». Se '
              'prueban los extremos y sus vecinos inmediatos.',
          destacado:
              'Para el rango de 18 a 65, los casos interesantes son 17, 18, '
              '19, 64, 65 y 66. Ahí vive la mayoría de los defectos de '
              'validación.',
        ),
        TarjetaTeoria(
          mensaje: 'Cuando hay varias condiciones',
          titulo: 'Tablas de decisión',
          texto:
              'Si el resultado depende de tres o cuatro condiciones '
              'combinadas, se arma una tabla con todas las combinaciones y su '
              'resultado esperado. Es tedioso y es la única forma de no '
              'olvidarse una.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso del catálogo',
          titulo: 'Los pedidos de la tienda',
          texto:
              'El descuento depende de si el cliente es habitual, de si el '
              'pedido supera cierto importe y de si hay promoción activa. Son '
              'ocho combinaciones, y a mano siempre se olvida alguna. Con una '
              'tabla de decisión, ninguna.',
        ),
        TarjetaTeoria(
          mensaje: 'Para cerrar el capítulo',
          titulo: 'Las dos juntas',
          texto:
              'Una estrategia seria usa caja negra para cubrir lo que el '
              'sistema debe hacer y caja blanca para comprobar que lo escrito '
              'no tiene rincones sin probar. Elegir solo una deja un hueco '
              'distinto en cada caso.',
        ),
      ],
    ),
 
    'cap-3-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-3-lec-1',
      titulo: 'Ciclo de Vida de un Defecto',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Tres palabras distintas',
          titulo: 'Error, defecto y fallo',
          texto:
              'El error es la equivocación de la persona. El defecto es su '
              'huella en el código o en el documento. El fallo es el '
              'comportamiento incorrecto que alguien percibe.',
          destacado:
              'Un defecto puede existir años sin producir un fallo. Por eso '
              '«nunca ha fallado» no es evidencia de que no haya defectos.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué le pasa a un defecto',
          titulo: 'Los estados del recorrido',
          texto:
              'Desde que alguien lo reporta hasta que se cierra, un defecto '
              'pasa por una secuencia que conviene tener definida por '
              'escrito.',
          vinetas: [
            'Nuevo: alguien lo reportó y nadie lo ha mirado',
            'Asignado: tiene responsable',
            'En progreso: alguien está trabajando en él',
            'Resuelto: quien lo arregló dice que ya está',
            'Verificado: quien lo reportó confirma que es cierto',
            'Cerrado',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y los desvíos',
          titulo: 'No todos se arreglan',
          texto:
              'Hay salidas legítimas que no pasan por corregir nada, y todas '
              'deben quedar registradas con su motivo.',
          vinetas: [
            'Duplicado: ya estaba reportado',
            'No es un defecto: el sistema hace lo que debe',
            'No reproducible: nadie consigue repetirlo',
            'Diferido: es real, se arregla más adelante',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Lo que marca la diferencia',
          titulo: 'Un buen reporte',
          texto:
              'Un defecto mal reportado se devuelve, y eso cuesta dos días. Un '
              'reporte sirve cuando otra persona puede reproducirlo sin '
              'preguntar nada.',
          vinetas: [
            'Pasos exactos para reproducirlo',
            'Qué esperabas que pasara',
            'Qué pasó en realidad',
            'Versión, entorno y datos usados',
          ],
          destacado:
              '«No funciona el login» no es un reporte. Es una queja.',
        ),
        TarjetaTeoria(
          mensaje: 'Por qué el registro importa',
          titulo: 'Sin él no hay métricas',
          texto:
              'Si los defectos se arreglan por mensaje privado, nadie puede '
              'saber cuántos hubo, dónde se concentran ni si mejoramos. El '
              'registro no es burocracia: es la materia prima de todo el '
              'Mundo 4.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso para pensar',
          titulo: 'Defectos que llegan a producción',
          texto:
              'Cuando los fallos los descubre el usuario, el ciclo del defecto '
              'está empezando demasiado tarde. Casi siempre faltan dos cosas: '
              'pruebas de regresión automatizadas y un criterio claro de qué '
              'se puede liberar.',
        ),
      ],
    ),
 
    'cap-3-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-3-lec-2',
      titulo: 'Severidad y Prioridad',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Dos cosas que se mezclan',
          titulo: 'No miden lo mismo',
          texto:
              'La severidad mide el daño técnico que causa el defecto. La '
              'prioridad mide la urgencia con que el negocio quiere que se '
              'arregle. Son independientes, y las decide gente distinta.',
          destacado:
              'La severidad la pone quien prueba; la prioridad, quien decide '
              'el producto.',
        ),
        TarjetaTeoria(
          mensaje: 'La escala de daño',
          titulo: 'Niveles de severidad',
          texto:
              'Las escalas varían entre organizaciones, pero el fondo es '
              'siempre este.',
          vinetas: [
            'Crítica: el sistema no se puede usar o se pierden datos',
            'Mayor: una función importante no sirve y no hay alternativa',
            'Menor: molesta, pero existe una forma de seguir',
            'Cosmética: un detalle visual sin impacto funcional',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Y ahora lo interesante',
          titulo: 'Las cuatro combinaciones',
          texto:
              'Que sean independientes significa que se dan las cuatro '
              'esquinas, y cada una se trata distinto.',
          vinetas: [
            'Severidad alta y prioridad alta: se para todo y se arregla',
            'Severidad alta y prioridad baja: grave, pero en una pantalla que '
                'usa una persona al año',
            'Severidad baja y prioridad alta: el logo del cliente mal escrito '
                'en la portada',
            'Severidad baja y prioridad baja: la cola de siempre',
          ],
          destacado:
              'El tercer caso es el que más cuesta aceptar a un equipo '
              'técnico, y es completamente razonable desde el negocio.',
        ),
        TarjetaTeoria(
          mensaje: 'Un caso real',
          titulo: 'El error de ortografía caro',
          texto:
              'Una errata en el nombre de la empresa en la pantalla de inicio '
              'no rompe nada: severidad cosmética. Pero si la aplicación se '
              'presenta mañana ante el directorio del cliente, la prioridad es '
              'máxima.',
        ),
        TarjetaTeoria(
          mensaje: 'Un aviso de gestión',
          titulo: 'Cuando todo es crítico',
          texto:
              'Si la mitad de los defectos abiertos están marcados como '
              'críticos, la clasificación dejó de servir. Suele pasar cuando '
              'quien reporta usa la severidad para que le hagan caso antes, en '
              'lugar de para describir el daño.',
          destacado:
              'Una escala en la que todo es urgente no ordena nada: solo '
              'traslada la decisión a quien grite más fuerte.',
        ),
        TarjetaTeoria(
          mensaje: 'Y nos lo llevamos así',
          titulo: 'Qué llevarte',
          texto:
              'Severidad describe; prioridad decide. Mantenerlas separadas es '
              'lo que permite tener una conversación sobre qué se arregla '
              'primero sin discutir sobre qué tan grave es cada cosa.',
        ),
      ],
    ),
 
    'cap-3-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-4-lec-1',
      titulo: 'Estrategias de Despliegue',
      tiempoLectura: 5,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'El momento de la verdad',
          titulo: 'Desplegar también es una decisión',
          texto:
              'Poner una versión en producción no es copiar archivos. Hay '
              'varias formas de hacerlo y cada una reparte distinto el riesgo '
              'entre los usuarios.',
        ),
        TarjetaTeoria(
          mensaje: 'La más simple',
          titulo: 'Reemplazo directo',
          texto:
              'Se apaga la versión vieja, se sube la nueva y se enciende. Es '
              'sencillo y barato, y tiene dos costes: hay interrupción de '
              'servicio, y si algo sale mal, lo sufren todos los usuarios a la '
              'vez.',
        ),
        TarjetaTeoria(
          mensaje: 'Sin cortar el servicio',
          titulo: 'Despliegue progresivo',
          texto:
              'Se van reemplazando las instancias de poco en poco, de modo que '
              'siempre queda alguna atendiendo. No hay caída, pero durante un '
              'rato conviven dos versiones, y eso hay que tenerlo previsto.',
        ),
        TarjetaTeoria(
          mensaje: 'Dos entornos gemelos',
          titulo: 'Azul y verde',
          texto:
              'Se mantienen dos entornos completos. Uno atiende a los usuarios '
              'y el otro recibe la versión nueva. Cuando está lista, se cambia '
              'el tráfico de golpe, y volver atrás es cambiarlo otra vez.',
          destacado:
              'Es la estrategia con la vuelta atrás más rápida que existe, y '
              'la más cara: hay que pagar dos entornos.',
        ),
        TarjetaTeoria(
          mensaje: 'La más prudente',
          titulo: 'Despliegue canario',
          texto:
              'La versión nueva se abre primero a un porcentaje pequeño de '
              'usuarios. Se vigilan los errores y la latencia, y si todo va '
              'bien se amplía por etapas hasta el cien por cien.',
          destacado:
              'El nombre viene de los canarios que los mineros bajaban al '
              'túnel: si algo iba mal, se notaba primero ahí.',
        ),
        TarjetaTeoria(
          mensaje: 'Y una técnica que acompaña',
          titulo: 'Interruptores de funcionalidad',
          texto:
              'El código nuevo se despliega apagado detrás de un interruptor y '
              'se enciende cuando conviene. Separa desplegar de publicar, que '
              'son dos decisiones distintas y hasta ahora iban juntas.',
        ),
        TarjetaTeoria(
          mensaje: 'Cómo elegir',
          titulo: 'Depende del coste de fallar',
          texto:
              'En el sistema del ascensor no hay despliegue canario que valga: '
              'se certifica y se instala. En una app de reparto, el canario es '
              'la forma sensata de descubrir un problema con el uno por ciento '
              'de los usuarios en lugar de con todos.',
        ),
      ],
    ),
 
    'cap-3-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-4-lec-2',
      titulo: 'Plan de Rollback',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La pregunta incómoda',
          titulo: '¿Y si sale mal?',
          texto:
              'Todo plan de despliegue necesita su plan de vuelta atrás, '
              'escrito antes de desplegar y no improvisado a las once de la '
              'noche con el sistema caído.',
          destacado:
              'Un plan de vuelta atrás que nadie ha ensayado no es un plan: es '
              'una intención.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo primero, siempre',
          titulo: 'Definir cuándo se vuelve',
          texto:
              'El criterio hay que fijarlo antes, cuando aún se razona con '
              'calma: qué nivel de errores, qué latencia o qué fallo concreto '
              'dispara la vuelta atrás. Sin criterio, la decisión se toma por '
              'nervios.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo que casi siempre falla',
          titulo: 'La base de datos',
          texto:
              'Volver atrás el código es fácil; volver atrás una migración que '
              'ya borró una columna, no. Por eso los cambios de esquema se '
              'hacen compatibles hacia atrás: primero se añade, se despliega, '
              'y solo mucho después se elimina lo viejo.',
          destacado:
              'Si el despliegue del lunes borra una columna, el martes no hay '
              'vuelta atrás posible aunque el código sí se pueda revertir.',
        ),
        TarjetaTeoria(
          mensaje: 'Antes de tocar nada',
          titulo: 'Respaldo verificado',
          texto:
              'Tener copia de respaldo no basta: hay que haber probado alguna '
              'vez que se puede restaurar. Una copia que nunca se restauró es '
              'una suposición.',
        ),
        TarjetaTeoria(
          mensaje: 'La otra salida',
          titulo: 'Avanzar en vez de retroceder',
          texto:
              'A veces volver atrás es más arriesgado que corregir hacia '
              'adelante con un parche pequeño y bien acotado. Es una decisión '
              'legítima, siempre que sea una decisión y no la excusa de no '
              'tener plan.',
        ),
        TarjetaTeoria(
          mensaje: 'Y después',
          titulo: 'Lo que viene al día siguiente',
          texto:
              'Tras una vuelta atrás toca entender qué pasó. No para buscar '
              'culpables, sino para que la próxima vez el fallo se detecte '
              'antes: en la tubería, en las pruebas o en el despliegue '
              'canario.',
        ),
      ],
    ),
 
    'cap-3-5-lec-1': ContenidoLeccion(
      leccionId: 'cap-3-5-lec-1',
      titulo: 'Tipos de Mantenimiento',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La fase más larga',
          titulo: 'Mantener no es arreglar',
          texto:
              'Mucha gente cree que mantenimiento es corregir errores. Es solo '
              'una cuarta parte. La norma ISO/IEC 14764 distingue cuatro tipos, '
              'y los que no son correctivos suelen ser la mayoría del '
              'esfuerzo.',
        ),
        TarjetaTeoria(
          mensaje: 'Empezamos por el obvio',
          titulo: 'Correctivo',
          texto:
              'Reparar defectos detectados después de la entrega. Es el que '
              'todo el mundo tiene en mente y, en sistemas maduros, el que '
              'menos horas consume.',
        ),
        TarjetaTeoria(
          mensaje: 'Este sorprende',
          titulo: 'Adaptativo',
          texto:
              'Ajustar el sistema a cambios de su entorno, aunque el sistema '
              'siga haciendo exactamente lo mismo: una versión nueva del '
              'sistema operativo, un cambio de normativa, un proveedor que '
              'modifica su interfaz.',
          destacado:
              'Aquí no hay ningún defecto. El software estaba bien y el mundo '
              'cambió alrededor.',
        ),
        TarjetaTeoria(
          mensaje: 'Y este es el mayor',
          titulo: 'Perfectivo',
          texto:
              'Mejorar lo que ya funciona: nuevas funciones pedidas por los '
              'usuarios, mejoras de rendimiento, reorganización del código '
              'para que sea más fácil de cambiar. Suele ser el más grande de '
              'los cuatro.',
        ),
        TarjetaTeoria(
          mensaje: 'El que se recorta',
          titulo: 'Preventivo',
          texto:
              'Actuar sobre problemas que todavía no se manifestaron: '
              'actualizar una dependencia con una vulnerabilidad conocida, '
              'limpiar código que empieza a ser frágil, añadir pruebas donde '
              'no las hay.',
          destacado:
              'Es el primero que se recorta cuando hay prisa, y el que más '
              'cuesta cuando se recorta.',
        ),
        TarjetaTeoria(
          mensaje: 'Para ubicarlos',
          titulo: 'Las dos preguntas que los separan',
          texto:
              'Basta con responder dos cosas: ¿hay un defecto, o el sistema '
              'funciona bien? Y si funciona bien, ¿cambió el entorno, lo pide '
              'el usuario, o lo hacemos por prudencia?',
        ),
      ],
    ),
 
    'cap-3-5-lec-2': ContenidoLeccion(
      leccionId: 'cap-3-5-lec-2',
      titulo: 'Gestión del Mantenimiento',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Del caos al proceso',
          titulo: 'Las peticiones entran por un sitio',
          texto:
              'En un sistema en producción, las peticiones de cambio llegan de '
              'todas partes: usuarios, soporte, dirección, el propio equipo. Si '
              'no hay una única puerta de entrada, se trabaja en lo que pide '
              'quien insiste más.',
        ),
        TarjetaTeoria(
          mensaje: 'El paso que nadie se salta impunemente',
          titulo: 'Análisis de impacto',
          texto:
              'Antes de aceptar un cambio hay que saber a qué afecta: qué '
              'módulos toca, qué pruebas hay que rehacer, qué documentación '
              'queda desactualizada y cuánto cuesta.',
          destacado:
              'Aquí es donde la trazabilidad se paga sola. Sin ella, el '
              'análisis de impacto es una conjetura de alguien con buena '
              'memoria.',
        ),
        TarjetaTeoria(
          mensaje: 'Quién decide',
          titulo: 'El comité de cambios',
          texto:
              'Las peticiones aprobadas se priorizan, y la decisión no es solo '
              'técnica: entra el coste, el riesgo y la urgencia del negocio. '
              'Por eso el comité no lo forman únicamente programadores.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo que se promete por contrato',
          titulo: 'Acuerdos de nivel de servicio',
          texto:
              'En muchos contratos de mantenimiento se fija cuánto se puede '
              'tardar en responder y en resolver según la severidad. Eso '
              'convierte la clasificación de defectos en algo con consecuencias '
              'económicas.',
        ),
        TarjetaTeoria(
          mensaje: 'La deuda que se acumula',
          titulo: 'Mantener también es decidir no mantener',
          texto:
              'Cada atajo que se toma para entregar a tiempo genera deuda '
              'técnica: el cambio siguiente cuesta un poco más. No toda deuda '
              'es mala, pero la que se contrae sin registrarla y sin plan de '
              'pago termina frenando el producto.',
        ),
        TarjetaTeoria(
          mensaje: 'Y con esto cerramos el mundo',
          titulo: 'Migrar un sistema heredado',
          texto:
              'Llega un momento en que mantener cuesta más que reemplazar. Esa '
              'decisión se toma con datos: cuántas horas consume el '
              'mantenimiento, cuántos defectos reaparecen, cuánto tarda un '
              'cambio pequeño. De medir todo eso va el Mundo 4.',
        ),
      ],
    ),

    // =================================================================
    // MUNDO 4 — MÉTRICAS DE PROYECTOS
    // =================================================================

    'cap-4-1-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-1-lec-1',
      titulo: 'Medida, Métrica e Indicador',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Suenan a lo mismo',
          titulo: 'Y se usan como si lo fueran',
          texto:
              'En una reunión se dice «esta métrica» para hablar de tres cosas '
              'distintas. Separarlas no es purismo: es lo que permite saber si '
              'un número sirve para decidir algo.',
        ),
        TarjetaTeoria(
          mensaje: 'La de abajo del todo',
          titulo: 'Medida',
          texto:
              'Un valor crudo obtenido directamente de la realidad, sin '
              'interpretar. Número de defectos encontrados. Líneas de código. '
              'Horas trabajadas. Por sí sola casi nunca dice nada.',
          destacado:
              '«Encontramos 40 defectos» no significa nada hasta saber en '
              'cuánto código y en cuánto tiempo.',
        ),
        TarjetaTeoria(
          mensaje: 'Un escalón arriba',
          titulo: 'Métrica',
          texto:
              'Relaciona dos o más medidas para producir algo comparable. '
              'Defectos por cada mil líneas. Defectos por semana. Porcentaje '
              'de pruebas que pasan. Ya se puede comparar con otro proyecto o '
              'con uno mismo el mes pasado.',
        ),
        TarjetaTeoria(
          mensaje: 'Y la tercera',
          titulo: 'Indicador',
          texto:
              'Una métrica con un umbral y un significado acordado, que '
              'dispara una decisión. «Más de 3 defectos por cada mil líneas: '
              'no se libera.» Eso ya no informa: ordena.',
          destacado:
              'La diferencia entre métrica e indicador es que el indicador '
              'lleva pegada la acción que hay que tomar.',
        ),
        TarjetaTeoria(
          mensaje: 'Cómo se construye una buena',
          titulo: 'Qué le hace falta a una métrica',
          texto:
              'Para que sirva tiene que estar definida sin ambigüedad, y eso '
              'significa responder cuatro cosas.',
          vinetas: [
            'Qué se mide exactamente',
            'Cómo se obtiene el dato y cada cuánto',
            'Contra qué valor se compara',
            'Qué se hace si se pasa del umbral',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Un aviso de salida',
          titulo: 'Medir no es mejorar',
          texto:
              'Un tablero lleno de gráficos que nadie usa para decidir es '
              'decoración cara. Si una métrica nunca ha cambiado una decisión, '
              'probablemente se puede dejar de medir.',
        ),
      ],
    ),
 
    'cap-4-1-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-1-lec-2',
      titulo: 'Tipos de Métricas',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Ordenemos el terreno',
          titulo: 'Tres familias',
          texto:
              'Según qué se esté observando, las métricas se agrupan en tres '
              'familias, y mezclarlas al razonar lleva a conclusiones falsas.',
          vinetas: [
            'De producto: cómo es el software que se construyó',
            'De proceso: cómo se trabaja',
            'De proyecto: cómo va el plan, el coste y el equipo',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Las de producto',
          titulo: 'Miran al software',
          texto:
              'Tamaño, complejidad, acoplamiento, cobertura de pruebas, '
              'densidad de defectos. Se obtienen del código y de los '
              'resultados de las pruebas, y son las que mejor se automatizan.',
        ),
        TarjetaTeoria(
          mensaje: 'Las de proceso',
          titulo: 'Miran cómo se trabaja',
          texto:
              'Tiempo desde que un cambio se escribe hasta que llega a '
              'producción, porcentaje de defectos escapados, frecuencia de '
              'despliegue. Son las que dicen si la forma de trabajar está '
              'mejorando.',
          destacado:
              'Las cuatro métricas DORA son todas de proceso. Por eso sirven '
              'para comparar equipos que construyen productos distintos.',
        ),
        TarjetaTeoria(
          mensaje: 'Las de proyecto',
          titulo: 'Miran el plan',
          texto:
              'Avance frente a lo planificado, desviación de coste, esfuerzo '
              'consumido, rotación del equipo. Son las que interesan a quien '
              'paga y las que se reportan hacia arriba.',
        ),
        TarjetaTeoria(
          mensaje: 'Otra forma de partirlas',
          titulo: 'Directas e indirectas',
          texto:
              'Las directas se cuentan: líneas, defectos, horas. Las '
              'indirectas se calculan a partir de otras y siempre llevan una '
              'suposición dentro: productividad, mantenibilidad, calidad.',
          destacado:
              'Cuanto más indirecta es una métrica, más fácil es discutirla. '
              'Conviene saber qué suposición lleva dentro antes de defenderla.',
        ),
        TarjetaTeoria(
          mensaje: 'Para elegir bien',
          titulo: 'Primero la pregunta',
          texto:
              'El orden correcto es decidir qué quieres saber, después qué '
              'métrica lo responde y solo al final qué medidas hace falta '
              'recoger. Al revés se acaba midiendo lo que es fácil de medir en '
              'vez de lo que importa.',
        ),
      ],
    ),
 
    'cap-4-2-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-2-lec-1',
      titulo: 'Línea Base del Proyecto',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La discusión de siempre',
          titulo: '«Eso estaba pedido desde el principio»',
          texto:
              'A mitad de proyecto el cliente asegura que una función siempre '
              'estuvo en el alcance y el equipo recuerda lo contrario. Sin un '
              'punto de referencia congelado, esa discusión no tiene forma de '
              'resolverse.',
        ),
        TarjetaTeoria(
          mensaje: 'Para eso existe',
          titulo: 'Qué es una línea base',
          texto:
              'Una versión de un producto o documento formalmente aprobada, '
              'que a partir de ese momento solo puede cambiarse mediante un '
              'procedimiento de control de cambios.',
          destacado:
              'Congelar no significa prohibir cambios. Significa que los '
              'cambios se ven, se valoran y se aprueban en lugar de colarse.',
        ),
        TarjetaTeoria(
          mensaje: 'No es una sola',
          titulo: 'Las tres líneas base clásicas',
          texto:
              'En gestión de proyectos se manejan tres, y juntas forman la '
              'referencia contra la que se mide todo lo demás.',
          vinetas: [
            'De alcance: qué se va a construir',
            'De cronograma: en qué fechas',
            'De coste: con qué presupuesto',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Cómo se cambia',
          titulo: 'El control de cambios',
          texto:
              'Una petición de cambio se registra, se analiza su impacto en '
              'las tres líneas base, se aprueba o se rechaza, y si se aprueba '
              'se actualizan. Ese último paso es el que más se olvida.',
          destacado:
              'Aprobar un cambio y no mover la línea base de cronograma es '
              'cómo un proyecto acaba «retrasado» cuando en realidad se le '
              'añadió trabajo.',
        ),
        TarjetaTeoria(
          mensaje: 'En lo técnico también',
          titulo: 'Líneas base de configuración',
          texto:
              'El mismo concepto aplica al producto: una versión etiquetada, '
              'con sus dependencias y su documentación, que se puede '
              'reconstruir exactamente igual dentro de dos años. De eso se '
              'ocupa la gestión de la configuración.',
        ),
        TarjetaTeoria(
          mensaje: 'Lo que hay que fijar',
          titulo: 'Sin referencia no hay desviación',
          texto:
              'Decir que un proyecto va retrasado exige saber respecto a qué. '
              'La línea base es ese «respecto a qué», y por eso todo el '
              'seguimiento del capítulo siguiente depende de ella.',
        ),
      ],
    ),
 
    'cap-4-2-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-2-lec-2',
      titulo: 'Seguimiento de Avance',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'La respuesta que no vale',
          titulo: '«Vamos al ochenta por ciento»',
          texto:
              'Es la respuesta más común y la menos informativa de todas. El '
              'famoso ochenta por ciento que dura tres meses aparece cuando el '
              'avance se estima a ojo en vez de medirse contra algo terminado.',
        ),
        TarjetaTeoria(
          mensaje: 'La regla más útil',
          titulo: 'Terminado o no terminado',
          texto:
              'Una tarea cuenta cuando cumple la definición de hecho. No hay '
              'medio terminado. Parece duro y es lo único que evita que el '
              'avance reportado se despegue de la realidad.',
          destacado:
              'Diez tareas al 50 % no son cinco tareas hechas: son cero '
              'entregables.',
        ),
        TarjetaTeoria(
          mensaje: 'Si quieres números',
          titulo: 'Valor ganado',
          texto:
              'Compara tres cantidades en el mismo momento del proyecto: lo '
              'que estaba planificado, lo que realmente se ha completado y lo '
              'que se ha gastado. De ahí salen dos índices.',
          vinetas: [
            'Índice de cronograma: avance real frente a avance planificado',
            'Índice de coste: avance real frente a dinero gastado',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Cómo se leen',
          titulo: 'Uno es la línea',
          texto:
              'En los dos índices, el valor 1 significa «según lo previsto». '
              'Por debajo, vas peor de lo planificado; por encima, mejor. Son '
              'dos números y se leen en un segundo, que es justo lo que hace '
              'falta en una reunión de seguimiento.',
        ),
        TarjetaTeoria(
          mensaje: 'En ágil se mira distinto',
          titulo: 'Gráficos de trabajo pendiente',
          texto:
              'En lugar de porcentajes se dibuja cuánto trabajo queda frente '
              'al tiempo que queda. Si la línea real va por encima de la '
              'ideal, no se va a llegar, y se ve sin calcular nada.',
        ),
        TarjetaTeoria(
          mensaje: 'La advertencia de siempre',
          titulo: 'El informe no es el proyecto',
          texto:
              'Cuando el equipo dedica más esfuerzo a que el gráfico se vea '
              'bien que a terminar trabajo, el seguimiento dejó de medir y '
              'empezó a distorsionar.',
        ),
      ],
    ),
 
    'cap-4-3-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-3-lec-1',
      titulo: 'Densidad y Fuga de Defectos',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Primera métrica de calidad',
          titulo: 'Densidad de defectos',
          texto:
              'Es el número de defectos dividido por el tamaño del software, '
              'normalmente por cada mil líneas de código o por punto función. '
              'Convierte un número suelto en algo comparable.',
          destacado:
              'Cuarenta defectos en diez mil líneas y cuarenta en cien mil '
              'describen dos situaciones completamente distintas.',
        ),
        TarjetaTeoria(
          mensaje: 'Cuidado al interpretarla',
          titulo: 'Baja no siempre es buena noticia',
          texto:
              'Una densidad muy baja puede significar un código excelente, o '
              'que casi no se ha probado. Sin saber la cobertura, el número no '
              'se puede leer.',
        ),
        TarjetaTeoria(
          mensaje: 'La segunda, y la más honesta',
          titulo: 'Fuga de defectos',
          texto:
              'Mide qué proporción de los defectos llegó hasta el usuario en '
              'lugar de haberse detectado antes. Se calcula dividiendo los '
              'encontrados en producción entre el total de encontrados.',
          destacado:
              'Es la métrica que mejor resume si el proceso de pruebas está '
              'funcionando, porque no mide cuántos defectos hay sino quién los '
              'encuentra primero.',
        ),
        TarjetaTeoria(
          mensaje: 'Por qué importa tanto',
          titulo: 'El coste sube con la fase',
          texto:
              'Un defecto detectado al revisar los requisitos cuesta una '
              'conversación. El mismo defecto detectado por un usuario cuesta '
              'soporte, parche, despliegue de urgencia y confianza.',
        ),
        TarjetaTeoria(
          mensaje: 'Dónde mirar después',
          titulo: 'Densidad por módulo',
          texto:
              'Calcular la densidad por componente en lugar de para todo el '
              'sistema señala dónde conviene reforzar las pruebas o '
              'reescribir. Los defectos casi nunca se reparten de forma '
              'pareja.',
        ),
        TarjetaTeoria(
          mensaje: 'Esto ya lo viste',
          titulo: 'Defectos que llegan a producción',
          texto:
              'Un equipo con buena densidad y mala fuga tiene un problema muy '
              'concreto: encuentra defectos, pero demasiado tarde. La solución '
              'no es probar más, es probar antes.',
        ),
      ],
    ),
 
    'cap-4-3-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-3-lec-2',
      titulo: 'Cobertura, MTBF y MTTR',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Volvemos a la cobertura',
          titulo: 'Qué mide y qué no',
          texto:
              'La cobertura indica qué proporción del sistema ejercitan las '
              'pruebas, medida en líneas, en ramas o en requisitos. Es un '
              'indicador de lo que no se ha probado, no una garantía sobre lo '
              'que sí.',
          destacado:
              'El 100 % de cobertura con afirmaciones vacías no prueba nada. '
              'Mide ejecución, no verificación.',
        ),
        TarjetaTeoria(
          mensaje: 'La más interesante de las tres',
          titulo: 'Cobertura de requisitos',
          texto:
              'En lugar de contar líneas, cuenta qué proporción de los '
              'requisitos tiene al menos un caso de prueba asociado. Sale '
              'directamente de la matriz de trazabilidad, y es la que un '
              'auditor pide.',
        ),
        TarjetaTeoria(
          mensaje: 'Ahora en producción',
          titulo: 'Tiempo medio entre fallos',
          texto:
              'El MTBF mide cuánto aguanta el sistema funcionando entre un '
              'fallo y el siguiente. Cuanto más alto, más fiable. Es una '
              'métrica de fiabilidad, una de las ocho características de la '
              'ISO/IEC 25010.',
        ),
        TarjetaTeoria(
          mensaje: 'Y su pareja',
          titulo: 'Tiempo medio de reparación',
          texto:
              'El MTTR mide cuánto se tarda en restablecer el servicio desde '
              'que se cae. Cuanto más bajo, mejor. Juntos describen dos cosas '
              'distintas: cada cuánto te rompes y cuánto tardas en levantarte.',
          destacado:
              'Un sistema que falla poco pero tarda ocho horas en volver puede '
              'ser peor que uno que falla más y se recupera en dos minutos.',
        ),
        TarjetaTeoria(
          mensaje: 'Las dos combinadas',
          titulo: 'Disponibilidad',
          texto:
              'De la relación entre esos dos tiempos sale el porcentaje de '
              'tiempo que el sistema está operativo, que es lo que se promete '
              'en los acuerdos de nivel de servicio.',
        ),
        TarjetaTeoria(
          mensaje: 'Para no perder el hilo',
          titulo: 'Dónde encaja cada una',
          texto:
              'La cobertura mira hacia atrás, al trabajo de pruebas. El MTBF y '
              'el MTTR miran hacia adelante, al comportamiento real en '
              'producción. Un equipo maduro vigila las tres.',
        ),
      ],
    ),
 
    'cap-4-4-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-4-lec-1',
      titulo: 'Velocidad y Capacidad en Scrum',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Dos conceptos que se confunden',
          titulo: 'Uno mira atrás y otro adelante',
          texto:
              'La velocidad es cuánto trabajo completó el equipo en los '
              'sprints anteriores. La capacidad es cuánto puede asumir en el '
              'siguiente, según quién esté disponible. Una es historia, la '
              'otra pronóstico.',
        ),
        TarjetaTeoria(
          mensaje: 'Cómo se usa de verdad',
          titulo: 'Para planificar, no para premiar',
          texto:
              'La velocidad sirve para que el equipo decida cuánto cabe en el '
              'próximo sprint, y se estabiliza tras tres o cuatro sprints. '
              'Antes de eso, el número no significa nada.',
        ),
        TarjetaTeoria(
          mensaje: 'Aquí viene lo importante',
          titulo: 'No se compara entre equipos',
          texto:
              'Cada equipo estima con su propia escala. Que uno tenga '
              'velocidad 40 y otro 20 no dice nada sobre cuál produce más: '
              'dice que miden con reglas distintas.',
          destacado:
              'Comparar velocidades entre equipos es la forma más rápida de '
              'que ambos empiecen a inflar sus estimaciones.',
        ),
        TarjetaTeoria(
          mensaje: 'La capacidad, en concreto',
          titulo: 'Qué se descuenta',
          texto:
              'La capacidad de un sprint no es el equipo completo por los días '
              'del sprint. Hay que restar vacaciones, formación, soporte a '
              'producción y las propias reuniones de Scrum.',
        ),
        TarjetaTeoria(
          mensaje: 'Otro de los marcadores',
          titulo: 'El equipo de reparto',
          texto:
              'Un equipo nuevo no tiene velocidad todavía, así que los '
              'primeros sprints se planifican con capacidad y se ajustan sobre '
              'la marcha. Prometer una fecha de entrega el primer día, sin '
              'velocidad histórica, es inventar.',
        ),
        TarjetaTeoria(
          mensaje: 'Y nos lo guardamos',
          titulo: 'La trampa de la velocidad creciente',
          texto:
              'Si alguien usa la velocidad como objetivo, subirá sin que se '
              'entregue más valor: basta con estimar más alto lo mismo. El '
              'número mejora y el producto no.',
        ),
      ],
    ),
 
    'cap-4-4-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-4-lec-2',
      titulo: 'Métricas y Personas',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Esta lección es la más importante del mundo',
          titulo: 'Las métricas cambian la conducta',
          texto:
              'En cuanto un número se usa para evaluar a alguien, esa persona '
              'empieza a trabajar para el número. No por mala fe: porque es lo '
              'que se le está pidiendo.',
          destacado:
              'Se conoce como la ley de Goodhart: cuando una medida se '
              'convierte en objetivo, deja de ser una buena medida.',
        ),
        TarjetaTeoria(
          mensaje: 'Ejemplos que verás',
          titulo: 'Qué pasa en la práctica',
          texto:
              'Cada métrica usada como objetivo individual tiene su forma de '
              'romperse, y no hace falta mala intención para encontrarla.',
          vinetas: [
            'Líneas de código: se escribe código más largo del necesario',
            'Número de defectos corregidos: se reportan defectos triviales',
            'Velocidad: se inflan las estimaciones',
            'Cobertura: se añaden pruebas sin afirmaciones',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'La regla práctica',
          titulo: 'Del equipo, no de la persona',
          texto:
              'Las métricas de software son útiles para que un equipo observe '
              'su propio trabajo y decida qué cambiar. Dejan de serlo en '
              'cuanto se usan para comparar personas.',
        ),
        TarjetaTeoria(
          mensaje: 'Un contrapeso sencillo',
          titulo: 'Nunca una sola',
          texto:
              'Toda métrica de velocidad necesita al lado una de calidad. Si '
              'solo miras frecuencia de despliegue, se despliega rápido y mal; '
              'si solo miras defectos, nadie se atreve a entregar.',
          destacado:
              'Por eso las cuatro métricas DORA van siempre juntas: dos de '
              'velocidad y dos de estabilidad, tirando en direcciones '
              'opuestas.',
        ),
        TarjetaTeoria(
          mensaje: 'Y lo que no se mide',
          titulo: 'Lo importante que no sale en el gráfico',
          texto:
              'La confianza del equipo, la claridad de los requisitos o la '
              'calidad de una revisión de código no tienen número. Que no se '
              'puedan medir no las hace menos reales, y olvidarlo es el error '
              'clásico de quien gestiona solo con tableros.',
        ),
        TarjetaTeoria(
          mensaje: 'Antes de seguir',
          titulo: 'La pregunta de control',
          texto:
              'Ante cualquier métrica nueva, conviene preguntarse cómo la '
              'haría subir alguien que quisiera hacer trampa sin trabajar '
              'más. Si la respuesta es fácil, la métrica no sirve como '
              'objetivo.',
        ),
      ],
    ),
 
    'cap-4-5-lec-1': ContenidoLeccion(
      leccionId: 'cap-4-5-lec-1',
      titulo: 'Lecciones Aprendidas',
      tiempoLectura: 4,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Una escena conocida',
          titulo: 'El mismo error otra vez',
          texto:
              'Un proyecto termina mal por un proveedor que no entregó a '
              'tiempo. Dos años después, otro equipo de la misma empresa '
              'tropieza exactamente con lo mismo. Nadie actuó de mala fe: '
              'simplemente no había dónde enterarse.',
        ),
        TarjetaTeoria(
          mensaje: 'Para eso sirven',
          titulo: 'Qué es una lección aprendida',
          texto:
              'El registro de algo que ocurrió, por qué ocurrió y qué '
              'recomendamos hacer la próxima vez. Las tres partes son '
              'necesarias: sin la tercera es una anécdota.',
        ),
        TarjetaTeoria(
          mensaje: 'Cuándo se recogen',
          titulo: 'No solo al final',
          texto:
              'Esperar al cierre del proyecto garantiza que se olviden los '
              'detalles y que la lección llegue tarde para el propio proyecto. '
              'Se recogen al terminar cada fase o cada iteración, en caliente.',
          destacado:
              'Una lección recogida a los seis meses conserva el titular y '
              'pierde la causa, que es justo la parte útil.',
        ),
        TarjetaTeoria(
          mensaje: 'Las que sirven',
          titulo: 'Concretas y accionables',
          texto:
              '«Hay que comunicar mejor» no es una lección: no se puede hacer '
              'nada con eso. «Acordar por escrito el formato del intercambio '
              'antes de programar la integración» sí lo es.',
        ),
        TarjetaTeoria(
          mensaje: 'El problema real',
          titulo: 'Casi nadie las lee',
          texto:
              'El repositorio de lecciones aprendidas es famoso por llenarse y '
              'no consultarse nunca. Solo funciona si alguien las revisa al '
              'planificar el proyecto siguiente, y eso hay que ponerlo como '
              'paso obligatorio del proceso.',
          destacado:
              'Una lección que no se consulta cuesta lo mismo que no haberla '
              'escrito, más el tiempo de escribirla.',
        ),
        TarjetaTeoria(
          mensaje: 'Y lo bueno también',
          titulo: 'No solo de errores',
          texto:
              'Lo que salió bien también es lección, y es la que menos se '
              'registra. Si una práctica ahorró dos semanas, conviene que el '
              'siguiente equipo la conozca y no la reinvente.',
        ),
      ],
    ),
 
    'cap-4-5-lec-2': ContenidoLeccion(
      leccionId: 'cap-4-5-lec-2',
      titulo: 'Retrospectivas y Mejora Continua',
      tiempoLectura: 5,
      tarjetas: [
        TarjetaTeoria(
          mensaje: 'Última lección del sílabo',
          titulo: 'Donde todo se junta',
          texto:
              'La retrospectiva es el mecanismo concreto con el que un equipo '
              'cierra el ciclo PHVA: mira los datos, decide un cambio y lo '
              'aplica. Todo lo medido en este mundo acaba aquí o no sirve de '
              'nada.',
        ),
        TarjetaTeoria(
          mensaje: 'Qué es y qué no',
          titulo: 'No es la revisión del sprint',
          texto:
              'La revisión mira el producto y participa el cliente. La '
              'retrospectiva mira cómo trabajó el equipo y es solo del equipo. '
              'Confundirlas hace que la segunda se convierta en un informe de '
              'estado.',
        ),
        TarjetaTeoria(
          mensaje: 'La condición de partida',
          titulo: 'Seguridad para hablar',
          texto:
              'Si decir «esto no funciona» tiene coste para quien lo dice, la '
              'retrospectiva se vuelve un trámite cortés. Por eso el jefe '
              'directo rara vez debería estar en la sala, y por eso se habla '
              'de procesos y no de personas.',
        ),
        TarjetaTeoria(
          mensaje: 'Una estructura que funciona',
          titulo: 'Cuatro pasos',
          texto:
              'Hay muchos formatos, y casi todos los buenos siguen el mismo '
              'esqueleto.',
          vinetas: [
            'Recoger los datos del periodo, sin interpretarlos todavía',
            'Buscar qué los explica',
            'Elegir una sola mejora, la de mayor impacto',
            'Definir quién la hace y cuándo se revisa',
          ],
        ),
        TarjetaTeoria(
          mensaje: 'Lo que la hace inútil',
          titulo: 'Acuerdos sin dueño',
          texto:
              'Una retrospectiva que produce diez buenas intenciones sin '
              'responsable ni fecha no cambia nada, y a la tercera el equipo '
              'deja de tomársela en serio. Es mejor un acuerdo cumplido que '
              'diez apuntados.',
          destacado:
              'Es el caso de las retrospectivas que no cambian nada, uno de '
              'los ocho marcadores de realidad aumentada de esta app.',
        ),
        TarjetaTeoria(
          mensaje: 'La prueba definitiva',
          titulo: 'Cómo saber si sirven',
          texto:
              'Mira el acuerdo de la retrospectiva anterior. Si se cumplió y '
              'se nota, el mecanismo funciona. Si nadie lo recuerda, lo que '
              'hay es una reunión periódica, no mejora continua.',
        ),
        TarjetaTeoria(
          mensaje: 'Y hasta aquí',
          titulo: 'El círculo completo',
          texto:
              'Empezamos en el Mundo 1 con el ciclo de vida, pasamos por las '
              'normas que lo ordenan, por las pruebas que lo verifican y por '
              'las métricas que lo describen. La retrospectiva es lo que hace '
              'que todo eso mejore en vez de repetirse igual.',
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