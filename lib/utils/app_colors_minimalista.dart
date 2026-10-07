import 'package:flutter/material.dart';

/// Colores Minimalistas para Rediseño
class AppColorsMinimalista {
  // Backgrounds
  static const Color bgPrimario = Color(0xFFF8F9FA);
  static const Color bgSecundario = Color(0xFFFFFFFF);

  // Texto
  static const Color textPrimario = Color(0xFF1A1A1A);
  static const Color textSecundario = Color(0xFF666666);
  static const Color textGrey = Color(0xFF999999);
  static const Color textLight = Color(0xFFCCCCCC);

  // Bordes y separadores
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);

  // Mundos - Colores primarios
  static const Color mundo1 = Color(0xFF5B7DFF); // Azul
  static const Color mundo2 = Color(0xFF4DBE9B); // Verde
  static const Color mundo3 = Color(0xFFFF9E7C); // Naranja
  static const Color mundo4 = Color(0xFFFDD262); // Amarillo

  // Estados
  static const Color success = Color(0xFF2FBF71);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFA500);
  static const Color info = Color(0xFF3B82F6);

  // Especiales
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color shadowDark = Color.fromRGBO(0, 0, 0, 0.12);

  // Deshabilitado
  static const Color disabled = Color(0xFFF0F0F0);
  static const Color disabledText = Color(0xFFB0B0B0);
}

/// Estilos de sombra (Elevación minimalista)
class AppShadows {
  static BoxShadow small = BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow medium = BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static BoxShadow large = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  static List<BoxShadow> elevated = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

/// Radios de esquinas (Border Radius)
class AppRadii {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 999;
}

/// Espaciado (Padding, Margin)
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

/// Iconos por Mundo
class MundoIconos {
  static const String mundo1 = '🚀'; // Metodologías
  static const String mundo2 = '📋'; // Normativas
  static const String mundo3 = '🧪'; // Pruebas
  static const String mundo4 = '📊'; // Métricas

  static String obtener(int numeroMundo) {
    switch (numeroMundo) {
      case 1:
        return mundo1;
      case 2:
        return mundo2;
      case 3:
        return mundo3;
      case 4:
        return mundo4;
      default:
        return '📚';
    }
  }
}

/// Colores por Mundo
class MundoColores {
  static const Color mundo1 = AppColorsMinimalista.mundo1;
  static const Color mundo2 = AppColorsMinimalista.mundo2;
  static const Color mundo3 = AppColorsMinimalista.mundo3;
  static const Color mundo4 = AppColorsMinimalista.mundo4;

  static Color obtener(int numeroMundo) {
    switch (numeroMundo) {
      case 1:
        return mundo1;
      case 2:
        return mundo2;
      case 3:
        return mundo3;
      case 4:
        return mundo4;
      default:
        return Colors.grey;
    }
  }

  static Color obtenerSecundaria(int numeroMundo) {
    return obtener(numeroMundo).withOpacity(0.1);
  }
}

/// Tipografía (Estilos de texto)
class AppTypography {
  static const String fontFamily = 'Inter'; // o Poppins

  // Display
  static const TextStyle display32 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColorsMinimalista.textPrimario,
    height: 1.2,
  );

  static const TextStyle display28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColorsMinimalista.textPrimario,
    height: 1.2,
  );

  // Heading
  static const TextStyle heading24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColorsMinimalista.textPrimario,
    height: 1.3,
  );

  static const TextStyle heading20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColorsMinimalista.textPrimario,
    height: 1.3,
  );

  static const TextStyle heading18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColorsMinimalista.textPrimario,
    height: 1.3,
  );

  // Body
  static const TextStyle body16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColorsMinimalista.textPrimario,
    height: 1.5,
  );

  static const TextStyle body14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColorsMinimalista.textPrimario,
    height: 1.5,
  );

  static const TextStyle body12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsMinimalista.textSecundario,
    height: 1.4,
  );

  // Label
  static const TextStyle label16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColorsMinimalista.textPrimario,
  );

  static const TextStyle label14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColorsMinimalista.textPrimario,
  );

  static const TextStyle label12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColorsMinimalista.textPrimario,
  );

  // Caption
  static const TextStyle caption11 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColorsMinimalista.textGrey,
    height: 1.4,
  );

  static const TextStyle caption10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColorsMinimalista.textGrey,
    height: 1.3,
  );
}