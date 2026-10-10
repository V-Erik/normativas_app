import 'dart:async';

import 'api_client.dart';
import 'api_config.dart';

/// Estado en vivo de la cola de generación, de `GET /api/v1/cola/estado`.
///
/// Existe una cola porque un solo Ollama en una sola GPU no genera más
/// rápido dos respuestas a la vez: las hace más lentas a las dos. Solo
/// `limite` respuestas (2 por defecto) se generan simultáneamente y el
/// resto espera turno.
class EstadoCola {
  final int limite;
  final int generando;
  final int enEspera;
  final double tiempoMedioGeneracionS;
  final double esperaMaximaS;

  const EstadoCola({
    required this.limite,
    required this.generando,
    required this.enEspera,
    required this.tiempoMedioGeneracionS,
    required this.esperaMaximaS,
  });

  /// `enEspera` es el total del servidor, no la posición exacta de esta
  /// petición: es una estimación, y así hay que presentarla.
  String get mensaje {
    if (enEspera <= 0) return 'El tutor está escribiendo…';
    final segundos = (enEspera * tiempoMedioGeneracionS).round();
    return 'El tutor está atendiendo a otros estudiantes '
        '($enEspera en espera, unos $segundos s)…';
  }

  factory EstadoCola.fromJson(Map<String, dynamic> j) => EstadoCola(
        limite: j['limite'] as int? ?? 0,
        generando: j['generando'] as int? ?? 0,
        enEspera: j['en_espera'] as int? ?? 0,
        tiempoMedioGeneracionS:
            (j['tiempo_medio_generacion_s'] as num?)?.toDouble() ?? 5.0,
        esperaMaximaS: (j['espera_maxima_s'] as num?)?.toDouble() ?? 120.0,
      );
}

/// Respuesta de `POST /api/v1/chat`.
class RespuestaTutor {
  /// El texto del tutor, en Markdown ligero (listas con `*`, a veces
  /// `**negrita**`). Mostrarlo respetando al menos los saltos de línea.
  final String respuesta;

  /// respuesta | saludo | funcionamiento | sin_contexto | redireccion |
  /// sin_documentos | error  — todos llegan con HTTP 200.
  final String tipo;

  /// Guardarlo y reenviarlo en el siguiente mensaje del mismo hilo:
  /// es la memoria del tutor.
  final String conversacionId;

  final bool desdeCache;
  final double latenciaMs;

  final String? temaDetectado;
  final int? unidadDetectada;
  final String? temaIdDetectado;
  final String? metodoDeteccion;

  /// Posición en la cola al llegar, estimación y espera real. Los tres
  /// llegan en null si la petición no esperó (había cupo, salió del caché
  /// o era un saludo).
  final int? posicionEnCola;
  final double? esperaEstimadaS;
  final double? esperaRealS;

  const RespuestaTutor({
    required this.respuesta,
    required this.tipo,
    required this.conversacionId,
    required this.desdeCache,
    required this.latenciaMs,
    this.temaDetectado,
    this.unidadDetectada,
    this.temaIdDetectado,
    this.metodoDeteccion,
    this.posicionEnCola,
    this.esperaEstimadaS,
    this.esperaRealS,
  });

  /// true cuando el tutor no tiene documentación del tema preguntado.
  /// **No es un error**: 9 de los 27 temas del sílabo no tienen documento
  /// indexado y está hecho así a propósito para que el modelo no invente.
  bool get sinDocumentacion => tipo == 'sin_contexto';

  /// true cuando la pregunta quedó fuera del temario y el tutor reconduce.
  bool get fueraDeTema => tipo == 'redireccion';

  /// true cuando el problema es del servidor, no de la pregunta.
  bool get esProblemaDelServidor => tipo == 'sin_documentos' || tipo == 'error';

  /// Nota discreta para poner bajo la burbuja cuando la espera fue notable.
  String? get notaDeEspera {
    final espera = esperaRealS;
    if (espera == null || espera < 5) return null;
    return 'Esperaste ${espera.round()} s en cola';
  }

  factory RespuestaTutor.fromJson(Map<String, dynamic> j) => RespuestaTutor(
        respuesta: j['respuesta'] as String? ?? '',
        tipo: j['tipo'] as String? ?? 'respuesta',
        conversacionId: j['conversacion_id'] as String? ?? '',
        desdeCache: j['desde_cache'] as bool? ?? false,
        latenciaMs: (j['latencia_ms'] as num?)?.toDouble() ?? 0.0,
        temaDetectado: j['tema_detectado'] as String?,
        unidadDetectada: j['unidad_detectada'] as int?,
        temaIdDetectado: j['tema_id_detectado'] as String?,
        metodoDeteccion: j['metodo_deteccion'] as String?,
        posicionEnCola: j['posicion_en_cola'] as int?,
        esperaEstimadaS: (j['espera_estimada_s'] as num?)?.toDouble(),
        esperaRealS: (j['espera_real_s'] as num?)?.toDouble(),
      );
}

/// Se mantiene el nombre `ErrorTutor` como alias de [ErrorApi] para que
/// las pantallas puedan capturar un solo tipo.
typedef ErrorTutor = ErrorApi;

/// Cliente del tutor IA.
///
/// Qué cambió respecto a la versión anterior y por qué:
///
///   antes                      | problema                      | ahora
///   ---------------------------|-------------------------------|----------------------
///   IP fija 10.25.233.4        | IP de una red concreta        | ApiConfig.base
///   sin Authorization          | 401 siempre                   | Bearer id_token
///   campo `message`            | 422: falta `mensaje`          | `mensaje`
///   `system_context`           | el backend lo descarta        | eliminado
///   `capitulo_id`/`norma_filtro`| se ignoran                   | `leccion_id`
///   no guardaba conversación   | el tutor no recordaba nada    | `conversacion_id`
///   leía `data['response']`    | ese campo no existe           | `data['respuesta']`
///   timeout 120 s              | cortaba antes del 503         | 150 s
///   todo error igual           | el alumno no sabía qué hacer  | 401/409/503 aparte
class ChatService {
  const ChatService._();

  /// `GET /api/v1/cola/estado`. Público y barato.
  static Future<EstadoCola> estadoCola() async {
    final datos = await ApiClient.getPublico(
      '/cola/estado',
      timeout: ApiConfig.timeoutCola,
    );
    return EstadoCola.fromJson(datos as Map<String, dynamic>);
  }

  /// Envía [mensaje] al tutor.
  ///
  /// [conversacionId]: el de la respuesta anterior, para seguir el mismo
  /// hilo. En el primer mensaje va null y el servidor genera uno.
  ///
  /// [leccionId]: el id de la lección en la que está el estudiante, para
  /// que la recuperación de contexto se centre en ese tema del sílabo.
  /// Usa `MapeoLecciones.temaDeLeccion(...)` para traducir el id de la app.
  ///
  /// [alCambiarCola]: se llama cada 3 s mientras se espera, con el estado
  /// de la cola, para poder mostrar algo mejor que un spinner durante los
  /// hasta 70 s que puede esperar una clase entera preguntando a la vez.
  static Future<RespuestaTutor> preguntarAlTutor(
    String mensaje, {
    String? conversacionId,
    String? leccionId,
    void Function(EstadoCola estado)? alCambiarCola,
  }) async {
    Timer? sondeo;

    if (alCambiarCola != null) {
      sondeo = Timer.periodic(ApiConfig.intervaloSondeoCola, (_) async {
        try {
          alCambiarCola(await estadoCola());
        } catch (_) {
          // El sondeo es puramente informativo: si falla, el chat sigue.
        }
      });
    }

    try {
      final datos = await ApiClient.post(
        '/chat',
        cuerpo: {
          'mensaje': mensaje,
          'conversacion_id': ?conversacionId,
          'leccion_id': ?leccionId,
        },
        timeout: ApiConfig.timeoutChat,
      );
      return RespuestaTutor.fromJson(datos as Map<String, dynamic>);
    } finally {
      sondeo?.cancel();
    }
  }

  /// Variante que no lanza: devuelve el texto de la respuesta o el del
  /// error. Sirve para pantallas simples como el escáner AR, donde no hay
  /// un flujo de reintento que ofrecer.
  static Future<String> preguntarTexto(
    String mensaje, {
    String? leccionId,
  }) async {
    try {
      final r = await preguntarAlTutor(mensaje, leccionId: leccionId);
      return r.respuesta;
    } on ErrorApi catch (e) {
      return e.mensaje;
    }
  }
}
