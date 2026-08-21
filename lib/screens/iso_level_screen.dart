import 'package:flutter/material.dart';
import '../models/seccion_iso.dart';
import '../theme/app_theme.dart';
import '../widgets/duolingo_section_header.dart';
import '../widgets/duolingo_zigzag_path.dart';

/// Pantalla de detalle: muestra únicamente los niveles de una norma ISO
/// en particular (se abre al tocar su nodo en el mapa general de
/// HomeScreen). Tiene su propio AppBar, sin la barra de estadísticas
/// para no duplicar el "HUD" de la pantalla anterior.
class IsoLevelScreen extends StatelessWidget {
  final SeccionIso seccion;

  const IsoLevelScreen({super.key, required this.seccion});

  void _onTapNivel(NivelRuta nivel) {
    if (nivel.estado != NivelEstado.actual) return;
    // Por ahora no hay lógica de navegación a la lección en sí,
    // solo confirmamos la interacción en consola.
    debugPrint('Nivel actual presionado -> ${nivel.icono} (estado: ${nivel.estado})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(seccion.codigoNorma),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: seccion.color.withOpacity(0.15),
              child: Icon(seccion.icono, color: seccion.color, size: 20),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final paddingHorizontal = constraints.maxWidth < 360 ? 14.0 : 20.0;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(paddingHorizontal, 16, paddingHorizontal, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuolingoSectionHeader(
                  etapa: seccion.etapa,
                  titulo: seccion.titulo,
                  color: seccion.color,
                ),
                const SizedBox(height: 12),
                DuolingoZigzagPath(
                  niveles: seccion.niveles,
                  color: seccion.color,
                  onTapNivel: _onTapNivel,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}