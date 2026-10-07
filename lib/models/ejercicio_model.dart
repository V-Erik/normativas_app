/// Tipos de ejercicios soportados
enum TipoEjercicio {
  multipleChoice,
  completarTexto,
  verdaderoFalso,
  emparejar,
  ordenarSecuencia,
}

/// Modelo de un ejercicio individual
class Ejercicio {
  final String id;
  final TipoEjercicio tipo;
  final String pregunta;
  final List<String> opciones; // para multiple_choice, emparejar, ordenar
  final String respuestaCorrecta; // para multiple_choice, true/false, completar
  final List<String> respuestasCorrectas; // para múltiples correctas
  final Map<String, String>? emparejamientos; // para emparejar
  final List<String> explicacion; // puntos clave de explicación
  final String pista;
  final int xpPorRespuesta;

  Ejercicio({
    required this.id,
    required this.tipo,
    required this.pregunta,
    this.opciones = const [],
    this.respuestaCorrecta = '',
    this.respuestasCorrectas = const [],
    this.emparejamientos,
    this.explicacion = const [],
    this.pista = '',
    this.xpPorRespuesta = 5,
  });

  /// Valida si la respuesta del estudiante es correcta.
  bool validarRespuesta(String respuestaUsuario) {
    switch (tipo) {
      case TipoEjercicio.multipleChoice:
        return _normalizar(respuestaUsuario) == _normalizar(respuestaCorrecta);

      case TipoEjercicio.completarTexto:
        return _fuzzyMatch(respuestaUsuario, respuestaCorrecta);

      case TipoEjercicio.verdaderoFalso:
        return respuestaUsuario.trim().toLowerCase() ==
            respuestaCorrecta.trim().toLowerCase();

      case TipoEjercicio.emparejar:
      case TipoEjercicio.ordenarSecuencia:
        // Validaciones más complejas, se manejan en pantalla
        return false;
    }
  }

  // ==================================================================
  // MÉTODOS AUXILIARES
  // Van dentro de la clase, pero FUERA de validarRespuesta.
  // Dart no permite 'static' en funciones anidadas.
  // ==================================================================

  /// Comparación tolerante a erratas, para completar texto.
  static bool _fuzzyMatch(String input, String expected) {
    final inputClean = _normalizar(input);
    final expectedClean = _normalizar(expected);

    if (inputClean.isEmpty) return false;

    // Coincidencia exacta
    if (inputClean == expectedClean) return true;

    // Tolerancia proporcional al largo de la respuesta esperada.
    // Respuestas cortas admiten 1 error; las largas, hasta 2.
    final tolerancia = expectedClean.length <= 8 ? 1 : 2;
    return _levenshteinDistance(inputClean, expectedClean) <= tolerancia;
  }

  /// Quita tildes, puntuación y espacios sobrantes antes de comparar.
  static String _normalizar(String texto) {
    const conTilde = 'áéíóúàèìòùäëïöüâêîôûñ';
    const sinTilde = 'aeiouaeiouaeiouaeioun';

    var t = texto.toLowerCase().trim();
    for (var i = 0; i < conTilde.length; i++) {
      t = t.replaceAll(conTilde[i], sinTilde[i]);
    }
    t = t.replaceAll(RegExp(r'[.,;:!¡?¿]'), '');
    t = t.replaceAll(RegExp(r'\s+'), ' ');
    return t.trim();
  }

  /// Distancia de Levenshtein entre dos cadenas.
  static int _levenshteinDistance(String s1, String s2) {
    final d = List.generate(
      s1.length + 1,
      (_) => List.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      d[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        final borrar = d[i - 1][j] + 1;
        final insertar = d[i][j - 1] + 1;
        final sustituir = d[i - 1][j - 1] + cost;
        d[i][j] = [borrar, insertar, sustituir].reduce((a, b) => a < b ? a : b);
      }
    }

    return d[s1.length][s2.length];
  }
}

/// Resultado de una respuesta
class ResultadoEjercicio {
  final bool esCorrecta;
  final int xpGanados;
  final String feedback;
  final List<String> explicacion;

  ResultadoEjercicio({
    required this.esCorrecta,
    required this.xpGanados,
    required this.feedback,
    required this.explicacion,
  });
}