import 'package:flutter/material.dart';

/// Cabeza de la mascota ESO como avatar circular.
///
/// Reemplaza al icono genérico de robot (`Icons.smart_toy_rounded`) en el
/// chat. Usa una imagen estática y no la animación Lottie a propósito: en
/// una lista de mensajes habría un avatar por burbuja, y cada animación
/// Lottie lleva su propio controlador y repintado. Una imagen se dibuja
/// una vez y no cuesta nada.
///
/// Si el asset no existe todavía (porque falta declararlo en pubspec.yaml
/// o copiar el PNG), cae al icono anterior en lugar de romper la pantalla.
class MascotaAvatar extends StatelessWidget {
  /// Diámetro del círculo.
  final double size;

  /// Color del círculo de fondo. Por defecto, un lila suave.
  final Color? fondo;

  /// Color del icono de reserva si la imagen no se puede cargar.
  final Color acento;

  const MascotaAvatar({
    super.key,
    this.size = 28,
    this.fondo,
    this.acento = const Color(0xFF6D4AFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fondo ?? acento.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: Padding(
        // Un pelín de aire para que la cabeza no toque el borde del círculo.
        padding: EdgeInsets.all(size * 0.10),
        child: Image.asset(
          'assets/img/mascota_cabeza.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Icon(
            Icons.smart_toy_rounded,
            size: size * 0.58,
            color: acento,
          ),
        ),
      ),
    );
  }
}

/// La cabeza de la mascota suelta, sin el círculo de fondo.
/// Para la pantalla de bienvenida del chat.
class MascotaCabeza extends StatelessWidget {
  final double size;
  final Color acento;

  const MascotaCabeza({
    super.key,
    this.size = 128,
    this.acento = const Color(0xFF6D4AFF),
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/mascota_cabeza.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => Icon(
        Icons.smart_toy_rounded,
        size: size * 0.7,
        color: acento,
      ),
    );
  }
}

/// Tres puntos que laten mientras el tutor genera la respuesta.
///
/// Los de antes eran círculos quietos, que con esperas de varios segundos
/// parecían la app colgada. Estos se mueven con un desfase entre sí.
class PuntosEscribiendo extends StatefulWidget {
  final Color color;
  const PuntosEscribiendo({super.key, required this.color});

  @override
  State<PuntosEscribiendo> createState() => _PuntosEscribiendoState();
}

class _PuntosEscribiendoState extends State<PuntosEscribiendo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 14,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(3, (i) {
              // Cada punto va un tercio de ciclo por detrás del anterior.
              final fase = (_c.value - i * 0.18) % 1.0;
              // Sube y baja solo durante la primera mitad del ciclo.
              final onda = fase < 0.5
                  ? Curves.easeInOut.transform(1 - (fase * 4 - 1).abs().clamp(0.0, 1.0))
                  : 0.0;
              return Transform.translate(
                offset: Offset(0, -3.5 * onda),
                child: Opacity(
                  opacity: 0.45 + 0.55 * onda,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
