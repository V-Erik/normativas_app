import 'package:flutter/material.dart';

import '../data/mapeo_lecciones.dart';
import '../models/chat_message.dart';
import '../models/SeccionSilabo.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/progreso_service.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';
import 'consentimiento_screen.dart';

/// Pantalla de Chat con el Tutor IA, hablando con el backend real.
///
/// Modo libre: se abre sin [mundo]/[capitulo]/[leccion] (pestaña "Tutor IA")
/// y funciona como un chat normal.
///
/// Modo Ruta: se abre desde una lección. Lo único que cambia es que se
/// envía `leccion_id`, para que el tutor busque el contexto en el tema del
/// sílabo de esa lección.
///
/// QUÉ DESAPARECIÓ Y POR QUÉ
/// -------------------------
/// El marcador `[[NIVEL_COMPLETADO]]` ya no existe. Antes esta pantalla
/// mandaba un prompt oculto en `system_context` pidiéndole al modelo que
/// escribiera ese marcador al acertar, y detectaba la lección completada
/// buscándolo en la respuesta. El backend **descarta `system_context`**: el
/// tutor tiene su propio prompt pedagógico y no acepta instrucciones del
/// cliente, así que el marcador nunca llegaría y la lección nunca se
/// marcaría como completada.
///
/// Ahora la lección se completa cuando el estudiante lo decide (botón
/// "Terminar lección") o cuando termina los ejercicios en
/// `lesson_screen_v3.dart`, y eso llama a
/// `POST /api/v1/progreso/lecciones/{id}/completar`.
class ChatScreen extends StatefulWidget {
  final SeccionSilabo? mundo;
  final CapituloSilabo? capitulo;
  final LeccionSilabo? leccion;

  const ChatScreen({
    super.key,
    this.mundo,
    this.capitulo,
    this.leccion,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isTyping = false;
  bool _leccionCompletada = false;

  /// Hilo de conversación. En el primer mensaje va null: el servidor
  /// genera uno y lo devuelve. Reenviarlo es lo que le da memoria al tutor
  /// (vive en la RAM del servidor y se pierde si se reinicia).
  String? _conversacionId;

  /// Texto que se muestra mientras se espera: estado de la cola.
  String? _avisoCola;

  /// Último mensaje que falló, para el botón de reintentar.
  String? _mensajePendiente;

  /// Aviso fijo arriba (servidor caído, tema sin documentación…).
  String? _avisoSuperior;

  bool get _esModoRuta =>
      widget.mundo != null && widget.capitulo != null && widget.leccion != null;

  /// El `leccion_id` que entiende el backend para esta lección.
  String? get _leccionIdBackend =>
      _esModoRuta ? MapeoLecciones.leccionIdParaChat(widget.leccion!.id) : null;

  @override
  void initState() {
    super.initState();
    _arrancar();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ==================== ARRANQUE ====================

  /// Flujo de arranque recomendado por el backend:
  ///   1. sesión de Firebase (ya la hay si llegamos aquí)
  ///   2. GET /salud  -> ¿está vivo el servidor? ¿responde Ollama?
  ///   3. GET /usuarios/yo -> ¿aceptó el consentimiento?
  ///   4. POST /chat
  Future<void> _arrancar() async {
    // 2. Salud del servidor. Si no responde, no tiene sentido seguir:
    //    ni el consentimiento ni el chat funcionarian, y pedirle al
    //    estudiante que acepte algo que va a fallar parece que la app
    //    esta rota cuando lo unico que falta es encender el backend.
    bool servidorListo = false;
    try {
      final salud = await UsuarioService.salud();
      servidorListo = salud.listo;
      if (!servidorListo && mounted) {
        setState(() => _avisoSuperior = salud.aviso);
      }
    } on ErrorApi catch (e) {
      if (mounted) setState(() => _avisoSuperior = e.mensaje);
    }

    if (!mounted) return;

    if (!servidorListo) {
      setState(() {
        _messages.add(
          const ChatMessage(
            isUser: false,
            text: 'Por ahora no puedo conectarme con el servidor del '
                'tutor, asi que no puedo responder preguntas.\n\n'
                'Las lecciones y los ejercicios si funcionan sin '
                'conexion: puedes seguir avanzando y volver aqui cuando '
                'el servidor este encendido.',
          ),
        );
      });
      return;
    }

    // 3. Consentimiento. Si falta, se pide antes de la primera pregunta
    //    para no chocar nunca con el 409.
    final usuario = AuthService.instance.usuario;
    if (usuario != null && !usuario.consentimientoAceptado) {
      final aceptado = await ConsentimientoScreen.abrir(context);
      if (!mounted) return;
      if (!aceptado) {
        setState(() {
          _messages.add(
            const ChatMessage(
              isUser: false,
              text: 'Para usar el tutor necesito que aceptes el '
                  'consentimiento informado. Cuando quieras, vuelve a '
                  'entrar aquí.',
            ),
          );
        });
        return;
      }
    }

    if (!mounted) return;

    // Aviso honesto cuando la lección apunta a un tema sin documentación:
    // 9 de los 27 temas del sílabo no tienen documento indexado y el tutor
    // dirá que no los tiene. Es correcto, pero mejor advertirlo antes.
    if (_esModoRuta && MapeoLecciones.sinDocumentacion(widget.leccion!.id)) {
      setState(() {
        _avisoSuperior = 'De este tema el tutor todavía no tiene documentación '
            'indexada: te dirá que no está en sus documentos en lugar de '
            'inventarse la norma.';
      });
    }

    // 4. Primer mensaje.
    if (_esModoRuta) {
      // Arranque silencioso: se abre la lección sin burbuja de usuario.
      // Ya sin instrucciones ocultas: solo el texto visible de la pregunta.
      await _enviar(
        '${widget.capitulo!.nombre}: ${widget.leccion!.titulo}. '
        'Explícame de qué se trata.',
        mostrarComoUsuario: false,
      );
    } else {
      setState(() {
        _messages.add(
          const ChatMessage(
            isUser: false,
            text: '¡Hola! Soy tu tutor de normativas de Ingeniería de '
                'Software. Pregúntame sobre cualquier norma o concepto del '
                'sílabo y te oriento.',
          ),
        );
      });
    }
  }

  // ==================== ENVÍO ====================

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _enviar(String texto, {bool mostrarComoUsuario = true}) async {
    final mensaje = texto.trim();
    if (mensaje.isEmpty || _isTyping) return;

    setState(() {
      if (mostrarComoUsuario) {
        _messages.add(ChatMessage(text: mensaje, isUser: true));
      }
      _isTyping = true;
      _avisoCola = null;
      _mensajePendiente = null;
    });
    if (mostrarComoUsuario) _controller.clear();
    _scrollAlFinal();

    try {
      final respuesta = await ChatService.preguntarAlTutor(
        mensaje,
        conversacionId: _conversacionId,
        leccionId: _leccionIdBackend,
        alCambiarCola: (estado) {
          if (mounted) setState(() => _avisoCola = estado.mensaje);
        },
      );

      if (!mounted) return;

      // Guardar el hilo para los siguientes mensajes.
      _conversacionId = respuesta.conversacionId.isEmpty
          ? _conversacionId
          : respuesta.conversacionId;

      setState(() {
        _messages.add(
          ChatMessage(text: respuesta.respuesta, isUser: false),
        );
        _isTyping = false;
        _avisoCola = null;
      });

      // Nota discreta si la espera en cola fue notable, para que el
      // estudiante entienda por qué tardó.
      final nota = respuesta.notaDeEspera;
      if (nota != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(nota),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.textGrey,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
          ),
        );
      }

      _scrollAlFinal();
    } on ErrorApi catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _avisoCola = null;
      });
      await _manejarError(e, mensaje);
    }
  }

  /// 401 -> al login. 409 -> consentimiento y reenviar.
  /// 503 y errores de red -> botón de reintentar, nunca reintento
  /// automático (solo alargaría la cola).
  Future<void> _manejarError(ErrorApi e, String mensaje) async {
    if (e.sesionCaducada) {
      await AuthService.instance.cerrarSesion();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
      return;
    }

    if (e.faltaConsentimiento) {
      final aceptado = await ConsentimientoScreen.abrir(context);
      if (!mounted) return;
      if (aceptado) {
        await _enviar(mensaje, mostrarComoUsuario: false);
        return;
      }
    }

    setState(() {
      _messages.add(ChatMessage(text: e.mensaje, isUser: false));
      _mensajePendiente = mensaje;
    });
    _scrollAlFinal();
  }

  // ==================== LECCIÓN ====================

  /// La app decide cuándo se completa la lección: ya no lo decide el texto
  /// que escriba el modelo.
  Future<void> _terminarLeccion() async {
    if (!_esModoRuta || _leccionCompletada) return;

    final completada = await ProgresoService.instance.completarLeccion(
      widget.leccion!.id,
      widget.leccion!.experiencia,
    );

    if (!mounted) return;
    setState(() => _leccionCompletada = true);

    if (!completada) {
      // Ya estaba completada: no se vuelve a sumar XP (el backend no
      // deduplica, así que el control tiene que estar aquí).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta lección ya estaba completada.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final color = widget.mundo?.colorPrimario ?? AppColors.deepPurple;
    final titulo = _esModoRuta
        ? 'Capítulo ${widget.capitulo!.numeroCapitulo} · ${widget.leccion!.numero}'
        : 'Tutor IA';

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          if (_esModoRuta && !_leccionCompletada)
            TextButton(
              onPressed: _isTyping ? null : _terminarLeccion,
              child: Text(
                'Terminar',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: _esModoRuta
                  ? Text(widget.mundo!.icono,
                      style: const TextStyle(fontSize: 18))
                  : Icon(Icons.smart_toy_rounded, color: color, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_avisoSuperior != null)
            _AvisoBanner(
              texto: _avisoSuperior!,
              onCerrar: () => setState(() => _avisoSuperior = null),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return _TypingBubble(
                    accentColor: color,
                    aviso: _avisoCola,
                  );
                }
                return _ChatBubble(
                  mensaje: _messages[index],
                  accentColor: color,
                );
              },
            ),
          ),
          if (_leccionCompletada)
            _NivelCompletadoBanner(
              color: color,
              onVolver: () => Navigator.of(context).pop(),
            )
          else if (_mensajePendiente != null)
            _ReintentarBarra(
              color: color,
              onReintentar: () {
                final mensaje = _mensajePendiente!;
                setState(() => _mensajePendiente = null);
                _enviar(mensaje, mostrarComoUsuario: false);
              },
              onDescartar: () => setState(() => _mensajePendiente = null),
            )
          else
            _InputBar(
              controller: _controller,
              enabled: !_isTyping,
              onSend: () => _enviar(_controller.text),
            ),
        ],
      ),
    );
  }
}

/// Franja de aviso arriba del chat: servidor caído, tema sin documentación.
class _AvisoBanner extends StatelessWidget {
  final String texto;
  final VoidCallback onCerrar;

  const _AvisoBanner({required this.texto, required this.onCerrar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF6E5),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Color(0xFF8A5A00),
              ),
            ),
          ),
          IconButton(
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close_rounded, color: Color(0xFF8A5A00)),
            onPressed: onCerrar,
          ),
        ],
      ),
    );
  }
}

/// Barra que reemplaza el campo de texto cuando una pregunta falló.
/// No se reintenta solo: un reintento automático durante una saturación
/// solo alargaría la cola.
class _ReintentarBarra extends StatelessWidget {
  final Color color;
  final VoidCallback onReintentar;
  final VoidCallback onDescartar;

  const _ReintentarBarra({
    required this.color,
    required this.onReintentar,
    required this.onDescartar,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onDescartar,
                child: const Text(
                  'Descartar',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aviso que reemplaza la barra de escritura cuando la lección se completó.
class _NivelCompletadoBanner extends StatelessWidget {
  final Color color;
  final VoidCallback onVolver;

  const _NivelCompletadoBanner({required this.color, required this.onVolver});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: color),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '¡Lección completada! Se desbloqueó la siguiente.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onVolver,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Burbuja individual de chat.
class _ChatBubble extends StatelessWidget {
  final ChatMessage mensaje;
  final Color accentColor;

  const _ChatBubble({required this.mensaje, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final esUsuario = mensaje.isUser;
    final bubbleColor = esUsuario ? AppColors.primaryGreen : Colors.white;
    final textColor = esUsuario ? Colors.white : AppColors.textDark;

    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!esUsuario) ...[
              CircleAvatar(
                radius: 14,
                backgroundColor: accentColor.withValues(alpha: 0.15),
                child: Icon(
                  Icons.smart_toy_rounded,
                  color: accentColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.bubble),
                    topRight: const Radius.circular(AppRadius.bubble),
                    bottomLeft: Radius.circular(esUsuario ? AppRadius.bubble : 4),
                    bottomRight:
                        Radius.circular(esUsuario ? 4 : AppRadius.bubble),
                  ),
                  border: esUsuario
                      ? null
                      : Border.all(color: AppColors.border, width: 1.5),
                ),
                // El tutor devuelve Markdown ligero. Sin un widget de
                // Markdown, al menos se respetan los saltos de línea y se
                // limpian los asteriscos para que no se lean como basura.
                child: Text(
                  esUsuario ? mensaje.text : _limpiarMarkdown(mensaje.text),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quita el `**negrita**` y convierte las listas con `*` en viñetas.
  /// Si más adelante se añade el paquete `flutter_markdown`, este método
  /// se reemplaza por un `MarkdownBody`.
  static String _limpiarMarkdown(String texto) {
    return texto
        // replaceAllMapped, no replaceAll: replaceAll no entiende $1 y
        // dejaría el "$1" literal en el texto.
        .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1] ?? '')
        .replaceAll(RegExp(r'^\s*\*\s+', multiLine: true), '•  ')
        .trim();
  }
}

class _TypingBubble extends StatelessWidget {
  final Color accentColor;

  /// Estado de la cola, mientras se espera turno.
  final String? aviso;

  const _TypingBubble({required this.accentColor, this.aviso});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: accentColor.withValues(alpha: 0.15),
              child: Icon(
                Icons.smart_toy_rounded,
                color: accentColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.bubble),
                    topRight: Radius.circular(AppRadius.bubble),
                    bottomRight: Radius.circular(AppRadius.bubble),
                  ),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: aviso == null
                    ? SizedBox(
                        width: 30,
                        height: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            3,
                            (_) => const _TypingDot(color: AppColors.textGrey),
                          ),
                        ),
                      )
                    : Text(
                        aviso!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: AppColors.textGrey,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final Color color;
  const _TypingDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: enabled
                      ? 'Pregúntale algo al tutor IA...'
                      : 'Esperando respuesta...',
                  hintStyle: const TextStyle(color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.field),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: enabled ? AppColors.primaryGreen : AppColors.textGrey,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: enabled ? onSend : null,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
