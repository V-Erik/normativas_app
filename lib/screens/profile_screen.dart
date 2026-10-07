import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/progreso_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar sesión'),
        content: const Text(
          'Tendrás que ingresar tu correo y contraseña la próxima vez.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await AuthService.instance.cerrarSesion();
    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (ruta) => false);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService.instance.usuario;
    final progreso = ProgresoService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      body: SafeArea(
        // Se redibuja solo cuando cambia el progreso del estudiante.
        child: AnimatedBuilder(
          animation: progreso,
          builder: (context, _) {
            final mundos = progreso.obtenerMundos();
            final avanceGeneral = progreso.avanceGeneral;

            return LayoutBuilder(
              builder: (context, constraints) {
                final columnas = constraints.maxWidth < 420
                    ? 2
                    : constraints.maxWidth < 800
                        ? 3
                        : 4;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _Encabezado(
                      nombre: usuario?.nombre ?? 'Estudiante',
                      email: usuario?.email ?? '',
                      iniciales: usuario?.iniciales ?? '?',
                      nivel: progreso.obtenerNivel(),
                      avance: avanceGeneral,
                    ),
                    const SizedBox(height: 28),

                    Text('Tu progreso',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: columnas,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
                      children: [
                        _Estadistica(
                          icono: Icons.bolt_rounded,
                          etiqueta: 'XP total',
                          valor: '${progreso.obtenerXPTotal()}',
                          color: AppColors.deepPurple,
                        ),
                        _Estadistica(
                          icono: Icons.local_fire_department_rounded,
                          etiqueta: 'Racha',
                          valor: _textoRacha(progreso.obtenerRacha()),
                          color: AppColors.red,
                        ),
                        _Estadistica(
                          icono: Icons.trending_up_rounded,
                          etiqueta: 'Nivel',
                          valor: '${progreso.obtenerNivel()}',
                          color: AppColors.electricBlue,
                        ),
                        _Estadistica(
                          icono: Icons.donut_large_rounded,
                          etiqueta: 'Avance',
                          valor: '${(avanceGeneral * 100).round()} %',
                          color: AppColors.gold,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    Text('Avance por mundo',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          for (final mundo in mundos)
                            _BarraMundo(
                              nombre: mundo.nombre,
                              numero: mundo.numeroMundo,
                              color: mundo.colorPrimario,
                              avance: progreso.obtenerProgresoMundo(mundo),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Text('Cuenta',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _FilaDato(
                            icono: Icons.person_rounded,
                            etiqueta: 'Nombre',
                            valor: usuario?.nombre ?? '—',
                          ),
                          const Divider(
                              height: 1, color: AppColors.border),
                          _FilaDato(
                            icono: Icons.alternate_email_rounded,
                            etiqueta: 'Correo',
                            valor: usuario?.email ?? '—',
                          ),
                          const Divider(
                              height: 1, color: AppColors.border),
                          _FilaDato(
                            icono: Icons.calendar_today_rounded,
                            etiqueta: 'Miembro desde',
                            valor: _fecha(usuario?.creadoEn),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    _BotonCerrarSesion(
                      onPressed: () => _cerrarSesion(context),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  static String _textoRacha(int dias) {
    if (dias == 0) return 'Sin racha';
    return dias == 1 ? '1 día' : '$dias días';
  }

  static String _fecha(DateTime? f) {
    if (f == null) return '—';
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${f.day} ${meses[f.month - 1]} ${f.year}';
  }
}

// =====================================================================
// ENCABEZADO
// =====================================================================

class _Encabezado extends StatelessWidget {
  final String nombre;
  final String email;
  final String iniciales;
  final int nivel;
  final double avance;

  const _Encabezado({
    required this.nombre,
    required this.email,
    required this.iniciales,
    required this.nivel,
    required this.avance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepPurple, AppColors.electricBlue],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurpleDark.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar con las iniciales del usuario registrado
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              iniciales,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.deepPurple,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            nombre,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Insignia de nivel y barra hacia el siguiente
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_rounded,
                    color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  'Nivel $nivel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: avance.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${(avance * 100).round()} % del sílabo completado',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// TARJETA DE ESTADÍSTICA
// =====================================================================

class _Estadistica extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;

  const _Estadistica({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          FittedBox(
            child: Text(
              valor,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            style:
                const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// BARRA DE AVANCE POR MUNDO
// =====================================================================

class _BarraMundo extends StatelessWidget {
  final String nombre;
  final int numero;
  final Color color;
  final double avance;

  const _BarraMundo({
    required this.nombre,
    required this.numero,
    required this.color,
    required this.avance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              '$numero',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: avance.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: color.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 38,
            child: Text(
              '${(avance * 100).round()}%',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// FILA DE DATO DE CUENTA
// =====================================================================

class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _FilaDato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icono, color: AppColors.deepPurple, size: 20),
          const SizedBox(width: 14),
          Text(
            etiqueta,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textGrey),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// BOTÓN DE CERRAR SESIÓN
// =====================================================================

class _BotonCerrarSesion extends StatelessWidget {
  final VoidCallback onPressed;
  const _BotonCerrarSesion({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout_rounded, size: 19),
        label: const Text(
          'Cerrar sesión',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: BorderSide(color: AppColors.red.withOpacity(0.4), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}