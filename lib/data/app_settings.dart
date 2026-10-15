import 'package:flutter/material.dart';

/// Dificultad del juego. Cada valor sabe su tamaño de tablero y su nombre,
/// así no repetimos "3, 4, 5" por toda la app.
enum Difficulty {
  easy(3, 'Fácil'),
  medium(4, 'Medio'),
  hard(5, 'Difícil');

  const Difficulty(this.size, this.label);

  /// Piezas por lado del tablero.
  final int size;

  /// Texto que se muestra al usuario.
  final String label;
}

/// Estilo visual de las piezas.
enum TileStyle {
  classic('Clásico'),
  colorful('Colorido'),
  minimal('Minimalista');

  const TileStyle(this.label);

  final String label;
}

/// Todas las preferencias del usuario juntas.
/// Es inmutable: para cambiar algo se crea una copia con copyWith.
class AppSettings {
  const AppSettings({
    this.difficulty = Difficulty.medium,
    this.themeMode = ThemeMode.system,
    this.tileStyle = TileStyle.classic,
    this.animationsEnabled = true,
  });

  final Difficulty difficulty;
  final ThemeMode themeMode;
  final TileStyle tileStyle;
  final bool animationsEnabled;

  /// Devuelve una copia cambiando solo los campos indicados.
  AppSettings copyWith({
    Difficulty? difficulty,
    ThemeMode? themeMode,
    TileStyle? tileStyle,
    bool? animationsEnabled,
  }) {
    return AppSettings(
      difficulty: difficulty ?? this.difficulty,
      themeMode: themeMode ?? this.themeMode,
      tileStyle: tileStyle ?? this.tileStyle,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }
}