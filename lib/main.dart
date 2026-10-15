import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/scores_repository.dart';
import 'data/settings_controller.dart';
import 'data/settings_repository.dart';

Future<void> main() async {
  // Necesario antes de usar plugins (como shared_preferences)
  // cuando main() es asíncrono.
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final controller = SettingsController(SettingsRepository(prefs));
  final scores = ScoresRepository(prefs);

  runApp(App(controller: controller, scores: scores));
}