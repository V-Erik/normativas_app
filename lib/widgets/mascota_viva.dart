import 'dart:math';

import 'package:flutter/material.dart';

/// Lo que la mascota está haciendo ahora mismo.
///
/// El reposo —flotar y parpadear— no basta para que un personaje parezca
/// vivo: parece animado, que no es lo mismo. Lo que lo hace vivo es que
/// responda a lo que acaba de pasar. Estos son los momentos en los que
/// pasa algo a lo que merece la pena responder.
enum GestoMascota {
  /// Flotando, sin nada que celebrar ni que lamentar.
  reposo,

  /// Acaba de acertar: se agacha, salta y aterriza con un rebote.
  acierto,

  /// Acaba de fallar: una sacudida corta y se encoge un poco.
  fallo,

  /// Un saltito sin motivo. Espontáneo.
  brinco,

  /// Se inclina a un lado y al otro, como quien mira algo. Espontáneo.
  ladeo,

  /// Se estira a lo alto y vuelve, como al desperezarse. Espontáneo.
  estiron,
}

/// Los gestos que la mascota se hace a sí misma cuando nadie le pide nada.
const List<GestoMascota> _espontaneos = [
  GestoMascota.brinco,
  GestoMascota.ladeo,
  GestoMascota.estiron,
];

/// La mascota ESO con vida propia: flota, respira, parpadea y reacciona.
///
/// No usa Lottie. El `Frame_1.json` es una animación de entrada que se
/// reproduce una vez y se queda quieta; esto es lo contrario, un estado de
/// reposo que no termina nunca. Hacerlo en Flutter permite además que
/// reaccione a lo que pasa en la app (ver [pensando] y [gesto]).
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
///
/// QUÉ SE MUEVE Y POR QUÉ
/// ----------------------
/// Cuatro capas de movimiento, de más lenta a más rápida:
///
///   - **Flotar**: sube y baja, 3,2 s por ciclo.
///   - **Respirar**: se estira a lo alto y se estrecha a lo ancho a la
///     mitad de esa frecuencia, conservando el volumen. Sin esto el
///     personaje es una calcomanía que sube y baja; con esto tiene cuerpo.
///     El pivote es la base, para que al estirarse no se le hundan los
///     pies.
///   - **Parpadear**: a intervalos irregulares, y de vez en cuando dos
///     seguidos.
///   - **Gesto**: la reacción puntual a un acierto o un fallo.
///
/// Y una de una sola vez: la entrada, con un rebote elástico. Aparecer de
/// golpe a tamaño final es lo que hace que un personaje se lea como una
/// imagen pegada en vez de como alguien que acaba de llegar.
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

  /// La reacción que debe representar. Al cambiar a [GestoMascota.acierto]
  /// o [GestoMascota.fallo] se reproduce una vez y vuelve al reposo.
  final GestoMascota gesto;

  /// Con false aparece ya a tamaño final, sin el rebote de entrada. Útil
  /// donde el personaje es parte del decorado y no acaba de llegar.
  final bool conEntrada;

  /// Con true se mueve por su cuenta cada tanto: un brinco, un ladeo, un
  /// estirón.
  ///
  /// Apagado por defecto. El reposo continuo acaba leyéndose como un
  /// bucle, y lo que lo rompe es que pase algo de vez en cuando sin que
  /// se sepa cuándo; pero en el escáner la mascota ya reacciona a los
  /// aciertos, y en un avatar de chat de 46 px un saltito es ruido. Se
  /// enciende donde el personaje es el protagonista de la pantalla.
  final bool inquieta;

  final Color acento;

  const MascotaViva({
    super.key,
    this.size = 132,
    this.completa = false,
    this.pensando = false,
    this.gesto = GestoMascota.reposo,
    this.conEntrada = true,
    this.inquieta = false,
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
  late final AnimationController _gesto;
  late final AnimationController _entrada;
  final _azar = Random();
  bool _vivo = true;

  /// El gesto que se está dibujando, que no siempre es el que pide el
  /// padre: los espontáneos nacen aquí dentro.
  GestoMascota _enCurso = GestoMascota.reposo;

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

    _gesto = AnimationController(vsync: this);

    _entrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
      value: widget.conEntrada ? 0 : 1,
    );
    if (widget.conEntrada) _entrada.forward();

    _programarParpadeo();
    if (widget.inquieta) _programarGestos();

    // Si nace ya con un gesto puesto, hay que lanzarlo aquí.
    //
    // `didUpdateWidget` solo ve cambios, y una mascota que se construye
    // dentro de un diálogo de resumen con `gesto: acierto` no cambia
    // nunca: nace así. Sin esto, el gesto no llegaba a ocurrir.
    //
    // Con un respiro de por medio para que la entrada se lea primero;
    // encadenadas, el rebote elástico y el salto se pisan y no se
    // distingue ninguno de los dos.
    if (widget.gesto != GestoMascota.reposo) {
      Future<void>.delayed(const Duration(milliseconds: 380), () {
        if (_vivo && mounted) _lanzar(widget.gesto);
      });
    }
  }

  /// Cuánto dura cada gesto.
  static Duration _duracionDe(GestoMascota g) => switch (g) {
        GestoMascota.acierto => const Duration(milliseconds: 780),
        GestoMascota.fallo => const Duration(milliseconds: 540),
        GestoMascota.brinco => const Duration(milliseconds: 620),
        GestoMascota.ladeo => const Duration(milliseconds: 900),
        GestoMascota.estiron => const Duration(milliseconds: 1100),
        GestoMascota.reposo => Duration.zero,
      };

  void _lanzar(GestoMascota g) {
    _enCurso = g;
    _gesto.duration = _duracionDe(g);
    _gesto.forward(from: 0);
  }

  /// Sortea un gesto cada ocho a dieciocho segundos.
  ///
  /// El margen es ancho a propósito: a intervalo fijo el personaje
  /// parecería un reloj, que es exactamente lo contrario de lo que se
  /// busca. Y nunca interrumpe: si hay un gesto en curso o el padre está
  /// pidiendo uno, este turno se salta.
  Future<void> _programarGestos() async {
    while (_vivo) {
      await Future<void>.delayed(
        Duration(milliseconds: 8000 + _azar.nextInt(10000)),
      );
      if (!_vivo || !mounted) return;
      if (!widget.inquieta) continue;
      if (_gesto.isAnimating) continue;
      if (widget.gesto != GestoMascota.reposo) continue;

      _lanzar(_espontaneos[_azar.nextInt(_espontaneos.length)]);
    }
  }

  @override
  void didUpdateWidget(MascotaViva anterior) {
    super.didUpdateWidget(anterior);
    // El gesto se dispara al cambiar, no mientras dure: el padre puede
    // reconstruir cincuenta veces por segundo y el salto tiene que salir
    // una sola vez.
    if (widget.gesto != anterior.gesto &&
        widget.gesto != GestoMascota.reposo) {
      // Lo que pide el padre manda sobre un espontáneo en curso: acertar
      // es más importante que el saltito que tocaba.
      _lanzar(widget.gesto);
    }
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
    _gesto.dispose();
    _entrada.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si el sistema pide menos movimiento, se queda quieta.
    final sinMovimiento =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (sinMovimiento) {
      return _Capas(
        size: widget.size,
        completa: widget.completa,
        aplastarOjos: 1,
        acento: widget.acento,
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_flotar, _parpadeo, _gesto, _entrada]),
      builder: (context, _) {
        final t = _flotar.value * 2 * pi;

        // --- reposo ----------------------------------------------------
        var subeBaja = sin(t) * (widget.pensando ? 5.0 : 3.5);
        // Una inclinación casi imperceptible, desfasada respecto al
        // flotar: sin ella el movimiento parece el de un ascensor.
        var giro = sin(t + pi / 3) * 0.012;
        // Respiración: a la mitad de la frecuencia del flotar, y lo que
        // se estira a lo alto se estrecha a lo ancho.
        final respira = sin(t * 0.5);
        var altoRel = 1 + respira * 0.026;
        var anchoRel = 1 - respira * 0.020;
        var ladea = 0.0;

        // --- gesto -----------------------------------------------------
        if (_gesto.isAnimating || _gesto.value > 0) {
          final p = _gesto.value;

          if (_enCurso == GestoMascota.brinco) {
            // El mismo salto del acierto a un tercio de altura y sin
            // giro: ahí celebra algo, aquí solo está vivo.
            if (p < 0.2) {
              altoRel -= 0.07 * (p / 0.2);
              anchoRel += 0.06 * (p / 0.2);
            } else if (p < 0.7) {
              final arco = sin((p - 0.2) / 0.5 * pi);
              subeBaja -= arco * widget.size * 0.09;
              altoRel += 0.05 * arco;
              anchoRel -= 0.04 * arco;
            } else {
              final q = (p - 0.7) / 0.3;
              final rebote = sin(q * pi * 2) * (1 - q);
              altoRel -= 0.05 * rebote;
              anchoRel += 0.04 * rebote;
            }
          } else if (_enCurso == GestoMascota.ladeo) {
            // Una oscilación completa y vuelta al centro. Como el pivote
            // del giro está en los pies, inclinarse mueve la cabeza y no
            // el cuerpo entero, que es lo que hace que parezca mirar.
            giro += sin(p * pi * 2) * 0.13;
            ladea = sin(p * pi * 2) * widget.size * 0.02;
          } else if (_enCurso == GestoMascota.estiron) {
            // Lento y en dos tiempos: sube estirándose, se queda un
            // instante arriba y baja. La campana de seno hace las dos
            // mitades simétricas sin tener que escribirlas.
            final campana = sin(p * pi);
            altoRel += 0.11 * campana;
            anchoRel -= 0.07 * campana;
            subeBaja -= campana * widget.size * 0.03;
            giro += sin(p * pi * 2) * 0.03;
          } else if (_enCurso == GestoMascota.acierto) {
            if (p < 0.16) {
              // Anticipación: se agacha antes de saltar. Sin esto el
              // salto parece un corte de montaje.
              final q = p / 0.16;
              altoRel -= 0.15 * q;
              anchoRel += 0.12 * q;
            } else if (p < 0.64) {
              final q = (p - 0.16) / 0.48;
              final arco = sin(q * pi);
              subeBaja -= arco * widget.size * 0.28;
              altoRel += 0.13 * arco;
              anchoRel -= 0.10 * arco;
            } else {
              // Aterrizaje: un rebote que se apaga.
              final q = (p - 0.64) / 0.36;
              final rebote = sin(q * pi * 2) * (1 - q);
              altoRel -= 0.11 * rebote;
              anchoRel += 0.09 * rebote;
            }
            giro += sin(p * pi * 2) * 0.07;
          } else if (_enCurso == GestoMascota.fallo) {
            // Sacudida horizontal amortiguada, y se encoge un poco.
            final amortigua = 1 - p;
            ladea = sin(p * pi * 6) * amortigua * widget.size * 0.055;
            giro += sin(p * pi * 6) * amortigua * 0.05;
            altoRel -= 0.055 * sin(p * pi);
            anchoRel += 0.04 * sin(p * pi);
          }
        }

        // --- entrada ---------------------------------------------------
        final entrada = Curves.elasticOut.transform(_entrada.value);
        final escalaEntrada = 0.62 + 0.38 * entrada;

        final ojos = 1 - _parpadeo.value * 0.94;

        return Opacity(
          opacity: _entrada.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(ladea, subeBaja),
            child: Transform.rotate(
              angle: giro,
              child: Transform.scale(
                scaleX: anchoRel * escalaEntrada,
                scaleY: altoRel * escalaEntrada,
                // Desde los pies: si se escala desde el centro, al
                // estirarse se hunde en la mesa y al encogerse levita.
                alignment: Alignment.bottomCenter,
                child: _Capas(
                  size: widget.size,
                  completa: widget.completa,
                  aplastarOjos: ojos,
                  acento: widget.acento,
                ),
              ),
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