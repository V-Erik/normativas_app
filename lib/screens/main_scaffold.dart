import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'ar_scanner_screen.dart';
import 'chat_screen.dart';
import 'home_screen_rediseno.dart';
import 'profile_screen.dart';

/// La pestaña que la aplicación debe estar mostrando.
///
/// POR QUÉ HACE FALTA ESTO Y NO VALE UN InheritedWidget
/// ----------------------------------------------------
/// Las pantallas apiladas —una lección, el escáner de una ficha— se abren
/// con `Navigator.push` sobre el mismo Navigator que contiene a
/// [MainScaffold], no dentro de su árbol de widgets. Un `.of(context)`
/// desde una lección no encontraría nunca al contenedor, porque la
/// lección es su hermana en la pila de rutas, no su descendiente.
///
/// Un notificador compartido sí las alcanza, y encaja con cómo ya
/// funcionan los servicios de esta aplicación.
///
/// Se usa en dos sentidos: la barra inferior pide pestaña cuando el
/// estudiante la toca, y cualquier pantalla puede pedirla también. Al
/// haber una sola fuente, las dos vías no pueden desincronizarse.
class PestanaPrincipal {
  const PestanaPrincipal._();

  static const int inicio = 0;
  static const int tutor = 1;
  static const int realidadAumentada = 2;
  static const int perfil = 3;

  static final ValueNotifier<int> solicitada = ValueNotifier<int>(inicio);

  /// Pide que se muestre [indice]. Si ya es la pestaña actual no hace
  /// nada, que es justo lo que se quiere: nadie debería reiniciar la
  /// cámara por pulsar dos veces.
  static void pedir(int indice) => solicitada.value = indice;
}

/// Contenedor principal de la app: mantiene las pestañas vivas con
/// [IndexedStack] (para no perder el progreso del chat al navegar) y
/// muestra la barra de navegación inferior personalizada.
///
/// LA CÁMARA Y EL IndexedStack
/// ---------------------------
/// `IndexedStack` construye **todos** sus hijos desde el principio y no
/// los destruye al cambiar de pestaña: eso es justo lo que se quiere para
/// el chat, pero con la realidad aumentada significaría montar el widget
/// de cámara nada más abrir la app. Aunque el controlador no arranque
/// (`autoStart: false`), el sistema reserva la sesión de cámara y enciende
/// el indicador de la barra de estado. Visto desde fuera, la app parece
/// estar mirando sin permiso.
///
/// Por eso esa pestaña se mantiene dormida hasta que el estudiante la
/// toca por primera vez. A partir de ahí conserva su estado como las
/// demás, y lo único que se enciende y se apaga es el hardware, mediante
/// el indicador [ArScannerScreen.activa].
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  /// Falso hasta que el estudiante entra por primera vez en la pestaña de
  /// realidad aumentada. Mientras tanto, ese hueco de la pila lo ocupa un
  /// marcador de posición que no toca la cámara.
  bool _raMontada = false;

  int _index = PestanaPrincipal.inicio;

  @override
  void initState() {
    super.initState();
    PestanaPrincipal.solicitada.addListener(_atender);
    // Por si alguien pidió una pestaña mientras esto no estaba montado.
    _index = PestanaPrincipal.solicitada.value;
    _raMontada = _index == PestanaPrincipal.realidadAumentada;
  }

  @override
  void dispose() {
    PestanaPrincipal.solicitada.removeListener(_atender);
    super.dispose();
  }

  void _atender() {
    if (!mounted) return;
    final i = PestanaPrincipal.solicitada.value;
    if (i == _index) return;
    setState(() {
      _index = i;
      // Entrar en la pestaña de RA, venga de donde venga, es lo que
      // autoriza a montar la cámara.
      if (i == PestanaPrincipal.realidadAumentada) _raMontada = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreenRediseno(),
          const ChatScreen(),
          _raMontada
              ? ArScannerScreen(
                  activa: _index == PestanaPrincipal.realidadAumentada,
                )
              : const ColoredBox(color: Color(0xFF101014)),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        // La barra pide por el mismo canal que las demás pantallas, para
        // que no haya dos maneras de cambiar de pestaña.
        onTap: PestanaPrincipal.pedir,
      ),
    );
  }
}