import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/neumorphic_text_field.dart';
import 'main_scaffold.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    // Simula la llamada a un backend de autenticación.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _cargando = false);

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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
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
                                color: AppColors.primaryGreen.withOpacity(0.15),
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
                              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
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
                            const SizedBox(height: 26),
                            _cargando
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
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
                                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
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