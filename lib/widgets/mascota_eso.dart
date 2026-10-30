import 'package:flutter/material.dart';

import 'mascota_viva.dart';

/// La mascota ESO de las pantallas de inicio, lecciones y sílabo.
///
/// ESTO YA NO USA LOTTIE
/// ---------------------
/// Antes reproducía `Frame_1.json` una vez al aparecer y se quedaba
/// congelada en el último fotograma; con `saludoPeriodico` volvía a
/// reproducir **la misma** animación cada doce segundos, que es lo que la
/// delataba: no parecía viva, parecía un bucle.
///
/// Ahora dibuja [MascotaViva], el mismo personaje montado con las capas
/// sueltas de aquel propio Lottie. Esa sí flota, respira, parpadea a
/// intervalos irregulares y, con [saludoPeriodico], se brinca, se ladea o
/// se estira cada cierto tiempo sin repetir siempre el mismo gesto.
///
/// POR QUÉ SIGUE EXISTIENDO ESTA CLASE
/// -----------------------------------
/// La llaman siete sitios de cuatro pantallas. Convertirla en un
/// adaptador cambia el personaje en toda la aplicación tocando un solo
/// archivo; reescribir las siete llamadas haría lo mismo con siete veces
/// más superficie para equivocarse.
///
/// LA CAJA ES LA DE ANTES, AL PÍXEL
/// --------------------------------
/// Ocupa `size` de ancho por `size * 1.15` de alto, exactamente como la
/// versión de Lottie. Eso es lo que permite que ninguna pantalla se mueva:
/// el personaje de dentro es más estrecho que su hueco —mide 0,4234 de su
/// altura— y se centra, igual que hacía el `BoxFit.contain`.
class MascotaESO extends StatelessWidget {
  final double size;

  /// Con true se mueve por su cuenta cada tanto.
  ///
  /// El nombre se conserva por las llamadas que ya existen, pero lo que
  /// hace es otra cosa: antes repetía la animación de entrada, ahora
  /// sortea un gesto distinto cada vez.
  final bool saludoPeriodico;

  /// Una reacción puntual: salta al acertar, se sacude al fallar.
  ///
  /// Se dispara al construirse, de modo que sirve en un diálogo que
  /// aparece ya sabiendo cómo fue la cosa.
  final GestoMascota gesto;

  /// Se mantiene por compatibilidad y ya no se usa.
  ///
  /// [MascotaViva] sortea sus propios intervalos, y a propósito: un gesto
  /// cada N segundos exactos se lee como un reloj, que es justo el
  /// defecto que esto venía a corregir.
  final Duration intervalo;

  const MascotaESO({
    super.key,
    this.size = 110,
    this.saludoPeriodico = false,
    this.gesto = GestoMascota.reposo,
    this.intervalo = const Duration(seconds: 12),
  });

  @override
  Widget build(BuildContext context) {
    final alto = size * 1.15;

    return SizedBox(
      width: size,
      height: alto,
      child: Center(
        child: MascotaViva(
          size: alto,
          completa: true,
          inquieta: saludoPeriodico,
          gesto: gesto,
        ),
      ),
    );
  }
}

/// Mascota con burbuja de diálogo apilada encima.
/// Se conserva por compatibilidad con otras pantallas del proyecto.
class MascotaESOBurbuja extends StatelessWidget {
  final String textoBurbuja;
  final Color colorBurbuja;
  final double size;
  final bool saludoPeriodico;

  const MascotaESOBurbuja({
    super.key,
    required this.textoBurbuja,
    required this.colorBurbuja,
    this.size = 110,
    this.saludoPeriodico = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MascotaESO(size: size, saludoPeriodico: saludoPeriodico),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorBurbuja.withValues(alpha: 0.22),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              textoBurbuja,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}