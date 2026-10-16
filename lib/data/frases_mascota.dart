import 'dart:math';

/// Lo que dice ESO.
///
/// POR QUÉ ESTO ESTÁ EN UN ARCHIVO Y NO SUELTO EN LA PANTALLA
/// ----------------------------------------------------------
/// La voz de la mascota es lo único que hace que la app no parezca un
/// formulario, y conviene poder leerla toda junta para que suene a una
/// sola persona. Repartida entre widgets acaba siendo incoherente: aquí
/// cercana, allí seca.
///
/// DÓNDE ESTÁ EL LÍMITE DEL HUMOR
/// ------------------------------
/// Tres reglas, y las tres importan para la defensa:
///
///   1. La broma nunca va sobre el error del estudiante. «Casi» y «Nos
///      pasa a todos» acompañan; «¿En serio?» humilla, y quien se siente
///      ridículo cierra la app.
///   2. La broma nunca va sobre la norma. El día que la mascota se ríe
///      de la ISO 9001, la herramienta deja de ser una guía didáctica
///      seria, y eso lo nota un tribunal antes que nadie.
///   3. El humor va en el acompañamiento, nunca en el contenido. Las
///      explicaciones de los ejercicios siguen siendo exactas y secas.
///
/// POR QUÉ CADA LISTA TIENE TANTAS ENTRADAS
/// ----------------------------------------
/// Una lección son cuatro preguntas y el sílabo tiene treinta y siete.
/// Con tres frases por situación, el estudiante las habría visto todas
/// antes de terminar el primer mundo, y una frase graciosa repetida
/// quince veces molesta más que una frase neutra. Por eso hay entre ocho
/// y doce de cada cosa, y la elección evita repetir la anterior.
abstract final class FrasesMascota {
  static final Random _azar = Random();

  /// Última frase entregada de cada lista, para no repetirla dos veces
  /// seguidas. Sin esto, con ocho opciones la repetición inmediata sale
  /// una de cada ocho veces, y se nota muchísimo.
  static final Map<String, String> _ultima = {};

  static String _elegir(String clave, List<String> opciones) {
    if (opciones.length == 1) return opciones.first;
    String frase;
    do {
      frase = opciones[_azar.nextInt(opciones.length)];
    } while (frase == _ultima[clave]);
    _ultima[clave] = frase;
    return frase;
  }

  // ------------------------------------------------------------------
  // ANTES DE RESPONDER
  // ------------------------------------------------------------------

  /// Burbuja sobre la pregunta. Cambia según si es la primera, la última
  /// o una del medio: siempre el mismo texto es justo lo que hacía que
  /// la mascota pareciera un cartel y no un personaje.
  static String pregunta({
    required int numero,
    required int total,
    required bool esCompletar,
  }) {
    if (numero == 1) {
      return _elegir('primera', const [
        'Empezamos suave',
        'La primera, para calentar',
        'Vamos allá',
        'A ver qué tal andamos',
        'Sin prisa, que hay tiempo',
        'Esta la tienes',
        'Arrancamos',
      ]);
    }

    if (numero == total) {
      return _elegir('ultima', const [
        'La última y nos vamos',
        'Queda esta',
        'Última. Que no se diga',
        'Una más y cerramos',
        'Final de lección',
        'La de cierre',
      ]);
    }

    if (esCompletar) {
      return _elegir('completar', const [
        'Completa la frase',
        'Arma la frase',
        'Coloca las palabras donde van',
        'Faltan piezas',
        'A ver cómo queda',
        'Ordena esto',
      ]);
    }

    return _elegir('media', const [
      'A ver esta',
      'Lee con calma',
      'Esta tiene miga',
      'Piénsala antes de tocar',
      'Aquí hay que fijarse',
      'Sin prisa',
      'Una más',
      'Esta separa a los que leyeron',
    ]);
  }

  // ------------------------------------------------------------------
  // DESPUÉS DE RESPONDER
  // ------------------------------------------------------------------

  /// Veredicto al acertar.
  static String acierto() => _elegir('acierto', const [
        '¡Eso es!',
        'Exacto',
        'Clavada',
        'Así se hace',
        'Correcto',
        'Muy bien',
        'Justo esa',
        'Perfecto',
        'Sin dudarlo',
      ]);

  /// Veredicto al fallar.
  ///
  /// Ninguna de estas señala al estudiante. Acompañan y devuelven al
  /// intento, porque la pregunta se repite y hay que volver a ella con
  /// ganas, no con vergüenza.
  static String fallo() => _elegir('fallo', const [
        'Casi',
        'Por poco',
        'No era esa',
        'Esa confunde a todos',
        'Nos pasa a todos',
        'Casi, vuelve a mirarla',
        'No, pero vas bien',
        'Esta es de las traicioneras',
      ]);

  // ------------------------------------------------------------------
  // CIERRE
  // ------------------------------------------------------------------

  /// Título del resumen final, según cuántas se acertaron a la primera.
  static String resumen({required int aciertos, required int total}) {
    if (total > 0 && aciertos == total) {
      return _elegir('perfecto', const [
        '¡Lección perfecta!',
        'Pleno. Nada que objetar',
        'Las cuatro. Impecable',
        'Ni una fallada',
      ]);
    }
    if (total > 0 && aciertos >= total / 2) {
      return _elegir('buena', const [
        '¡Lección completada!',
        'Lección superada',
        'Buen trabajo',
        'Hecho',
      ]);
    }
    return _elegir('justa', const [
      'Lección completada',
      'Terminada. Repasar no está de más',
      'Hecho, aunque esta merece una segunda vuelta',
    ]);
  }
}