import '../models/ejercicio_model.dart';

/// BANCO DE EJERCICIOS
///
/// Cuatro preguntas por lección, 148 en total, alineadas con el contenido
/// de mock_contenidos.dart y con los títulos de mock_data_silabo.dart.
class MockPreguntas {
  static final Map<String, List<Ejercicio>> _preguntas = {

    // =================================================================
    // MUNDO 1 — METODOLOGÍAS DE DESARROLLO
    // =================================================================

    'cap-1-1-lec-1': [
      Ejercicio(
        id: 'q111a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es el SDLC?',
        opciones: [
          'El marco de procesos que ordena el desarrollo desde la necesidad hasta el retiro',
          'Un lenguaje de programación para sistemas grandes',
          'Una herramienta que se instala en el servidor',
          'Un tipo de base de datos para proyectos de software',
        ],
        respuestaCorrecta:
            'El marco de procesos que ordena el desarrollo desde la necesidad hasta el retiro',
        explicacion: [
          'El SDLC no se instala ni se programa: es la estructura que organiza el trabajo.',
        ],
        pista: 'No es algo que se descargue.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué norma internacional define el ciclo de vida del software?',
        opciones: [
          'ISO/IEC/IEEE 12207',
          'ISO 9001',
          'ISO/IEC 27001',
          'ISO/IEC 25010',
        ],
        respuestaCorrecta: 'ISO/IEC/IEEE 12207',
        explicacion: [
          'La 12207 agrupa los procesos en técnicos, de gestión y organizacionales.',
        ],
        pista: 'Lleva los tres prefijos: ISO, IEC e IEEE.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Scrum reemplaza al SDLC.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Scrum es una forma de recorrer el ciclo de vida, no un sustituto.',
          'Cascada, Kanban y DevOps también recorren el mismo ciclo por caminos distintos.',
        ],
        pista: 'Una metodología y un ciclo de vida no son lo mismo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q111d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Un equipo empieza a programar pantallas sin analizar requisitos. ¿Qué error comete?',
        opciones: [
          'Saltarse el análisis, el error más común en perfiles junior',
          'Usar el framework equivocado',
          'No tener suficientes programadores',
          'Elegir mal el lenguaje de programación',
        ],
        respuestaCorrecta:
            'Saltarse el análisis, el error más común en perfiles junior',
        explicacion: [
          'Las reglas de negocio no descubiertas aparecen cuando ya hay código escrito.',
        ],
        pista: 'El problema es de orden, no de herramientas.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-1-lec-2': [
      Ejercicio(
        id: 'q112a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el orden correcto de las fases del SDLC?',
        opciones: [
          'Análisis, Diseño, Desarrollo, Pruebas, Despliegue, Mantenimiento',
          'Diseño, Análisis, Pruebas, Desarrollo, Despliegue, Mantenimiento',
          'Desarrollo, Pruebas, Análisis, Diseño, Mantenimiento, Despliegue',
          'Análisis, Desarrollo, Diseño, Despliegue, Pruebas, Mantenimiento',
        ],
        respuestaCorrecta:
            'Análisis, Diseño, Desarrollo, Pruebas, Despliegue, Mantenimiento',
        explicacion: [
          'Primero se entiende el problema, luego se diseña la solución y recién ahí se programa.',
        ],
        pista: 'Entender, planear, construir, verificar, publicar, sostener.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué garantiza la trazabilidad de requisitos?',
        opciones: [
          'Que cada requisito se pueda seguir hasta la prueba que lo verifica',
          'Que el código no tenga errores de sintaxis',
          'Que el proyecto termine en el plazo acordado',
          'Que el sistema soporte muchos usuarios a la vez',
        ],
        respuestaCorrecta:
            'Que cada requisito se pueda seguir hasta la prueba que lo verifica',
        explicacion: [
          'Un requisito sin prueba asociada no se puede demostrar ante el cliente.',
        ],
        pista: 'Conecta el inicio con el final del ciclo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El mantenimiento suele consumir más esfuerzo que el desarrollo inicial.',
        respuestaCorrecta: 'true',
        explicacion: [
          'A lo largo de la vida del sistema, sostenerlo cuesta más que construirlo.',
        ],
        pista: 'Piensa en cuántos años vive un sistema después de salir.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q112d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué documento registra qué puede salir mal, su probabilidad y su impacto?',
        opciones: [
          'La matriz de riesgos',
          'La matriz de trazabilidad',
          'El plan de pruebas',
          'El acta de constitución',
        ],
        respuestaCorrecta: 'La matriz de riesgos',
        explicacion: [
          'Casi ningún equipo la elabora, y su ausencia explica buena parte de los retrasos.',
        ],
        pista: 'Anticipa problemas antes de que ocurran.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-2-lec-1': [
      Ejercicio(
        id: 'q121a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la regla central del modelo en cascada?',
        opciones: [
          'Una fase termina, se documenta y se aprueba antes de iniciar la siguiente',
          'Todas las fases avanzan en paralelo',
          'Se entrega software funcionando cada dos semanas',
          'El cliente participa en la codificación diaria',
        ],
        respuestaCorrecta:
            'Una fase termina, se documenta y se aprueba antes de iniciar la siguiente',
        explicacion: [
          'El flujo avanza en una sola dirección, como el agua que cae.',
        ],
        pista: 'El agua no vuelve a subir.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la secuencia del modelo Waterfall?',
        opciones: [
          'Requisitos, Diseño, Implementación, Pruebas, Mantenimiento',
          'Sprint, Daily, Review, Retrospectiva',
          'Planificar, Hacer, Verificar, Actuar',
          'Construir, Medir, Aprender',
        ],
        respuestaCorrecta:
            'Requisitos, Diseño, Implementación, Pruebas, Mantenimiento',
        explicacion: [
          'Cada transición entre fases necesita una aprobación formal.',
        ],
        pista: 'Las otras tres pertenecen a otros marcos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En cascada el cliente ve el software funcionando desde las primeras semanas.',
        respuestaCorrecta: 'false',
        explicacion: [
          'El cliente ve el producto recién al final, y ahí aparecen los malentendidos.',
        ],
        pista: 'Las entregas tempranas son de otra metodología.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q121d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué en cascada corregir un error de requisitos sale caro?',
        opciones: [
          'Porque se detecta cuando ya está todo diseñado y programado',
          'Porque hay que cambiar de lenguaje de programación',
          'Porque el equipo debe contratar más personal',
          'Porque no existen herramientas de depuración',
        ],
        respuestaCorrecta:
            'Porque se detecta cuando ya está todo diseñado y programado',
        explicacion: [
          'Hay que retroceder, rehacer documentación y renegociar plazos.',
        ],
        pista: 'El costo viene de cuándo se detecta, no de qué se detecta.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-2-lec-2': [
      Ejercicio(
        id: 'q122a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿En qué escenario conviene usar cascada?',
        opciones: [
          'Requisitos fijados por una norma y que no van a cambiar',
          'Un producto nuevo cuyo alcance aún se está descubriendo',
          'Una startup que valida ideas con usuarios cada semana',
          'Un equipo que entrega funcionalidad cada tres días',
        ],
        respuestaCorrecta:
            'Requisitos fijados por una norma y que no van a cambiar',
        explicacion: [
          'Aeroespacial, salud y banca son los sectores donde cascada sigue siendo obligatorio.',
        ],
        pista: 'Cascada necesita certeza, no descubrimiento.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál NO es una ventaja del modelo en cascada?',
        opciones: [
          'Facilidad para incorporar cambios en cualquier momento',
          'Documentación completa de cada fase',
          'Estimación de costos confiable desde el inicio',
          'Auditorías sencillas porque todo deja evidencia',
        ],
        respuestaCorrecta:
            'Facilidad para incorporar cambios en cualquier momento',
        explicacion: [
          'La rigidez ante el cambio es justamente su principal desventaja.',
        ],
        pista: 'Tres son fortalezas reales; una es su punto débil.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Las metodologías ágiles siempre son mejores que cascada.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Depende de la incertidumbre del proyecto, no de la moda.',
          'En sectores regulados cascada sigue siendo la opción correcta.',
        ],
        pista: 'Piensa en el firmware de un equipo médico.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q122d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál es la pregunta correcta al elegir entre cascada y ágil?',
        opciones: [
          'Cuánta incertidumbre tiene el proyecto',
          'Cuál metodología está más de moda',
          'Cuántos programadores hay disponibles',
          'Qué lenguaje domina el equipo',
        ],
        respuestaCorrecta: 'Cuánta incertidumbre tiene el proyecto',
        explicacion: [
          'A mayor incertidumbre sobre los requisitos, más conviene un enfoque iterativo.',
        ],
        pista: 'No se trata de cuál es mejor en abstracto.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-3-lec-1': [
      Ejercicio(
        id: 'q131a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿En qué año se publicó el Manifiesto Ágil?',
        opciones: ['2001', '1995', '2010', '1987'],
        respuestaCorrecta: '2001',
        explicacion: [
          'Diecisiete profesionales se reunieron en Utah y redactaron cuatro valores.',
        ],
        pista: 'Comienzos de los dos mil.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estos NO es un valor del Manifiesto Ágil?',
        opciones: [
          'Documentación exhaustiva sobre software funcionando',
          'Personas e interacciones sobre procesos y herramientas',
          'Colaboración con el cliente sobre negociación contractual',
          'Respuesta al cambio sobre seguimiento de un plan',
        ],
        respuestaCorrecta:
            'Documentación exhaustiva sobre software funcionando',
        explicacion: [
          'El manifiesto dice exactamente lo contrario: software funcionando por encima de documentación.',
        ],
        pista: 'Uno está invertido.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Ser ágil significa no documentar nada.',
        respuestaCorrecta: 'false',
        explicacion: [
          'El manifiesto establece una jerarquía de prioridades, no una lista de cosas eliminables.',
          'Un equipo que no documenta nada no es ágil: es desordenado.',
        ],
        pista: '"Más que" no significa "en lugar de".',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q131d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué efecto han tenido los asistentes de IA sobre los ciclos ágiles?',
        opciones: [
          'Los han acortado: de sprints de semanas a iteraciones de horas',
          'Los han alargado por la complejidad añadida',
          'Han eliminado la necesidad de iterar',
          'No han tenido ningún efecto medible',
        ],
        respuestaCorrecta:
            'Los han acortado: de sprints de semanas a iteraciones de horas',
        explicacion: [
          'La retroalimentación llega mucho más rápido que antes.',
        ],
        pista: 'La velocidad de respuesta cambió.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-3-lec-2': [
      Ejercicio(
        id: 'q132a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Quién decide qué se construye y en qué orden en Scrum?',
        opciones: [
          'El Product Owner',
          'El Scrum Master',
          'El equipo de desarrollo',
          'El gerente de la empresa',
        ],
        respuestaCorrecta: 'El Product Owner',
        explicacion: [
          'El Product Owner prioriza el backlog. El equipo decide cómo implementarlo.',
        ],
        pista: 'Es quien responde por el valor del producto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'El Product Owner define la arquitectura técnica del sistema.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La arquitectura, el lenguaje y la forma de implementar los decide el equipo.',
          'El Product Owner decide el qué y el orden, no el cómo.',
        ],
        pista: 'Separa el qué del cómo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuáles son los cuatro eventos de Scrum?',
        opciones: [
          'Planificación, Daily, Review y Retrospectiva',
          'Análisis, Diseño, Desarrollo y Pruebas',
          'Planificar, Hacer, Verificar y Actuar',
          'Backlog, Sprint, Incremento y Entrega',
        ],
        respuestaCorrecta: 'Planificación, Daily, Review y Retrospectiva',
        explicacion: [
          'Las otras opciones corresponden al SDLC, al ciclo PHVA y a los artefactos.',
        ],
        pista: 'Son reuniones, no fases ni documentos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q132d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué Kanban suele funcionar mejor en equipos pequeños?',
        opciones: [
          'Porque no exige cubrir tres roles obligatorios como Scrum',
          'Porque permite trabajar sin ningún tipo de planificación',
          'Porque elimina la necesidad de hacer pruebas',
          'Porque solo sirve para proyectos de mantenimiento',
        ],
        respuestaCorrecta:
            'Porque no exige cubrir tres roles obligatorios como Scrum',
        explicacion: [
          'Con pocas personas, la estructura de Scrum pesa más de lo que ayuda.',
          'Kanban se apoya en un tablero y en limitar el trabajo en curso.',
        ],
        pista: 'Piensa en cuántas personas necesita Scrum para funcionar.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-4-lec-1': [
      Ejercicio(
        id: 'q141a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué hace la Integración Continua?',
        opciones: [
          'Compila y prueba automáticamente cada cambio subido al repositorio',
          'Publica el sistema en producción todos los viernes',
          'Genera la documentación técnica del proyecto',
          'Asigna las tareas del sprint a cada desarrollador',
        ],
        respuestaCorrecta:
            'Compila y prueba automáticamente cada cambio subido al repositorio',
        explicacion: [
          'Si algo se rompe, el equipo se entera en minutos en lugar de semanas.',
        ],
        pista: 'Ocurre cada vez que alguien sube código.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál es la diferencia entre Entrega Continua y Despliegue Continuo?',
        opciones: [
          'En la Entrega alguien aprueba el paso a producción; en el Despliegue sale solo',
          'La Entrega usa pruebas y el Despliegue no',
          'La Entrega es para móviles y el Despliegue para web',
          'No existe ninguna diferencia entre ambas',
        ],
        respuestaCorrecta:
            'En la Entrega alguien aprueba el paso a producción; en el Despliegue sale solo',
        explicacion: [
          'La diferencia está en quién aprieta el botón final.',
        ],
        pista: 'Piensa en la aprobación humana.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'En DevSecOps la seguridad se revisa al final, antes de publicar.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La seguridad se integra dentro del pipeline y se verifica en cada cambio.',
        ],
        pista: 'La idea es adelantar, no postergar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q141d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué problema histórico busca resolver DevOps?',
        opciones: [
          'La separación entre desarrollo y operaciones con objetivos opuestos',
          'La falta de lenguajes de programación modernos',
          'El alto costo de las licencias de software',
          'La escasez de bases de datos relacionales',
        ],
        respuestaCorrecta:
            'La separación entre desarrollo y operaciones con objetivos opuestos',
        explicacion: [
          'Desarrollo quiere entregar rápido y operaciones quiere estabilidad.',
        ],
        pista: '"En mi máquina funciona" contra "no lo subo a producción".',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-1-4-lec-2': [
      Ejercicio(
        id: 'q142a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es la infraestructura como código?',
        opciones: [
          'Escribir la configuración de servidores en archivos versionados',
          'Programar el sistema usando solo código abierto',
          'Contratar servidores en la nube por hora',
          'Documentar manualmente cómo se configuró cada servidor',
        ],
        respuestaCorrecta:
            'Escribir la configuración de servidores en archivos versionados',
        explicacion: [
          'Si un servidor falla, se levanta otro idéntico ejecutando ese archivo.',
          'La configuración deja de vivir en la cabeza de una persona.',
        ],
        pista: 'La clave está en que se versiona igual que el software.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuáles son las cuatro señales básicas a monitorear en producción?',
        opciones: [
          'Latencia, errores, tráfico y saturación',
          'Líneas de código, commits, ramas y etiquetas',
          'Costo, plazo, alcance y calidad',
          'Usuarios, ventas, ingresos y márgenes',
        ],
        respuestaCorrecta: 'Latencia, errores, tráfico y saturación',
        explicacion: [
          'Si esas cuatro están sanas, el sistema está sano.',
        ],
        pista: 'Todas describen el comportamiento del sistema en vivo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Si el cliente avisa que el sistema se cayó, el monitoreo funcionó bien.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Las alertas existen para que el equipo se entere antes que el usuario.',
        ],
        pista: 'Piensa en para qué sirve una alerta.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q142d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué ventaja principal aporta automatizar el despliegue?',
        opciones: [
          'Reduce el error humano y permite desplegar con más frecuencia',
          'Elimina la necesidad de escribir pruebas',
          'Hace innecesaria la documentación del sistema',
          'Garantiza que el software no tenga defectos',
        ],
        respuestaCorrecta:
            'Reduce el error humano y permite desplegar con más frecuencia',
        explicacion: [
          'Lo repetible se automatiza; lo manual es donde se cuelan los errores.',
        ],
        pista: 'Piensa en qué falla cuando alguien repite un proceso a mano.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // MUNDO 2 — NORMATIVAS Y CALIDAD
    // =================================================================

    'cap-2-1-lec-1': [
      Ejercicio(
        id: 'q211a',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Las normas ISO son leyes de obligado cumplimiento.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Son voluntarias. Lo que las vuelve casi obligatorias es que los contratos las exigen.',
        ],
        pista: 'Nadie te multa por no cumplirlas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué significa el prefijo ISO/IEC/IEEE en una norma?',
        opciones: [
          'Que la desarrollaron las tres organizaciones en conjunto',
          'Que es una norma exclusiva de ingeniería eléctrica',
          'Que reemplaza a tres normas anteriores',
          'Que solo aplica en Estados Unidos y Europa',
        ],
        respuestaCorrecta:
            'Que la desarrollaron las tres organizaciones en conjunto',
        explicacion: [
          'El prefijo indica quién participó en la elaboración del estándar.',
        ],
        pista: 'Los prefijos hablan de autoría, no de alcance.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué indica el año en ISO 9001:2015?',
        opciones: [
          'La versión vigente de la norma',
          'El año en que vence el certificado',
          'El número de países que la adoptaron',
          'La fecha límite para implementarla',
        ],
        respuestaCorrecta: 'La versión vigente de la norma',
        explicacion: [
          'Las normas se revisan y actualizan; el año identifica la edición.',
        ],
        pista: 'Es como el número de versión de un software.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q211d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué norma rige la seguridad de la información?',
        opciones: [
          'ISO/IEC 27001',
          'ISO/IEC 25010',
          'ISO/IEC/IEEE 29119',
          'ISO/IEC/IEEE 12207',
        ],
        respuestaCorrecta: 'ISO/IEC 27001',
        explicacion: [
          'La 25010 es calidad de producto, la 29119 pruebas y la 12207 ciclo de vida.',
        ],
        pista: 'Es la del SGSI.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-1-lec-2': [
      Ejercicio(
        id: 'q212a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el beneficio principal de aplicar una norma?',
        opciones: [
          'Sustituir la opinión subjetiva por criterios medibles',
          'Reducir el número de desarrolladores necesarios',
          'Eliminar por completo los defectos del software',
          'Acelerar la escritura de código',
        ],
        respuestaCorrecta:
            'Sustituir la opinión subjetiva por criterios medibles',
        explicacion: [
          'Sin norma, discutir si un software es bueno se reduce a preferencias personales.',
        ],
        pista: 'Piensa en cómo cambia una discusión cuando hay un criterio.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Por qué una entidad pública exige ISO 9001 en una licitación?',
        opciones: [
          'Para reducir su riesgo sin auditar internamente a cada proveedor',
          'Porque la ley ecuatoriana lo obliga en todos los casos',
          'Para que el proveedor pague una tarifa adicional',
          'Porque garantiza que el software no tendrá errores',
        ],
        respuestaCorrecta:
            'Para reducir su riesgo sin auditar internamente a cada proveedor',
        explicacion: [
          'La certificación funciona como una garantía verificada por un tercero.',
        ],
        pista: 'Piensa en el costo de auditar a veinte empresas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Sin estándar de documentación, el conocimiento se pierde cuando alguien renuncia.',
        respuestaCorrecta: 'true',
        explicacion: [
          'La norma funciona como memoria de la organización.',
        ],
        pista: 'Piensa en qué pasa si el único que entiende un módulo se va.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q212d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estos NO es un beneficio de las normas?',
        opciones: [
          'Garantizar que el proyecto termine antes de lo previsto',
          'Consistencia entre distintos equipos',
          'Confianza del cliente sin auditoría directa',
          'Obligar a medir y con ello habilitar la mejora',
        ],
        respuestaCorrecta:
            'Garantizar que el proyecto termine antes de lo previsto',
        explicacion: [
          'Ninguna norma promete acortar plazos. Prometen orden y consistencia.',
        ],
        pista: 'Una de las opciones promete algo que ninguna norma promete.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-2-lec-1': [
      Ejercicio(
        id: 'q221a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué certifica ISO 9001?',
        opciones: [
          'El sistema de gestión de la organización',
          'La calidad técnica del producto entregado',
          'La seguridad de la información del cliente',
          'El cumplimiento de los plazos del proyecto',
        ],
        respuestaCorrecta: 'El sistema de gestión de la organización',
        explicacion: [
          'ISO 9001 mira cómo trabaja la empresa; ISO/IEC 25010 mira el producto.',
        ],
        pista: 'No evalúa el software, evalúa a quien lo hace.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué significan las siglas del ciclo PHVA?',
        opciones: [
          'Planificar, Hacer, Verificar y Actuar',
          'Producir, Habilitar, Validar y Ajustar',
          'Planear, Hacer, Validar y Auditar',
          'Prever, Hacer, Verificar y Aprobar',
        ],
        respuestaCorrecta: 'Planificar, Hacer, Verificar y Actuar',
        explicacion: [
          'Es la herramienta central de la norma para la mejora continua.',
        ],
        pista: 'También se conoce como ciclo de Deming.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Implementar ISO 9001 consiste básicamente en redactar manuales.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La documentación es la evidencia, no el objetivo.',
          'Si un proceso está escrito pero nadie lo sigue, se levanta una no conformidad.',
        ],
        pista: 'El auditor verifica lo que se hace, no solo lo que se escribe.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q221d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuánto tiempo es válido un certificado ISO 9001?',
        opciones: [
          'Tres años, con auditorías de seguimiento anuales',
          'Un año, renovable indefinidamente',
          'Cinco años, sin auditorías intermedias',
          'De forma permanente una vez obtenido',
        ],
        respuestaCorrecta: 'Tres años, con auditorías de seguimiento anuales',
        explicacion: [
          'La vigilancia periódica asegura que el sistema se mantenga vivo.',
        ],
        pista: 'No es permanente ni anual.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-2-lec-2': [
      Ejercicio(
        id: 'q222a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuántas características de calidad define ISO/IEC 25010?',
        opciones: ['Ocho', 'Cuatro', 'Seis', 'Doce'],
        respuestaCorrecta: 'Ocho',
        explicacion: [
          'Adecuación funcional, desempeño, compatibilidad, usabilidad, fiabilidad, seguridad, mantenibilidad y portabilidad.',
        ],
        pista: 'Más de seis y menos de diez.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estos requisitos no funcionales está bien escrito?',
        opciones: [
          'El 95 % de las consultas responde en menos de 2 segundos con 100 usuarios simultáneos',
          'El sistema debe ser rápido',
          'La aplicación debe ser fácil de usar',
          'El software debe tener buen rendimiento',
        ],
        respuestaCorrecta:
            'El 95 % de las consultas responde en menos de 2 segundos con 100 usuarios simultáneos',
        explicacion: [
          'Un requisito no funcional sirve solo si se puede verificar con un número.',
        ],
        pista: 'Busca el que se puede comprobar con una medición.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'ISO 9001 e ISO/IEC 25010 evalúan exactamente lo mismo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'ISO 9001 evalúa el proceso de la organización; ISO/IEC 25010, el producto resultante.',
        ],
        pista: 'Una mira la empresa, la otra el software.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q222d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿En qué se subdivide la mantenibilidad según ISO/IEC 25010?',
        opciones: [
          'Modularidad, reusabilidad, analizabilidad, modificabilidad y capacidad de ser probado',
          'Latencia, errores, tráfico y saturación',
          'Confidencialidad, integridad y disponibilidad',
          'Correctivo, adaptativo, perfectivo y preventivo',
        ],
        respuestaCorrecta:
            'Modularidad, reusabilidad, analizabilidad, modificabilidad y capacidad de ser probado',
        explicacion: [
          'Esa descomposición es lo que permite medir en lugar de opinar.',
        ],
        pista: 'Las otras opciones pertenecen a otros temas de la materia.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-3-lec-1': [
      Ejercicio(
        id: 'q231a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué significa la triada CIA?',
        opciones: [
          'Confidencialidad, Integridad y Disponibilidad',
          'Control, Inspección y Auditoría',
          'Cifrado, Identificación y Autenticación',
          'Calidad, Innovación y Agilidad',
        ],
        respuestaCorrecta: 'Confidencialidad, Integridad y Disponibilidad',
        explicacion: [
          'Es el fundamento de toda la seguridad de la información.',
        ],
        pista: 'La A final viene de disponibilidad en inglés.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Que nadie pueda modificar una calificación sin dejar rastro corresponde a:',
        opciones: [
          'Integridad',
          'Confidencialidad',
          'Disponibilidad',
          'Portabilidad',
        ],
        respuestaCorrecta: 'Integridad',
        explicacion: [
          'La integridad protege los datos de alteraciones no autorizadas.',
        ],
        pista: 'No es sobre quién ve el dato, sino sobre quién lo cambia.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Se pueden maximizar la confidencialidad, la integridad y la disponibilidad al mismo tiempo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Las tres compiten entre sí: reforzar una suele debilitar otra.',
          'Diseñar seguridad es decidir dónde equilibrarlas.',
        ],
        pista: 'Piensa en qué pasa si cifras todo y pierdes la clave.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q231d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Que el sistema de notas funcione el día del cierre de actas corresponde a:',
        opciones: [
          'Disponibilidad',
          'Integridad',
          'Confidencialidad',
          'Trazabilidad',
        ],
        respuestaCorrecta: 'Disponibilidad',
        explicacion: [
          'La información debe estar accesible justo cuando se la necesita.',
        ],
        pista: 'Es el día en que todos entran al mismo tiempo.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-3-lec-2': [
      Ejercicio(
        id: 'q232a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué significa SGSI?',
        opciones: [
          'Sistema de Gestión de Seguridad de la Información',
          'Servicio General de Soporte Informático',
          'Sistema Global de Seguimiento de Incidentes',
          'Software de Gestión de Servicios Internos',
        ],
        respuestaCorrecta:
            'Sistema de Gestión de Seguridad de la Información',
        explicacion: [
          'Es lo que ISO/IEC 27001 exige establecer y mantener.',
        ],
        pista: 'Sigue la misma lógica de sistema de gestión que ISO 9001.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'ISO/IEC 27001 obliga a aplicar todos los controles de su anexo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Se seleccionan los controles que el análisis de riesgos justifica.',
          'Los descartes se documentan en la Declaración de Aplicabilidad.',
        ],
        pista: 'El análisis de riesgos decide cuáles aplicar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cómo se llama el documento que justifica qué controles se aplican y cuáles no?',
        opciones: [
          'Declaración de Aplicabilidad',
          'Matriz de trazabilidad',
          'Plan de continuidad',
          'Acta de constitución',
        ],
        respuestaCorrecta: 'Declaración de Aplicabilidad',
        explicacion: [
          'Es uno de los documentos que el auditor revisa primero.',
        ],
        pista: 'Declara qué aplica y qué no.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q232d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es un control de seguridad aplicado al desarrollo?',
        opciones: [
          'Analizar automáticamente las vulnerabilidades de las dependencias',
          'Aumentar el número de sprints del proyecto',
          'Reducir la documentación técnica',
          'Contratar más personal de soporte',
        ],
        respuestaCorrecta:
            'Analizar automáticamente las vulnerabilidades de las dependencias',
        explicacion: [
          'Revisar el código y controlar el acceso al repositorio también son controles.',
        ],
        pista: 'Debe responder a un riesgo concreto de seguridad.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-4-lec-1': [
      Ejercicio(
        id: 'q241a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estos es un proceso primario según ISO 12207?',
        opciones: [
          'Desarrollo',
          'Documentación',
          'Gestión de configuración',
          'Aseguramiento de la calidad',
        ],
        respuestaCorrecta: 'Desarrollo',
        explicacion: [
          'Los otros tres son procesos de soporte: no producen el producto pero lo sostienen.',
        ],
        pista: 'Los primarios producen valor directo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'ISO 12207 obliga a usar una metodología específica de desarrollo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Define qué resultados debe producir cada proceso, no cómo lograrlos.',
          'Por eso es compatible tanto con cascada como con Scrum.',
        ],
        pista: 'La norma habla de resultados, no de recetas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué se define en el proceso de acuerdo?',
        opciones: [
          'Alcance, criterios de aceptación, plazos y responsabilidades',
          'La arquitectura técnica del sistema',
          'El lenguaje de programación a utilizar',
          'La estrategia de despliegue en producción',
        ],
        respuestaCorrecta:
            'Alcance, criterios de aceptación, plazos y responsabilidades',
        explicacion: [
          'Casi todos los conflictos al entregar nacen de haberse saltado este proceso.',
        ],
        pista: 'Ocurre antes de escribir una línea de código.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q241d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué abarca el proceso de desarrollo en ISO 12207?',
        opciones: [
          'Desde el análisis de requisitos hasta la integración',
          'Solo la escritura de código fuente',
          'Únicamente las pruebas de aceptación',
          'La gestión contractual con el cliente',
        ],
        respuestaCorrecta: 'Desde el análisis de requisitos hasta la integración',
        explicacion: [
          'Programar es una parte del proceso de desarrollo, no todo el proceso.',
        ],
        pista: 'Es más amplio que solo codificar.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-2-4-lec-2': [
      Ejercicio(
        id: 'q242a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la diferencia entre verificar y validar?',
        opciones: [
          'Verificar es construirlo bien; validar es construir lo correcto',
          'Verificar lo hace el cliente; validar lo hace el programador',
          'Verificar se aplica al código; validar solo a la documentación',
          'Son dos nombres para la misma actividad',
        ],
        respuestaCorrecta:
            'Verificar es construirlo bien; validar es construir lo correcto',
        explicacion: [
          'Un sistema puede pasar toda la verificación y fallar la validación.',
        ],
        pista: 'Una pregunta por el cómo, la otra por el qué.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'El sistema calcula el promedio tal como decía el requisito, pero el reglamento pondera las notas y nadie lo preguntó. ¿Qué falló?',
        opciones: [
          'La validación',
          'La verificación',
          'La integración',
          'El despliegue',
        ],
        respuestaCorrecta: 'La validación',
        explicacion: [
          'El código está bien construido pero el producto no resuelve la necesidad real.',
        ],
        pista: 'Se construyó bien algo equivocado.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué controla la gestión de configuración?',
        opciones: [
          'Versiones, cambios y líneas base',
          'El presupuesto del proyecto',
          'La contratación del equipo',
          'La satisfacción del cliente',
        ],
        respuestaCorrecta: 'Versiones, cambios y líneas base',
        explicacion: [
          'Sin ella, nadie sabe qué versión está en producción ni qué cambió.',
        ],
        pista: 'Tiene que ver con el control de lo que existe y de lo que cambia.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q242d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Los procesos de soporte no producen el producto, pero sin ellos no se puede sostener.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Documentación, configuración, calidad, verificación y validación son de soporte.',
        ],
        pista: 'Piensa en qué pasa sin documentación ni control de versiones.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // MUNDO 3 — PRUEBAS, IMPLEMENTACIÓN Y MANTENIMIENTO
    // =================================================================

    'cap-3-1-lec-1': [
      Ejercicio(
        id: 'q311a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué verifica una prueba unitaria?',
        opciones: [
          'Una función o método aislado, sin dependencias externas',
          'El sistema completo con todos sus módulos integrados',
          'La experiencia del usuario final en producción',
          'La capacidad del servidor bajo carga',
        ],
        respuestaCorrecta:
            'Una función o método aislado, sin dependencias externas',
        explicacion: [
          'Sin base de datos, sin red y sin depender de otros módulos.',
        ],
        pista: 'Es la prueba más pequeña de todas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Para qué sirve un doble de prueba en una prueba unitaria?',
        opciones: [
          'Para sustituir lo externo y que la prueba no dependa de nada más',
          'Para ejecutar la prueba dos veces y confirmar el resultado',
          'Para repartir la prueba entre dos desarrolladores',
          'Para comparar dos versiones del mismo código',
        ],
        respuestaCorrecta:
            'Para sustituir lo externo y que la prueba no dependa de nada más',
        explicacion: [
          'Así la prueba nunca falla porque el servidor esté caído.',
        ],
        pista: 'Reemplaza aquello que la función necesita del exterior.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Las pruebas unitarias son lentas, por eso se ejecutan solo una vez por sprint.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Corren en segundos, y por eso se ejecutan en cada cambio dentro del pipeline.',
        ],
        pista: 'Su principal virtud es la velocidad.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q311d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Al probar una función que valida cédulas, ¿qué casos encuentran más defectos?',
        opciones: [
          'Los casos límite: vacío, longitud incorrecta, letras',
          'Solo el caso de una cédula válida',
          'Repetir muchas veces el mismo caso correcto',
          'Probar con cédulas de otros países únicamente',
        ],
        respuestaCorrecta:
            'Los casos límite: vacío, longitud incorrecta, letras',
        explicacion: [
          'El caso feliz casi siempre funciona. Los raros son los que rompen el código.',
        ],
        pista: 'Los errores viven en los bordes.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-1-lec-2': [
      Ejercicio(
        id: 'q312a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué verifican las pruebas de integración?',
        opciones: [
          'Que los módulos se comuniquen correctamente entre sí',
          'Que cada función devuelva el valor esperado por separado',
          'Que el usuario final quede satisfecho con la interfaz',
          'Que el servidor soporte mil usuarios simultáneos',
        ],
        respuestaCorrecta:
            'Que los módulos se comuniquen correctamente entre sí',
        explicacion: [
          'Cada módulo puede estar perfecto por separado y fallar al conectarse.',
        ],
        pista: 'El problema está en la interfaz entre partes.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Usuarios envía la fecha como 14/09/2026 y Reportes la espera como 2026-09-14. ¿Qué tipo de fallo es?',
        opciones: [
          'De integración',
          'Unitario',
          'De aceptación',
          'De rendimiento',
        ],
        respuestaCorrecta: 'De integración',
        explicacion: [
          'Ambos módulos pasan sus pruebas unitarias; juntos producen datos incorrectos.',
        ],
        pista: 'Cada parte funciona sola.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la ventaja de la integración incremental?',
        opciones: [
          'Es más fácil aislar dónde está el fallo',
          'Es más rápida de montar que la big bang',
          'No requiere escribir pruebas unitarias antes',
          'Elimina la necesidad de pruebas de sistema',
        ],
        respuestaCorrecta: 'Es más fácil aislar dónde está el fallo',
        explicacion: [
          'Con big bang, si algo falla la depuración se vuelve una búsqueda a ciegas.',
        ],
        pista: 'Integrar de a poco te dice dónde se rompió.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q312d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Si todos los módulos pasan sus pruebas unitarias, la integración también funcionará.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Las pruebas unitarias no detectan diferencias de interpretación entre módulos.',
        ],
        pista: 'Recuerda el caso del formato de fecha.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-1-lec-3': [
      Ejercicio(
        id: 'q313a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Quién ejecuta la prueba de aceptación del usuario (UAT)?',
        opciones: [
          'El cliente o el usuario final',
          'El equipo de desarrollo',
          'El administrador del servidor',
          'Un organismo certificador externo',
        ],
        respuestaCorrecta: 'El cliente o el usuario final',
        explicacion: [
          'Su pregunta no es si cumple la especificación, sino si resuelve el problema.',
        ],
        pista: 'La U de UAT es de usuario.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué evalúa la prueba de sistema?',
        opciones: [
          'El producto completo contra los requisitos, en un entorno similar a producción',
          'Solo las funciones individuales del código',
          'Únicamente la comunicación entre dos módulos',
          'La rentabilidad económica del proyecto',
        ],
        respuestaCorrecta:
            'El producto completo contra los requisitos, en un entorno similar a producción',
        explicacion: [
          'Cubre tanto los requisitos funcionales como los no funcionales.',
        ],
        pista: 'Es el nivel anterior a la UAT.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Los criterios de aceptación deben escribirse antes de la UAT.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Sin ellos, la prueba se convierte en una opinión sobre si al cliente le gustó.',
        ],
        pista: 'Sin criterio previo no se puede cerrar la prueba.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q313d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué la UAT es la última oportunidad de detectar algo?',
        opciones: [
          'Porque puede revelar que se construyó algo correcto pero inútil',
          'Porque después ya no se pueden corregir errores de sintaxis',
          'Porque es la única prueba que revisa el rendimiento',
          'Porque después el sistema pasa a mantenimiento correctivo',
        ],
        respuestaCorrecta:
            'Porque puede revelar que se construyó algo correcto pero inútil',
        explicacion: [
          'La UAT valida utilidad real, no cumplimiento de especificación.',
        ],
        pista: 'Piensa en la diferencia entre verificar y validar.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-2-lec-1': [
      Ejercicio(
        id: 'q321a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué caracteriza a la prueba de caja blanca?',
        opciones: [
          'El tester conoce el código y diseña casos según su estructura',
          'El tester solo conoce la especificación funcional',
          'La ejecuta siempre el usuario final',
          'No requiere diseñar casos de prueba',
        ],
        respuestaCorrecta:
            'El tester conoce el código y diseña casos según su estructura',
        explicacion: [
          'El objetivo es recorrer sentencias, ramas y caminos lógicos.',
        ],
        pista: 'La caja es transparente: se ve lo de adentro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Una cobertura del 100 % garantiza que el software es correcto.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Se puede ejecutar todo el código sin comprobar ni un solo resultado.',
          'La cobertura dice qué se recorrió, no qué se verificó.',
        ],
        pista: 'Recorrer no es lo mismo que comprobar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Si una condición if solo se prueba en su camino verdadero, ¿qué cobertura de ramas se alcanza?',
        opciones: ['50 %', '100 %', '0 %', '75 %'],
        respuestaCorrecta: '50 %',
        explicacion: [
          'Cada decisión necesita probarse en ambos sentidos para cubrirse por completo.',
        ],
        pista: 'Falta la mitad de los caminos posibles.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q321d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la diferencia entre cobertura de sentencias y de ramas?',
        opciones: [
          'Sentencias mide líneas ejecutadas; ramas mide decisiones probadas en ambos sentidos',
          'Sentencias se aplica a Java y ramas a Python',
          'Sentencias la calcula el tester y ramas el desarrollador',
          'No existe ninguna diferencia entre ambas',
        ],
        respuestaCorrecta:
            'Sentencias mide líneas ejecutadas; ramas mide decisiones probadas en ambos sentidos',
        explicacion: [
          'La cobertura de ramas es más exigente que la de sentencias.',
        ],
        pista: 'Una cuenta líneas, la otra cuenta caminos.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-2-lec-2': [
      Ejercicio(
        id: 'q322a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Desde qué diseña sus casos la prueba de caja negra?',
        opciones: [
          'Desde la especificación, sin ver el código',
          'Desde el código fuente línea por línea',
          'Desde los registros del servidor en producción',
          'Desde las métricas de cobertura',
        ],
        respuestaCorrecta: 'Desde la especificación, sin ver el código',
        explicacion: [
          'Es la mirada del usuario: estas entradas deben producir estas salidas.',
        ],
        pista: 'La caja está cerrada.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Si se aprueba con 7 sobre 10, ¿qué valores límite conviene probar?',
        opciones: [
          '6,99, 7 y 7,01',
          '0, 5 y 10',
          'Solo el 7',
          '1, 2 y 3',
        ],
        respuestaCorrecta: '6,99, 7 y 7,01',
        explicacion: [
          'Ahí vive el error clásico de escribir mayor que cuando debía ser mayor o igual.',
        ],
        pista: 'Los bordes de la frontera entre aprobar y reprobar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué son las clases de equivalencia?',
        opciones: [
          'Grupos de entradas que el sistema debería tratar igual',
          'Categorías de defectos según su severidad',
          'Niveles de acceso de los usuarios del sistema',
          'Tipos de pruebas ordenados por costo',
        ],
        respuestaCorrecta:
            'Grupos de entradas que el sistema debería tratar igual',
        explicacion: [
          'Se prueba un representante de cada grupo en lugar de todos los casos.',
        ],
        pista: 'Sirven para no probar mil casos equivalentes.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q322d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La prueba de caja gris combina conocimiento parcial del código con el enfoque de caja negra.',
        respuestaCorrecta: 'true',
        explicacion: [
          'El tester conoce parte de la estructura interna pero prueba desde afuera.',
        ],
        pista: 'El nombre da la pista: entre blanco y negro.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-3-lec-1': [
      Ejercicio(
        id: 'q331a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es el orden correcto de los estados de un defecto?',
        opciones: [
          'Nuevo, Asignado, En progreso, Resuelto, Verificado, Cerrado',
          'Asignado, Nuevo, Resuelto, En progreso, Cerrado, Verificado',
          'Nuevo, Resuelto, Asignado, Cerrado, Verificado, En progreso',
          'En progreso, Nuevo, Asignado, Verificado, Resuelto, Cerrado',
        ],
        respuestaCorrecta:
            'Nuevo, Asignado, En progreso, Resuelto, Verificado, Cerrado',
        explicacion: [
          'Puede además rechazarse si no era un defecto, o diferirse a otra versión.',
        ],
        pista: 'Se reporta, se asigna, se arregla, se confirma.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué debe incluir un buen reporte de defecto?',
        opciones: [
          'Pasos para reproducir, resultado esperado y resultado obtenido',
          'Solo una descripción general del problema',
          'El nombre del desarrollador responsable del módulo',
          'Una estimación del tiempo de corrección',
        ],
        respuestaCorrecta:
            'Pasos para reproducir, resultado esperado y resultado obtenido',
        explicacion: [
          'Un reporte que dice "no funciona" obliga a investigar desde cero.',
        ],
        pista: 'Quien lo lea debe poder reproducirlo sin preguntar nada.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Quien corrige un defecto puede ser la misma persona que verifica la corrección.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La verificación la realiza alguien distinto de quien implementó el arreglo.',
        ],
        pista: 'Piensa en por qué existe la revisión independiente.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q331d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué estado recibe un defecto que se decide corregir en una versión futura?',
        opciones: ['Diferido', 'Rechazado', 'Cerrado', 'Verificado'],
        respuestaCorrecta: 'Diferido',
        explicacion: [
          'Rechazado se usa cuando resulta que no era un defecto real.',
        ],
        pista: 'No se descarta, se posterga.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-3-lec-2': [
      Ejercicio(
        id: 'q332a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué mide la severidad de un defecto?',
        opciones: [
          'El impacto técnico sobre el funcionamiento del sistema',
          'La urgencia con la que el negocio necesita la corrección',
          'El tiempo que tomará repararlo',
          'El costo económico de la reparación',
        ],
        respuestaCorrecta:
            'El impacto técnico sobre el funcionamiento del sistema',
        explicacion: [
          'La urgencia es prioridad, que es una dimensión distinta.',
        ],
        pista: 'Responde a cuánto se rompe.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'El nombre de la universidad aparece mal escrito y el sistema se presenta mañana. ¿Cómo se clasifica?',
        opciones: [
          'Severidad baja, prioridad alta',
          'Severidad alta, prioridad alta',
          'Severidad alta, prioridad baja',
          'Severidad baja, prioridad baja',
        ],
        respuestaCorrecta: 'Severidad baja, prioridad alta',
        explicacion: [
          'No deja de funcionar nada, pero debe arreglarse antes de la presentación.',
        ],
        pista: 'Nada se rompe, pero no puede salir así.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Severidad y prioridad siempre coinciden.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Son dimensiones independientes y las cuatro combinaciones ocurren en la práctica.',
        ],
        pista: 'Piensa en un error de ortografía urgente.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q332d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Quién asigna la prioridad de un defecto?',
        opciones: [
          'El responsable del producto, según el criterio del negocio',
          'El tester que lo encontró',
          'El desarrollador que lo va a corregir',
          'El administrador de la base de datos',
        ],
        respuestaCorrecta:
            'El responsable del producto, según el criterio del negocio',
        explicacion: [
          'El tester fija la severidad; la prioridad es una decisión de negocio.',
        ],
        pista: 'La urgencia la define quien responde por el producto.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-4-lec-1': [
      Ejercicio(
        id: 'q341a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué estrategia libera la versión nueva a un porcentaje pequeño de usuarios?',
        opciones: ['Canary', 'Big bang', 'Blue-green', 'Rolling'],
        respuestaCorrecta: 'Canary',
        explicacion: [
          'Si las métricas se mantienen sanas, se amplía gradualmente al resto.',
        ],
        pista: 'El nombre viene de los canarios en las minas.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué caracteriza al despliegue blue-green?',
        opciones: [
          'Dos entornos idénticos entre los que se conmuta el tráfico',
          'Actualizar los servidores por tandas sucesivas',
          'Liberar primero a un 5 % de los usuarios',
          'Reemplazar toda la versión de una sola vez',
        ],
        respuestaCorrecta:
            'Dos entornos idénticos entre los que se conmuta el tráfico',
        explicacion: [
          'Permite revertir en segundos volviendo a apuntar al entorno anterior.',
        ],
        pista: 'Son dos, y se cambia de uno al otro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Para qué sirven las feature flags?',
        opciones: [
          'Desplegar el código desactivado y encenderlo por configuración',
          'Marcar qué funciones están documentadas',
          'Etiquetar las versiones en el repositorio',
          'Medir cuántos usuarios usan cada función',
        ],
        respuestaCorrecta:
            'Desplegar el código desactivado y encenderlo por configuración',
        explicacion: [
          'Separan el riesgo de desplegar del riesgo de activar.',
        ],
        pista: 'Son un interruptor.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q341d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Un sistema con usuarios en varios husos horarios puede desplegarse con big bang sin riesgo.',
        respuestaCorrecta: 'false',
        explicacion: [
          'No existe una ventana sin tráfico, así que conviene rolling o canary.',
        ],
        pista: 'Piensa en si hay alguna hora en que nadie esté conectado.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-4-lec-2': [
      Ejercicio(
        id: 'q342a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo debe escribirse el plan de rollback?',
        opciones: [
          'Antes de desplegar, cuando todo está tranquilo',
          'Durante el incidente, según lo que vaya ocurriendo',
          'Después de revertir, como lección aprendida',
          'No hace falta escribirlo si el equipo tiene experiencia',
        ],
        respuestaCorrecta: 'Antes de desplegar, cuando todo está tranquilo',
        explicacion: [
          'Bajo presión nadie razona bien; el plan debe existir de antemano.',
        ],
        pista: 'No se improvisa en la crisis.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la parte más difícil de revertir en un despliegue?',
        opciones: [
          'Los cambios de esquema en la base de datos',
          'El código fuente de la aplicación',
          'La configuración del servidor web',
          'Los archivos de imágenes y recursos',
        ],
        respuestaCorrecta: 'Los cambios de esquema en la base de datos',
        explicacion: [
          'Revertir código es sencillo; revertir datos casi nunca lo es.',
        ],
        pista: 'Piensa en qué pasa con los datos ya guardados.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Cuál es una forma segura de cambiar el nombre de una columna?',
        opciones: [
          'Crear la nueva y mantener ambas durante una versión',
          'Renombrarla directamente en producción',
          'Eliminar la vieja y crear la nueva en el mismo despliegue',
          'Esperar a que nadie use el sistema y renombrarla',
        ],
        respuestaCorrecta:
            'Crear la nueva y mantener ambas durante una versión',
        explicacion: [
          'Si hay que revertir, el código anterior sigue encontrando la columna que espera.',
        ],
        pista: 'Convivencia temporal entre lo viejo y lo nuevo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q342d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué debe definir un plan de rollback completo?',
        opciones: [
          'Criterio que lo dispara, quién decide, pasos técnicos y a quién se avisa',
          'Solo los comandos necesarios para revertir el código',
          'Únicamente el nombre del responsable de la reversión',
          'El presupuesto asignado a la recuperación',
        ],
        respuestaCorrecta:
            'Criterio que lo dispara, quién decide, pasos técnicos y a quién se avisa',
        explicacion: [
          'El criterio debe ser objetivo, por ejemplo una tasa de error durante cinco minutos.',
        ],
        pista: 'Son cuatro cosas, no una.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-5-lec-1': [
      Ejercicio(
        id: 'q351a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Cambia el reglamento y hay que ajustar la nota mínima de aprobación. ¿Qué tipo de mantenimiento es?',
        opciones: ['Adaptativo', 'Correctivo', 'Perfectivo', 'Preventivo'],
        respuestaCorrecta: 'Adaptativo',
        explicacion: [
          'El adaptativo responde a cambios del entorno técnico o normativo.',
        ],
        pista: 'El software no falló: cambió lo de afuera.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Los docentes piden poder exportar las actas a Excel. ¿Qué tipo de mantenimiento es?',
        opciones: ['Perfectivo', 'Correctivo', 'Adaptativo', 'Preventivo'],
        respuestaCorrecta: 'Perfectivo',
        explicacion: [
          'El perfectivo agrega funcionalidad o mejora el rendimiento a pedido del usuario.',
        ],
        pista: 'Nada está roto, se quiere algo nuevo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Se refactoriza un módulo porque su complejidad hace riesgoso cualquier cambio. ¿Qué tipo es?',
        opciones: ['Preventivo', 'Correctivo', 'Perfectivo', 'Adaptativo'],
        respuestaCorrecta: 'Preventivo',
        explicacion: [
          'El preventivo corrige defectos latentes antes de que se manifiesten.',
        ],
        pista: 'Se arregla algo que aún no falla.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q351d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El mantenimiento correctivo es el que más esfuerzo consume de los cuatro tipos.',
        respuestaCorrecta: 'false',
        explicacion: [
          'La mayor parte del trabajo es perfectivo y adaptativo.',
          'Arreglar bugs ocupa mucho menos de lo que suele imaginarse.',
        ],
        pista: 'Esto rompe la intuición de casi todos.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-3-5-lec-2': [
      Ejercicio(
        id: 'q352a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué define un acuerdo de nivel de servicio (SLA)?',
        opciones: [
          'Tiempos máximos de respuesta y solución según la criticidad',
          'El sueldo del equipo de soporte',
          'La arquitectura técnica del sistema',
          'El número de usuarios que puede atender el servidor',
        ],
        respuestaCorrecta:
            'Tiempos máximos de respuesta y solución según la criticidad',
        explicacion: [
          'Sin SLA, la atención depende de quién reclame con más fuerza.',
        ],
        pista: 'Es un compromiso de tiempos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Toda solicitud de mantenimiento debe registrarse, clasificarse y priorizarse.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Sin registro no hay métricas, y sin métricas no hay mejora posible.',
        ],
        pista: 'Nada se atiende por mensaje directo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué pasa con la deuda técnica si no se planifica?',
        opciones: [
          'Se acumula hasta hacer riesgoso cualquier cambio',
          'Desaparece sola con el tiempo',
          'Se resuelve al cambiar de framework',
          'Solo afecta al rendimiento del servidor',
        ],
        respuestaCorrecta:
            'Se acumula hasta hacer riesgoso cualquier cambio',
        explicacion: [
          'Por eso el mantenimiento preventivo debe entrar en la planificación.',
        ],
        pista: 'Es una deuda: si no se paga, crece.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q352d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'En un SLA típico, ¿qué tiempo de respuesta corresponde a un incidente crítico?',
        opciones: ['1 hora', '3 días', '1 semana', 'La próxima versión'],
        respuestaCorrecta: '1 hora',
        explicacion: [
          'Crítico: respuesta en 1 hora y solución en 8. Los tiempos se pactan de antemano.',
        ],
        pista: 'Es el nivel más urgente de todos.',
        xpPorRespuesta: 10,
      ),
    ],

    // =================================================================
    // MUNDO 4 — MÉTRICAS DE PROYECTOS
    // =================================================================

    'cap-4-1-lec-1': [
      Ejercicio(
        id: 'q411a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '"45 defectos reportados este mes" es un ejemplo de:',
        opciones: ['Una medida', 'Una métrica', 'Un indicador', 'Un umbral'],
        respuestaCorrecta: 'Una medida',
        explicacion: [
          'Una medida es un dato crudo obtenido por observación directa.',
        ],
        pista: 'Todavía no se combinó con nada.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '"2,1 defectos por cada mil líneas de código" es:',
        opciones: ['Una métrica', 'Una medida', 'Un indicador', 'Una línea base'],
        respuestaCorrecta: 'Una métrica',
        explicacion: [
          'Una métrica combina medidas mediante una fórmula para producir algo interpretable.',
        ],
        pista: 'Ya hay una división de por medio.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '"El objetivo era 2,0 y estamos en 2,1, hay que revisar" es:',
        opciones: ['Un indicador', 'Una medida', 'Una métrica', 'Un defecto'],
        respuestaCorrecta: 'Un indicador',
        explicacion: [
          'Un indicador compara la métrica contra un objetivo y habilita una decisión.',
        ],
        pista: 'Hay una comparación contra una meta.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q411d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Una métrica sin umbral definido permite tomar decisiones.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Sin umbral es un número que nadie sabe si es bueno o malo.',
        ],
        pista: 'Falta el punto de comparación.',
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
          'De entrada, de salida y de control',
          'Técnicas, económicas y humanas',
          'Primarias, secundarias y terciarias',
        ],
        respuestaCorrecta: 'De producto, de proceso y de proyecto',
        explicacion: [
          'Producto mide el software, proceso mide cómo se trabaja y proyecto mide la gestión.',
        ],
        pista: 'Las tres empiezan con la misma letra.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué ventaja tienen los puntos de función sobre las líneas de código?',
        opciones: [
          'Permiten comparar proyectos escritos en lenguajes distintos',
          'Son más fáciles de contar automáticamente',
          'Miden la calidad del código además del tamaño',
          'No requieren conocer los requisitos del sistema',
        ],
        respuestaCorrecta:
            'Permiten comparar proyectos escritos en lenguajes distintos',
        explicacion: [
          'ISO/IEC 20968 mide el tamaño según lo que el sistema hace, no cuántas líneas tiene.',
        ],
        pista: 'Mil líneas de un lenguaje no equivalen a mil de otro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué ocurre si se mide la productividad por líneas de código escritas?',
        opciones: [
          'Los programadores producen código innecesariamente extenso',
          'La calidad del software mejora automáticamente',
          'Se reduce el tiempo de desarrollo',
          'Aumenta la cobertura de pruebas',
        ],
        respuestaCorrecta:
            'Los programadores producen código innecesariamente extenso',
        explicacion: [
          'Cuando una métrica se convierte en objetivo, se optimiza el número y no el resultado.',
        ],
        pista: 'La gente optimiza aquello por lo que se la mide.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q412d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'El tiempo de ciclo y la frecuencia de despliegue son métricas de proceso.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Miden cómo trabaja el equipo, no el producto ni la gestión del proyecto.',
        ],
        pista: 'Describen la forma de trabajar.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-2-lec-1': [
      Ejercicio(
        id: 'q421a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué es la línea base de un proyecto?',
        opciones: [
          'La versión aprobada del alcance, el cronograma y el presupuesto',
          'El primer commit del repositorio de código',
          'La versión inicial del sistema en producción',
          'El conjunto mínimo de funciones que debe tener el producto',
        ],
        respuestaCorrecta:
            'La versión aprobada del alcance, el cronograma y el presupuesto',
        explicacion: [
          'Contra ella se mide todo el avance posterior.',
        ],
        pista: 'Es un punto de referencia acordado.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta: 'Sin línea base no se puede afirmar que un proyecto va retrasado.',
        respuestaCorrecta: 'true',
        explicacion: [
          'Si nunca se acordó cuándo había que terminar, no hay contra qué comparar.',
        ],
        pista: 'El retraso es relativo a algo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cómo puede cambiar legítimamente una línea base?',
        opciones: [
          'Mediante un procedimiento formal de control de cambios',
          'Cuando el equipo lo considere necesario',
          'Automáticamente al final de cada sprint',
          'Solo si el proyecto se cancela',
        ],
        respuestaCorrecta:
            'Mediante un procedimiento formal de control de cambios',
        explicacion: [
          'Se solicita, se evalúa el impacto, se aprueba o rechaza y se replantea.',
        ],
        pista: 'Requiere evaluación y aprobación.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q421d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'El cliente pide quince funciones pequeñas que el equipo acepta sin evaluar. ¿Qué ocurrió?',
        opciones: [
          'El alcance se desvió sin control y nadie puede señalar cuándo',
          'El proyecto mejoró su cobertura funcional',
          'Se aplicó correctamente el principio ágil de responder al cambio',
          'Se actualizó la línea base de forma automática',
        ],
        respuestaCorrecta:
            'El alcance se desvió sin control y nadie puede señalar cuándo',
        explicacion: [
          'Modificar la línea base informalmente equivale a no tenerla.',
        ],
        pista: 'Muchos cambios chicos suman un problema grande.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-2-lec-2': [
      Ejercicio(
        id: 'q422a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué muestra un burndown chart?',
        opciones: [
          'El trabajo pendiente del sprint día a día',
          'El número de defectos encontrados por módulo',
          'El costo acumulado del proyecto',
          'La cobertura de pruebas a lo largo del tiempo',
        ],
        respuestaCorrecta: 'El trabajo pendiente del sprint día a día',
        explicacion: [
          'La línea debería descender hasta cero al cierre del sprint.',
        ],
        pista: 'Se quema el trabajo pendiente.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'La línea del burndown se mantiene plana y cae de golpe el último día. ¿Qué indica?',
        opciones: [
          'El equipo acumuló trabajo sin terminarlo',
          'El equipo trabajó de forma constante y equilibrada',
          'Entró trabajo nuevo al sprint',
          'El sprint se completó antes de tiempo',
        ],
        respuestaCorrecta: 'El equipo acumuló trabajo sin terminarlo',
        explicacion: [
          'Muchas tareas quedaron en progreso hasta el final en lugar de cerrarse.',
        ],
        pista: 'Nada bajó durante días y todo bajó al final.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'La velocidad permite comparar la productividad entre equipos distintos.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Los puntos de historia son una unidad relativa que cada equipo calibra internamente.',
        ],
        pista: 'Cada equipo define su propia escala.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q422d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: 'Si la línea del burndown sube en lugar de bajar, ¿qué pasó?',
        opciones: [
          'Entró trabajo nuevo al sprint',
          'El equipo completó tareas adelantadas',
          'Se redujo el alcance del sprint',
          'Se corrigieron defectos pendientes',
        ],
        respuestaCorrecta: 'Entró trabajo nuevo al sprint',
        explicacion: [
          'Indica que el alcance del sprint no se está respetando.',
        ],
        pista: 'El pendiente creció.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-3-lec-1': [
      Ejercicio(
        id: 'q431a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cómo se calcula la densidad de defectos?',
        opciones: [
          'Defectos divididos entre el tamaño del software',
          'Defectos divididos entre el número de desarrolladores',
          'Defectos multiplicados por la severidad promedio',
          'Defectos divididos entre los días del sprint',
        ],
        respuestaCorrecta: 'Defectos divididos entre el tamaño del software',
        explicacion: [
          'Permite comparar módulos grandes con módulos pequeños.',
        ],
        pista: 'Es una proporción respecto al tamaño.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Se detectaron 80 defectos en pruebas y 20 en producción. ¿Cuál es la tasa de escape?',
        opciones: ['20 %', '25 %', '80 %', '4 %'],
        respuestaCorrecta: '20 %',
        explicacion: [
          '20 escapados sobre 100 totales da 20 %. Un objetivo razonable está bajo el 10 %.',
        ],
        pista: 'Divide los escapados entre el total de defectos.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué evalúa realmente la tasa de escape?',
        opciones: [
          'La eficacia del proceso de pruebas',
          'La calidad del código fuente',
          'La productividad de los desarrolladores',
          'La satisfacción del cliente',
        ],
        respuestaCorrecta: 'La eficacia del proceso de pruebas',
        explicacion: [
          'Una tasa alta significa que las pruebas no están encontrando lo que deberían.',
        ],
        pista: 'Mide a las pruebas, no al producto.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q431d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Qué módulo tiene peor calidad: 500 líneas con 10 defectos o 5.000 con 40?',
        opciones: [
          'El de 500 líneas con 10 defectos',
          'El de 5.000 líneas con 40 defectos',
          'Ambos tienen la misma calidad',
          'No se puede comparar sin más datos',
        ],
        respuestaCorrecta: 'El de 500 líneas con 10 defectos',
        explicacion: [
          'Su densidad es de 20 por cada mil líneas frente a 8 del otro módulo.',
        ],
        pista: 'Calcula defectos por cada mil líneas en ambos casos.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-3-lec-2': [
      Ejercicio(
        id: 'q432a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué mide el MTBF?',
        opciones: [
          'El tiempo medio entre fallos',
          'El tiempo medio de reparación',
          'El tiempo total de indisponibilidad al año',
          'El tiempo promedio de respuesta del sistema',
        ],
        respuestaCorrecta: 'El tiempo medio entre fallos',
        explicacion: [
          'El tiempo medio de reparación es el MTTR, su complemento.',
        ],
        pista: 'La B es de "between".',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cómo se calcula la disponibilidad?',
        opciones: [
          'MTBF dividido entre la suma de MTBF y MTTR',
          'MTTR dividido entre MTBF',
          'MTBF multiplicado por MTTR',
          'MTBF menos MTTR',
        ],
        respuestaCorrecta: 'MTBF dividido entre la suma de MTBF y MTTR',
        explicacion: [
          'De ahí sale el 99,9 % que aparece en los acuerdos de servicio.',
        ],
        pista: 'Es una proporción sobre el tiempo total.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuánta caída anual permite una disponibilidad del 99,9 %?',
        opciones: [
          'Unas 8,7 horas',
          'Unos 52 minutos',
          'Unos 5 días',
          'Menos de 1 minuto',
        ],
        respuestaCorrecta: 'Unas 8,7 horas',
        explicacion: [
          'Subir al 99,99 % la reduce a 52 minutos, pero el costo se multiplica.',
        ],
        pista: 'Es el 0,1 % de un año.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q432d',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Exigir un 90 % de cobertura obligatoria mejora siempre la calidad del software.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Genera pruebas escritas solo para subir el número, sin verificar nada.',
        ],
        pista: 'La cobertura es útil como diagnóstico, no como meta.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-4-lec-1': [
      Ejercicio(
        id: 'q441a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué miden los puntos de historia?',
        opciones: [
          'Esfuerzo relativo: complejidad, incertidumbre y volumen',
          'Las horas exactas que tomará la tarea',
          'El costo económico de cada funcionalidad',
          'La cantidad de líneas de código a escribir',
        ],
        respuestaCorrecta:
            'Esfuerzo relativo: complejidad, incertidumbre y volumen',
        explicacion: [
          'No son horas: son una unidad comparativa interna del equipo.',
        ],
        pista: 'No se traducen directamente a tiempo.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué se usa la secuencia de Fibonacci al estimar?',
        opciones: [
          'Porque a mayor tamaño, mayor imprecisión en la estimación',
          'Porque es más fácil de recordar que los números consecutivos',
          'Porque cada número representa un día de trabajo',
          'Porque lo exige la Scrum Guide',
        ],
        respuestaCorrecta:
            'Porque a mayor tamaño, mayor imprecisión en la estimación',
        explicacion: [
          'Los saltos crecen porque estimar tareas grandes es inherentemente menos preciso.',
        ],
        pista: 'Los intervalos se agrandan a propósito.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es la diferencia entre velocidad y capacidad?',
        opciones: [
          'Velocidad mira lo que se hizo; capacidad, lo que se puede hacer',
          'Velocidad se mide en horas y capacidad en puntos',
          'Velocidad la calcula el Scrum Master y capacidad el Product Owner',
          'Son dos nombres para la misma métrica',
        ],
        respuestaCorrecta:
            'Velocidad mira lo que se hizo; capacidad, lo que se puede hacer',
        explicacion: [
          'La capacidad ajusta por vacaciones, feriados y personas asignadas a otras tareas.',
        ],
        pista: 'Una mira atrás y la otra adelante.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q441d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'Con velocidad de 30 puntos por sprint y 180 puntos en el backlog, ¿cuántos sprints faltan?',
        opciones: ['Unos 6', 'Unos 3', 'Unos 12', 'Unos 18'],
        respuestaCorrecta: 'Unos 6',
        explicacion: [
          '180 dividido entre 30 da 6. La proyección mejora conforme se acumulan sprints reales.',
        ],
        pista: 'Una división simple.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-4-lec-2': [
      Ejercicio(
        id: 'q442a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Para qué sirven las métricas humanas?',
        opciones: [
          'Son señales tempranas de problemas que las métricas técnicas muestran tarde',
          'Para decidir los aumentos de sueldo del equipo',
          'Para comparar la productividad entre programadores',
          'Para calcular el costo total del proyecto',
        ],
        respuestaCorrecta:
            'Son señales tempranas de problemas que las métricas técnicas muestran tarde',
        explicacion: [
          'Un equipo agotado produce más defectos, y eso no aparece en el burndown.',
        ],
        pista: 'Avisan antes que el cronograma.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442b',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Las métricas de equipo pueden usarse para evaluar el desempeño individual.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Al hacerlo dejan de reflejar la realidad, porque la gente ajusta su comportamiento.',
        ],
        pista: 'Es la regla que nunca se rompe.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            'El equipo lleva tres sprints con horas extra y la velocidad se mantiene. ¿Qué suele ocurrir?',
        opciones: [
          'La densidad de defectos empieza a subir',
          'La velocidad se duplica en el siguiente sprint',
          'Los costos del proyecto se reducen',
          'La cobertura de pruebas aumenta sola',
        ],
        respuestaCorrecta: 'La densidad de defectos empieza a subir',
        explicacion: [
          'El burndown se ve bien mientras la calidad se degrada por detrás.',
        ],
        pista: 'El cansancio se paga en errores.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q442d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estas es una métrica humana?',
        opciones: [
          'Tasa de rotación del equipo',
          'Densidad de defectos por módulo',
          'Cobertura de pruebas',
          'Tiempo medio entre fallos',
        ],
        respuestaCorrecta: 'Tasa de rotación del equipo',
        explicacion: [
          'Junto con satisfacción, ausentismo y horas extra.',
        ],
        pista: 'Las otras tres miden al software.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-5-lec-1': [
      Ejercicio(
        id: 'q451a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuándo se recogen las lecciones aprendidas?',
        opciones: [
          'Durante todo el proyecto, no solo al cierre',
          'Únicamente en la reunión final de cierre',
          'Solo cuando el proyecto fracasa',
          'Al inicio, antes de empezar a trabajar',
        ],
        respuestaCorrecta: 'Durante todo el proyecto, no solo al cierre',
        explicacion: [
          'Al final nadie recuerda con precisión qué ocurrió en el segundo mes.',
        ],
        pista: 'La memoria se desvanece rápido.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué tres partes tiene una lección aprendida bien escrita?',
        opciones: [
          'Situación, impacto y recomendación accionable',
          'Problema, culpable y sanción',
          'Fecha, responsable y costo',
          'Riesgo, probabilidad e impacto',
        ],
        respuestaCorrecta: 'Situación, impacto y recomendación accionable',
        explicacion: [
          '"Hubo problemas de comunicación" no es una lección: es una queja.',
        ],
        pista: 'Qué pasó, qué causó y qué hacer.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451c',
        tipo: TipoEjercicio.verdaderoFalso,
        pregunta:
            'Una lección aprendida sirve aunque nadie la consulte en el siguiente proyecto.',
        respuestaCorrecta: 'false',
        explicacion: [
          'Si el documento se archiva y nadie vuelve a abrirlo, el esfuerzo se perdió.',
        ],
        pista: 'El valor está en el uso, no en el registro.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q451d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál de estas es una lección aprendida y no una queja?',
        opciones: [
          'Los requisitos llegaron por correo sin registro central; usar una herramienta única',
          'Hubo problemas de comunicación en el equipo',
          'El cliente fue muy exigente durante todo el proyecto',
          'Faltó tiempo para terminar bien el trabajo',
        ],
        respuestaCorrecta:
            'Los requisitos llegaron por correo sin registro central; usar una herramienta única',
        explicacion: [
          'Es específica, verificable y termina en una acción concreta.',
        ],
        pista: 'Busca la que dice qué hacer distinto.',
        xpPorRespuesta: 10,
      ),
    ],

    'cap-4-5-lec-2': [
      Ejercicio(
        id: 'q452a',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Qué tres preguntas estructuran una retrospectiva?',
        opciones: [
          'Qué salió bien, qué no salió bien y qué vamos a cambiar',
          'Qué hicimos, cuánto costó y cuánto tardamos',
          'Quién falló, por qué falló y cómo se sanciona',
          'Qué falta, quién lo hace y para cuándo',
        ],
        respuestaCorrecta:
            'Qué salió bien, qué no salió bien y qué vamos a cambiar',
        explicacion: [
          'La tercera pregunta es la que realmente importa.',
        ],
        pista: 'Dos miran atrás y una mira adelante.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452b',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Cuál es una acción útil de retrospectiva?',
        opciones: [
          'María configura una alerta cuando el pipeline falle, antes del viernes',
          'Comunicarnos mejor entre todos',
          'Esforzarnos más el próximo sprint',
          'Tener una mejor actitud en el equipo',
        ],
        respuestaCorrecta:
            'María configura una alerta cuando el pipeline falle, antes del viernes',
        explicacion: [
          'Tiene responsable y plazo, así que se puede verificar en la siguiente retrospectiva.',
        ],
        pista: 'Busca la que se puede comprobar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452c',
        tipo: TipoEjercicio.multipleChoice,
        pregunta: '¿Por qué es indispensable la seguridad psicológica?',
        opciones: [
          'Porque si señalar problemas trae consecuencias, nadie habla',
          'Porque reduce el número de reuniones necesarias',
          'Porque acelera la velocidad del equipo',
          'Porque lo exige la norma ISO 9001',
        ],
        respuestaCorrecta:
            'Porque si señalar problemas trae consecuencias, nadie habla',
        explicacion: [
          'Sin ella, la reunión produce silencio cortés y ningún hallazgo real.',
        ],
        pista: 'Tiene que ver con quién se anima a hablar.',
        xpPorRespuesta: 10,
      ),
      Ejercicio(
        id: 'q452d',
        tipo: TipoEjercicio.multipleChoice,
        pregunta:
            '¿Con qué etapa del ciclo PHVA de ISO 9001 se corresponde la retrospectiva?',
        opciones: ['Actuar', 'Planificar', 'Hacer', 'Verificar'],
        respuestaCorrecta: 'Actuar',
        explicacion: [
          'Scrum y ISO 9001 llegaron a la misma idea de mejora continua por caminos distintos.',
        ],
        pista: 'Es la etapa donde se corrigen las desviaciones.',
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