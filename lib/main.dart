import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'screens/auth/login_screen.dart';
import 'screens/main_scaffold.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // La sesión se carga ANTES de inicializar Rive. Así, si el runtime
  // nativo de Rive falla, al menos la sesión ya quedó resuelta.
  await AuthService.instance.cargarSesion();

  // Rive 0.14+ usa un runtime nativo en C++. Va dentro de try/catch
  // porque un fallo aquí no debe impedir que la app abra: ninguna
  // pantalla activa usa animaciones .riv todavía.
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
    // Si ya hay sesión guardada, entra directo. Si no, va al login.
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