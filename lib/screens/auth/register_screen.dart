import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/progreso_service.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/neumorphic_text_field.dart';
import '../main_scaffold.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await AuthService.instance.registrar(
      nombre: _nombreController.text,
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
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(Icons.arrow_back_rounded,
                                        color: AppColors.textDark),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Crea tu cuenta',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 48),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Empieza tu ruta de normas ISO desde cero',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.textGrey, fontSize: 13),
                              ),
                              const SizedBox(height: 24),
                              NeumorphicTextField(
                                controller: _nombreController,
                                label: 'Nombre completo',
                                icon: Icons.person_rounded,
                                validator: (v) =>
                                    (v == null || v.trim().length < 3)
                                        ? 'Ingresa tu nombre completo'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              NeumorphicTextField(
                                controller: _emailController,
                                label: 'Correo electrónico',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
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

                              if (_error != null) ...[
                                const SizedBox(height: 16),
                                _CajaErrorRegistro(mensaje: _error!),
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
                                                AppColors.deepPurple),
                                          ),
                                        ),
                                      ),
                                    )
                                  : DuoButton(
                                      label: 'Crear cuenta',
                                      icon: Icons.rocket_launch_rounded,
                                      color: AppColors.deepPurple,
                                      shadowColor: AppColors.deepPurpleDark,
                                      width: double.infinity,
                                      onPressed: _registrar,
                                    ),
                              const SizedBox(height: 18),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textGrey),
                                    children: [
                                      TextSpan(text: '¿Ya tienes cuenta? '),
                                      TextSpan(
                                        text: 'Inicia sesión',
                                        style: TextStyle(
                                          color: AppColors.primaryGreen,
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

class _CajaErrorRegistro extends StatelessWidget {
  final String mensaje;
  const _CajaErrorRegistro({required this.mensaje});

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