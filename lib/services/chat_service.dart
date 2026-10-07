import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // ¡ATENCIÓN! Cambia las "X" por tu Dirección IPv4 real del paso 1
  static const String _baseUrl = 'http://10.25.233.4:8000/api/v1/chat';

  /// [systemContext] es la instrucción oculta del "Modo Ruta" (qué capítulo/lección 
  /// estamos enseñando). [capituloFiltro] ayuda al backend a priorizar los documentos
  /// de ese capítulo en el RAG. [normaFiltro] sirve para reforzar con normas específicas.
  /// Todos son opcionales: si van en null, el chat funciona en modo libre.
  static Future<String> preguntarAlTutor(
    String texto, {
    String? systemContext,
    String? capituloFiltro,
    String? normaFiltro,
  }) async {
    try {
      final respuesta = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'message': texto,
              'system_context': systemContext,
              'capitulo_id': capituloFiltro,        // Nuevo: contexto del capítulo
              'norma_filtro': normaFiltro,           // Norma de apoyo
            }),
          )
          .timeout(const Duration(seconds: 120));

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(utf8.decode(respuesta.bodyBytes));
        return data['response'] ?? 'El tutor se quedó sin palabras.';
      } else {
        return 'Ocurrió un error en el servidor (Código: ${respuesta.statusCode})';
      }
    } catch (e) {
      return 'No se pudo conectar con el cerebro de la IA. Revisa tu IP o el servidor.';
    }
  }
}
