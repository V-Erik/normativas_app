import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data_silabo.dart';
import '../models/SeccionSilabo.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'auth_service.dart';
import 'progreso_remoto_service.dart';

/// Servicio de progreso del estudiante.
///
/// Mantiene UNA sola lista de mundos para toda la aplicación. Antes cada
/// pantalla pedía su propia copia a MockDataSilabo, así que el desbloqueo
/// se aplicaba sobre objetos que nadie estaba mostrando y los candados
/// nunca se abrían.
///
/// REPARTO DE RESPONSABILIDADES CON EL BACKEND
/// -------------------------------------------
/// El backend (`/api/v1/progreso/*`) guarda **XP, racha, cuántas lecciones
/// y cuántos ejercicios**. No guarda *cuáles* lecciones, ni conoce el grafo
/// de desbloqueo de los 4 mundos. Así que:
///
///   - qué lección está completada y qué candado está abierto: aquí,
///     persistido en el dispositivo con SharedPreferences;
///   - XP y racha: el servidor es la fuente de verdad cuando responde, y
///     lo que hay aquí es el reflejo local para que la app funcione sin red.
///
/// Importante: el backend **no deduplica** completar la misma lección, así
/// que [completarLeccion] solo reporta cuando la lección no estaba hecha.
class ProgresoService extends ChangeNotifier {
  static final ProgresoService _instance = ProgresoService._();
  factory ProgresoService() => _instance;
  ProgresoService._();
  static ProgresoService get instance => _instance;

  late EstadisticasJugador estadisticas = EstadisticasJugador();

  /// Fuente única de verdad. Se construye una sola vez.
  List<SeccionSilabo>? _mundos;

  /// { idLeccion: completada }
  final Map<String, bool> _estadoProgreso = {};

  int _experienciaTotal = 0;

  /// true cuando el último intento de hablar con el servidor falló.
  /// Las pantallas pueden usarlo para mostrar "sin sincronizar".
  bool _sinSincronizar = false;
  bool get sinSincronizar => _sinSincronizar;

  // ========== GETTERS ==========

  Map<String, bool> get estadoProgreso => _estadoProgreso;
  int get experienciaTotal => _experienciaTotal;

  /// Avance general del sílabo, de 0.0 a 1.0.
  double get avanceGeneral {
    if (_estadoProgreso.isEmpty) return 0.0;
    final completadas = _estadoProgreso.values.where((v) => v).length;
    return completadas / _estadoProgreso.length;
  }

  /// El mismo avance expresado de 0 a 100.
  double get avanceGeneralPorcentaje => avanceGeneral * 100;

  // ========== LISTA ÚNICA DE MUNDOS ==========

  /// Devuelve siempre la misma lista. Todas las pantallas deben usar
  /// este método en lugar de MockDataSilabo.obtenerMundosSilabo().
  List<SeccionSilabo> obtenerMundos() {
    if (_mundos == null) {
      _mundos = MockDataSilabo.obtenerMundosSilabo();
      _prepararEstadoInicial(_mundos!);
    }
    return _mundos!;
  }

  /// Marca todas las lecciones como pendientes y aplica la política de
  /// desbloqueo: solo la primera lección del primer capítulo del mundo 1.
  void _prepararEstadoInicial(List<SeccionSilabo> mundos) {
    _estadoProgreso.clear();

    for (var i = 0; i < mundos.length; i++) {
      final mundo = mundos[i];
      for (var j = 0; j < mundo.capitulos.length; j++) {
        final capitulo = mundo.capitulos[j];
        for (var k = 0; k < capitulo.lecciones.length; k++) {
          final leccion = capitulo.lecciones[k];
          _estadoProgreso[leccion.id] = false;
          // Solo la primerísima lección arranca abierta.
          leccion.desbloqueada = (i == 0 && j == 0 && k == 0);
        }
      }
    }
  }

  /// Reinicia el estado sobre la lista actual.
  void inicializarDesdeWorldos(List<SeccionSilabo> mundos) {
    _mundos = mundos;
    _experienciaTotal = 0;
    estadisticas = EstadisticasJugador();
    _prepararEstadoInicial(mundos);
    notifyListeners();
  }

  // ========== ARRANQUE / SINCRONIZACIÓN ==========

  /// Llamar después del login. Hace dos cosas:
  ///   1. recupera del dispositivo qué lecciones estaban completadas;
  ///   2. pide al servidor el XP y la racha reales.
  ///
  /// Si el servidor no responde, la app sigue con lo local: el tutor
  /// necesita red, las lecciones no.
  Future<void> iniciarSesionEstudiante() async {
    obtenerMundos();
    await cargarDelDispositivo();
    await sincronizarConServidor();
  }

  /// Clave de SharedPreferences, separada por usuario para que dos cuentas
  /// en el mismo teléfono no se pisen el avance.
  String get _clavePrefs {
    final uid = AuthService.instance.uid ?? 'anonimo';
    return 'progreso_$uid';
  }

  Future<void> cargarDelDispositivo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final crudo = prefs.getString(_clavePrefs);
      if (crudo == null || crudo.isEmpty) return;

      final json = jsonDecode(crudo);
      if (json is Map<String, dynamic>) desdeJSON(json);
    } catch (e) {
      debugPrint('Progreso: no se pudo leer el avance guardado -> $e');
    }
  }

  Future<void> guardarEnDispositivo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_clavePrefs, jsonEncode(aJSON()));
    } catch (e) {
      debugPrint('Progreso: no se pudo guardar el avance -> $e');
    }
  }

  /// `GET /api/v1/progreso/mio`. Adopta el XP y la racha del servidor.
  ///
  /// Se queda con el mayor de los dos valores de XP: si el estudiante jugó
  /// sin red, lo local va por delante y no debe perderse; si cambió de
  /// teléfono, el servidor va por delante.
  Future<void> sincronizarConServidor() async {
    if (!AuthService.instance.autenticado) return;

    try {
      final remoto = await ProgresoRemotoService.mio(
        timeout: ApiConfig.timeoutArranque,
      );

      if (remoto.xpTotal > estadisticas.xpTotal) {
        estadisticas.xpTotal = remoto.xpTotal;
        _experienciaTotal = remoto.xpTotal;
      }
      if (remoto.rachaActual > estadisticas.streakDias) {
        estadisticas.streakDias = remoto.rachaActual;
      }
      estadisticas.rachaMejor = remoto.rachaMejor;

      _sinSincronizar = false;
      notifyListeners();
    } on ErrorApi catch (e) {
      _sinSincronizar = true;
      debugPrint('Progreso: no se pudo sincronizar -> ${e.mensaje}');
    } catch (e) {
      _sinSincronizar = true;
      debugPrint('Progreso: fallo al sincronizar -> $e');
    }
  }

  // ========== COMPLETAR LECCIÓN ==========

  /// Marca una lección como completada, abre lo que corresponda, lo guarda
  /// en el dispositivo y lo reporta al servidor.
  ///
  /// Devuelve false si la lección ya estaba completada, y en ese caso NO
  /// reporta nada: el backend sumaría XP por segunda vez.
  ///
  /// El tercer parámetro [mundos] se ignora: siempre se trabaja sobre la
  /// lista única. Se conserva para no romper las llamadas existentes.
  Future<bool> completarLeccion(
    String leccionId,
    int experienciaGanada, [
    List<SeccionSilabo>? mundos,
  ]) async {
    final lista = obtenerMundos();

    if (_estadoProgreso[leccionId] ?? false) {
      return false; // ya estaba completada
    }

    _estadoProgreso[leccionId] = true;
    _experienciaTotal += experienciaGanada;
    estadisticas.xpTotal += experienciaGanada;

    _actualizarRacha();
    _desbloquearProximosElementos(leccionId, lista);

    notifyListeners();

    await guardarEnDispositivo();
    await _reportarLeccion(leccionId);

    return true;
  }

  /// `POST /api/v1/progreso/lecciones/{id}/completar`. Suma +20 XP en el
  /// servidor y actualiza la racha. Se envía el id de la app tal cual:
  /// este endpoint acepta cualquier id.
  Future<void> _reportarLeccion(String leccionId) async {
    if (!AuthService.instance.autenticado) return;

    try {
      final remoto = await ProgresoRemotoService.completarLeccion(leccionId);
      // El servidor es la autoridad sobre XP y racha una vez que responde.
      estadisticas.xpTotal = remoto.xpTotal;
      estadisticas.streakDias = remoto.rachaActual;
      estadisticas.rachaMejor = remoto.rachaMejor;
      _sinSincronizar = false;
      notifyListeners();
    } on ErrorApi catch (e) {
      _sinSincronizar = true;
      debugPrint('Progreso: lección no reportada -> ${e.mensaje}');
    } catch (e) {
      _sinSincronizar = true;
      debugPrint('Progreso: fallo al reportar lección -> $e');
    }
  }

  /// `POST /api/v1/progreso/ejercicios/{id}/resolver`.
  /// +10 XP si es correcto, +2 si no. La llama `lesson_screen_v3`.
  ///
  /// No toca el desbloqueo: los ejercicios no abren lecciones, solo dan XP.
  Future<void> registrarEjercicio(
    String ejercicioId, {
    required bool correcto,
    String? leccionId,
  }) async {
    if (!AuthService.instance.autenticado) return;

    try {
      final remoto = await ProgresoRemotoService.resolverEjercicio(
        ejercicioId,
        correcto: correcto,
        leccionId: leccionId,
      );
      estadisticas.xpTotal = remoto.xpTotal;
      estadisticas.streakDias = remoto.rachaActual;
      estadisticas.rachaMejor = remoto.rachaMejor;
      _sinSincronizar = false;
      notifyListeners();
    } on ErrorApi catch (e) {
      _sinSincronizar = true;
      debugPrint('Progreso: ejercicio no reportado -> ${e.mensaje}');
    } catch (e) {
      _sinSincronizar = true;
      debugPrint('Progreso: fallo al reportar ejercicio -> $e');
    }
  }

  /// La racha sube una sola vez por día, no una vez por lección.
  void _actualizarRacha() {
    final hoy = DateTime.now();
    final ultimo = estadisticas.ultimoDiaActivo;

    final mismoDia = ultimo.year == hoy.year &&
        ultimo.month == hoy.month &&
        ultimo.day == hoy.day;

    if (mismoDia && estadisticas.streakDias > 0) {
      return; // ya contó hoy
    }

    final ayer = DateTime(hoy.year, hoy.month, hoy.day - 1);
    final fueAyer = ultimo.year == ayer.year &&
        ultimo.month == ayer.month &&
        ultimo.day == ayer.day;

    estadisticas.streakDias = fueAyer ? estadisticas.streakDias + 1 : 1;
    estadisticas.ultimoDiaActivo = hoy;

    if (estadisticas.streakDias > estadisticas.rachaMejor) {
      estadisticas.rachaMejor = estadisticas.streakDias;
    }
  }

  // ========== DESBLOQUEO ==========

  void _desbloquearProximosElementos(
    String leccionId,
    List<SeccionSilabo> mundos,
  ) {
    SeccionSilabo? mundoActual;
    CapituloSilabo? capituloActual;
    int indiceMundo = -1;
    int indiceCapitulo = -1;
    int indiceLeccion = -1;

    buscar:
    for (var i = 0; i < mundos.length; i++) {
      for (var j = 0; j < mundos[i].capitulos.length; j++) {
        final lecciones = mundos[i].capitulos[j].lecciones;
        for (var k = 0; k < lecciones.length; k++) {
          if (lecciones[k].id == leccionId) {
            mundoActual = mundos[i];
            capituloActual = mundos[i].capitulos[j];
            indiceMundo = i;
            indiceCapitulo = j;
            indiceLeccion = k;
            break buscar;
          }
        }
      }
    }

    if (mundoActual == null || capituloActual == null) return;

    // 1. ¿Queda otra lección en este capítulo?
    if (indiceLeccion + 1 < capituloActual.lecciones.length) {
      capituloActual.lecciones[indiceLeccion + 1].desbloqueada = true;
      return;
    }

    // 2. Capítulo terminado. ¿Hay otro capítulo en este mundo?
    if (indiceCapitulo + 1 < mundoActual.capitulos.length) {
      final siguienteCap = mundoActual.capitulos[indiceCapitulo + 1];
      if (siguienteCap.lecciones.isNotEmpty) {
        siguienteCap.lecciones.first.desbloqueada = true;
      }
      return;
    }

    // 3. Mundo terminado. Abrir el primer capítulo del siguiente mundo.
    if (indiceMundo + 1 < mundos.length) {
      final siguienteMundo = mundos[indiceMundo + 1];
      if (siguienteMundo.capitulos.isNotEmpty &&
          siguienteMundo.capitulos.first.lecciones.isNotEmpty) {
        siguienteMundo.capitulos.first.lecciones.first.desbloqueada = true;
      }
    }
  }

  // ========== CONSULTAS ==========

  double obtenerProgreso(CapituloSilabo capitulo) {
    if (capitulo.lecciones.isEmpty) return 0.0;
    final completadas =
        capitulo.lecciones.where((l) => _estadoProgreso[l.id] ?? false).length;
    return completadas / capitulo.lecciones.length;
  }

  /// Avance del mundo medido en lecciones, no en capítulos.
  /// Así la barra se mueve con cada lección y no solo al cerrar capítulo.
  double obtenerProgresoMundo(SeccionSilabo mundo) {
    final total =
        mundo.capitulos.fold<int>(0, (suma, c) => suma + c.lecciones.length);
    if (total == 0) return 0.0;

    final completadas = mundo.capitulos.fold<int>(
      0,
      (suma, c) =>
          suma + c.lecciones.where((l) => _estadoProgreso[l.id] ?? false).length,
    );
    return completadas / total;
  }

  bool estaCapituloCompletado(CapituloSilabo capitulo) =>
      capitulo.lecciones.isNotEmpty && obtenerProgreso(capitulo) == 1.0;

  bool estaMundoCompletado(SeccionSilabo mundo) =>
      obtenerProgresoMundo(mundo) == 1.0;

  bool estaLeccionCompletada(String leccionId) =>
      _estadoProgreso[leccionId] ?? false;

  bool estaLeccionDesbloqueada(LeccionSilabo leccion) => leccion.desbloqueada;

  /// Un capítulo está disponible si su primera lección ya se abrió.
  bool estaCapituloDesbloqueado(CapituloSilabo capitulo) {
    if (capitulo.lecciones.isEmpty) return false;
    return capitulo.lecciones.first.desbloqueada;
  }

  /// Un mundo está disponible si su primer capítulo ya se abrió.
  bool estaMundoDesbloqueado(SeccionSilabo mundo) {
    if (mundo.capitulos.isEmpty) return false;
    return estaCapituloDesbloqueado(mundo.capitulos.first);
  }

  /// Cuenta lecciones completadas dentro de un mundo.
  int contarLeccionesCompletadas(SeccionSilabo mundo) {
    return mundo.capitulos.fold<int>(
      0,
      (suma, c) =>
          suma + c.lecciones.where((l) => _estadoProgreso[l.id] ?? false).length,
    );
  }

  int contarLeccionesTotales(SeccionSilabo mundo) =>
      mundo.capitulos.fold<int>(0, (suma, c) => suma + c.lecciones.length);

  LeccionSilabo? obtenerProximaLeccion(CapituloSilabo capitulo) {
    for (final leccion in capitulo.lecciones) {
      if (!estaLeccionCompletada(leccion.id)) return leccion;
    }
    return null;
  }

  CapituloSilabo? obtenerProximoCapitulo(SeccionSilabo mundo) {
    for (final capitulo in mundo.capitulos) {
      if (!estaCapituloCompletado(capitulo)) return capitulo;
    }
    return null;
  }

  List<CapituloSilabo> obtenerCapitulosCompletados(SeccionSilabo mundo) =>
      mundo.capitulos.where(estaCapituloCompletado).toList();

  int contarCapitulosCompletados(SeccionSilabo mundo) =>
      obtenerCapitulosCompletados(mundo).length;

  // ========== MODO DEMOSTRACIÓN ==========

  /// Abre todas las lecciones sin marcarlas como completadas.
  /// Útil para mostrar cualquier parte de la app durante la sustentación
  /// sin tener que completar el sílabo entero en vivo.
  void desbloquearTodo() {
    for (final mundo in obtenerMundos()) {
      for (final capitulo in mundo.capitulos) {
        for (final leccion in capitulo.lecciones) {
          leccion.desbloqueada = true;
        }
      }
    }
    notifyListeners();
  }

  // ========== ESTADÍSTICAS ==========

  Map<String, dynamic> obtenerResumen([List<SeccionSilabo>? mundosParam]) {
    final mundos = mundosParam ?? obtenerMundos();
    final totalCapitulos =
        mundos.fold<int>(0, (suma, m) => suma + m.capitulos.length);
    final capitulosCompletados = mundos.fold<int>(
        0, (suma, m) => suma + contarCapitulosCompletados(m));

    return {
      'experiencia_total': _experienciaTotal,
      'avance_general': avanceGeneralPorcentaje,
      'capitulos_completados': capitulosCompletados,
      'capitulos_totales': totalCapitulos,
      'lecciones_completadas': _estadoProgreso.values.where((v) => v).length,
      'lecciones_totales': _estadoProgreso.length,
      'mundos_completados': mundos.where(estaMundoCompletado).length,
      'mundos_totales': mundos.length,
    };
  }

  String generarReporte([List<SeccionSilabo>? mundosParam]) {
    final mundos = mundosParam ?? obtenerMundos();
    final resumen = obtenerResumen(mundos);
    final buf = StringBuffer();

    buf.writeln('REPORTE DE PROGRESO');
    buf.writeln('');
    buf.writeln('Experiencia: ${resumen['experiencia_total']} XP');
    buf.writeln('Avance general: '
        '${(resumen['avance_general'] as double).toStringAsFixed(1)} %');
    buf.writeln('Capítulos: ${resumen['capitulos_completados']}'
        '/${resumen['capitulos_totales']}');
    buf.writeln('Lecciones: ${resumen['lecciones_completadas']}'
        '/${resumen['lecciones_totales']}');
    buf.writeln('Mundos: ${resumen['mundos_completados']}'
        '/${resumen['mundos_totales']}');
    buf.writeln('');
    buf.writeln('DESGLOSE POR MUNDO');

    for (final mundo in mundos) {
      final estado = estaMundoCompletado(mundo) ? 'COMPLETO' : 'EN PROGRESO';
      buf.writeln('');
      buf.writeln('${mundo.numeroMundo}. ${mundo.nombre} - $estado');
      buf.writeln('   Capítulos: ${contarCapitulosCompletados(mundo)}'
          '/${mundo.capitulos.length}');
      buf.writeln('   Lecciones: ${contarLeccionesCompletadas(mundo)}'
          '/${contarLeccionesTotales(mundo)}');
      buf.writeln('   Progreso: '
          '${(obtenerProgresoMundo(mundo) * 100).toStringAsFixed(1)} %');
    }

    return buf.toString();
  }

  // ========== RESET ==========

  /// Reinicia el avance local. No borra el XP del servidor: para eso está
  /// `POST /api/v1/perfil/{uid}/reiniciar`, que es otra cosa (el perfil
  /// adaptativo del tutor).
  Future<void> resetearProgreso() async {
    _experienciaTotal = 0;
    estadisticas = EstadisticasJugador();
    if (_mundos != null) _prepararEstadoInicial(_mundos!);
    notifyListeners();
    await guardarEnDispositivo();
  }

  /// Al cerrar sesión: limpia la memoria para que el siguiente usuario no
  /// vea el avance del anterior. Lo guardado en el dispositivo se queda
  /// (está separado por uid) y vuelve si ese usuario entra de nuevo.
  void limpiarMemoria() {
    _experienciaTotal = 0;
    estadisticas = EstadisticasJugador();
    _sinSincronizar = false;
    if (_mundos != null) _prepararEstadoInicial(_mundos!);
    notifyListeners();
  }

  // ========== PERSISTENCIA ==========

  Map<String, dynamic> aJSON() => {
        'estado_progreso': _estadoProgreso,
        'experiencia_total': _experienciaTotal,
        'xp_total': estadisticas.xpTotal,
        'streak_dias': estadisticas.streakDias,
        'racha_mejor': estadisticas.rachaMejor,
        'ultimo_dia_activo': estadisticas.ultimoDiaActivo.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      };

  void desdeJSON(Map<String, dynamic> json) {
    final mundos = obtenerMundos();

    _estadoProgreso.clear();
    _estadoProgreso
        .addAll(Map<String, bool>.from(json['estado_progreso'] ?? {}));

    _experienciaTotal = json['experiencia_total'] ?? 0;
    estadisticas.xpTotal = json['xp_total'] ?? _experienciaTotal;
    estadisticas.streakDias = json['streak_dias'] ?? 0;
    estadisticas.rachaMejor = json['racha_mejor'] ?? estadisticas.streakDias;
    estadisticas.ultimoDiaActivo =
        DateTime.tryParse(json['ultimo_dia_activo'] ?? '') ?? DateTime(2000);

    // Reconstruye los candados a partir de lo que ya está completado.
    _recalcularDesbloqueos(mundos);
    notifyListeners();
  }

  /// Vuelve a aplicar la regla de desbloqueo según las lecciones completadas.
  void _recalcularDesbloqueos(List<SeccionSilabo> mundos) {
    for (var i = 0; i < mundos.length; i++) {
      for (var j = 0; j < mundos[i].capitulos.length; j++) {
        final lecciones = mundos[i].capitulos[j].lecciones;
        for (var k = 0; k < lecciones.length; k++) {
          lecciones[k].desbloqueada = (i == 0 && j == 0 && k == 0);
        }
      }
    }

    for (final mundo in mundos) {
      for (final capitulo in mundo.capitulos) {
        for (final leccion in capitulo.lecciones) {
          if (_estadoProgreso[leccion.id] ?? false) {
            leccion.desbloqueada = true;
            _desbloquearProximosElementos(leccion.id, mundos);
          }
        }
      }
    }
  }

  // ========== ATAJOS ==========

  int obtenerXPTotal() => estadisticas.xpTotal;
  int obtenerRacha() => estadisticas.streakDias;
  int obtenerNivel() => (estadisticas.xpTotal / 100).floor() + 1;
}

class EstadisticasJugador {
  int xpTotal = 0;
  int streakDias = 0;
  int rachaMejor = 0;
  DateTime ultimoDiaActivo = DateTime(2000);

  int calcularBonusRacha() {
    if (streakDias >= 30) return 5;
    if (streakDias >= 7) return 2;
    if (streakDias >= 3) return 1;
    return 0;
  }
}
