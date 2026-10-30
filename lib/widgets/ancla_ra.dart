import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Pose de un marcador dentro de la pantalla.
///
/// Esto es lo que convierte el escáner en realidad aumentada: sin esto, el
/// contenido se dibuja en un sitio fijo de la pantalla y se queda ahí
/// aunque muevas el teléfono. Con esto, el contenido se dibuja **donde
/// está el papel**, con su tamaño, su inclinación y su perspectiva, y lo
/// sigue.
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
///
/// POR QUÉ SE GUARDAN LAS CUATRO ESQUINAS
/// --------------------------------------
/// Con el centro, el tamaño y el giro basta para pegar una calcomanía en
/// el cristal: el contenido sigue al papel pero siempre se ve de frente, y
/// por eso se percibe como un dibujo sobre la pantalla en vez de como algo
/// posado en la mesa.
///
/// Las cuatro esquinas dicen bastante más. Un cuadrado fotografiado en
/// ángulo se proyecta como un cuadrilátero irregular, y de ese
/// cuadrilátero sale la homografía: la transformación que lleva el plano
/// del papel al plano de la pantalla. Aplicada a un widget, lo dibuja
/// tumbado sobre la mesa, con el lado lejano más corto que el cercano.
///
/// Es la misma idea con la que funcionaba la RA de marcadores clásica
/// (ARToolKit estimaba la pose a partir de los cuatro vértices de un
/// marcador cuadrado). No hace falta ARCore ni modelos 3D: hace falta
/// resolver ocho incógnitas, que es lo que hay en [matriz].
@immutable
class AnclaRA {
  /// Centro del marcador, en píxeles lógicos de la pantalla.
  final Offset centro;

  /// Ancho del marcador en pantalla. Es la escala de la escena: todo lo
  /// que se dibuje encima se mide en múltiplos de esto, y así el contenido
  /// crece al acercar el teléfono y se encoge al alejarlo, como un objeto
  /// de verdad.
  final double lado;

  /// Inclinación del marcador en radianes, sin topar.
  ///
  /// Da la vuelta entera. Antes estaba limitado a ±30°, porque el
  /// contenido llevaba texto encima y un párrafo del revés no se lee. El
  /// texto ya no va aquí, así que lo que se dibuja sobre el marcador
  /// puede acompañarlo hasta boca abajo: al girar el teléfono, algo que
  /// estuviera de verdad sobre la mesa giraría con ella.
  final double angulo;

  /// Las cuatro esquinas del marcador en pantalla, en el orden en que las
  /// da el lector: superior izquierda, superior derecha, inferior derecha,
  /// inferior izquierda.
  ///
  /// Siempre son cuatro. Cuando la detección no las trae (pasa en la web),
  /// se rellenan con el cuadrado de frente que corresponde a [centro],
  /// [lado] y [angulo]: entonces no hay perspectiva que estimar, pero el
  /// resto del código no tiene que enterarse.
  final List<Offset> esquinas;

  const AnclaRA({
    required this.centro,
    required this.lado,
    required this.angulo,
    required this.esquinas,
  });

  /// Traduce una detección a coordenadas de pantalla.
  ///
  /// [tamanoVista] es el tamaño del widget donde se dibuja la cámara (el
  /// de un `LayoutBuilder` alrededor del `MobileScanner`), no el de la
  /// pantalla: si el escáner no ocupa todo, usar el de la pantalla
  /// desplaza el anclaje.
  ///
  /// Devuelve null si la detección no trae geometría utilizable.
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
    if (!angulo.isFinite) angulo = 0;

    // Un marcador más grande que la vista entera no es un marcador: es
    // una lectura espuria de un fotograma movido.
    final mayor = math.max(tamanoVista.width, tamanoVista.height);
    if (lado > mayor * 1.3) return null;

    // Y la geometría tiene que ser posible. Un cuadrado fotografiado
    // desde cualquier ángulo razonable sigue siendo convexo y sus lados
    // no llegan a diferir en cuatro a uno; lo que sale de una imagen
    // movida, sí. Sin este filtro el contenido pega un salto y vuelve.
    if (puntos.length >= 4 && !_geometriaPosible(puntos)) return null;

    // El giro no se topa: lo que se dibuja sobre el marcador acompaña al
    // papel aunque quede boca abajo. Las esquinas tampoco se tocan: esas
    // tienen que caer exactas sobre el código, y el contorno que se
    // dibuja encima es lo que delataría un anclaje descuadrado.
    final cuatro = puntos.length >= 4
        ? puntos.sublist(0, 4)
        : _cuadradoDeFrente(centro, lado, angulo);

    for (final p in cuatro) {
      if (!p.dx.isFinite || !p.dy.isFinite) return null;
    }

    return AnclaRA(
      centro: centro,
      lado: lado,
      angulo: angulo,
      esquinas: cuatro,
    );
  }

  /// Comprueba que las cuatro esquinas puedan ser de verdad las de un
  /// cuadrado visto en perspectiva.
  ///
  /// Dos condiciones. La primera, que el cuadrilátero sea convexo: la
  /// proyección de un cuadrado siempre lo es, y un cruce indica que las
  /// esquinas llegaron desordenadas o inventadas. La segunda, que el lado
  /// más largo no pase de cuatro veces el más corto, que es más escorzo
  /// del que admite un marcador legible.
  static bool _geometriaPosible(List<Offset> p) {
    var signo = 0;
    var corto = double.infinity;
    var largo = 0.0;

    for (var i = 0; i < 4; i++) {
      final a = p[i];
      final b = p[(i + 1) % 4];
      final c = p[(i + 2) % 4];

      final lado = (b - a).distance;
      if (!lado.isFinite || lado <= 0) return false;
      corto = math.min(corto, lado);
      largo = math.max(largo, lado);

      final cruz = (b.dx - a.dx) * (c.dy - b.dy) -
          (b.dy - a.dy) * (c.dx - b.dx);
      if (cruz == 0) continue;
      final s = cruz > 0 ? 1 : -1;
      if (signo == 0) {
        signo = s;
      } else if (s != signo) {
        return false; // no es convexo
      }
    }

    if (signo == 0) return false; // los cuatro puntos en línea
    return largo <= corto * 4;
  }

  /// El cuadrado de lado [lado] centrado en [centro] y girado [angulo],
  /// en el mismo orden que las esquinas del lector. Es la pose "de frente"
  /// hacia la que se endereza el contenido.
  static List<Offset> _cuadradoDeFrente(
    Offset centro,
    double lado,
    double angulo,
  ) {
    final c = math.cos(angulo);
    final s = math.sin(angulo);
    final h = lado / 2;
    Offset v(double x, double y) =>
        Offset(centro.dx + x * c - y * s, centro.dy + x * s + y * c);
    return <Offset>[v(-h, -h), v(h, -h), v(h, h), v(-h, h)];
  }

  /// La transformación que lleva el plano del papel a la pantalla.
  ///
  /// La entrada son píxeles del plano del marcador, con el origen en su
  /// centro y el propio marcador midiendo [lado]: el punto (0, 0) cae en
  /// el centro del QR y (lado/2, lado/2) en su esquina inferior derecha.
  /// La salida son píxeles lógicos de pantalla.
  ///
  /// Un widget envuelto en `Transform(transform: ancla.matriz)` queda
  /// dibujado en el plano de la mesa. Flutter además invierte esta matriz
  /// para el hit testing, así que los botones se pulsan donde se ven, no
  /// donde estarían sin inclinar.
  ///
  /// La cuenta es la de Heckbert para llevar el cuadrado unidad a un
  /// cuadrilátero cualquiera: ocho incógnitas, solución cerrada.
  Matrix4 get matriz {
    final x0 = esquinas[0].dx, y0 = esquinas[0].dy;
    final x1 = esquinas[1].dx, y1 = esquinas[1].dy;
    final x2 = esquinas[2].dx, y2 = esquinas[2].dy;
    final x3 = esquinas[3].dx, y3 = esquinas[3].dy;

    final dx1 = x1 - x2, dx2 = x3 - x2, dx3 = x0 - x1 + x2 - x3;
    final dy1 = y1 - y2, dy2 = y3 - y2, dy3 = y0 - y1 + y2 - y3;

    final double a, b, c, d, e, f, g, h;
    final den = dx1 * dy2 - dy1 * dx2;

    if (den.abs() < 1e-9) {
      // Cuadrilátero degenerado (el marcador visto justo de canto). No hay
      // perspectiva que calcular; se cae a una transformación afín, que es
      // lo que había antes de todo esto.
      g = 0;
      h = 0;
      a = x1 - x0;
      b = x2 - x1;
      c = x0;
      d = y1 - y0;
      e = y2 - y1;
      f = y0;
    } else {
      g = (dx3 * dy2 - dy3 * dx2) / den;
      h = (dx1 * dy3 - dy1 * dx3) / den;
      a = x1 - x0 + g * x1;
      b = x3 - x0 + h * x3;
      c = x0;
      d = y1 - y0 + g * y1;
      e = y3 - y0 + h * y3;
      f = y0;
    }

    // Fila 3 es la de la perspectiva: es la que hace que el lado lejano
    // salga más corto. La fila y la columna de z se quedan como están,
    // porque aquí todo vive en z = 0.
    final homografia = Matrix4.identity()
      ..setEntry(0, 0, a)
      ..setEntry(0, 1, b)
      ..setEntry(0, 3, c)
      ..setEntry(1, 0, d)
      ..setEntry(1, 1, e)
      ..setEntry(1, 3, f)
      ..setEntry(3, 0, g)
      ..setEntry(3, 1, h)
      ..setEntry(3, 3, 1);

    // La homografía espera el cuadrado unidad con el origen en una
    // esquina. Lo de fuera son píxeles del plano con el origen en el
    // centro, así que antes hay que escalar y recentrar.
    final k = 1 / lado;
    return homografia
      ..multiply(Matrix4.translationValues(0.5, 0.5, 0))
      ..multiply(Matrix4.diagonal3Values(k, k, 1));
  }

  /// Dónde cae en pantalla un punto del plano del papel.
  Offset proyectar(Offset enElPlano) =>
      MatrixUtils.transformPoint(matriz, enElPlano);

  /// La misma pose, enderezada [t] hacia la cámara.
  ///
  /// Con t = 0 el contenido queda tumbado en el plano del papel. Con t = 1
  /// queda de frente, que es como se dibujaba antes de tener esquinas.
  /// En medio, inclinado: lo justo para que se lea como posado en la mesa
  /// y no como una calcomanía, sin que el texto se escorce tanto que
  /// cueste leerlo.
  AnclaRA aplanado(double t) {
    if (t <= 0) return this;
    final frente = _cuadradoDeFrente(centro, lado, angulo);
    final nuevas = t >= 1
        ? frente
        : List<Offset>.generate(
            4,
            (i) => Offset.lerp(esquinas[i], frente[i], t)!,
            growable: false,
          );
    return AnclaRA(
      centro: centro,
      lado: lado,
      angulo: angulo,
      esquinas: nuevas,
    );
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
      angulo: _entreAngulos(angulo, destino.angulo, t),
      // Las esquinas se suavizan igual que el resto. Si no, el contorno y
      // la perspectiva irían a saltos mientras el centro se desliza.
      esquinas: List<Offset>.generate(
        4,
        (i) => Offset.lerp(esquinas[i], destino.esquinas[i], t)!,
        growable: false,
      ),
    );
  }

  static double _entre(double a, double b, double t) => a + (b - a) * t;

  /// Interpola dos ángulos por el camino corto.
  ///
  /// `atan2` devuelve el ángulo en (-π, π], así que una tarjeta que cruza
  /// esa frontera pasa de +179° a -179° de un fotograma al siguiente. Con
  /// una interpolación normal eso son 358° de recorrido y el muñeco daría
  /// una vuelta entera en sentido contrario; por el camino corto son dos.
  static double _entreAngulos(double a, double b, double t) {
    var d = (b - a) % (2 * math.pi);
    if (d > math.pi) d -= 2 * math.pi;
    return a + d * t;
  }

  /// true si el marcador saltó tanto que no tiene sentido interpolar
  /// (cambió de código, o el teléfono se movió de golpe). En ese caso
  /// conviene colocar el contenido de una vez en el sitio nuevo.
  ///
  /// El giro cuenta igual que el desplazamiento. Antes no: solo se
  /// miraban el centro y el tamaño, así que una rotación pura —el papel
  /// gira sobre sí mismo y su centro no se mueve— nunca llegaba a contar
  /// como salto y se iba interpolando grado a grado, arrastrándose
  /// detrás del teléfono.
  bool lejosDe(AnclaRA otra) =>
      (centro - otra.centro).distance > lado * 1.6 ||
      (lado - otra.lado).abs() > lado * 0.6 ||
      distanciaAngular(angulo, otra.angulo) > 0.6; // ~34°

  /// Cuánto hay entre dos ángulos, por el camino corto y sin signo.
  static double distanciaAngular(double a, double b) {
    var d = (b - a).abs() % (2 * math.pi);
    if (d > math.pi) d = 2 * math.pi - d;
    return d;
  }

  /// Compara las cuatro esquinas. Se escribe a mano porque `listEquals`
  /// vive en `foundation.dart`, que este archivo no importa.
  static bool _mismasEsquinas(List<Offset> a, List<Offset> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      other is AnclaRA &&
      other.centro == centro &&
      other.lado == lado &&
      other.angulo == angulo &&
      _mismasEsquinas(other.esquinas, esquinas);

  @override
  int get hashCode =>
      Object.hash(centro, lado, angulo, Object.hashAll(esquinas));
}