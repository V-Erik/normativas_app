import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/chat_message.dart';
import '../theme/app_theme.dart';

/// Pantalla de Chat con el Tutor IA. Conectada a una API local vía HTTP.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Cambia esta URL según dónde corra tu API:
  // - Emulador Android -> 10.0.2.2 apunta al localhost de tu PC.
  // - Simulador iOS / Chrome / Windows -> usa http://localhost:5000/api/chat
  // - Dispositivo físico -> usa la IP de tu PC en la red local.
  static const String _apiUrl = 'http://10.0.2.2:5000/api/chat';

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      const ChatMessage(
        isUser: false,
        text: '¡Hola! Soy tu tutor IA 🤖. Hoy vamos a repasar Ingeniería de Software. '
            '¿Sobre qué característica o cláusula te gustaría empezar?',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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

  /// Envía [text] a la API local del tutor IA y añade la respuesta al chat.
  Future<void> sendMessage(String text) async {
    final mensaje = text.trim();
    if (mensaje.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(ChatMessage(text: mensaje, isUser: true));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': mensaje}),
          )
          .timeout(const Duration(seconds: 20));

      String respuesta;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        respuesta = (data['reply'] ?? data['response'] ?? '').toString();
        if (respuesta.isEmpty) {
          respuesta = 'No entendí eso, ¿puedes reformular tu pregunta?';
        }
      } else {
        respuesta =
            'El servidor respondió con un error (${response.statusCode}). '
            'Intenta de nuevo en unos segundos.';
      }

      setState(() {
        _messages.add(ChatMessage(text: respuesta, isUser: false));
      });
    } catch (_) {
      setState(() {
        _messages.add(
          const ChatMessage(
            text: 'No pude conectarme al tutor IA. Verifica que el '
                'servidor local esté activo e inténtalo de nuevo.',
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  void _lanzarVisorAr() {
    setState(() {
      _messages.add(
        const ChatMessage(
          isUser: false,
          text: '📦 Lanzando modelo 3D en tu entorno real. Apunta la cámara '
              'hacia una superficie plana para colocarlo.',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo Escáner AR...'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepPurple,
      ),
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    const color = AppColors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor IA'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: const Icon(Icons.smart_toy_rounded, color: color, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return _TypingBubble(accentColor: color);
                }
                final mensaje = _messages[index];
                return _ChatBubble(mensaje: mensaje, accentColor: color);
              },
            ),
          ),
          _InputBar(
            controller: _controller,
            enabled: !_isTyping,
            onSend: () => sendMessage(_controller.text),
            onLaunchAr: _lanzarVisorAr,
          ),
        ],
      ),
    );
  }
}

/// Burbuja individual de chat, alineada según el emisor. Usa
/// [MediaQuery] para limitar su ancho máximo de forma responsive.
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
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!esUsuario) ...[
              CircleAvatar(
                radius: 14,
                backgroundColor: accentColor.withValues(alpha: 0.15),
                child: Icon(Icons.smart_toy_rounded, color: accentColor, size: 16),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.bubble),
                    topRight: const Radius.circular(AppRadius.bubble),
                    bottomLeft: Radius.circular(esUsuario ? AppRadius.bubble : 4),
                    bottomRight: Radius.circular(esUsuario ? 4 : AppRadius.bubble),
                  ),
                  border: esUsuario
                      ? null
                      : Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Text(
                  mensaje.text,
                  style: TextStyle(color: textColor, fontSize: 14.5, height: 1.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Burbuja de "escribiendo..." mientras se espera la respuesta de la API.
class _TypingBubble extends StatelessWidget {
  final Color accentColor;
  const _TypingBubble({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: accentColor.withValues(alpha: 0.15),
              child: Icon(Icons.smart_toy_rounded, color: accentColor, size: 16),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.bubble),
                  topRight: Radius.circular(AppRadius.bubble),
                  bottomRight: Radius.circular(AppRadius.bubble),
                ),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: SizedBox(
                width: 30,
                height: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (_) => const _TypingDot(color: AppColors.textGrey),
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

/// Barra fija inferior con campo de texto redondeado, botón AR y botón de enviar.
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onLaunchAr;
  final bool enabled;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onLaunchAr,
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
            BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2)),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.field),
                    borderSide: BorderSide.none,
                  ),
                  // Ícono AR embebido dentro del propio campo de texto.
                  suffixIcon: IconButton(
                    tooltip: 'Lanzar visor AR',
                    icon: const Icon(Icons.view_in_ar_rounded,
                        color: AppColors.deepPurple),
                    onPressed: enabled ? onLaunchAr : null,
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