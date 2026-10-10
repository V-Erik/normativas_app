import 'api_client.dart';

/// Progreso guardado en el servidor, de `GET /api/v1/progreso/mio`.
///
/// Es la gamificación de la app (XP, racha, lecciones y ejercicios) hecha
/// persistente: antes vivía solo en memoria y se perdía al cerrar.
///
/// Siempre es el del estudiante del token: estos endpoints no reciben
/// ningún uid.
class ProgresoRemoto {
  final int xpTotal;
  final int rachaActual;
  final int rachaMejor;

  /// Solo la fecha (`2026-10-09`), o null si no hay actividad.
  final String? ultimaActividadFecha;

  final int leccionesCompletadas;
  final int ejerciciosResueltos;
  final int ejerciciosCorrectos;

  const ProgresoRemoto({
    required this.xpTotal,
    required this.rachaActual,
    required this.rachaMejor,
    required this.ultimaActividadFecha,
    required this.leccionesCompletadas,
    required this.ejerciciosResueltos,
    required this.ejerciciosCorrectos,
  });

  factory ProgresoRemoto.fromJson(Map<String, dynamic> j) => ProgresoRemoto(
        xpTotal: j['xp_total'] as int? ?? 0,
        rachaActual: j['racha_actual'] as int? ?? 0,
        rachaMejor: j['racha_mejor'] as int? ?? 0,
        ultimaActividadFecha: j['ultima_actividad_fecha'] as String?,
        leccionesCompletadas: j['lecciones_completadas'] as int? ?? 0,
        ejerciciosResueltos: j['ejercicios_resueltos'] as int? ?? 0,
        ejerciciosCorrectos: j['ejercicios_correctos'] as int? ?? 0,
      );
}

/// XP y racha en el servidor.
///
/// Reglas del backend (`backend/app/services/progreso_service.py`):
///   - una lección completada da +20 XP;
///   - un ejercicio correcto, +10; uno incorrecto, +2;
///   - la racha sube una vez por día con actividad, y vuelve a 1 tras un
///     hueco de más de un día;
///   - **completar dos veces la misma lección suma XP dos veces**: el
///     backend no deduplica, así que la app tiene que llamar una sola vez.
///     De eso se encarga `ProgresoService.completarLeccion`, que devuelve
///     false si la lección ya estaba completada.
class ProgresoRemotoService {
  const ProgresoRemotoService._();

  /// `GET /api/v1/progreso/mio`
  static Future<ProgresoRemoto> mio({Duration? timeout}) async {
    final datos = await ApiClient.get('/progreso/mio', timeout: timeout);
    return ProgresoRemoto.fromJson(datos as Map<String, dynamic>);
  }

  /// `POST /api/v1/progreso/lecciones/{leccionId}/completar`
  ///
  /// [leccionId] es libre: se manda directamente el id de la app
  /// (`cap-2-2-lec-1`), no la clave canónica del tutor.
  static Future<ProgresoRemoto> completarLeccion(String leccionId) async {
    final datos = await ApiClient.post(
      '/progreso/lecciones/${Uri.encodeComponent(leccionId)}/completar',
    );
    return ProgresoRemoto.fromJson(datos as Map<String, dynamic>);
  }

  /// `POST /api/v1/progreso/ejercicios/{ejercicioId}/resolver`
  static Future<ProgresoRemoto> resolverEjercicio(
    String ejercicioId, {
    required bool correcto,
    String? leccionId,
  }) async {
    final datos = await ApiClient.post(
      '/progreso/ejercicios/${Uri.encodeComponent(ejercicioId)}/resolver',
      cuerpo: {
        'correcto': correcto,
        ?'leccion_id': leccionId,
      },
    );
    return ProgresoRemoto.fromJson(datos as Map<String, dynamic>);
  }
}
