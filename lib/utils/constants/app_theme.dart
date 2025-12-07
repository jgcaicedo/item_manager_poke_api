import 'package:flutter/material.dart';

/// Clase que define los temas visuales de la aplicación.
/// Incluye colores, tipografía, formas y animaciones personalizadas.
class AppTheme {
  // Paleta de colores principal
  static const Color primaryColor = Color(0xFF6366F1); // Indigo moderno
  static const Color secondaryColor = Color(0xFFEC4899); // Pink accent
  static const Color backgroundColor = Color(0xFFF8FAFC); // Gris muy claro
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFEF4444);

  // Colores para tipos de Pokémon
  static const Map<String, Color> typeColors = {
    'normal': Color(0xFFA8A878),
    'fighting': Color(0xFFC03028),
    'flying': Color(0xFFA890F0),
    'poison': Color(0xFFA040A0),
    'ground': Color(0xFFE0C068),
    'rock': Color(0xFFB8A038),
    'bug': Color(0xFFA8B820),
    'ghost': Color(0xFF705898),
    'steel': Color(0xFFB8B8D0),
    'fire': Color(0xFFF08030),
    'water': Color(0xFF6890F0),
    'grass': Color(0xFF78C850),
    'electric': Color(0xFFF8D030),
    'psychic': Color(0xFFF85888),
    'ice': Color(0xFF98D8D8),
    'dragon': Color(0xFF7038F8),
    'dark': Color(0xFF705848),
    'fairy': Color(0xFFEE99AC),
  };

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Esquema de colores
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),

    // Tipografía
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.black54,
        height: 1.4,
      ),
    ),

    // Componentes
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: Colors.black87,
      elevation: 0,
      shadowColor: Colors.black12,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),

    cardTheme: CardThemeData(
      color: surfaceColor,
      shadowColor: Colors.black12,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: Colors.black38,
      ),
    ),

    // Animaciones
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // Tema oscuro (opcional para futura implementación)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white70,
      onBackground: Colors.white70,
    ),
  );

  /// Obtiene el color correspondiente a un tipo de Pokémon
  static Color getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}