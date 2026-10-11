import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Posición de un marcador dentro de la pantalla.
///
/// Esto es lo que convierte el escáner en realidad aumentada: sin esto, el
/// contenido se dibuja en un sitio fijo de la pantalla y se queda ahí
/// aunque muevas el teléfono. Con esto, el contenido se dibuja **donde
/// está el papel**, con su tamaño y su inclinación, y lo sigue.
///
/// DE DÓNDE SALEN LAS COORDENADAS
/// ------------------------------
/// `mobile_scanner` entrega en cada detección:
///
///   - `BarcodeCapture.size`  el tamaño de la imagen de la cámara en la que
///                            se detectó (p. ej. 1080 × 1920)
///   - `Barcode.corners`      las cuatro esquinas del QR **en esa misma
///                            imagen**, en sentido horario empezando por la
///                            esquina superior izquierda
///
/// Las dos están en el mismo sistema de coordenadas, y el plugin de Android
/// ya corrige la rotación del sensor antes de informarlas, así que la
/// imagen llega "de pie" igual que la vista previa.
///
/// Falta un paso: la vista previa se dibuja con `BoxFit.cover`, que escala
/// la imagen hasta tapar todo el hueco y recorta lo que sobra. Hay que
/// aplicar esa misma transformación a las esquinas, o el contenido aparece
/// desplazado. Eso es lo que hace [desde].
///
/// Nota: `Barcode.scaleCorners` del paquete **no** sirve para esto. Divide
/// por `Barcode.size` (el tamaño del propio código), no por el de la
/// imagen, así que mapea el QR sobre el destino entero en vez de situarlo
/// dentro de la escena. La cuenta se hace aquí a mano.
@immutable
class AnclaRA {
  /// Centro del marcador, en píxeles lógicos de la pantalla.
  final Offset centro;

  /// Ancho del marcador en pantalla. Es la escala de la escena: todo lo
  /// que se dibuje encima se mide en múltiplos de esto, y así el contenido
  /// crece al acercar el teléfono y se encoge al alejarlo, como un objeto
  /// de verdad.
  final double lado;

  /// Inclinación del marcador en radianes. Permite que la tarjeta se
  /// gire con el papel en vez de quedarse recta sobre una hoja torcida.
  final double angulo;

  const AnclaRA({
    required this.centro,
    required this.lado,
    required this.angulo,
  });

  /// Traduce una detección a coordenadas de pantalla.
  ///
  /// [tamanoVista] es el tamaño del widget donde se dibuja la cámara (el
  /// de un `LayoutBuilder` alrededor del `MobileScanner`), no el de la
  /// pantalla: si el escáner no ocupa todo, usar el de la pantalla
  /// desplaza el anclaje.
  ///
  /// Devuelve null si la detección no trae geometría utilizable, que pasa
  /// en la web y en algunos códigos muy inclinados.
  static AnclaRA? desde(
    BarcodeCapture captura,
    Barcode codigo,
    Size tamanoVista,
  ) {
    final imagen = captura.size;
    if (imagen.width <= 0 || imagen.height <= 0) return null;
    if (tamanoVista.width <= 0 || tamanoVista.height <= 0) return null;

    final esquinas = codigo.corners;
    if (esquinas.isEmpty) return null;

    // BoxFit.cover: la misma escala en los dos ejes, la mayor de las dos
    // necesarias, y la imagen centrada (lo que sobra se recorta por igual
    // a los dos lados).
    final escala = math.max(
      tamanoVista.width / imagen.width,
      tamanoVista.height / imagen.height,
    );
    final margenX = (tamanoVista.width - imagen.width * escala) / 2;
    final margenY = (tamanoVista.height - imagen.height * escala) / 2;

    Offset aPantalla(Offset p) =>
        Offset(p.dx * escala + margenX, p.dy * escala + margenY);

    final puntos = esquinas.map(aPantalla).toList(growable: false);

    // Centro: promedio de los vértices. Con cuatro esquinas es el centro
    // del cuadrilátero; con menos (web) sigue siendo una aproximación
    // razonable.
    var sx = 0.0;
    var sy = 0.0;
    for (final p in puntos) {
      sx += p.dx;
      sy += p.dy;
    }
    final centro = Offset(sx / puntos.length, sy / puntos.length);

    double lado;
    double angulo;

    if (puntos.length >= 4) {
      // Los dos lados "horizontales" del QR: arriba (0→1) y abajo (3→2).
      // Se promedian porque en perspectiva uno sale más corto que el otro
      // y quedarse con uno hace que el contenido palpite al inclinar.
      final arriba = puntos[1] - puntos[0];
      final abajo = puntos[2] - puntos[3];
      lado = (arriba.distance + abajo.distance) / 2;
      // El ángulo del borde superior es la inclinación del papel.
      angulo = math.atan2(arriba.dy, arriba.dx);
    } else {
      // Sin cuatro esquinas, el rectángulo que las contiene es lo mejor
      // que hay, y no se intenta adivinar la inclinación.
      var minX = puntos.first.dx, maxX = puntos.first.dx;
      var minY = puntos.first.dy, maxY = puntos.first.dy;
      for (final p in puntos) {
        minX = math.min(minX, p.dx);
        maxX = math.max(maxX, p.dx);
        minY = math.min(minY, p.dy);
        maxY = math.max(maxY, p.dy);
      }
      lado = math.max(maxX - minX, maxY - minY);
      angulo = 0;
    }

    if (!lado.isFinite || lado <= 1) return null;
    if (!centro.dx.isFinite || !centro.dy.isFinite) return null;

    // Un texto cabeza abajo no se lee. Se deja que la tarjeta acompañe la
    // inclinación del papel hasta ±30° y de ahí no pasa.
    const tope = 30 * math.pi / 180;
    if (!angulo.isFinite) {
      angulo = 0;
    } else if (angulo > tope) {
      angulo = tope;
    } else if (angulo < -tope) {
      angulo = -tope;
    }

    return AnclaRA(centro: centro, lado: lado, angulo: angulo);
  }

  /// Interpola hacia [destino]. [t] entre 0 y 1: cuanto menor, más suave
  /// y más retrasado.
  ///
  /// Hace falta porque la detección llega a saltos (unas diez veces por
  /// segundo) y con ruido de uno o dos píxeles incluso con el teléfono
  /// quieto. Sin suavizar, la tarjeta vibra; con esto se desliza.
  AnclaRA haciaDestino(AnclaRA destino, double t) {
    return AnclaRA(
      centro: Offset(
        _entre(centro.dx, destino.centro.dx, t),
        _entre(centro.dy, destino.centro.dy, t),
      ),
      lado: _entre(lado, destino.lado, t),
      angulo: _entre(angulo, destino.angulo, t),
    );
  }

  static double _entre(double a, double b, double t) => a + (b - a) * t;

  /// true si el marcador saltó tanto que no tiene sentido interpolar
  /// (cambió de código, o el teléfono se movió de golpe). En ese caso
  /// conviene colocar el contenido de una vez en el sitio nuevo.
  bool lejosDe(AnclaRA otra) =>
      (centro - otra.centro).distance > lado * 1.6 ||
      (lado - otra.lado).abs() > lado * 0.6;

  @override
  bool operator ==(Object other) =>
      other is AnclaRA &&
      other.centro == centro &&
      other.lado == lado &&
      other.angulo == angulo;

  @override
  int get hashCode => Object.hash(centro, lado, angulo);
}
