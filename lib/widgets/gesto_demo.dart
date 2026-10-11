import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/escaneos_ra_service.dart';
import '../services/progreso_service.dart';

/// Gesto escondido para abrir el modo demostración.
///
/// PARA QUÉ
/// --------
/// En una sustentación no hay tiempo de completar treinta y siete
/// lecciones en vivo, y enseñar una pantalla llena de candados da la
/// impresión equivocada: parece que la app no tiene contenido, cuando lo
/// que pasa es que el progreso funciona.
///
/// `ProgresoService.desbloquearTodo()` ya existía en el código desde hace
/// tiempo, pero no estaba conectado a nada, así que no había forma de
/// llamarlo sin recompilar.
///
/// POR QUÉ UN GESTO Y NO UN BOTÓN
/// ------------------------------
/// Un botón que diga "modo demostración" en la pantalla de perfil se lo
/// va a leer el tribunal, y la primera pregunta va a ser si lo que están
/// viendo es real o está preparado. Mantener pulsado el avatar tres
/// segundos no se distingue de una pulsación torpe.
///
/// QUÉ HACE Y QUÉ NO HACE
/// ----------------------
/// Abre los candados de todas las lecciones y olvida las respuestas de
/// los marcadores de RA, para que las tarjetas vuelvan a plantear la
/// pregunta en limpio.
///
/// **No marca nada como completado y no suma XP.** El avance real no se
/// toca, y como el desbloqueo no se guarda en el dispositivo, al reiniciar
/// la app todo vuelve a su sitio. Es decir: no ensucia los datos. Si lo
/// usas durante las pruebas con estudiantes, los resultados siguen siendo
/// los de ellos.
class GestoDemo extends StatefulWidget {
  final Widget child;

  /// Cuánto hay que mantener pulsado. Tres segundos es bastante más que
  /// un toque accidental y bastante menos de lo que incomoda sostener.
  final Duration espera;

  const GestoDemo({
    super.key,
    required this.child,
    this.espera = const Duration(seconds: 3),
  });

  @override
  State<GestoDemo> createState() => _GestoDemoState();
}

class _GestoDemoState extends State<GestoDemo> {
  Timer? _cuenta;
  bool _pulsando = false;

  @override
  void dispose() {
    _cuenta?.cancel();
    super.dispose();
  }

  void _empezar() {
    setState(() => _pulsando = true);
    _cuenta?.cancel();
    _cuenta = Timer(widget.espera, _activar);
  }

  void _soltar() {
    _cuenta?.cancel();
    _cuenta = null;
    if (mounted) setState(() => _pulsando = false);
  }

  Future<void> _activar() async {
    if (!mounted) return;
    setState(() => _pulsando = false);

    // Un golpe seco, para saber que entró sin tener que mirar la pantalla.
    await HapticFeedback.heavyImpact();

    ProgresoService.instance.desbloquearTodo();
    await EscaneosRAService.instance.reiniciar();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2B2B3C),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: const Text(
          'Modo demostración: lecciones abiertas y marcadores en limpio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // `onLongPress` de Flutter salta a los 500 ms, demasiado pronto.
      // Con start/end se controla la espera real.
      onLongPressStart: (_) => _empezar(),
      onLongPressEnd: (_) => _soltar(),
      onLongPressCancel: _soltar,
      // Hay que responder también al toque corto, o el gesto largo no se
      // reconoce en algunos teléfonos.
      onTap: () {},
      child: AnimatedScale(
        // El único aviso de que está contando. Parece una pulsación
        // normal, así que no delata nada a quien esté mirando.
        scale: _pulsando ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
