import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';

// =====================================================================
// CONFIGURACIÓN
// =====================================================================

class AuthConfig {
  /// Cambia a true cuando el backend de FastAPI esté listo.
  /// Con false, todo funciona en el dispositivo y no se necesita servidor.
  static const bool usarServidor = false;

  /// IP del equipo donde corre FastAPI dentro de la red local.
  /// Averíguala con `ipconfig` en Windows y reemplázala aquí.
  static const String baseUrl = 'http://192.168.1.100:8000';

  /// Si el servidor no responde en este tiempo, se usa el modo local.
  /// Evita que la app se congele si el wifi falla durante la demostración.
  static const Duration timeout = Duration(seconds: 6);
}

// =====================================================================
// CONTRATO
// =====================================================================

abstract class FuenteAuth {
  Future<ResultadoAuth> registrar({
    required String nombre,
    required String email,
    required String password,
  });

  Future<ResultadoAuth> iniciarSesion({
    required String email,
    required String password,
  });
}

// =====================================================================
// IMPLEMENTACIÓN LOCAL (SharedPreferences)
// =====================================================================

class AuthLocal implements FuenteAuth {
  static const _claveUsuarios = 'auth_usuarios';

  /// Genera una sal aleatoria para cada usuario.
  String _generarSal() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// La contraseña nunca se guarda en claro: solo su hash con sal.
  String _hashear(String password, String sal) {
    return sha256.convert(utf8.encode('$sal|$password')).toString();
  }

  Future<List<Map<String, dynamic>>> _leerUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final crudo = prefs.getString(_claveUsuarios);
    if (crudo == null || crudo.isEmpty) return [];
    try {
      final lista = jsonDecode(crudo) as List;
      return lista.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _guardarUsuarios(List<Map<String, dynamic>> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveUsuarios, jsonEncode(usuarios));
  }

  @override
  Future<ResultadoAuth> registrar({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final correo = email.trim().toLowerCase();
    final usuarios = await _leerUsuarios();

    final existe = usuarios.any((u) => u['email'] == correo);
    if (existe) {
      return const ResultadoAuth.error(
        'Ya existe una cuenta con ese correo',
        modoLocal: true,
      );
    }

    final sal = _generarSal();
    final registro = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'nombre': nombre.trim(),
      'email': correo,
      'sal': sal,
      'hash': _hashear(password, sal),
      'creadoEn': DateTime.now().toIso8601String(),
    };

    usuarios.add(registro);
    await _guardarUsuarios(usuarios);

    return ResultadoAuth.ok(
      Usuario(
        id: registro['id'] as String,
        nombre: registro['nombre'] as String,
        email: correo,
        creadoEn: DateTime.now(),
      ),
      modoLocal: true,
    );
  }

  @override
  Future<ResultadoAuth> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final correo = email.trim().toLowerCase();
    final usuarios = await _leerUsuarios();

    Map<String, dynamic>? encontrado;
    for (final u in usuarios) {
      if (u['email'] == correo) {
        encontrado = u;
        break;
      }
    }

    if (encontrado == null) {
      return const ResultadoAuth.error(
        'No existe una cuenta con ese correo',
        modoLocal: true,
      );
    }

    final hashIngresado = _hashear(password, encontrado['sal'] as String);
    if (hashIngresado != encontrado['hash']) {
      return const ResultadoAuth.error(
        'La contraseña no es correcta',
        modoLocal: true,
      );
    }

    return ResultadoAuth.ok(
      Usuario(
        id: encontrado['id'] as String,
        nombre: encontrado['nombre'] as String,
        email: correo,
        creadoEn: DateTime.tryParse(encontrado['creadoEn'] as String? ?? '') ??
            DateTime.now(),
      ),
      modoLocal: true,
    );
  }

  /// Guarda una copia local del usuario que validó el servidor,
  /// para que pueda entrar aunque después no haya red.
  Future<void> sincronizar({
    required Usuario usuario,
    required String password,
  }) async {
    final usuarios = await _leerUsuarios();
    usuarios.removeWhere((u) => u['email'] == usuario.email);

    final sal = _generarSal();
    usuarios.add({
      'id': usuario.id,
      'nombre': usuario.nombre,
      'email': usuario.email,
      'sal': sal,
      'hash': _hashear(password, sal),
      'creadoEn': usuario.creadoEn.toIso8601String(),
    });

    await _guardarUsuarios(usuarios);
  }
}

// =====================================================================
// IMPLEMENTACIÓN REMOTA (FastAPI)
// =====================================================================

class AuthRemoto implements FuenteAuth {
  final String baseUrl;
  AuthRemoto({this.baseUrl = AuthConfig.baseUrl});

  @override
  Future<ResultadoAuth> registrar({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final respuesta = await http
        .post(
          Uri.parse('$baseUrl/auth/registro'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombre': nombre.trim(),
            'email': email.trim().toLowerCase(),
            'password': password,
          }),
        )
        .timeout(AuthConfig.timeout);

    return _interpretar(respuesta);
  }

  @override
  Future<ResultadoAuth> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final respuesta = await http
        .post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim().toLowerCase(),
            'password': password,
          }),
        )
        .timeout(AuthConfig.timeout);

    return _interpretar(respuesta);
  }

  ResultadoAuth _interpretar(http.Response respuesta) {
    final cuerpo = jsonDecode(utf8.decode(respuesta.bodyBytes));

    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return ResultadoAuth.ok(Usuario.fromJson(cuerpo['usuario']));
    }

    final detalle = cuerpo is Map
        ? (cuerpo['detail'] ?? cuerpo['mensaje'])
        : null;
    return ResultadoAuth.error(
      detalle?.toString() ?? 'No se pudo completar la operación',
    );
  }
}

// =====================================================================
// SERVICIO PRINCIPAL
// =====================================================================

/// Punto único de acceso a la autenticación.
///
/// Intenta usar el servidor cuando está configurado. Si no responde,
/// recurre al modo local para que la aplicación siga funcionando.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _claveSesion = 'auth_sesion';

  final AuthLocal _local = AuthLocal();
  final AuthRemoto _remoto = AuthRemoto();

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  bool get autenticado => _usuario != null;

  /// true cuando la última operación se resolvió sin servidor.
  bool _sinServidor = false;
  bool get sinServidor => _sinServidor;

  // -------------------- Sesión persistida --------------------

  /// Llamar al arrancar la app, antes de decidir a qué pantalla ir.
  ///
  /// Todo el cuerpo va dentro de un try/catch: si por cualquier motivo
  /// el almacenamiento no está disponible, la app arranca igual en la
  /// pantalla de login en lugar de cerrarse.
  Future<void> cargarSesion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final crudo = prefs.getString(_claveSesion);
      if (crudo == null || crudo.isEmpty) return;

      final datos = jsonDecode(crudo);
      if (datos is! Map<String, dynamic>) {
        await prefs.remove(_claveSesion);
        return;
      }

      _usuario = Usuario.fromJson(datos);
    } catch (e) {
      debugPrint('Auth: no se pudo cargar la sesión -> $e');
      _usuario = null;
    }
  }

  Future<void> _guardarSesion(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveSesion, jsonEncode(usuario.toJson()));
    _usuario = usuario;
    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveSesion);
    _usuario = null;
    _sinServidor = false;
    notifyListeners();
  }

  // -------------------- Operaciones --------------------

  Future<ResultadoAuth> registrar({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final resultado = await _ejecutar(
      remoto: () => _remoto.registrar(
        nombre: nombre,
        email: email,
        password: password,
      ),
      local: () => _local.registrar(
        nombre: nombre,
        email: email,
        password: password,
      ),
      password: password,
    );

    if (resultado.exito) await _guardarSesion(resultado.usuario!);
    return resultado;
  }

  Future<ResultadoAuth> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final resultado = await _ejecutar(
      remoto: () => _remoto.iniciarSesion(email: email, password: password),
      local: () => _local.iniciarSesion(email: email, password: password),
      password: password,
    );

    if (resultado.exito) await _guardarSesion(resultado.usuario!);
    return resultado;
  }

  /// Intenta el servidor y cae al modo local si no hay red.
  Future<ResultadoAuth> _ejecutar({
    required Future<ResultadoAuth> Function() remoto,
    required Future<ResultadoAuth> Function() local,
    required String password,
  }) async {
    if (!AuthConfig.usarServidor) {
      _sinServidor = true;
      return local();
    }

    try {
      final resultado = await remoto();
      _sinServidor = false;
      // Guarda una copia local para poder entrar sin red más adelante.
      if (resultado.exito && resultado.usuario != null) {
        await _local.sincronizar(
          usuario: resultado.usuario!,
          password: password,
        );
      }
      return resultado;
    } on SocketException {
      _sinServidor = true;
      return local();
    } on TimeoutException {
      _sinServidor = true;
      return local();
    } on http.ClientException {
      _sinServidor = true;
      return local();
    } catch (e) {
      debugPrint('Auth: error inesperado del servidor -> $e');
      _sinServidor = true;
      return local();
    }
  }
}