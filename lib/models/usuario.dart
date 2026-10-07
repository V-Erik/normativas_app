/// Usuario autenticado de la aplicación.
class Usuario {
  final String id;
  final String nombre;
  final String email;
  final DateTime creadoEn;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.creadoEn,
  });

  /// Iniciales para mostrar en el avatar del perfil.
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
      };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        creadoEn: DateTime.tryParse(json['creadoEn'] as String? ?? '') ??
            DateTime.now(),
      );
}

/// Resultado de una operación de autenticación.
class ResultadoAuth {
  final bool exito;
  final Usuario? usuario;
  final String? mensajeError;

  /// Indica si la operación se resolvió sin servidor.
  final bool modoLocal;

  const ResultadoAuth.ok(this.usuario, {this.modoLocal = false})
      : exito = true,
        mensajeError = null;

  const ResultadoAuth.error(this.mensajeError, {this.modoLocal = false})
      : exito = false,
        usuario = null;
}