import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // <-- ¡Aquí eliminamos el "auth/"!
import 'screens/main_scaffold.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NormativasApp());
}

class NormativasApp extends StatelessWidget {
  const NormativasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Normativas SW',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // La app siempre arranca en el flujo de autenticación. LoginScreen
      // navega a RegisterScreen, o reemplaza la ruta por MainScaffold
      // (con el menú inferior) tras un inicio de sesión/registro exitoso.
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScaffold(),
      },
    );
  }
}