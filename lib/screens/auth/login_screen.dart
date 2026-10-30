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

  /// Abre el diálogo de recuperación y, si se envió el correo, lo confirma.
  ///
  /// El aviso dice "si esa cuenta existe" a propósito: Firebase responde
  /// igual tanto si el correo está registrado como si no, para no revelar
  /// qué direcciones tienen cuenta. Prometer "te enviamos un correo" sería
  /// mentir la mitad de las veces.
  Future<void> _recuperarContrasena() async {
    FocusScope.of(context).unfocus();

    final enviado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoRecuperar(
        correoInicial: _emailController.text.trim(),
      ),
    );

    if (enviado != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryGreen,
        duration: Duration(seconds: 6),
        content: Text(
          'Si esa cuenta existe, te llegará un correo con el enlace para '
          'crear una contraseña nueva. Revisa también la carpeta de spam.',
          style: TextStyle(color: Colors.white, height: 1.35),
        ),
      ),
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

                              // Va aquí arriba y no al final a propósito:
                              // quien se queda fuera es porque falló la
                              // contraseña, y el enlace tiene que estar
                              // donde está mirando, no debajo del registro.
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: _cargando ? null : _recuperarContrasena,
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.deepPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),
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

// ==========================================================================
// RECUPERAR CONTRASEÑA
// ==========================================================================

/// Pide el correo y manda el enlace de restablecimiento de Firebase.
///
/// Devuelve `true` por `Navigator.pop` cuando el envío salió bien, para que
/// la pantalla de login muestre el aviso. El diálogo se queda abierto si
/// hubo error, así el estudiante puede corregir el correo sin volver a
/// abrirlo.
class _DialogoRecuperar extends StatefulWidget {
  final String correoInicial;

  const _DialogoRecuperar({required this.correoInicial});

  @override
  State<_DialogoRecuperar> createState() => _DialogoRecuperarState();
}

class _DialogoRecuperarState extends State<_DialogoRecuperar> {
  late final TextEditingController _correo =
      TextEditingController(text: widget.correoInicial);

  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final correo = _correo.text.trim().toLowerCase();
    if (!correo.contains('@')) {
      setState(() => _error = 'Escribe un correo válido.');
      return;
    }

    setState(() {
      _enviando = true;
      _error = null;
    });

    final fallo = await AuthService.instance.enviarCorreoDeRecuperacion(correo);
    if (!mounted) return;

    if (fallo != null) {
      setState(() {
        _enviando = false;
        _error = fallo;
      });
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: const Text(
        'Recuperar contraseña',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escribe tu correo institucional y te enviaremos un enlace '
              'para crear una contraseña nueva.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _correo,
              enabled: !_enviando,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _enviando ? null : _enviar(),
              decoration: InputDecoration(
                hintText: 'nombre.apellido@upec.edu.ec',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
                prefixIcon: const Icon(Icons.email_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.deepPurple,
                    width: 1.6,
                  ),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              _CajaError(mensaje: _error!),
            ],
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      actions: [
        TextButton(
          onPressed: _enviando ? null : () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _enviando ? null : _enviar,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepPurple,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.deepPurple,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _enviando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Text(
                  'Enviar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
        ),
      ],
    );
  }
}

/// Caja de error compartida por login, registro y el diálogo de
/// recuperación.
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