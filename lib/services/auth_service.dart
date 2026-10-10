import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/usuario.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'usuario_service.dart';

/// Autenticación de la aplicación, sobre **Firebase Authentication**.
///
/// Por qué cambió: el backend no maneja contraseñas. Solo verifica el
/// `id_token` que Firebase le da a la app, y crea la fila del usuario la
/// primera vez que ve un uid. No existen `/auth/registro` ni `/auth/login`.
/// Sin un usuario de Firebase no hay token, y sin token todos los endpoints
/// protegidos responden 401.
///
/// La interfaz pública es la misma que tenía la versión local
/// (`instance`, `usuario`, `autenticado`, `cargarSesion`, `registrar`,
/// `iniciarSesion`, `cerrarSesion`), así que `login_screen`,
/// `register_screen`, `profile_screen`, `home_screen_rediseno` y `main.dart`
/// siguen funcionando sin cambios.
///
/// Requisitos en Firebase (consola del proyecto `tutor-ia-upec-ec787`):
/// Authentication -> Sign-in method -> **Correo/contraseña activado**.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// Getter, no campo: como campo se resolveria al construir el singleton,
  /// y en `flutter test` (donde Firebase no se inicializa) eso lanzaria una
  /// excepcion al leer algo tan inocente como `autenticado`.
  FirebaseAuth get _firebase => FirebaseAuth.instance;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  bool get autenticado => _usuario != null;

  /// uid de Firebase del usuario actual, o null. Es el identificador que
  /// usa el backend (`/perfil/{uid}`).
  String? get uid => _usuario?.id;

  /// Se mantiene por compatibilidad: con Firebase no hay modo local.
  bool get sinServidor => false;

  /// Si la última llamada a `/usuarios/yo` llegó al servidor.
  /// null = todavía no se ha intentado.
  ///
  /// Sirve para no mostrarle al estudiante la pantalla de consentimiento
  /// cuando el servidor está apagado: aceptarlo fallaría igual, y parece
  /// que la app está rota cuando en realidad solo falta encender el
  /// backend.
  bool? _backendAlcanzable;
  bool get backendAlcanzable => _backendAlcanzable ?? false;

  StreamSubscription<User?>? _suscripcion;

  // ------------------------------------------------------- arranque

  /// Llamar al arrancar la app, DESPUÉS de `Firebase.initializeApp` y
  /// ANTES de decidir a qué pantalla ir.
  ///
  /// Firebase guarda la sesión en el dispositivo por su cuenta, así que
  /// aquí solo hay que leer la cuenta actual. Todo va dentro de try/catch:
  /// si algo falla, la app arranca en el login en lugar de cerrarse.
  Future<void> cargarSesion() async {
    try {
      // Si Firebase está restaurando la sesión del disco, currentUser
      // puede ser null durante un instante. authStateChanges().first
      // espera a que el SDK se pronuncie.
      final cuenta = _firebase.currentUser ??
          await _firebase
              .authStateChanges()
              .first
              .timeout(const Duration(seconds: 5), onTimeout: () => null);

      if (cuenta != null) {
        _usuario = Usuario.deFirebase(cuenta);
      }

      _escucharCambios();
    } catch (e) {
      debugPrint('Auth: no se pudo cargar la sesión -> $e');
      _usuario = null;
    }
  }

  /// Mantiene `_usuario` al día si Firebase cierra la sesión por su cuenta
  /// (token revocado, cuenta borrada, contraseña cambiada en otro aparato).
  void _escucharCambios() {
    _suscripcion?.cancel();
    _suscripcion = _firebase.authStateChanges().listen((cuenta) {
      if (cuenta == null) {
        if (_usuario != null) {
          _usuario = null;
          notifyListeners();
        }
      } else if (_usuario?.id != cuenta.uid) {
        _usuario = Usuario.deFirebase(cuenta);
        notifyListeners();
      }
    });
  }

  // ------------------------------------------------------- operaciones

  Future<ResultadoAuth> registrar({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      final credencial = await _firebase.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final cuenta = credencial.user;
      if (cuenta == null) {
        return const ResultadoAuth.error('No se pudo crear la cuenta.');
      }

      // El nombre se guarda en el perfil de Firebase para que viaje dentro
      // del token y el backend lo reciba en `GET /usuarios/yo`.
      final nombreLimpio = nombre.trim();
      if (nombreLimpio.isNotEmpty) {
        await cuenta.updateDisplayName(nombreLimpio);
        await cuenta.reload();
      }

      _usuario = Usuario.deFirebase(
        _firebase.currentUser ?? cuenta,
        nombreAlternativo: nombreLimpio,
      );
      notifyListeners();

      // El backend crea la fila del usuario la primera vez que ve el token.
      // No hay endpoint de registro que llamar: basta con presentarse.
      await _presentarseAlBackend();

      return ResultadoAuth.ok(_usuario);
    } on FirebaseAuthException catch (e) {
      return ResultadoAuth.error(_mensajeDeFirebase(e));
    } catch (e) {
      debugPrint('Auth: error inesperado al registrar -> $e');
      return const ResultadoAuth.error(
        'No se pudo crear la cuenta. Revisa tu conexión a internet.',
      );
    }
  }

  Future<ResultadoAuth> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final credencial = await _firebase.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final cuenta = credencial.user;
      if (cuenta == null) {
        return const ResultadoAuth.error('No se pudo iniciar sesión.');
      }

      _usuario = Usuario.deFirebase(cuenta);
      notifyListeners();

      await _presentarseAlBackend();

      return ResultadoAuth.ok(_usuario);
    } on FirebaseAuthException catch (e) {
      return ResultadoAuth.error(_mensajeDeFirebase(e));
    } catch (e) {
      debugPrint('Auth: error inesperado al iniciar sesión -> $e');
      return const ResultadoAuth.error(
        'No se pudo iniciar sesión. Revisa tu conexión a internet.',
      );
    }
  }

  Future<void> cerrarSesion() async {
    try {
      await _firebase.signOut();
    } catch (e) {
      debugPrint('Auth: error al cerrar sesión -> $e');
    }
    _usuario = null;
    notifyListeners();
  }

  /// Token de Firebase listo para la cabecera `Authorization`.
  /// Se pide justo antes de cada petición, no se guarda: caduca a la hora
  /// y el SDK lo renueva solo.
  Future<String?> token({bool forzarRenovacion = false}) =>
      ApiClient.token(forzarRenovacion: forzarRenovacion);

  // ------------------------------------------------------- backend

  /// Consulta `GET /usuarios/yo` para que el backend cree o actualice la
  /// fila del estudiante y para saber si ya aceptó el consentimiento.
  ///
  /// Si el servidor está apagado esto falla, y no pasa nada: la sesión de
  /// Firebase ya es válida y el estudiante puede usar las lecciones; solo
  /// el tutor necesita el servidor. Por eso el error se registra y se
  /// ignora en lugar de tumbar el login.
  Future<void> _presentarseAlBackend() async {
    try {
      // Timeout corto: esta llamada no debe hacer esperar al estudiante.
      final datos = await UsuarioService.miUsuario(
        timeout: ApiConfig.timeoutArranque,
      );
      _usuario = _usuario?.conDatosDelBackend(
        nombre: datos.nombre,
        rol: datos.rol,
        consentimientoAceptado: datos.consentimientoAceptado,
      );
      _backendAlcanzable = true;
      notifyListeners();
    } on ErrorApi catch (e) {
      _backendAlcanzable = false;
      debugPrint('Auth: el backend no respondió a /usuarios/yo -> ${e.mensaje}');
    } catch (e) {
      _backendAlcanzable = false;
      debugPrint('Auth: fallo al consultar /usuarios/yo -> $e');
    }
  }

  /// Vuelve a leer `/usuarios/yo`. La llama la pantalla de consentimiento
  /// después de aceptar.
  Future<void> refrescarDesdeBackend() => _presentarseAlBackend();

  /// Marca en memoria que el consentimiento quedó aceptado, para no tener
  /// que volver a consultar el servidor.
  void marcarConsentimientoAceptado() {
    if (_usuario == null) return;
    _usuario = _usuario!.conDatosDelBackend(consentimientoAceptado: true);
    notifyListeners();
  }

  // ------------------------------------------------------- mensajes

  /// Traduce los códigos de Firebase a algo que el estudiante entienda.
  String _mensajeDeFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'weak-password':
        return 'La contraseña es muy débil: usa al menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'El inicio de sesión con correo y contraseña no está '
            'habilitado en Firebase.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        // Firebase ya no distingue entre correo inexistente y contraseña
        // equivocada (lo unifica en invalid-credential), y es mejor así:
        // no revela qué correos están registrados.
        return 'El correo o la contraseña no son correctos.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera un momento y vuelve a probar.';
      case 'network-request-failed':
        return 'Sin conexión a internet. Firebase necesita red para '
            'validar la cuenta.';
      default:
        return e.message ?? 'No se pudo completar la operación (${e.code}).';
    }
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
