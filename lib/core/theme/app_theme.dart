import 'package:flutter/material.dart';

/// Define los temas claro y oscuro de la app en un solo lugar.
/// Así, si queremos cambiar los colores, solo tocamos este archivo.
class AppTheme {
  // Color base: Flutter genera toda la paleta a partir de él.
  static const Color _seed = Color(0xFF6C5CE7);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      );
}