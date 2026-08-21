import 'package:flutter/material.dart';
import '../models/seccion_iso.dart';
import '../theme/app_theme.dart';
import '../widgets/duolingo_section_header.dart';
import '../widgets/duolingo_zigzag_path.dart';
import '../widgets/top_stats_bar.dart';

class IsoRoadmapScreen extends StatelessWidget {
  final SeccionIso seccion;

  const IsoRoadmapScreen({super.key, required this.seccion});

  void _onTapNivelActual(BuildContext context, NivelRuta nivel) {
    debugPrint('Nivel actual presionado -> ${nivel.icono}');
    // TODO: Navegar a la lección o al escáner AR
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Barra superior con botón de regreso incorporado
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textGrey, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: TopStatsBar(racha: 12, gemas: 340, energia: 5),
                ),
              ],
            ),
          ),
          // El camino en zigzag que se puede desplazar
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                DuolingoSectionHeader(
                  etapa: seccion.etapa,
                  titulo: seccion.titulo,
                  color: seccion.color,
                ),
                const SizedBox(height: 32),
                DuolingoZigzagPath(
                  niveles: seccion.niveles,
                  color: seccion.color,
                  onTapNivel: (nivel) => _onTapNivelActual(context, nivel),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}