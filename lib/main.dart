import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_scaffold.dart';
import 'services/auth_service.dart';
import 'services/progreso_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase va primero: AuthService ya no funciona sin él, porque la
  // identidad del estudiante es la cuenta de Firebase y el backend solo
  // acepta su id_token.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase no se pudo inicializar -> $e');
  }

  // Lee la sesión que Firebase guarda en el dispositivo. Dentro de
  // try/catch: si falla, la app arranca en el login en lugar de cerrarse.
  try {
    await AuthService.instance.cargarSesion();
  } catch (e) {
    debugPrint('No se pudo cargar la sesión -> $e');
  }

  // Si ya había sesión, recupera el avance guardado y pide al servidor el
  // XP y la racha reales. No bloquea el arranque si el servidor está
  // apagado: las lecciones funcionan sin red, solo el tutor la necesita.
  if (AuthService.instance.autenticado) {
    try {
      await ProgresoService.instance.iniciarSesionEstudiante();
    } catch (e) {
      debugPrint('No se pudo preparar el progreso -> $e');
    }
  }

  // Rive 0.14+ usa un runtime nativo en C++. Va dentro de try/catch
  // porque un fallo aquí no debe impedir que la app abra: solo el
  // escáner AR usa animaciones .riv.
  try {
    await rive.RiveNative.init();
  } catch (e) {
    debugPrint('Rive no se pudo inicializar -> $e');
  }

  runApp(const NormativasApp());
}

class NormativasApp extends StatelessWidget {
  const NormativasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Si ya hay sesión de Firebase, entra directo. Si no, va al login.
    final rutaInicial = AuthService.instance.autenticado ? '/home' : '/login';

    return MaterialApp(
      title: 'Normativas SW',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: rutaInicial,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScaffold(),
      },
    );
  }
}
