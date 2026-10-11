import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'ar_scanner_screen.dart';
import 'chat_screen.dart';
import 'home_screen_rediseno.dart';
import 'profile_screen.dart';

/// Contenedor principal de la app: mantiene las 4 pestañas vivas con
/// [IndexedStack] (para no perder el progreso del chat al navegar) y
/// muestra la barra de navegación inferior personalizada.
///
/// LA CÁMARA Y EL IndexedStack
/// ---------------------------
/// `IndexedStack` construye **las cuatro** pestañas desde el principio y
/// no las destruye al cambiar: eso es justo lo que se quiere para el chat,
/// pero significa que la pantalla de realidad aumentada existe desde que
/// arranca la app. Si la cámara arrancara sola, estaría encendida toda la
/// sesión: calienta el teléfono y se come la batería.
///
/// Por eso se le dice a [ArScannerScreen] si está a la vista, y ella
/// arranca y detiene la cámara. La pestaña sigue conservando su estado;
/// lo único que se apaga es el hardware.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  /// Posición de la pestaña de realidad aumentada en [_tabs] y en la barra
  /// inferior. Si se reordenan las pestañas, hay que cambiar esto.
  static const int _indiceRA = 2;

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreenRediseno(),
          const ChatScreen(),
          ArScannerScreen(activa: _index == _indiceRA),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
