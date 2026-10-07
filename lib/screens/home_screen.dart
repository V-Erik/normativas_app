import 'package:flutter/material.dart';

import '../data/mock_data_silabo.dart';
import '../models/SeccionSilabo.dart';
import '../services/progreso_service.dart';
import '../theme/app_theme.dart';
import '../widgets/top_stats_bar.dart';
import 'silabo_roadmap_screen.dart';

/// Pantalla principal: rejilla de "mundos" (4 contenidos del sílabo). Lee el
/// catálogo y el progreso siempre desde [ProgresoService], así que se
/// refresca sola cuando el estudiante desbloquea capítulos o mundos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _nombreUsuario = 'Erik';

  void _abrirMundo(BuildContext context, SeccionSilabo mundo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SilabusRoadmapScreen(mundo: mundo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProgresoService.instance,
      builder: (context, _) {
        final mundos = MockDataSilabo.obtenerMundosSilabo();

        final completados =
            mundos.where((m) => m.estaCompletado()).length;
        final progresoTotal = mundos.isEmpty ? 0.0 : completados / mundos.length;

        final anchoPantalla = MediaQuery.of(context).size.width;
        final columnas = anchoPantalla < 380
            ? 2
            : anchoPantalla < 700
                ? 3
                : 4;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TopStatsBar(
                    nombre: _nombreUsuario,
                    racha: 12,
                    progreso: progresoTotal,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 26,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final mundo = mundos[index];
                        return _MundoCard(
                          mundo: mundo,
                          onTap: () => _abrirMundo(context, mundo),
                        );
                      },
                      childCount: mundos.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tarjeta "mundo/planeta": círculo con degradado del color del mundo,
/// ícono central, número del mundo, y barra de progreso.
class _MundoCard extends StatelessWidget {
  final SeccionSilabo mundo;
  final VoidCallback onTap;

  const _MundoCard({required this.mundo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final completado = mundo.estaCompletado();
    final progreso = mundo.obtenerProgreso();
    final colorBase = mundo.colorPrimario;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorBase.withValues(alpha: 0.14),
                      colorBase.withValues(alpha: 0.30)
                    ],
                  ),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: colorBase.withValues(alpha: 0.10),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    mundo.icono,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              if (completado)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                  ),
                )
              else if (progreso > 0)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorBase,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      '${(progreso * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Mundo ${mundo.numeroMundo}',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            mundo.nombre,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
