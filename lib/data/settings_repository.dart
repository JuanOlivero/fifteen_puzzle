import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings.dart';

/// Lee y escribe las preferencias en el almacenamiento local.
/// Es la única clase que conoce shared_preferences: el resto de la app
/// solo trabaja con AppSettings.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  // Claves con las que se guarda cada valor.
  static const _kDifficulty = 'settings_difficulty';
  static const _kThemeMode = 'settings_theme_mode';
  static const _kTileStyle = 'settings_tile_style';
  static const _kAnimations = 'settings_animations';

  /// Lee las preferencias guardadas. Si algo falta o está dañado,
  /// usa el valor por defecto en vez de fallar.
  AppSettings load() {
    const defaults = AppSettings();
    return AppSettings(
      difficulty: _readEnum(
        Difficulty.values,
        _prefs.getString(_kDifficulty),
        defaults.difficulty,
      ),
      themeMode: _readEnum(
        ThemeMode.values,
        _prefs.getString(_kThemeMode),
        defaults.themeMode,
      ),
      tileStyle: _readEnum(
        TileStyle.values,
        _prefs.getString(_kTileStyle),
        defaults.tileStyle,
      ),
      animationsEnabled:
          _prefs.getBool(_kAnimations) ?? defaults.animationsEnabled,
    );
  }

  /// Guarda todas las preferencias.
  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_kDifficulty, settings.difficulty.name);
    await _prefs.setString(_kThemeMode, settings.themeMode.name);
    await _prefs.setString(_kTileStyle, settings.tileStyle.name);
    await _prefs.setBool(_kAnimations, settings.animationsEnabled);
  }

  /// Convierte el texto guardado (ej. "hard") de vuelta a su enum.
  T _readEnum<T extends Enum>(List<T> values, String? name, T fallback) {
    return values.asNameMap()[name] ?? fallback;
  }
}