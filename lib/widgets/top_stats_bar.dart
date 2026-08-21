import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Cabecera superior minimalista: saludo con el nombre del usuario,
/// su racha de días, y una barra delgada de "Progreso Total".
/// Reemplaza al antiguo HUD de vidas/gemas/energía.
class TopStatsBar extends StatelessWidget {
  final String nombre;
  final int racha;

  /// Progreso general del usuario, de 0.0 a 1.0.
  final double progreso;

  const TopStatsBar({
    super.key,
    required this.nombre,
    required this.racha,
    this.progreso = 0,
  });

  String get _saludo {
    final hora = TimeOfDay.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final progresoClamp = progreso.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_saludo, $nombre',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Continúa tu ruta de normas ISO',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _StreakBadge(racha: racha),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progresoClamp,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Progreso total · ${(progresoClamp * 100).round()}%',
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

/// Insignia de racha: minimalista, con borde delgado, sin fondo sólido.
class _StreakBadge extends StatelessWidget {
  final int racha;
  const _StreakBadge({required this.racha});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              size: 17, color: Color(0xFFFF9600)),
          const SizedBox(width: 5),
          Text(
            '$racha',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}