import 'package:flutter/foundation.dart';
import '../models/SeccionSilabo.dart';
import '../data/mock_data_silabo.dart';

/// Servicio de progreso del estudiante.
///
/// Mantiene UNA sola lista de mundos para toda la aplicación. Antes cada
/// pantalla pedía su propia copia a MockDataSilabo, así que el desbloqueo
/// se aplicaba sobre objetos que nadie estaba mostrando y los candados
/// nunca se abrían.
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

  // ========== COMPLETAR LECCIÓN ==========

  /// Marca una lección como completada y abre lo que corresponda.
  /// El parámetro [mundos] se ignora: siempre se trabaja sobre la lista
  /// única. Se conserva para no romper las llamadas existentes.
  bool completarLeccion(
    String leccionId,
    int experienciaGanada, [
    List<SeccionSilabo>? mundos,
  ]) {
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
    return true;
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

    estadisticas.streakDias =
        fueAyer ? estadisticas.streakDias + 1 : 1;
    estadisticas.ultimoDiaActivo = hoy;
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
    final completadas = capitulo.lecciones
        .where((l) => _estadoProgreso[l.id] ?? false)
        .length;
    return completadas / capitulo.lecciones.length;
  }

  /// Avance del mundo medido en lecciones, no en capítulos.
  /// Así la barra se mueve con cada lección y no solo al cerrar capítulo.
  double obtenerProgresoMundo(SeccionSilabo mundo) {
    final total = mundo.capitulos
        .fold<int>(0, (suma, c) => suma + c.lecciones.length);
    if (total == 0) return 0.0;

    final completadas = mundo.capitulos.fold<int>(
      0,
      (suma, c) =>
          suma +
          c.lecciones.where((l) => _estadoProgreso[l.id] ?? false).length,
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
          suma +
          c.lecciones.where((l) => _estadoProgreso[l.id] ?? false).length,
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
      'lecciones_completadas':
          _estadoProgreso.values.where((v) => v).length,
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
    buf.writeln(
        'Avance general: ${(resumen['avance_general'] as double).toStringAsFixed(1)} %');
    buf.writeln(
        'Capítulos: ${resumen['capitulos_completados']}/${resumen['capitulos_totales']}');
    buf.writeln(
        'Lecciones: ${resumen['lecciones_completadas']}/${resumen['lecciones_totales']}');
    buf.writeln(
        'Mundos: ${resumen['mundos_completados']}/${resumen['mundos_totales']}');
    buf.writeln('');
    buf.writeln('DESGLOSE POR MUNDO');

    for (final mundo in mundos) {
      final estado =
          estaMundoCompletado(mundo) ? 'COMPLETO' : 'EN PROGRESO';
      buf.writeln('');
      buf.writeln('${mundo.numeroMundo}. ${mundo.nombre} - $estado');
      buf.writeln(
          '   Capítulos: ${contarCapitulosCompletados(mundo)}/${mundo.capitulos.length}');
      buf.writeln(
          '   Lecciones: ${contarLeccionesCompletadas(mundo)}/${contarLeccionesTotales(mundo)}');
      buf.writeln(
          '   Progreso: ${(obtenerProgresoMundo(mundo) * 100).toStringAsFixed(1)} %');
    }

    return buf.toString();
  }

  // ========== RESET ==========

  void resetearProgreso() {
    _experienciaTotal = 0;
    estadisticas = EstadisticasJugador();
    if (_mundos != null) _prepararEstadoInicial(_mundos!);
    notifyListeners();
  }

  // ========== PERSISTENCIA ==========

  Map<String, dynamic> aJSON() => {
        'estado_progreso': _estadoProgreso,
        'experiencia_total': _experienciaTotal,
        'xp_total': estadisticas.xpTotal,
        'streak_dias': estadisticas.streakDias,
        'ultimo_dia_activo':
            estadisticas.ultimoDiaActivo.toIso8601String(),
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
    estadisticas.ultimoDiaActivo =
        DateTime.tryParse(json['ultimo_dia_activo'] ?? '') ?? DateTime.now();

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
  DateTime ultimoDiaActivo = DateTime(2000);

  int calcularBonusRacha() {
    if (streakDias >= 30) return 5;
    if (streakDias >= 7) return 2;
    if (streakDias >= 3) return 1;
    return 0;
  }
}