import 'api_client.dart';
import 'api_config.dart';

/// Estado del servidor, de `GET /api/v1/salud` (público, sin token).
///
/// Se consulta antes de dejar que el estudiante escriba, para poder avisar
/// de que el tutor no está disponible en vez de dejarlo esperando.
class EstadoSalud {
  /// "ok" si Ollama responde; "degradado" si el servidor está arriba pero
  /// Ollama no contesta.
  final String estado;
  final String modelo;
  final bool ollamaDisponible;
  final int documentosIndexados;
  final int chunksIndexados;

  const EstadoSalud({
    required this.estado,
    required this.modelo,
    required this.ollamaDisponible,
    required this.documentosIndexados,
    required this.chunksIndexados,
  });

  bool get listo => estado == 'ok' && documentosIndexados > 0;

  /// Qué decirle al estudiante cuando no está listo.
  String get aviso {
    if (documentosIndexados == 0) {
      return 'El servidor está encendido pero no tiene documentos '
          'indexados. Revisa la consola del backend.';
    }
    if (!ollamaDisponible) {
      return 'El modelo de lenguaje (Ollama) no está respondiendo. '
          'Comprueba que Ollama esté corriendo.';
    }
    return 'El tutor no está disponible en este momento.';
  }

  factory EstadoSalud.fromJson(Map<String, dynamic> j) => EstadoSalud(
        estado: j['estado'] as String? ?? 'desconocido',
        modelo: j['modelo'] as String? ?? '',
        ollamaDisponible: j['ollama_disponible'] as bool? ?? false,
        documentosIndexados: j['documentos_indexados'] as int? ?? 0,
        chunksIndexados: j['chunks_indexados'] as int? ?? 0,
      );
}

/// Usuario tal como lo ve el backend, de `GET /api/v1/usuarios/yo`.
class UsuarioBackend {
  final String uid;
  final String correo;
  final String nombre;
  final String? fotoUrl;

  /// "password" o "google".
  final String proveedor;

  /// "estudiante", "docente" o "admin".
  final String rol;

  final DateTime? fechaRegistro;
  final DateTime? ultimoAcceso;

  /// Si es false, `POST /chat` responde 409.
  final bool consentimientoAceptado;
  final DateTime? consentimientoFecha;

  const UsuarioBackend({
    required this.uid,
    required this.correo,
    required this.nombre,
    required this.fotoUrl,
    required this.proveedor,
    required this.rol,
    required this.fechaRegistro,
    required this.ultimoAcceso,
    required this.consentimientoAceptado,
    required this.consentimientoFecha,
  });

  factory UsuarioBackend.fromJson(Map<String, dynamic> j) => UsuarioBackend(
        uid: j['uid'] as String? ?? '',
        correo: j['correo'] as String? ?? '',
        nombre: j['nombre'] as String? ?? '',
        fotoUrl: j['foto_url'] as String?,
        proveedor: j['proveedor'] as String? ?? '',
        rol: j['rol'] as String? ?? 'estudiante',
        fechaRegistro: DateTime.tryParse(j['fecha_registro'] as String? ?? ''),
        ultimoAcceso: DateTime.tryParse(j['ultimo_acceso'] as String? ?? ''),
        consentimientoAceptado: j['consentimiento_aceptado'] as bool? ?? false,
        consentimientoFecha:
            DateTime.tryParse(j['consentimiento_fecha'] as String? ?? ''),
      );
}

/// Identidad y consentimiento.
class UsuarioService {
  const UsuarioService._();

  /// `GET /api/v1/salud`. Público: no necesita token ni sesión.
  static Future<EstadoSalud> salud() async {
    final datos = await ApiClient.getPublico(
      '/salud',
      timeout: ApiConfig.timeoutSalud,
    );
    return EstadoSalud.fromJson(datos as Map<String, dynamic>);
  }

  /// `GET /api/v1/usuarios/yo`.
  ///
  /// La primera vez que el backend ve un uid crea el usuario con
  /// rol "estudiante" y consentimiento en false. No hay endpoint de
  /// registro: esta llamada ES el registro en el backend.
  static Future<UsuarioBackend> miUsuario({Duration? timeout}) async {
    final datos = await ApiClient.get('/usuarios/yo', timeout: timeout);
    return UsuarioBackend.fromJson(datos as Map<String, dynamic>);
  }

  /// `POST /api/v1/usuarios/consentimiento`. No lleva cuerpo.
  /// Devuelve el mismo objeto, ya con el consentimiento aceptado.
  static Future<UsuarioBackend> aceptarConsentimiento() async {
    final datos = await ApiClient.post('/usuarios/consentimiento');
    return UsuarioBackend.fromJson(datos as Map<String, dynamic>);
  }
}
