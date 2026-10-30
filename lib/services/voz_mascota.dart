import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// La voz de la mascota: clips sintetizados de antemano, con el motor del
/// teléfono como respaldo.
///
/// POR QUÉ CLIPS Y NO SÍNTESIS EN VIVO
/// -----------------------------------
/// El motor de Android habla con la voz que cada teléfono tenga
/// instalada, de modo que el mismo diálogo suena distinto en cada equipo
/// y en algunos no suena. Los clips se generan una sola vez con una voz
/// neuronal (ver `generar_voces.py` en la raíz del proyecto), viajan en el
/// paquete y suenan igual en todas partes y sin red.
///
/// POR QUÉ EL RESPALDO NO SOBRA
/// ----------------------------
/// Hay texto que no se puede grabar de antemano porque no existe hasta
/// que el estudiante pregunta: las respuestas del tutor. Y si un clip
/// falta —porque se añadió un caso y nadie volvió a ejecutar el
/// generador— es preferible que esa frase la lea el teléfono a que se
/// quede muda sin avisar. Por eso [decir] admite una clave y, cuando no
/// encuentra su clip, sintetiza.
///
/// ESTO NO CONTRADICE LA INFERENCIA LOCAL
/// --------------------------------------
/// El apartado 4.2.1.5 sostiene que ninguna consulta del estudiante
/// abandona la infraestructura institucional. Aquí no abandona ninguna:
/// la síntesis ocurrió una vez, en el equipo de desarrollo, sobre el
/// texto fijo de los casos. En ejecución solo se reproduce un archivo del
/// propio paquete.
///
/// APAGADA POR DEFECTO
/// -------------------
/// El uso previsto es un aula con treinta teléfonos sobre la mesa. Una
/// voz que arranca sola en todos a la vez no es una mejora. Se enciende
/// desde el botón de la cabecera y la elección se recuerda.
class VozMascota {
  VozMascota._();

  static final VozMascota instance = VozMascota._();

  static const _clave = 'voz_mascota_activa';
  static const _manifiesto = 'assets/voz/voces.json';

  /// Si el estudiante quiere oírla. Se recuerda entre sesiones.
  final ValueNotifier<bool> activa = ValueNotifier(false);

  /// Si hay con qué hablar: clips, motor de síntesis, o ambos. Mientras
  /// sea false no se ofrece el botón.
  final ValueNotifier<bool> disponible = ValueNotifier(false);

  final AudioPlayer _reproductor = AudioPlayer();

  /// Las claves que tienen clip. Vacío significa que se hablará siempre
  /// por síntesis.
  Set<String> _clips = const {};

  FlutterTts? _motor;
  bool _preparando = false;

  /// Deja la voz lista. Es seguro llamarla varias veces.
  Future<void> preparar() async {
    if (_preparando || disponible.value) return;
    _preparando = true;
    try {
      await _cargarClips();
      await _prepararSintesis();

      disponible.value = _clips.isNotEmpty || _motor != null;
      if (disponible.value) {
        final prefs = await SharedPreferences.getInstance();
        activa.value = prefs.getBool(_clave) ?? false;
      }
    } finally {
      _preparando = false;
    }
  }

  Future<void> _cargarClips() async {
    try {
      final crudo = await rootBundle.loadString(_manifiesto);
      final datos = jsonDecode(crudo) as Map<String, dynamic>;
      final claves = (datos['claves'] as List?) ?? const [];
      _clips = claves.map((e) => e.toString()).toSet();
      await _reproductor.setReleaseMode(ReleaseMode.stop);
    } catch (_) {
      // Sin manifiesto no hay clips, y no pasa nada: queda la síntesis.
      _clips = const {};
    }
  }

  Future<void> _prepararSintesis() async {
    try {
      final motor = FlutterTts();
      final espanol = _primeraEnEspanol(await motor.getLanguages);
      if (espanol == null) return;

      await motor.setLanguage(espanol);
      // El ritmo por defecto de Android atropella las frases largas, y
      // aquí se leen explicaciones, no notificaciones.
      await motor.setSpeechRate(0.46);
      await motor.setPitch(1.12);
      await motor.setVolume(1.0);
      // Sin esperar al final: quien pulsa «sigue» no debe quedarse
      // bloqueado hasta que termine de sonar la frase anterior.
      await motor.awaitSpeakCompletion(false);
      _motor = motor;
    } catch (_) {
      // Un motor de síntesis ausente o roto no puede tumbar el escáner.
      _motor = null;
    }
  }

  /// La primera voz española de la lista, prefiriendo las de América.
  static String? _primeraEnEspanol(dynamic idiomas) {
    if (idiomas is! List) return null;
    final todos = idiomas.map((e) => e.toString()).toList();

    for (final preferida in ['es-US', 'es-MX', 'es-419', 'es-ES']) {
      for (final i in todos) {
        if (i.toLowerCase() == preferida.toLowerCase()) return i;
      }
    }
    for (final i in todos) {
      final b = i.toLowerCase();
      if (b == 'es' || b.startsWith('es-') || b.startsWith('es_')) return i;
    }
    return null;
  }

  Future<void> alternar() async {
    if (!disponible.value) return;
    activa.value = !activa.value;
    if (!activa.value) await callar();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clave, activa.value);
  }

  /// Dice [texto], reproduciendo el clip de [clave] si existe.
  ///
  /// Siempre corta lo anterior: al avanzar de paso la frase previa ya no
  /// viene a cuento, y dos voces superpuestas no se entienden.
  Future<void> decir(String texto, {String? clave}) async {
    if (!activa.value) return;
    await callar();

    if (clave != null && _clips.contains(clave)) {
      try {
        await _reproductor.play(AssetSource('voz/$clave.mp3'));
        return;
      } catch (_) {
        // El clip está en el manifiesto pero no se pudo reproducir; se
        // cae a la síntesis en lugar de quedarse en silencio.
      }
    }

    final motor = _motor;
    if (motor == null) return;
    final limpio = _legible(texto);
    if (limpio.isEmpty) return;
    try {
      await motor.speak(limpio);
    } catch (_) {}
  }

  Future<void> callar() async {
    try {
      await _reproductor.stop();
    } catch (_) {}
    try {
      await _motor?.stop();
    } catch (_) {}
  }

  /// Prepara el texto para que suene como una frase y no como una ficha.
  ///
  /// Dos arreglos concretos: la barra de «ISO/IEC» se lee como tal y
  /// suena a error, y las comillas angulares se pronuncian en algunos
  /// motores. Los números no se tocan: «27001» ya se lee bien en español.
  static String _legible(String texto) {
    return texto
        .replaceAll('ISO/IEC', 'ISO IEC')
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'[«»"]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}