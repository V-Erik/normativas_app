import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';

/// Consentimiento informado.
///
/// El backend exige haberlo aceptado antes de usar el tutor: mientras
/// `consentimiento_aceptado` sea false, `POST /chat` responde 409. Esta
/// pantalla llama a `POST /api/v1/usuarios/consentimiento` (sin cuerpo).
///
/// Se abre de dos maneras:
///   - al entrar al tutor, si `GET /usuarios/yo` dice que falta;
///   - como reacción a un ErrorApi con código 409.
///
/// Devuelve `true` por `Navigator.pop` si el estudiante aceptó.
class ConsentimientoScreen extends StatefulWidget {
  const ConsentimientoScreen({super.key});

  /// Abre la pantalla y devuelve true si se aceptó.
  static Future<bool> abrir(BuildContext context) async {
    final aceptado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ConsentimientoScreen()),
    );
    return aceptado ?? false;
  }

  @override
  State<ConsentimientoScreen> createState() => _ConsentimientoScreenState();
}

class _ConsentimientoScreenState extends State<ConsentimientoScreen> {
  bool _marcado = false;
  bool _enviando = false;
  String? _error;

  Future<void> _aceptar() async {
    setState(() {
      _enviando = true;
      _error = null;
    });

    try {
      await UsuarioService.aceptarConsentimiento();
      AuthService.instance.marcarConsentimientoAceptado();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ErrorApi catch (e) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = e.mensaje;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.deepPurple, AppColors.electricBlue],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ANTES DE EMPEZAR',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Consentimiento informado',
                    style: TextStyle(
                      fontSize: 26,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Texto
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                children: const [
                  _Parrafo(
                    'Esta aplicación forma parte de un Trabajo de Integración '
                    'Curricular de la Carrera de Computación de la Universidad '
                    'Politécnica del Carchi. El tutor que responde tus '
                    'preguntas es un modelo de lenguaje que funciona en un '
                    'servidor de la propia institución.',
                  ),
                  _Titulo('Qué se guarda'),
                  _Vineta(
                    'Tu correo y tu nombre, para identificar tu cuenta.',
                  ),
                  _Vineta(
                    'Las preguntas que le haces al tutor y sus respuestas, '
                    'para poder continuar una conversación y para analizar '
                    'cómo se usa la guía.',
                  ),
                  _Vineta(
                    'Tu avance: lecciones completadas, ejercicios resueltos, '
                    'experiencia y racha.',
                  ),
                  _Titulo('Para qué se usa'),
                  _Vineta(
                    'Para adaptar las explicaciones a tu nivel estimado en '
                    'cada unidad del sílabo.',
                  ),
                  _Vineta(
                    'Para resultados agregados de la investigación. Los datos '
                    'que se publiquen no permiten identificarte.',
                  ),
                  _Titulo('Tus condiciones'),
                  _Vineta(
                    'Participar es voluntario y puedes dejar de usar la app en '
                    'cualquier momento.',
                  ),
                  _Vineta(
                    'Tus consultas no salen de la infraestructura de la '
                    'institución: el modelo se ejecuta localmente, no en un '
                    'servicio externo.',
                  ),
                  _Vineta(
                    'Puedes pedir que se borre tu perfil de aprendizaje desde '
                    'el perfil de la app.',
                  ),
                  _Titulo('Qué no es'),
                  _Parrafo(
                    'El tutor orienta, da pistas y hace preguntas; no resuelve '
                    'tus trabajos ni sustituye las clases ni la bibliografía '
                    'de la asignatura. Puede equivocarse: contrasta siempre '
                    'con la norma original.',
                  ),
                ],
              ),
            ),

            // Pie: casilla, error y botones
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: _enviando
                        ? null
                        : () => setState(() => _marcado = !_marcado),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _marcado,
                            activeColor: AppColors.deepPurple,
                            onChanged: _enviando
                                ? null
                                : (v) => setState(() => _marcado = v ?? false),
                          ),
                          const Expanded(
                            child: Text(
                              'He leído y acepto participar en estas '
                              'condiciones.',
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.35,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCEBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFFD64545),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (!_marcado || _enviando) ? null : _aceptar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepPurple,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFD9DCE3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _enviando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'Aceptar y continuar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: _enviando
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Ahora no',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _Parrafo extends StatelessWidget {
  final String texto;
  const _Parrafo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          height: 1.55,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _Vineta extends StatelessWidget {
  final String texto;
  const _Vineta(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.deepPurple,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
