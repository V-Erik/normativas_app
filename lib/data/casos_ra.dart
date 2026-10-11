import 'mapeo_lecciones.dart';

/// Catálogo de los marcadores de realidad aumentada.
///
/// QUÉ ES UN MARCADOR AQUÍ
/// -----------------------
/// No es una norma suelta, es un **caso**: un proyecto de software real y
/// corto ("historia clínica para un hospital", "app de banca móvil"). El
/// docente imprime la tarjeta, el estudiante la apunta con la cámara y la
/// mascota aparece sobre el papel y le plantea el caso.
///
/// POR QUÉ UN DIÁLOGO Y NO UNA FICHA
/// ---------------------------------
/// La primera versión mostraba la respuesta nada más detectar el código.
/// Eso tenía un problema de fondo: la tarjeta impresa pregunta "¿qué
/// normativa aplicarías?" y la app la contestaba medio segundo después,
/// antes de que el estudiante pensara nada. Con eso, la realidad aumentada
/// no aportaba nada que no aportara abrir el chat, que es exactamente lo
/// que un tribunal pregunta.
///
/// Ahora la mascota plantea el encargo, **pregunta** con tres opciones, y
/// solo entonces explica. La explicación se construye sobre lo que el
/// estudiante eligió ([OpcionNorma.reaccion]), así que una respuesta
/// equivocada no recibe un "no" sino el motivo por el que esa norma se
/// queda corta en este caso concreto. Eso es lo que no se puede copiar de
/// una respuesta genérica.
///
/// POR QUÉ EL CONTENIDO ESTÁ AQUÍ Y NO EN EL SERVIDOR
/// --------------------------------------------------
/// Para que todo aparezca **al instante**. Con el modelo corriendo en CPU
/// una respuesta tarda entre 15 y 40 segundos, y una experiencia de RA en
/// la que apuntas la cámara y no pasa nada durante medio minuto está rota.
/// El tutor sigue disponible, pero como un botón al final del diálogo.
///
/// LOS TEMAS ESTÁN ELEGIDOS A PROPÓSITO
/// ------------------------------------
/// Las ocho lecciones referenciadas apuntan a temas del sílabo que **sí**
/// tienen documento indexado en el backend (ver
/// [MapeoLecciones.temasSinDocumentacion]). Así, si el estudiante pulsa
/// "Preguntar al tutor", recibe una respuesta con material real en lugar
/// de un "eso no está en mis documentos".
class CasoRA {
  /// Id corto que va dentro del QR, como `eso://caso/hce-hospital`.
  final String id;

  /// El caso, en una línea. Es el título de la ficha.
  final String titulo;

  /// El encargo tal como lo plantearía un cliente. Se usa en la ficha y
  /// en la tarjeta impresa.
  final String contexto;

  /// Lo primero que dice la mascota. Más corto y más hablado que
  /// [contexto]: tiene que caber en un globo sobre la cámara y leerse de
  /// un vistazo con el teléfono en la mano.
  final String enganche;

  /// Las tres opciones del paso 2. Exactamente una tiene
  /// [OpcionNorma.correcta] en true.
  final List<OpcionNorma> opciones;

  /// El primer paso concreto. Deliberadamente NO es "leer la norma": es
  /// la primera acción de ingeniería que haría un equipo.
  final String primerPaso;

  /// Qué normativa aplica y por qué, para la ficha completa. Es una
  /// mirada más reposada que la reacción del diálogo.
  final List<NormaSugerida> normas;

  /// Lección de la app con la que se corresponde, para poder saltar a
  /// ella y para centrar la búsqueda de contexto del tutor.
  final String leccionId;

  /// Emoji del caso. Da identidad a la tarjeta sin necesitar un asset.
  final String icono;

  /// XP que se gana la primera vez que se **responde** este marcador.
  /// No se da por escanear: se da por contestar, aunque se falle.
  final int xp;

  const CasoRA({
    required this.id,
    required this.titulo,
    required this.contexto,
    required this.enganche,
    required this.opciones,
    required this.primerPaso,
    required this.normas,
    required this.leccionId,
    required this.icono,
    this.xp = 15,
  });

  OpcionNorma get opcionCorrecta =>
      opciones.firstWhere((o) => o.correcta, orElse: () => opciones.first);

  /// Pregunta con la que se abre el tutor. Lleva el caso dentro para que
  /// la respuesta sea sobre el caso y no una definición genérica.
  String get preguntaParaElTutor =>
      'Estoy trabajando en este caso: $contexto '
      '¿Qué normativa debería aplicar y cómo empiezo a aplicarla?';

  String? get tema => MapeoLecciones.temaDeLeccion(leccionId);

  String? get leccionIdParaChat => MapeoLecciones.leccionIdParaChat(leccionId);

  /// Mundo de la app (1..4), deducido del id de la lección.
  int get mundo {
    final m = RegExp(r'^cap-(\d)-').firstMatch(leccionId);
    return m == null ? 1 : int.parse(m.group(1)!);
  }
}

/// Una de las tres respuestas posibles.
class OpcionNorma {
  /// Lo que se escribe en el botón. Corto: tiene que caber en un chip
  /// sobre la cámara.
  final String etiqueta;

  final bool correcta;

  /// Lo que contesta la mascota si el estudiante elige **esta**.
  ///
  /// Las incorrectas no dicen "no". Empiezan reconociendo lo que la
  /// elección tiene de razonable y luego explican por qué en este caso se
  /// queda corta; es la diferencia entre corregir y enseñar.
  final String reaccion;

  const OpcionNorma(this.etiqueta, this.reaccion, {this.correcta = false});
}

/// Una norma recomendada, con la razón por la que aplica a este caso.
class NormaSugerida {
  final String norma;
  final String porque;
  const NormaSugerida(this.norma, this.porque);
}

/// Los marcadores imprimibles.
///
/// Son ocho y cubren los cuatro mundos: así la pestaña de RA no se queda
/// pegada al Mundo 2 (normativas) y sirve para repasar todo el sílabo.
class CasosRA {
  const CasosRA._();

  /// Esquema del QR. Se acepta también el id a secas, por si una tarjeta
  /// se genera a mano.
  static const String esquema = 'eso://caso/';

  static const List<CasoRA> todos = [
    // ---------------------------------------------------------------- M2
    CasoRA(
      id: 'hce-hospital',
      icono: '🏥',
      titulo: 'Historia clínica electrónica',
      contexto: 'Un hospital quiere digitalizar las historias clínicas de '
          'sus pacientes y que el personal las consulte desde cualquier área.',
      enganche: 'Un hospital quiere pasar las historias clínicas a digital '
          'y que se consulten desde cualquier área.',
      opciones: [
        OpcionNorma(
          'ISO 9001',
          'Ordena los procesos del hospital, y eso suma. Pero aquí lo que '
              'puede arruinarlo todo es una fuga de datos de salud, y de eso '
              'se ocupa la 27001.',
        ),
        OpcionNorma(
          'ISO 27001',
          'Eso es. Son datos de salud: antes de que funcione bonito tiene '
              'que estar protegido, y el marco para eso es la 27001.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 29119',
          'Las pruebas vienen después. Primero hay que decidir qué '
              'información proteges y de qué la proteges.',
        ),
      ],
      primerPaso: 'Define el alcance del SGSI (qué sistemas y qué datos '
          'entran) y clasifica la información por sensibilidad. Sin esa '
          'clasificación no puedes justificar ningún control.',
      normas: [
        NormaSugerida(
          'ISO/IEC 27001',
          'Son datos de salud: el caso es de seguridad de la información '
              'antes que de funcionalidad.',
        ),
        NormaSugerida(
          'ISO/IEC 25010',
          'Fija qué significa "seguro" y "fiable" de forma medible, no como '
              'una buena intención.',
        ),
      ],
      leccionId: 'cap-2-3-lec-2',
    ),
    CasoRA(
      id: 'banca-movil',
      icono: '🏦',
      titulo: 'App de banca móvil',
      contexto: 'Una cooperativa de ahorro quiere una app para que sus '
          'socios consulten saldos y hagan transferencias.',
      enganche: 'Una cooperativa quiere una app donde sus socios vean '
          'saldos y hagan transferencias.',
      opciones: [
        OpcionNorma(
          'ISO 25010',
          'Sí hace falta: te dice cómo medir que sea segura y rápida. Pero '
              'el sistema de gestión que te va a pedir el regulador lo define '
              'la 27001.',
        ),
        OpcionNorma(
          'ISO 27001',
          'Correcto. Estás moviendo dinero de terceros: primero el marco de '
              'seguridad, y los controles concretos salen de la 27002.',
          correcta: true,
        ),
        OpcionNorma(
          'Scrum',
          'Scrum te dice cómo organizar al equipo, no qué tienes que '
              'proteger. Es una pregunta distinta.',
        ),
      ],
      primerPaso: 'Haz el análisis de riesgos: qué activo, qué amenaza y qué '
          'pasa si falla. Los controles salen de ahí, no de una lista '
          'copiada de internet.',
      normas: [
        NormaSugerida(
          'ISO/IEC 27001 y 27002',
          'La 27001 dice qué sistema de gestión hace falta; la 27002, qué '
              'controles concretos elegir.',
        ),
        NormaSugerida(
          'ISO/IEC 25010',
          'Seguridad y rendimiento como características de calidad del '
              'producto, con métricas asociadas.',
        ),
      ],
      leccionId: 'cap-2-3-lec-1',
    ),
    CasoRA(
      id: 'tienda-pyme',
      icono: '🛒',
      titulo: 'Tienda en línea de una PYME',
      contexto: 'Una ferretería de Tulcán vende por WhatsApp y quiere una '
          'tienda en línea sin perder el control de los pedidos.',
      enganche: 'Una ferretería de Tulcán vende por WhatsApp y quiere una '
          'tienda en línea sin perder el control de los pedidos.',
      opciones: [
        OpcionNorma(
          'ISO 9001',
          'Eso es. El problema no es el código: es que el proceso de pedido '
              'no está escrito en ninguna parte, y automatizarlo así solo lo '
              'vuelve más rápido y más confuso.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 27001',
          'Aquí no hay datos críticos. Cuidado con cargarle seguridad '
              'pesada a una ferretería: cuesta dinero y no resuelve su '
              'problema real.',
        ),
        OpcionNorma(
          'ISO 12207',
          'Es demasiada norma para una tienda pequeña. La 12207 ordena el '
              'ciclo de vida de proyectos bastante más grandes.',
        ),
      ],
      primerPaso: 'Dibuja el proceso de pedido tal como ocurre hoy, con sus '
          'entradas, salidas y responsables. Recién ahí decides qué parte '
          'vale la pena automatizar.',
      normas: [
        NormaSugerida(
          'ISO 9001',
          'El problema de fondo es el proceso de la empresa, no el código: '
              'esta norma ordena el proceso.',
        ),
        NormaSugerida(
          'ISO/IEC 25010',
          'Usabilidad: si el dueño no entiende el panel, la tienda vuelve a '
              'WhatsApp en una semana.',
        ),
      ],
      leccionId: 'cap-2-2-lec-1',
    ),
    CasoRA(
      id: 'control-ascensor',
      icono: '🛗',
      titulo: 'Control de un ascensor',
      contexto: 'Una empresa fabrica ascensores y necesita el software que '
          'gestiona puertas, frenos y llamadas de piso.',
      enganche: 'Una empresa fabrica ascensores y necesita el software que '
          'maneja puertas, frenos y llamadas de piso.',
      opciones: [
        OpcionNorma(
          'ISO 9001',
          'Certifica cómo trabaja la empresa, no cómo se construye este '
              'software. Y aquí un fallo puede herir a alguien.',
        ),
        OpcionNorma(
          'ISO 12207',
          'Así es. Software crítico: los procesos del ciclo de vida y la '
              'verificación se definen antes de empezar, no se improvisan.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 25010',
          'Te sirve para fijar la fiabilidad como algo medible, pero no te '
              'da los procesos de desarrollo. Esos los da la 12207.',
        ),
      ],
      primerPaso: 'Separa verificación de validación y fija los niveles de '
          'prueba desde los requisitos. En software crítico el plan de '
          'pruebas se escribe antes que el código.',
      normas: [
        NormaSugerida(
          'ISO/IEC/IEEE 12207',
          'Un fallo puede herir a alguien: hace falta un ciclo de vida con '
              'procesos de verificación definidos, no improvisación.',
        ),
        NormaSugerida(
          'ISO/IEC/IEEE 29119',
          'Define niveles y documentación de prueba, que es lo que se '
              'audita cuando algo sale mal.',
        ),
      ],
      leccionId: 'cap-2-4-lec-1',
    ),
    // ---------------------------------------------------------------- M1
    CasoRA(
      id: 'equipo-delivery',
      icono: '🛵',
      titulo: 'Equipo nuevo, app de delivery',
      contexto: 'Cuatro estudiantes tienen cuatro meses para entregar una '
          'app de delivery y nadie ha trabajado en equipo antes.',
      enganche: 'Cuatro estudiantes, cuatro meses, una app de delivery, y '
          'nadie ha trabajado en equipo antes.',
      opciones: [
        OpcionNorma(
          'Waterfall',
          'Con requisitos que van a cambiar cada semana, cerrar el alcance '
              'al principio es la forma más rápida de llegar tarde.',
        ),
        OpcionNorma(
          'Scrum',
          'Correcto. Cuatro meses y mucha incertidumbre piden entregas '
              'cortas y revisar el rumbo cada sprint.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 9001',
          'Es una norma para una organización, no un marco para que cuatro '
              'personas se repartan el trabajo del semestre.',
        ),
      ],
      primerPaso: 'Reparte los tres roles, acuerda sprints de dos semanas y '
          'escribe el Product Backlog antes de abrir el editor. Sin backlog '
          'priorizado, Scrum es solo una reunión diaria.',
      normas: [
        NormaSugerida(
          'Scrum',
          'Cuatro meses y requisitos que van a cambiar: conviene un marco '
              'iterativo con entregas cortas.',
        ),
        NormaSugerida(
          'Ciclo de vida (SDLC)',
          'Aunque el marco sea ágil, las fases siguen existiendo; saberlo '
              'evita llamar "sprint" a trabajar sin plan.',
        ),
      ],
      leccionId: 'cap-1-3-lec-2',
    ),
    CasoRA(
      id: 'migracion-legado',
      icono: '🗄️',
      titulo: 'Migrar un sistema heredado',
      contexto: 'Una institución tiene un sistema de 12 años en un servidor '
          'propio y quiere moverlo a la nube sin parar la atención al '
          'público.',
      enganche: 'Un sistema de 12 años tiene que irse a la nube sin parar '
          'la atención al público ni un día.',
      opciones: [
        OpcionNorma(
          'Scrum',
          'Puedes organizar el trabajo así, pero la migración no es una '
              'función nueva del producto: es gestión de la configuración.',
        ),
        OpcionNorma(
          'ISO 12207',
          'Eso es. Lo que estás moviendo cae en los procesos de soporte del '
              'ciclo de vida, y esos los define la 12207.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 25010',
          'Mide la calidad del producto terminado; no te ayuda a mover un '
              'sistema vivo sin tumbarlo.',
        ),
      ],
      primerPaso: 'Levanta el inventario y la línea base de configuración de '
          'lo que hay hoy, y escribe el plan de rollback antes de tocar '
          'nada. Si no sabes volver atrás, no puedes empezar.',
      normas: [
        NormaSugerida(
          'ISO/IEC/IEEE 12207',
          'La migración es un proceso de soporte (gestión de la '
              'configuración), no una función nueva del producto.',
        ),
        NormaSugerida(
          'CI/CD y gestión de la configuración',
          'Sin despliegue repetible, cada intento de migración es un '
              'experimento irrepetible.',
        ),
      ],
      leccionId: 'cap-3-4-lec-2',
    ),
    // ---------------------------------------------------------------- M3/M4
    CasoRA(
      id: 'defectos-produccion',
      icono: '🐞',
      titulo: 'Defectos que llegan a producción',
      contexto: 'Un equipo entrega a tiempo, pero los usuarios reportan '
          'fallos cada semana y el jefe pide "más pruebas".',
      enganche: 'El equipo entrega a tiempo, pero los usuarios reportan '
          'fallos cada semana y el jefe pide "más pruebas".',
      opciones: [
        OpcionNorma(
          'ISO 29119',
          'Vas bien encaminado: lo normal es que falte un nivel de prueba. '
              'Pero antes de cambiar nada hay que medir por dónde se están '
              'escapando.',
        ),
        OpcionNorma(
          'Métricas de calidad',
          'Exacto. Defect density y defect escape rate te dicen si el '
              'problema está en el código o en las pruebas, y sin ese dato '
              '"más pruebas" es adivinar.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 9001',
          'Certificar el proceso no encuentra defectos. Primero el dato y '
              'después el proceso, no al revés.',
        ),
      ],
      primerPaso: 'Cuenta cuántos defectos encuentra el equipo y cuántos '
          'encuentra el usuario, durante dos o tres sprints. Esa proporción '
          'te dice dónde está el agujero.',
      normas: [
        NormaSugerida(
          'Métricas de calidad del producto',
          'Defect density y defect escape rate dicen si el problema está en '
              'el código o en las pruebas.',
        ),
        NormaSugerida(
          'ISO/IEC/IEEE 29119',
          'Si los defectos se escapan, suele faltar un nivel de prueba, no '
              'cantidad de pruebas.',
        ),
      ],
      leccionId: 'cap-4-3-lec-1',
    ),
    CasoRA(
      id: 'retro-sin-cambios',
      icono: '🔁',
      titulo: 'Retrospectivas que no cambian nada',
      contexto: 'Un equipo hace retrospectiva cada sprint, apunta los '
          'mismos problemas y al sprint siguiente vuelven a pasar.',
      enganche: 'Un equipo hace retrospectiva cada sprint, apunta siempre '
          'los mismos problemas, y nunca cambia nada.',
      opciones: [
        OpcionNorma(
          'Scrum',
          'Scrum ya les dice que hagan la retrospectiva, y la hacen. El '
              'problema es qué pasa después, y eso el marco no lo cubre.',
        ),
        OpcionNorma(
          'Mejora continua',
          'Eso es. Una retrospectiva sin acciones con dueño y fecha es una '
              'queja documentada; el gobierno de procesos es lo que cierra '
              'ese ciclo.',
          correcta: true,
        ),
        OpcionNorma(
          'ISO 25010',
          'Mide el producto, no cómo trabaja el equipo. Aquí el que falla '
              'es el proceso.',
        ),
      ],
      primerPaso: 'Convierte cada hallazgo en una acción con dueño, fecha y '
          'una señal medible de que funcionó, y revísala en la siguiente '
          'retrospectiva antes de abrir temas nuevos.',
      normas: [
        NormaSugerida(
          'Gobierno de procesos y mejora continua',
          'Una retrospectiva sin acciones con responsable y fecha es una '
              'queja documentada.',
        ),
        NormaSugerida(
          'ISO 9001',
          'Aporta el ciclo de mejora continua y la idea de evidencia: qué '
              'se cambió y qué efecto tuvo.',
        ),
      ],
      leccionId: 'cap-4-5-lec-2',
    ),
  ];

  /// Interpreta el contenido crudo de un QR.
  ///
  /// Acepta, por orden:
  ///   1. `eso://caso/<id>`   el formato propio
  ///   2. `<id>`              el id a secas
  ///   3. cualquier texto que contenga el id de un caso
  ///
  /// El tercero existe porque las tarjetas se imprimen una vez y luego se
  /// fotocopian: si alguien genera un QR a mano, es mejor que la app lo
  /// resuelva que dejar al estudiante mirando una pantalla que no
  /// reacciona.
  static CasoRA? resolver(String? crudo) {
    if (crudo == null) return null;
    final texto = crudo.trim();
    if (texto.isEmpty) return null;

    final minusculas = texto.toLowerCase();
    final sinEsquema =
        minusculas.startsWith(esquema) ? minusculas.substring(esquema.length) : minusculas;

    for (final caso in todos) {
      if (caso.id == sinEsquema.trim()) return caso;
    }
    for (final caso in todos) {
      if (minusculas.contains(caso.id)) return caso;
    }
    return null;
  }

  static CasoRA? porId(String id) {
    for (final caso in todos) {
      if (caso.id == id) return caso;
    }
    return null;
  }

  /// Contenido que hay que poner dentro del QR impreso.
  static String contenidoQr(CasoRA caso) => '$esquema${caso.id}';
}
