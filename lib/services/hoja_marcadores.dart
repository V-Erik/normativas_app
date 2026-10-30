import 'dart:typed_data';

import 'package:flutter/material.dart' show Color;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/casos_ra.dart';

/// Genera la hoja imprimible de marcadores de un mundo.
///
/// POR QUÉ ESTO EXISTE
/// -------------------
/// Hasta ahora las tarjetas de realidad aumentada las imprimía el docente
/// y las repartía, de modo que el estudiante que terminaba un tema en el
/// Modo Ruta no tenía manera de llegar al caso que lo practica. Los dos
/// componentes vivían separados aunque el dato que los une ya estuviera
/// ahí: cada [CasoRA] declara su `leccionId`, y de él sale su mundo.
///
/// LA NUMERACIÓN ES LA DE LA HOJA REPARTIDA EN CLASE
/// -------------------------------------------------
/// «CASO 3 DE 8» se cuenta sobre el catálogo completo y no sobre los casos
/// de este mundo. Un estudiante puede tener delante las dos hojas a la
/// vez, y si el mismo código llevara dos números distintos, la que sobra
/// es esta.
///
/// POR QUÉ UN PDF Y NO UNA IMAGEN
/// ------------------------------
/// Un QR impreso tiene que medir lo que mide. Una captura de pantalla se
/// escala a lo que quiera la impresora y el código acaba demasiado
/// pequeño para enfocarlo de cerca; en un PDF los milímetros son los que
/// se piden.
///
/// EL QR NO SE DIBUJA EN PANTALLA Y ES DELIBERADO
/// ----------------------------------------------
/// Un código mostrado en el mismo teléfono que ha de leerlo no sirve de
/// nada. Esta hoja es para que salga del dispositivo: a papel, o a la
/// pantalla de un computador desde la que sí se puede escanear.
class HojaMarcadores {
  const HojaMarcadores._();

  /// El morado de la aplicación, el mismo que usa la mascota.
  static const PdfColor _morado = PdfColor.fromInt(0xFF6D4AFF);
  static const PdfColor _tinta = PdfColor.fromInt(0xFF1A1A1F);
  static const PdfColor _gris = PdfColor.fromInt(0xFF8A8A94);
  static const PdfColor _fondoTarjeta = PdfColor.fromInt(0xFFF3F3F7);

  /// La cabeza de la mascota: va dentro de cada código y, en pequeño y
  /// muy clara, por el blanco del folio.
  static const String _logo = 'assets/img/mascota_cabeza.png';

  /// Dónde cae cada carita del fondo: izquierda, arriba, tamaño y giro.
  ///
  /// Están escritas a mano y no sorteadas: una siembra al azar acaba
  /// juntando dos en una esquina y dejando media hoja vacía, y además
  /// cambiaría en cada impresión del mismo documento.
  static const List<List<double>> _siembra = [
    [20, 95, 110, -0.36],
    [470, 150, 86, 0.44],
    [45, 430, 96, 0.24],
    [455, 540, 120, -0.52],
    [190, 730, 92, 0.33],
    [30, 650, 70, 0.60],
    [330, 330, 78, -0.22],
  ];

  /// Los casos que corresponden a [mundo], en el orden del catálogo.
  static List<CasoRA> casosDelMundo(int mundo) =>
      CasosRA.todos.where((c) => c.mundo == mundo).toList(growable: false);

  /// Arma la hoja y abre el diálogo de impresión del sistema.
  ///
  /// Devuelve false si ese mundo no tiene ningún caso asociado, para que
  /// quien llame no ofrezca un botón que no haría nada.
  static Future<bool> imprimirMundo(
    int mundo, {
    String? titulo,
    Color? color,
  }) async {
    return imprimirCasos(
      casosDelMundo(mundo),
      titulo: titulo ?? 'Mundo $mundo',
      color: color,
      nombreArchivo: 'marcadores-mundo-$mundo',
    );
  }

  /// Imprime un conjunto cualquiera de casos.
  ///
  /// Existe aparte de [imprimirMundo] porque el archivo de tarjetas ofrece
  /// juntar en una sola hoja todo lo que el estudiante lleva desbloqueado,
  /// y eso cruza varias unidades.
  static Future<bool> imprimirCasos(
    List<CasoRA> casos, {
    required String titulo,
    Color? color,
    String nombreArchivo = 'marcadores',
  }) async {
    if (casos.isEmpty) return false;

    final bytes = await construir(casos, encabezado: titulo, color: color);
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: '$nombreArchivo.pdf',
    );
    return true;
  }

  /// El PDF, en A4.
  static Future<Uint8List> construir(
    List<CasoRA> casos, {
    required String encabezado,
    Color? color,
  }) async {
    // `Color.value` está marcado como obsoleto en las versiones recientes
    // de Flutter, pero sigue existiendo; los accesores nuevos no están en
    // las antiguas. Se usa el que compila en ambas.
    // ignore: deprecated_member_use
    final acento = color == null
        ? const PdfColor.fromInt(0xFF58CC02)
        : PdfColor.fromInt(color.value);

    final mascota = await _cargarLogo();

    final doc = pw.Document(
      title: 'PRIS · Marcadores de realidad aumentada · $encabezado',
    );

    // Helvetica va incorporada al formato PDF: cubre acentos y eñe sin
    // empaquetar ninguna tipografía y, sobre todo, sin descargar nada. La
    // hoja tiene que salir también con el teléfono sin red, que es la
    // condición en la que se usa la aplicación.
    final tema = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 30, 32, 26),
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
        italic: pw.Font.helveticaOblique(),
      ),
      buildBackground: (_) => _marcaDeAgua(mascota),
    );

    // Con un solo caso, la tarjeta normal queda diminuta en mitad de un
    // folio vacío; entonces se usa una del doble y un código de 48 mm.
    final grande = casos.length == 1;

    // Hasta cuatro tarjetas caben en una página, y en ese caso conviene
    // una `Page` en lugar de una `MultiPage`: es la única forma de
    // centrarlas verticalmente, porque la segunda reparte el contenido
    // desde arriba por definición.
    final enUnaPagina = casos.length <= 4;

    pw.Widget reticula() => pw.Wrap(
          alignment: pw.WrapAlignment.center,
          spacing: 20,
          runSpacing: 18,
          children: [
            for (final caso in casos) _tarjeta(caso, mascota, grande: grande),
          ],
        );

    if (enUnaPagina) {
      doc.addPage(
        pw.Page(
          pageTheme: tema,
          build: (_) => pw.Column(
            children: [
              _encabezado(encabezado, casos.length, acento, mascota),
              pw.Expanded(child: pw.Center(child: reticula())),
              _pie(),
            ],
          ),
        ),
      );
    } else {
      doc.addPage(
        pw.MultiPage(
          pageTheme: tema,
          header: (_) =>
              _encabezado(encabezado, casos.length, acento, mascota),
          footer: (_) => _pie(),
          build: (_) => [pw.SizedBox(height: 18), reticula()],
        ),
      );
    }

    return doc.save();
  }

  /// La cabeza de la mascota, o null si el asset no está.
  ///
  /// Null no es un fallo: la hoja se dibuja igual, solo que sin logo ni
  /// marca de agua. Quedarse sin imprimir por un adorno sería absurdo.
  static Future<pw.ImageProvider?> _cargarLogo() async {
    try {
      final datos = await rootBundle.load(_logo);
      return pw.MemoryImage(datos.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  // -------------------------------------------------------- marca de agua

  /// Caritas de la mascota desperdigadas por el folio, cada una con su
  /// inclinación.
  ///
  /// Van en el fondo de la página, detrás de todo. Como las tarjetas
  /// llevan su propio relleno opaco, las caritas solo asoman donde el
  /// papel está vacío, que es justo donde se quieren, y **nunca debajo de
  /// un código**: un QR impreso sobre una trama gris se lee peor, y aquí
  /// leerlo es el único propósito de la hoja.
  ///
  /// Al 6 % apenas se ve en pantalla y en papel queda como un gris muy
  /// claro. Más que eso compite con el texto.
  static pw.Widget _marcaDeAgua(pw.ImageProvider? mascota) {
    if (mascota == null) return pw.SizedBox();

    return pw.Stack(
      children: [
        for (final p in _siembra)
          pw.Positioned(
            left: p[0],
            top: p[1],
            child: pw.Opacity(
              opacity: 0.06,
              child: pw.Transform.rotate(
                angle: p[3],
                child: pw.SizedBox(
                  width: p[2],
                  height: p[2],
                  child: pw.Image(mascota),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------ cabecera

  static pw.Widget _encabezado(
    String titulo,
    int cuantos,
    PdfColor acento,
    pw.ImageProvider? mascota,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (mascota != null) ...[
              pw.Container(
                width: 38,
                height: 38,
                decoration: const pw.BoxDecoration(
                  color: _fondoTarjeta,
                  shape: pw.BoxShape.circle,
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Image(mascota),
              ),
              pw.SizedBox(width: 12),
            ],
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: 'PRIS',
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: _morado,
                          ),
                        ),
                        pw.TextSpan(
                          text: ' · Marcadores de realidad aumentada',
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: _tinta,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Abre la app, entra en «Escáner AR» y apunta la cámara a '
                    'cada código. ${_cuantosCasos(cuantos)} de $titulo.',
                    style: const pw.TextStyle(fontSize: 8.5, color: _gris),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Carrera de Computación · Universidad Politécnica '
                    'Estatal del Carchi',
                    style: pw.TextStyle(
                      fontSize: 7.5,
                      fontStyle: pw.FontStyle.italic,
                      color: _gris,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 11),
        pw.Container(height: 2.2, color: acento),
      ],
    );
  }

  static String _cuantosCasos(int n) => n == 1 ? 'Es un caso' : 'Son $n casos';

  static pw.Widget _pie() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 12),
      child: pw.Text(
        'Si un código no se lee, aléjate unos centímetros y evita los '
        'reflejos de la luz.',
        style: const pw.TextStyle(fontSize: 7.5, color: _gris),
      ),
    );
  }

  // ------------------------------------------------------------- tarjeta

  /// Una tarjeta: el código en el centro y el caso debajo.
  ///
  /// El ancho normal, 254 pt, no es arbitrario: en A4 con márgenes de 32
  /// quedan 531 pt útiles, de modo que dos tarjetas y su separación llenan
  /// la fila justa.
  static pw.Widget _tarjeta(
    CasoRA caso,
    pw.ImageProvider? mascota, {
    required bool grande,
  }) {
    // Numeración sobre el catálogo completo, no sobre este mundo: la hoja
    // repartida en clase y esta tienen que llamar igual al mismo código.
    final numero = CasosRA.todos.indexOf(caso) + 1;
    final total = CasosRA.todos.length;

    return pw.Container(
      width: grande ? 340 : 254,
      height: grande ? 452 : 300,
      padding: pw.EdgeInsets.all(grande ? 22 : 16),
      decoration: pw.BoxDecoration(
        color: _fondoTarjeta,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // --- el número, arriba del todo ---
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                width: grande ? 19 : 16,
                height: grande ? 19 : 16,
                alignment: pw.Alignment.center,
                decoration: const pw.BoxDecoration(
                  color: _morado,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Text(
                  '$numero',
                  style: pw.TextStyle(
                    fontSize: grande ? 9 : 8,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 7),
              pw.Text(
                'CASO $numero DE $total',
                style: pw.TextStyle(
                  fontSize: grande ? 7.5 : 6.5,
                  letterSpacing: 0.9,
                  color: _gris,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),

          // --- el código, en el centro y sobre blanco ---
          //
          // El cuadro blanco no es decorativo. El fondo de la tarjeta es
          // gris, y un QR necesita contraste y un margen claro alrededor
          // para que el lector encuentre sus esquinas.
          pw.SizedBox(height: grande ? 18 : 13),
          pw.Container(
            padding: pw.EdgeInsets.all(grande ? 11 : 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(grande ? 12 : 9),
            ),
            child: _codigo(caso, mascota, grande: grande),
          ),

          // --- el caso, debajo ---
          pw.SizedBox(height: grande ? 18 : 13),
          pw.Text(
            caso.titulo,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: grande ? 16 : 12.5,
              height: 1.25,
              color: _tinta,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: grande ? 8 : 6),
          pw.Text(
            caso.contexto,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: grande ? 10 : 8,
              lineSpacing: grande ? 2.6 : 2,
              color: _gris,
            ),
          ),

          // Empuja la pregunta al borde inferior, de modo que todas las
          // tarjetas la tengan a la misma altura aunque sus contextos
          // midan distinto.
          pw.Spacer(),
          pw.Text(
            '¿Qué normativa aplicarías?',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: grande ? 11 : 9,
              color: _morado,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// El código, con la cabeza de la mascota en el centro.
  ///
  /// Tapar el centro de un QR solo es posible porque la corrección de
  /// errores reconstruye lo que queda debajo. Se usa el nivel alto, que
  /// tolera cerca de un tercio de la superficie perdida; con el nivel por
  /// defecto, el logo rompería el código.
  static pw.Widget _codigo(
    CasoRA caso,
    pw.ImageProvider? mascota, {
    required bool grande,
  }) {
    // 48 mm frente a 36. Por debajo de unos 30 mm un teléfono de gama
    // media tiene que acercarse tanto que pierde el enfoque, y perder el
    // enfoque es perder la pose del marcador; cuando sobra sitio en la
    // hoja, no hay motivo para quedarse cerca del mínimo.
    final lado = (grande ? 48 : 36) * PdfPageFormat.mm;

    final barras = pw.BarcodeWidget(
      barcode: pw.Barcode.qrCode(
        errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high,
      ),
      data: CasosRA.contenidoQr(caso),
      width: lado,
      height: lado,
      color: _tinta,
      drawText: false,
    );

    if (mascota == null) return barras;

    return pw.Stack(
      alignment: pw.Alignment.center,
      children: [
        barras,
        pw.Container(
          width: lado * 0.24,
          height: lado * 0.24,
          padding: const pw.EdgeInsets.all(2),
          decoration: const pw.BoxDecoration(
            color: PdfColors.white,
            shape: pw.BoxShape.circle,
          ),
          child: pw.Image(mascota),
        ),
      ],
    );
  }
}