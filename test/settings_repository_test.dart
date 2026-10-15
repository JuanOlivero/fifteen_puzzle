import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fifteen_puzzle/data/app_settings.dart';
import 'package:fifteen_puzzle/data/settings_repository.dart';

void main() {
  test('sin datos guardados devuelve los valores por defecto', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final settings = SettingsRepository(prefs).load();

    expect(settings.difficulty, Difficulty.medium);
    expect(settings.themeMode, ThemeMode.system);
    expect(settings.tileStyle, TileStyle.classic);
    expect(settings.animationsEnabled, isTrue);
  });

  test('lo que se guarda se recupera igual', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = SettingsRepository(prefs);

    await repo.save(const AppSettings(
      difficulty: Difficulty.hard,
      themeMode: ThemeMode.dark,
      tileStyle: TileStyle.colorful,
      animationsEnabled: false,
    ));
    final loaded = repo.load();

    expect(loaded.difficulty, Difficulty.hard);
    expect(loaded.themeMode, ThemeMode.dark);
    expect(loaded.tileStyle, TileStyle.colorful);
    expect(loaded.animationsEnabled, isFalse);
  });

  test('un valor dañado se reemplaza por el valor por defecto', () async {
    SharedPreferences.setMockInitialValues({
      'settings_difficulty': 'inexistente',
    });
    final prefs = await SharedPreferences.getInstance();

    final settings = SettingsRepository(prefs).load();

    expect(settings.difficulty, Difficulty.medium);
  });
}