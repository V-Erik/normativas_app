import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/SeccionSilabo.dart';
import '../services/chat_service.dart';
import '../services/progreso_service.dart';
import '../theme/app_theme.dart';

/// Marcador que le pedimos a la IA que agregue, en una línea aparte, al
/// final de su respuesta SOLO cuando el estudiante respondió bien la
/// pregunta de la lección actual. Se oculta del texto que ve el usuario
/// y dispara el desbloqueo de la siguiente lección.
const String _marcadorNivelCompletado = '[[NIVEL_COMPLETADO]]';

/// Pantalla de Chat con el Tutor IA.
///
/// Modo libre: se abre sin [mundo]/[capitulo]/[leccion] (ej. desde la pestaña
/// "Tutor IA" del menú inferior) y funciona como un chat normal.
///
/// Modo Ruta: se abre desde una lección con los tres parámetros indicados.
/// Ahí el chat le manda a la IA una instrucción oculta (prompt oculto) para que
/// la conversación gire en torno a esa lección específica, y detecta cuándo el
/// estudiante ya respondió bien para desbloquear la siguiente lección.
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
  bool _nivelCompletado = false;

  bool get _esModoRuta =>
      widget.mundo != null && widget.capitulo != null && widget.leccion != null;

  @override
  void initState() {
    super.initState();
    if (_esModoRuta) {
      // Arranque silencioso: le pedimos a la IA que inicie la lección,
      // sin mostrar un mensaje vacío del "usuario" en el chat.
      sendMessage(
        '${widget.mundo!.nombre} - Capítulo ${widget.capitulo!.numeroCapitulo}: ${widget.leccion!.titulo}',
        mostrarComoUsuario: false,
      );
    } else {
      _messages.add(
        const ChatMessage(
          isUser: false,
          text: '¡Hola! Soy tu tutor IA 🤖. ¿Sobre qué concepto de normativas '
              'de software te gustaría que te oriente hoy?',
        ),
      );
    }
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

  /// Instrucción interna (prompt oculto) que programa al tutor para la
  /// lección actual. Solo existe en Modo Ruta.
  String? get _promptOculto {
    if (!_esModoRuta) return null;

    return '''Actúa como un tutor guiando paso a paso. El estudiante está en:
- Mundo ${widget.mundo!.numeroMundo}: ${widget.mundo!.nombre}
- Capítulo ${widget.capitulo!.numeroCapitulo}: ${widget.capitulo!.nombre}
- Lección ${widget.leccion!.numero}: ${widget.leccion!.titulo}

Tipo de lección: ${widget.leccion!.tipoLeccion}
Objetivo: ${widget.capitulo!.objetivoAprendizaje}
${widget.capitulo!.normasUsadas.isNotEmpty ? 'Normas asociadas: ${widget.capitulo!.normasUsadas.join(', ')}' : ''}

Tu tarea:
1. Explica brevemente el concepto de la lección (máximo 2-3 párrafos)
2. Hazle una pregunta de opción múltiple para verificar la comprensión
3. Cuando el estudiante responda:
   - Si es correcto: felicítalo brevemente y agrega en una línea aparte: $_marcadorNivelCompletado
   - Si no es correcto: dale una pista breve y vuelve a preguntar

IMPORTANTE: El marcador solo se agrega cuando la respuesta es correcta.''';
  }

  /// Envía [text] al tutor IA. Si [mostrarComoUsuario] es false, no se
  /// agrega una burbuja de usuario visible (se usa para el arranque
  /// silencioso de una lección en Modo Ruta).
  Future<void> sendMessage(String text, {bool mostrarComoUsuario = true}) async {
    final mensaje = text.trim();
    if (mensaje.isEmpty || _isTyping) return;

    setState(() {
      if (mostrarComoUsuario) {
        _messages.add(ChatMessage(text: mensaje, isUser: true));
      }
      _isTyping = true;
    });
    if (mostrarComoUsuario) _controller.clear();
    _scrollToBottom();

    // Enviar al backend con contexto
    final respuesta = await ChatService.preguntarAlTutor(
      mensaje,
      systemContext: _promptOculto,
      capituloFiltro: _esModoRuta ? widget.capitulo?.id : null,
      normaFiltro: _esModoRuta ? widget.capitulo?.normasUsadas.first : null,
    );

    final completo = respuesta.contains(_marcadorNivelCompletado);
    final textoVisible = respuesta.replaceAll(_marcadorNivelCompletado, '').trim();

    setState(() {
      _messages.add(ChatMessage(text: textoVisible, isUser: false));
      _isTyping = false;
      if (completo) _nivelCompletado = true;
    });

    // Si se completó la lección, desbloquear la siguiente
    if (completo && _esModoRuta) {
      final mundos = ProgresoService.instance.obtenerMundos();
      ProgresoService.instance.completarLeccion(
        widget.leccion!.id,
        widget.leccion!.experiencia,
        mundos,
      );
    }

    _scrollToBottom();
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
    final color = widget.mundo?.colorPrimario ?? AppColors.deepPurple;
    final titulo = _esModoRuta
        ? 'Capítulo ${widget.capitulo!.numeroCapitulo} · ${widget.leccion!.numero}'
        : 'Tutor IA';

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _esModoRuta
                ? Hero(
                    tag: 'mundo-icon-${widget.mundo!.id}',
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: Text(widget.mundo!.icono, style: const TextStyle(fontSize: 18)),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(Icons.smart_toy_rounded, color: color, size: 20),
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
                return _ChatBubble(mensaje: _messages[index], accentColor: color);
              },
            ),
          ),
          if (_nivelCompletado)
            _NivelCompletadoBanner(
              color: color,
              onVolver: () => Navigator.of(context).pop(),
            )
          else
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

/// Aviso que reemplaza la barra de escritura cuando la lección actual se
/// completó: felicita al estudiante y lo regresa al mapa de lecciones.
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
            BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: color),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '¡Lección completada! Se desbloqueó la siguiente.',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
            ),
            ElevatedButton(
              onPressed: onVolver,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Burbuja individual de chat, alineada según el emisor.
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
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!esUsuario) ...[
              CircleAvatar(
                radius: 14,
                backgroundColor: accentColor.withOpacity(0.15),
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
                  border: esUsuario ? null : Border.all(color: AppColors.border, width: 1.5),
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
              backgroundColor: accentColor.withOpacity(0.15),
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
                  children: List.generate(3, (_) => const _TypingDot(color: AppColors.textGrey)),
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
                  hintText: enabled ? 'Pregúntale algo al tutor IA...' : 'Esperando respuesta...',
                  hintStyle: const TextStyle(color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.field),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Lanzar visor AR',
                    icon: const Icon(Icons.view_in_ar_rounded, color: AppColors.deepPurple),
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
