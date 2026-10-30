import 'package:flutter/material.dart';

import '../data/casos_ra.dart';
import '../models/SeccionSilabo.dart';
import '../services/hoja_marcadores.dart';
import '../services/progreso_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascota_viva.dart';

/// El archivo de tarjetas imprimibles, una unidad por fila.
///
/// POR QUÉ UN APARTADO Y NO SOLO EL AVISO AL TERMINAR
/// --------------------------------------------------
/// La primera versión ofrecía la hoja en un diálogo, al cerrar la unidad.
/// Estaba mal pensado: ese momento ocurre una sola vez, y quien no tenía
/// impresora a mano justo entonces se quedaba sin manera de volver. Peor
/// todavía, repetir la última lección no lo reabría, porque el aviso se
/// dispara en la transición de «incompleta» a «completa» y esa transición
/// ya había ocurrido.
///
/// Aquí las hojas están siempre, y el diálogo del final pasa a ser lo que
/// debió ser desde el principio: un aviso de que algo nuevo apareció en
/// un sitio al que se puede volver.
///
/// POR QUÉ SE VEN LAS BLOQUEADAS
/// -----------------------------
/// Ocultar lo que falta deja la pantalla casi vacía al principio y no
/// cuenta nada. Mostrarlas con su candado dice cuántas unidades hay,
/// cuántos casos trae cada una y qué se gana al terminarla.
class TarjetasRAScreen extends StatelessWidget {
  const TarjetasRAScreen({super.key});

  /// El número de unidad, sacado del id de su primera lección.
  ///
  /// Se deduce del id y no de `numeroMundo` a propósito: es la misma
  /// fuente de la que sale `CasoRA.mundo`, de modo que las dos no pueden
  /// discrepar. Si el formato del id cambiara, dejarían de emparejarse a
  /// la vez y el fallo sería visible, en lugar de ofrecer en silencio las
  /// tarjetas de otra unidad.
  static int? _numeroDe(SeccionSilabo mundo) {
    for (final capitulo in mundo.capitulos) {
      for (final leccion in capitulo.lecciones) {
        final m = RegExp(r'^cap-(\d)-').firstMatch(leccion.id);
        if (m != null) return int.tryParse(m.group(1)!);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProgresoService.instance,
      builder: (context, _) {
        final servicio = ProgresoService.instance;
        final mundos = servicio.obtenerMundos();

        final abiertos = <CasoRA>[];
        for (final mundo in mundos) {
          if (!servicio.estaMundoCompletado(mundo)) continue;
          final n = _numeroDe(mundo);
          if (n != null) abiertos.addAll(HojaMarcadores.casosDelMundo(n));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F7FB),
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            title: const Text(
              'Tarjetas para imprimir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
            children: [
              const _Presentacion(),
              const SizedBox(height: 20),
              for (final mundo in mundos)
                _FilaUnidad(
                  mundo: mundo,
                  numero: _numeroDe(mundo),
                  completada: servicio.estaMundoCompletado(mundo),
                ),
              if (abiertos.length > 1) ...[
                const SizedBox(height: 10),
                _TodasEnUna(casos: abiertos),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Presentacion extends StatelessWidget {
  const _Presentacion();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MascotaViva(size: 58, conEntrada: false),
        const SizedBox(width: 12),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'Cada unidad que termines abre sus casos de realidad '
              'aumentada. Imprime la hoja, recórtala y apunta la cámara '
              'desde el Escáner AR.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Una unidad: abierta con su botón de imprimir, o cerrada con su candado.
class _FilaUnidad extends StatelessWidget {
  final SeccionSilabo mundo;
  final int? numero;
  final bool completada;

  const _FilaUnidad({
    required this.mundo,
    required this.numero,
    required this.completada,
  });

  @override
  Widget build(BuildContext context) {
    final color = mundo.colorPrimario;
    final casos =
        numero == null ? const <CasoRA>[] : HojaMarcadores.casosDelMundo(numero!);

    // Una unidad sin casos asociados no se anuncia: un candado que no
    // esconde nada es una promesa que no se va a cumplir.
    if (casos.isEmpty) return const SizedBox.shrink();

    final abierta = completada;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: abierta ? color.withValues(alpha: 0.35) : AppColors.border,
          width: abierta ? 1.6 : 1,
        ),
      ),
      child: Opacity(
        opacity: abierta ? 1 : 0.62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: abierta
                        ? color.withValues(alpha: 0.13)
                        : const Color(0xFFF0F0F6),
                    shape: BoxShape.circle,
                  ),
                  child: abierta
                      ? Icon(Icons.qr_code_2_rounded, size: 19, color: color)
                      : const Icon(Icons.lock_rounded,
                          size: 16, color: Color(0xFFB0B0BC)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mundo.nombre,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.25,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        abierta
                            ? (casos.length == 1
                                ? '1 caso disponible'
                                : '${casos.length} casos disponibles')
                            : 'Termina esta unidad para abrir '
                                '${casos.length == 1 ? "su caso" : "sus ${casos.length} casos"}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (abierta) ...[
              const SizedBox(height: 13),
              for (final caso in casos)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 2),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          caso.titulo,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.35,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => HojaMarcadores.imprimirMundo(
                    numero!,
                    titulo: mundo.nombre,
                    color: color,
                  ),
                  icon: const Icon(Icons.print_rounded, size: 18),
                  label: Text(
                    casos.length == 1 ? 'Imprimir la hoja' : 'Imprimir la hoja',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Todas las unidades abiertas en una sola hoja.
///
/// Aparece solo cuando hay más de una: con una sola, este botón haría
/// exactamente lo mismo que el de arriba y sería ruido.
class _TodasEnUna extends StatelessWidget {
  final List<CasoRA> casos;

  const _TodasEnUna({required this.casos});

  Future<void> _imprimir() => HojaMarcadores.imprimirCasos(
        casos,
        titulo: 'todo lo desbloqueado',
        nombreArchivo: 'marcadores-desbloqueados',
      );

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _imprimir,
      icon: const Icon(Icons.library_books_rounded, size: 18),
      label: Text(
        'Imprimir las ${casos.length} en una sola hoja',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.deepPurpleDark,
        side: const BorderSide(color: AppColors.deepPurple),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    );
  }
}