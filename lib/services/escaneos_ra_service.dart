import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/casos_ra.dart';
import 'auth_service.dart';
import 'progreso_service.dart';

/// Lo que el estudiante contestó en un marcador.
class RespuestaRA {
  /// Etiqueta de la norma que eligió **la primera vez**.
  final String eligio;

  /// true si esa primera elección era la correcta.
  final bool acerto;

  /// Cuántas veces ha abierto este marcador.
  final int veces;

  const RespuestaRA({
    required this.eligio,
    required this.acerto,
    required this.veces,
  });

  Map<String, dynamic> aJson() => {'n': eligio, 'ok': acerto, 'v': veces};

  factory RespuestaRA.deJson(Map<String, dynamic> j) => RespuestaRA(
        eligio: j['n'] as String? ?? '',
        acerto: j['ok'] as bool? ?? false,
        veces: j['v'] as int? ?? 1,
      );
}

/// Guarda qué contestó el estudiante en cada marcador de RA.
///
/// Tiene dos razones de ser, y la segunda es la importante.
///
/// La primera es evitar que el XP se repita: sin esto, dejar el teléfono
/// apuntando a una tarjeta sumaría puntos diez veces por segundo y la
/// gamificación dejaría de significar nada.
///
/// La segunda es que esto produce **datos**. Cada marcador es una pregunta
/// de opción múltiple con una respuesta correcta, así que al terminar las
/// pruebas con estudiantes se puede decir cuántos acertaron qué norma
/// correspondía a cada caso, a la primera. Eso es evidencia de aprendizaje
/// y es justo lo que se pide en el capítulo de resultados; sin guardarlo,
/// la realidad aumentada solo puede defenderse diciendo que se ve bien.
///
/// Se guarda en el dispositivo y separado por uid, igual que el progreso
/// de las lecciones, para que dos cuentas en el mismo teléfono no se
/// pisen.
class EscaneosRAService {
  EscaneosRAService._();
  static final EscaneosRAService instance = EscaneosRAService._();

  final Map<String, RespuestaRA> _respuestas = {};
  bool _cargado = false;
  String? _uidCargado;

  Map<String, RespuestaRA> get respuestas => Map.unmodifiable(_respuestas);

  int get cuantosRespondidos => _respuestas.length;
  int get cuantosAcertados => _respuestas.values.where((r) => r.acerto).length;
  int get cuantosHay => CasosRA.todos.length;

  String get _clave {
    final uid = AuthService.instance.uid ?? 'anonimo';
    return 'ra_registro_$uid';
  }

  /// Lee lo guardado. Se puede llamar varias veces; solo trabaja cuando
  /// hace falta (al arrancar o al cambiar de usuario).
  Future<void> cargar() async {
    final uid = AuthService.instance.uid ?? 'anonimo';
    if (_cargado && _uidCargado == uid) return;

    _respuestas.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      final crudo = prefs.getString(_clave);
      if (crudo != null && crudo.isNotEmpty) {
        final json = jsonDecode(crudo);
        if (json is Map) {
          json.forEach((k, v) {
            if (v is Map) {
              _respuestas[k.toString()] =
                  RespuestaRA.deJson(Map<String, dynamic>.from(v));
            }
          });
        }
      }
    } catch (e) {
      debugPrint('RA: no se pudo leer el registro -> $e');
    }
    _cargado = true;
    _uidCargado = uid;
  }

  bool yaRespondido(String idCaso) => _respuestas.containsKey(idCaso);

  RespuestaRA? respuestaDe(String idCaso) => _respuestas[idCaso];

  /// Registra que el estudiante contestó [caso] eligiendo [eligio].
  ///
  /// Devuelve true si era la primera vez, y solo entonces suma XP. Se da
  /// XP **aunque la respuesta sea incorrecta**: el objetivo es que se
  /// atreva a decidir, no que adivine. Lo que queda guardado para el
  /// análisis es si acertó, que es cosa distinta del premio.
  ///
  /// Si el servidor no responde, la respuesta igual queda guardada en el
  /// dispositivo.
  Future<bool> registrarRespuesta(
    CasoRA caso, {
    required String eligio,
    required bool acerto,
  }) async {
    await cargar();

    final previa = _respuestas[caso.id];
    if (previa != null) {
      // Ya había contestado: solo se cuenta que volvió a abrirlo. La
      // primera elección no se pisa, porque es la que vale como medida.
      _respuestas[caso.id] = RespuestaRA(
        eligio: previa.eligio,
        acerto: previa.acerto,
        veces: previa.veces + 1,
      );
      await _guardar();
      return false;
    }

    _respuestas[caso.id] =
        RespuestaRA(eligio: eligio, acerto: acerto, veces: 1);
    await _guardar();

    // El aviso de "+XP" tiene que salir en el momento. Con el modelo en
    // CPU el servidor puede tardar segundos, así que el reporte se lanza
    // y no se espera: `registrarEjercicio` gestiona sus propios errores.
    unawaited(
      ProgresoService.instance.registrarEjercicio(
        'ra-${caso.id}',
        correcto: acerto,
        leccionId: caso.leccionIdParaChat,
      ),
    );
    return true;
  }

  Future<void> _guardar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mapa = <String, dynamic>{};
      _respuestas.forEach((k, v) => mapa[k] = v.aJson());
      await prefs.setString(_clave, jsonEncode(mapa));
    } catch (e) {
      debugPrint('RA: no se pudo guardar el registro -> $e');
    }
  }

  /// Resumen en texto plano, para pegarlo en el capítulo de resultados o
  /// leerlo en voz alta durante la sustentación.
  String resumen() {
    if (_respuestas.isEmpty) {
      return 'Todavía no se ha respondido ningún marcador.';
    }
    final buf = StringBuffer()
      ..writeln('MARCADORES DE REALIDAD AUMENTADA')
      ..writeln('Respondidos: $cuantosRespondidos de $cuantosHay')
      ..writeln('Acertados a la primera: $cuantosAcertados')
      ..writeln('');

    for (final caso in CasosRA.todos) {
      final r = _respuestas[caso.id];
      if (r == null) {
        buf.writeln('·  ${caso.titulo}: sin responder');
      } else {
        buf.writeln('${r.acerto ? '✓' : '✗'}  ${caso.titulo}: '
            'eligió ${r.eligio} '
            '(correcta: ${caso.opcionCorrecta.etiqueta})');
      }
    }
    return buf.toString();
  }

  /// Para la sustentación: olvida las respuestas y así las tarjetas
  /// vuelven a plantear la pregunta en limpio delante del tribunal.
  Future<void> reiniciar() async {
    _respuestas.clear();
    await _guardar();
  }

  /// Al cerrar sesión. Lo guardado se queda (está separado por uid) y
  /// vuelve si ese usuario entra de nuevo.
  void limpiarMemoria() {
    _respuestas.clear();
    _cargado = false;
    _uidCargado = null;
  }
}
