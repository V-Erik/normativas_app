import 'package:firebase_auth/firebase_auth.dart' show User;

/// Usuario autenticado de la aplicación.
///
/// [id] es el **uid de Firebase**: es el mismo identificador que usa el
/// backend en `/perfil/{uid}` y el que asocia el progreso del estudiante.
/// Ya no se guardan contraseñas en el dispositivo: de la contraseña se
/// encarga Firebase Authentication y la app nunca la ve.
class Usuario {
  final String id;
  final String nombre;
  final String email;
  final DateTime creadoEn;

  /// Rol que informa el backend en `GET /usuarios/yo`:
  /// "estudiante", "docente" o "admin". Vacío hasta la primera consulta.
  final String rol;

  /// Si ya aceptó el consentimiento informado. Mientras sea false,
  /// `POST /chat` responde 409.
  final bool consentimientoAceptado;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.creadoEn,
    this.rol = '',
    this.consentimientoAceptado = false,
  });

  /// Construye el usuario a partir de la cuenta de Firebase.
  /// Si la cuenta no tiene displayName (puede pasar justo tras el registro),
  /// se usa la parte del correo antes de la @ para no mostrar un nombre vacío.
  factory Usuario.deFirebase(User cuenta, {String? nombreAlternativo}) {
    final correo = cuenta.email ?? '';
    final nombreCrudo = (cuenta.displayName?.trim().isNotEmpty ?? false)
        ? cuenta.displayName!.trim()
        : (nombreAlternativo?.trim().isNotEmpty ?? false)
            ? nombreAlternativo!.trim()
            : correo.split('@').first;

    return Usuario(
      id: cuenta.uid,
      nombre: nombreCrudo,
      email: correo,
      creadoEn: cuenta.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// Copia con los datos que devolvió el backend.
  Usuario conDatosDelBackend({
    String? nombre,
    String? rol,
    bool? consentimientoAceptado,
  }) {
    return Usuario(
      id: id,
      nombre: (nombre?.trim().isNotEmpty ?? false) ? nombre!.trim() : this.nombre,
      email: email,
      creadoEn: creadoEn,
      rol: rol ?? this.rol,
      consentimientoAceptado:
          consentimientoAceptado ?? this.consentimientoAceptado,
    );
  }

  /// Iniciales para el avatar del perfil.
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  /// Primer nombre, para saludos.
  String get primerNombre {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    return partes.isEmpty ? nombre : partes.first;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'creadoEn': creadoEn.toIso8601String(),
        'rol': rol,
        'consentimientoAceptado': consentimientoAceptado,
      };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        creadoEn: DateTime.tryParse(json['creadoEn'] as String? ?? '') ??
            DateTime.now(),
        rol: json['rol'] as String? ?? '',
        consentimientoAceptado: json['consentimientoAceptado'] as bool? ?? false,
      );
}

/// Resultado de una operación de autenticación.
class ResultadoAuth {
  final bool exito;
  final Usuario? usuario;
  final String? mensajeError;

  /// Se mantiene por compatibilidad con el código anterior. Con Firebase
  /// Auth siempre es false: ya no hay un modo "sin servidor".
  final bool modoLocal;

  const ResultadoAuth.ok(this.usuario, {this.modoLocal = false})
      : exito = true,
        mensajeError = null;

  const ResultadoAuth.error(this.mensajeError, {this.modoLocal = false})
      : exito = false,
        usuario = null;
}
