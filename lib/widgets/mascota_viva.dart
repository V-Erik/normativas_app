import 'dart:math';

import 'package:flutter/material.dart';

/// La mascota ESO con vida propia: flota despacio y parpadea.
///
/// No usa Lottie. El `Frame_1.json` es una animación de entrada que se
/// reproduce una vez y se queda quieta; esto es lo contrario, un estado de
/// reposo que no termina nunca. Hacerlo en Flutter permite además que
/// reaccione a lo que pasa en la app (ver [pensando]).
///
/// DOS TAMAÑOS DEL MISMO PERSONAJE
/// -------------------------------
/// Con [completa] en false se dibuja solo la cabeza, que es lo que cabe
/// en el avatar de una burbuja de chat. Con true se dibuja el muñeco
/// entero, cohete incluido, que es lo que se usa en la realidad aumentada:
/// ahí el personaje tiene que leerse como alguien que está de pie sobre la
/// tarjeta, y una cabeza suelta flotando no da esa lectura.
///
/// CÓMO ESTÁ MONTADO
/// -----------------
/// Cada versión viene partida en dos imágenes recortadas con el mismo
/// rectángulo, así que apiladas encajan al pixel:
///
///   assets/img/mascota_cabeza_base.png   la cabeza sin ojos   (256×256)
///   assets/img/mascota_ojos.png          los ojos de la cabeza
///   assets/img/mascota_cuerpo_base.png   el muñeco sin ojos   (271×640)
///   assets/img/mascota_cuerpo_ojos.png   los ojos del muñeco
///
/// Las cuatro salen renderizadas del propio Lottie ya limpio, aislando sus
/// capas, así que tienen la forma exacta del diseño y no un recorte a
/// mano.
///
/// El parpadeo aplasta la capa de los ojos en vertical. El pivote no es el
/// centro de la imagen sino el centro de los ojos dentro de ella; con el
/// centro del lienzo los ojos se desplazarían al cerrarse, y en el muñeco
/// entero, donde los ojos están muy arriba, el efecto sería grotesco.
class MascotaViva extends StatefulWidget {
  /// Alto del personaje. En la versión de cabeza el widget es cuadrado;
  /// en la entera el ancho sale de la proporción real del dibujo.
  final double size;

  /// true dibuja el muñeco entero; false, solo la cabeza.
  final bool completa;

  /// Con true flota un poco más rápido y parpadea más seguido. Se usa
  /// mientras el tutor genera una respuesta: comunica actividad sin
  /// recurrir a otro indicador de carga.
  final bool pensando;

  final Color acento;

  const MascotaViva({
    super.key,
    this.size = 132,
    this.completa = false,
    this.pensando = false,
    this.acento = const Color(0xFF6D4AFF),
  });

  /// Ancho / alto del muñeco entero, medido sobre el recorte real.
  static const double razonCuerpo = 0.4234;

  /// Ancho que ocupará un muñeco entero de alto [alto].
  static double anchoDeCuerpo(double alto) => alto * razonCuerpo;

  @override
  State<MascotaViva> createState() => _MascotaVivaState();
}

class _MascotaVivaState extends State<MascotaViva>
    with TickerProviderStateMixin {
  /// Centro de los ojos dentro de cada PNG, en coordenadas de Alignment
  /// (-1 arriba/izquierda, +1 abajo/derecha).
  static const _pivoteCabeza = Alignment(0.008, 0.117);
  static const _pivoteCuerpo = Alignment(0.0124, -0.6196);

  late final AnimationController _flotar;
  late final AnimationController _parpadeo;
  final _azar = Random();
  bool _vivo = true;

  @override
  void initState() {
    super.initState();

    _flotar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _parpadeo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );

    _programarParpadeo();
  }

  /// Parpadeos a intervalos irregulares. Un parpadeo cada N segundos
  /// exactos se nota mecánico; el azar es lo que lo hace parecer vivo.
  /// De vez en cuando encadena dos, como hacemos las personas.
  Future<void> _programarParpadeo() async {
    while (_vivo) {
      final base = widget.pensando ? 1400 : 2600;
      final espera = base + _azar.nextInt(widget.pensando ? 1600 : 3400);
      await Future<void>.delayed(Duration(milliseconds: espera));
      if (!_vivo || !mounted) return;

      await _parpadear();
      if (_azar.nextInt(5) == 0) {
        await Future<void>.delayed(const Duration(milliseconds: 180));
        if (!_vivo || !mounted) return;
        await _parpadear();
      }
    }
  }

  Future<void> _parpadear() async {
    if (!mounted) return;
    await _parpadeo.forward(from: 0);
    if (!mounted) return;
    await _parpadeo.reverse();
  }

  @override
  void dispose() {
    _vivo = false;
    _flotar.dispose();
    _parpadeo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si el sistema pide menos movimiento, se queda quieta.
    final sinMovimiento = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (sinMovimiento) {
      return _Capas(
        size: widget.size,
        completa: widget.completa,
        aplastarOjos: 1,
        acento: widget.acento,
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_flotar, _parpadeo]),
      builder: (context, _) {
        final t = _flotar.value * 2 * pi;
        final desplazamiento = sin(t) * (widget.pensando ? 5.0 : 3.5);
        // Una inclinación casi imperceptible, desfasada respecto al
        // flotar: sin ella el movimiento parece el de un ascensor.
        final giro = sin(t + pi / 3) * 0.012;
        final ojos = 1 - _parpadeo.value * 0.94;

        return Transform.translate(
          offset: Offset(0, desplazamiento),
          child: Transform.rotate(
            angle: giro,
            child: _Capas(
              size: widget.size,
              completa: widget.completa,
              aplastarOjos: ojos,
              acento: widget.acento,
            ),
          ),
        );
      },
    );
  }
}

class _Capas extends StatelessWidget {
  final double size;
  final bool completa;
  final double aplastarOjos;
  final Color acento;

  const _Capas({
    required this.size,
    required this.completa,
    required this.aplastarOjos,
    required this.acento,
  });

  @override
  Widget build(BuildContext context) {
    final base = completa
        ? 'assets/img/mascota_cuerpo_base.png'
        : 'assets/img/mascota_cabeza_base.png';
    final ojos = completa
        ? 'assets/img/mascota_cuerpo_ojos.png'
        : 'assets/img/mascota_ojos.png';
    final pivote = completa
        ? _MascotaVivaState._pivoteCuerpo
        : _MascotaVivaState._pivoteCabeza;

    return SizedBox(
      width: completa ? MascotaViva.anchoDeCuerpo(size) : size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            base,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            // Si faltan las piezas nuevas, al menos se ve la cabeza entera.
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/img/mascota_cabeza.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.smart_toy_rounded,
                size: size * 0.7,
                color: acento,
              ),
            ),
          ),
          Transform.scale(
            scaleY: aplastarOjos,
            alignment: pivote,
            child: Image.asset(
              ojos,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
