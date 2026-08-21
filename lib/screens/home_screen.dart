import 'package:flutter/material.dart';
import '../models/seccion_iso.dart';
import '../theme/app_theme.dart';
import '../widgets/top_stats_bar.dart';
import 'iso_level_screen.dart';

/// Pantalla principal: rejilla de "mundos" (uno por Norma ISO) en vez
/// del antiguo camino en zigzag. Cada mundo es una tarjeta circular con
/// degradado sutil, ícono central y estado (en curso / completado /
/// bloqueado).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _nombreUsuario = 'Erik';

  static final List<SeccionIso> _secciones = [
    const SeccionIso(
      etapa: 'Etapa 1',
      titulo: 'Introducción a la ISO/IEC 25010',
      codigoNorma: 'ISO/IEC 25010',
      icono: Icons.verified_rounded,
      color: AppColors.primaryGreen,
      niveles: [
        NivelRuta(icono: Icons.menu_book_rounded, estado: NivelEstado.completado),
        NivelRuta(icono: Icons.quiz_rounded, estado: NivelEstado.completado),
        NivelRuta(icono: Icons.verified_rounded, estado: NivelEstado.actual),
        NivelRuta(icono: Icons.fact_check_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.emoji_events_rounded, estado: NivelEstado.bloqueado),
      ],
    ),
    const SeccionIso(
      etapa: 'Etapa 2',
      titulo: 'Ciclo de Vida del Software',
      codigoNorma: 'ISO/IEC 12207',
      icono: Icons.autorenew_rounded,
      color: AppColors.electricBlue,
      niveles: [
        NivelRuta(icono: Icons.autorenew_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.quiz_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.integration_instructions_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.emoji_events_rounded, estado: NivelEstado.bloqueado),
      ],
    ),
    const SeccionIso(
      etapa: 'Etapa 3',
      titulo: 'Seguridad de la Información',
      codigoNorma: 'ISO/IEC 27001',
      icono: Icons.shield_rounded,
      color: AppColors.deepPurple,
      niveles: [
        NivelRuta(icono: Icons.shield_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.quiz_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.vpn_key_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.emoji_events_rounded, estado: NivelEstado.bloqueado),
      ],
    ),
    const SeccionIso(
      etapa: 'Etapa 4',
      titulo: 'Evaluación de Procesos de Software',
      codigoNorma: 'ISO/IEC 33001',
      icono: Icons.fact_check_rounded,
      color: AppColors.electricBlue,
      niveles: [
        NivelRuta(icono: Icons.fact_check_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.quiz_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.analytics_rounded, estado: NivelEstado.bloqueado),
        NivelRuta(icono: Icons.emoji_events_rounded, estado: NivelEstado.bloqueado),
      ],
    ),
  ];

  void _abrirNorma(BuildContext context, SeccionIso seccion) {
    if (seccion.estadoGeneral == NivelEstado.bloqueado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Completa la norma anterior para desbloquear esta.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textDark,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IsoLevelScreen(seccion: seccion)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completadas =
        _secciones.where((s) => s.estadoGeneral == NivelEstado.completado).length;
    final progresoTotal =
        _secciones.isEmpty ? 0.0 : completadas / _secciones.length;

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
                    final seccion = _secciones[index];
                    return _WorldCard(
                      seccion: seccion,
                      onTap: () => _abrirNorma(context, seccion),
                    );
                  },
                  childCount: _secciones.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta "mundo/planeta": círculo con degradado sutil derivado del
/// color de la norma, ícono central, y una insignia pequeña de estado
/// (check si está completada, candado si está bloqueada).
class _WorldCard extends StatelessWidget {
  final SeccionIso seccion;
  final VoidCallback onTap;

  const _WorldCard({required this.seccion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bloqueado = seccion.estadoGeneral == NivelEstado.bloqueado;
    final completado = seccion.estadoGeneral == NivelEstado.completado;
    final colorBase = bloqueado ? AppColors.textGrey : seccion.color;

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
                    colors: bloqueado
                        ? const [Color(0xFFEDEEF2), Color(0xFFE2E4EA)]
                        : [colorBase.withOpacity(0.14), colorBase.withOpacity(0.30)],
                  ),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: (bloqueado ? Colors.black : colorBase).withOpacity(0.10),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(seccion.icono, size: 32, color: colorBase),
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
                ),
              if (bloqueado)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: const Icon(Icons.lock_rounded, size: 12, color: AppColors.textGrey),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            seccion.codigoNorma,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: bloqueado ? AppColors.textGrey : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            bloqueado ? 'Bloqueado' : (completado ? 'Completado' : 'En curso'),
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}