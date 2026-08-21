import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/neumorphic_text_field.dart';
import 'main_scaffold.dart';
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

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    // Simula la llamada a un backend de registro.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _cargando = false);

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
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
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
                                  const SizedBox(width: 48), // balancea el IconButton
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Empieza tu ruta de normas ISO desde cero',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                              ),
                              const SizedBox(height: 24),
                              NeumorphicTextField(
                                controller: _nombreController,
                                label: 'Nombre completo',
                                icon: Icons.person_rounded,
                                validator: (v) => (v == null || v.trim().length < 3)
                                    ? 'Ingresa tu nombre completo'
                                    : null,
                              ),
                              const SizedBox(height: 16),
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
                                onTap: () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style:
                                        TextStyle(fontSize: 13, color: AppColors.textGrey),
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