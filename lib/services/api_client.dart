import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

/// Error del backend con un mensaje ya listo para mostrar y el código HTTP,
/// para que cada pantalla decida qué hacer:
///
///   401 -> la sesión caducó: volver al login
///   409 -> falta aceptar el consentimiento informado
///   503 -> el tutor está saturado: ofrecer un botón de reintentar
///   null -> no hubo respuesta (sin red, servidor apagado, timeout)
class ErrorApi implements Exception {
  final int? codigo;
  final String mensaje;

  const ErrorApi(this.codigo, this.mensaje);

  bool get sesionCaducada => codigo == 401;
  bool get faltaConsentimiento => codigo == 409;
  bool get servidorSaturado => codigo == 503;
  bool get sinConexion => codigo == null;

  @override
  String toString() => mensaje;
}

/// Cliente HTTP único del backend.
///
/// Se encarga de las tres cosas que antes faltaban y que hacían que todos
/// los endpoints protegidos respondieran 401:
///
///   1. Adjunta `Authorization: Bearer <id_token de Firebase>` en cada
///      petición, pidiendo el token justo antes de enviarla (el SDK lo
///      renueva solo, pero caduca a la hora).
///   2. Si el servidor responde 401, fuerza la renovación del token
///      (`getIdToken(true)`) y reintenta UNA vez. Si vuelve a fallar,
///      lanza ErrorApi(401) para que la pantalla mande al login.
///   3. Traduce los códigos de error a mensajes en español.
class ApiClient {
  const ApiClient._();

  // ---------------------------------------------------------------- público

  /// GET autenticado. [ruta] empieza con "/" y es relativa a /api/v1,
  /// por ejemplo "/usuarios/yo".
  static Future<dynamic> get(String ruta, {Duration? timeout}) {
    return _conReintento(
      (token) => http
          .get(Uri.parse('${ApiConfig.v1}$ruta'), headers: _cabeceras(token))
          .timeout(timeout ?? ApiConfig.timeoutDatos),
    );
  }

  /// POST autenticado. [cuerpo] puede ser null para los endpoints que no
  /// reciben nada (por ejemplo /usuarios/consentimiento).
  static Future<dynamic> post(
    String ruta, {
    Map<String, dynamic>? cuerpo,
    Duration? timeout,
  }) {
    return _conReintento(
      (token) => http
          .post(
            Uri.parse('${ApiConfig.v1}$ruta'),
            headers: _cabeceras(token),
            body: cuerpo == null ? null : jsonEncode(cuerpo),
          )
          .timeout(timeout ?? ApiConfig.timeoutDatos),
    );
  }

  /// GET sin token, para los dos endpoints públicos: /salud y /cola/estado.
  static Future<dynamic> getPublico(String ruta, {Duration? timeout}) async {
    try {
      final respuesta = await http
          .get(Uri.parse('${ApiConfig.v1}$ruta'))
          .timeout(timeout ?? ApiConfig.timeoutDatos);
      return _interpretar(respuesta);
    } on ErrorApi {
      rethrow;
    } catch (e) {
      throw _errorDeRed(e);
    }
  }

  /// Token actual de Firebase, o null si no hay sesión.
  /// Útil si alguna pantalla necesita hacer una petición a mano.
  static Future<String?> token({bool forzarRenovacion = false}) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return null;
    return usuario.getIdToken(forzarRenovacion);
  }

  // ---------------------------------------------------------------- interno

  static Map<String, String> _cabeceras(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// Ejecuta [peticion] con el token actual. Ante un 401, renueva el token
  /// y reintenta una sola vez.
  static Future<dynamic> _conReintento(
    Future<http.Response> Function(String token) peticion,
  ) async {
    try {
      var token = await _tokenObligatorio(forzarRenovacion: false);
      var respuesta = await peticion(token);

      if (respuesta.statusCode == 401) {
        token = await _tokenObligatorio(forzarRenovacion: true);
        respuesta = await peticion(token);
      }

      return _interpretar(respuesta);
    } on ErrorApi {
      rethrow;
    } catch (e) {
      throw _errorDeRed(e);
    }
  }

  static Future<String> _tokenObligatorio({
    required bool forzarRenovacion,
  }) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      throw const ErrorApi(401, 'Inicia sesión para usar el tutor.');
    }
    final token = await usuario.getIdToken(forzarRenovacion);
    if (token == null || token.isEmpty) {
      throw const ErrorApi(401, 'Tu sesión expiró. Vuelve a iniciar sesión.');
    }
    return token;
  }

  /// Convierte una respuesta HTTP en el JSON decodificado, o lanza ErrorApi.
  static dynamic _interpretar(http.Response respuesta) {
    final cuerpoCrudo = utf8.decode(respuesta.bodyBytes);
    dynamic cuerpo;
    try {
      cuerpo = cuerpoCrudo.isEmpty ? null : jsonDecode(cuerpoCrudo);
    } catch (_) {
      cuerpo = null;
    }

    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return cuerpo;
    }

    final detalle = _detalle(cuerpo);

    switch (respuesta.statusCode) {
      case 401:
        // Si el servidor no tiene configurado FIREBASE_CREDENTIALS_PATH,
        // también responde 401. Renovar el token no sirve de nada ahí, así
        // que conviene distinguirlo: el problema es del backend.
        if (detalle != null && detalle.contains('FIREBASE_CREDENTIALS_PATH')) {
          throw const ErrorApi(
            401,
            'El servidor no tiene configurada la credencial de Firebase. '
            'Revisa el archivo .env del backend (servidor/.env).',
          );
        }
        throw const ErrorApi(
          401,
          'Tu sesión expiró. Vuelve a iniciar sesión.',
        );
      case 403:
        throw ErrorApi(403, detalle ?? 'No tienes permiso para ver esto.');
      case 409:
        throw const ErrorApi(
          409,
          'Antes de usar el tutor tienes que aceptar el consentimiento '
          'informado.',
        );
      case 422:
        throw const ErrorApi(
          422,
          'La app envió la petición en un formato que el servidor no '
          'entiende.',
        );
      case 503:
        throw const ErrorApi(
          503,
          'El tutor está atendiendo a muchos estudiantes. '
          'Inténtalo en un momento.',
        );
      default:
        throw ErrorApi(
          respuesta.statusCode,
          'Error del servidor (${respuesta.statusCode})'
          '${detalle == null ? '' : ': $detalle'}',
        );
    }
  }

  /// Todos los errores del backend tienen la forma {"detail": "..."},
  /// menos el 422, donde `detail` es una lista.
  static String? _detalle(dynamic cuerpo) {
    if (cuerpo is! Map) return null;
    final detalle = cuerpo['detail'];
    if (detalle is String) return detalle;
    if (detalle is List && detalle.isNotEmpty) return detalle.first.toString();
    return null;
  }

  static ErrorApi _errorDeRed(Object e) {
    if (e is TimeoutException) {
      return const ErrorApi(
        null,
        'El servidor tardó demasiado en responder. Inténtalo de nuevo.',
      );
    }
    if (e is SocketException || e is http.ClientException) {
      return const ErrorApi(
        null,
        'No se pudo conectar con el servidor. '
        '¿Está encendido y en la misma red?',
      );
    }
    return ErrorApi(null, 'No se pudo completar la operación: $e');
  }
}
