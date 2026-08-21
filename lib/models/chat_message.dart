/// Representa un mensaje dentro de la conversación con el Tutor IA.
class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.isUser,
  });
}