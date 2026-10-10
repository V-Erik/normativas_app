import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/progreso_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/neumorphic_text_field.dart';
import '../main_scaffold.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await AuthService.instance.iniciarSesion(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (!resultado.exito) {
      setState(() => _error = resultado.mensajeError);
      return;
    }

    // Recupera el avance guardado de este usuario y pide al servidor su
    // XP y su racha. Sin esto el estudiante entraria siempre con 0 XP.
    await ProgresoService.instance.iniciarSesionEstudiante();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScaffold()),
    );
  }

  void _irARegistro() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight - 48),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: GlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryGreen.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.school_rounded,
                                    color: AppColors.primaryGreen, size: 32),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                '¡Bienvenido de nuevo!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Inicia sesión para continuar tu ruta ISO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.textGrey, fontSize: 13),
                              ),
                              const SizedBox(height: 28),
                              NeumorphicTextField(
                                controller: _emailController,
                                label: 'Correo electrónico',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) => (v == null || !v.contains('@'))
                                    ? 'Ingresa un correo válido'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              NeumorphicTextField(
                                controller: _passwordController,
                                label: 'Contraseña',
                                icon: Icons.lock_rounded,
                                obscureText: true,
                                validator: (v) => (v == null || v.length < 4)
                                    ? 'Mínimo 4 caracteres'
                                    : null,
                              ),

                              // Mensaje de error del servicio
                              if (_error != null) ...[
                                const SizedBox(height: 16),
                                _CajaError(mensaje: _error!),
                              ],

                              const SizedBox(height: 26),
                              _cargando
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      child: Center(
                                        child: SizedBox(
                                          width: 26,
                                          height: 26,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor: AlwaysStoppedAnimation(
                                                AppColors.primaryGreen),
                                          ),
                                        ),
                                      ),
                                    )
                                  : DuoButton(
                                      label: 'Iniciar sesión',
                                      icon: Icons.login_rounded,
                                      width: double.infinity,
                                      onPressed: _iniciarSesion,
                                    ),
                              const SizedBox(height: 18),
                              GestureDetector(
                                onTap: _irARegistro,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textGrey),
                                    children: [
                                      TextSpan(text: '¿No tienes cuenta? '),
                                      TextSpan(
                                        text: 'Regístrate',
                                        style: TextStyle(
                                          color: AppColors.deepPurple,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Caja de error compartida por login y registro.
class _CajaError extends StatelessWidget {
  final String mensaje;
  const _CajaError({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD64545).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD64545).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFD64545), size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mensaje,
              style: const TextStyle(
                color: Color(0xFFB83A3A),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}