import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/scores_repository.dart';
import 'data/settings_controller.dart';
import 'screens/splash_screen.dart';

/// Widget raíz de la aplicación.
/// Escucha al controlador de preferencias: cuando cambian,
/// el tema se actualiza solo.
class App extends StatelessWidget {
  const App({super.key, required this.controller, required this.scores});

  final SettingsController controller;
  final ScoresRepository scores;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return MaterialApp(
          title: '15-Puzzle Flutter',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: controller.settings.themeMode,
          home: SplashScreen(controller: controller, scores: scores),
        );
      },
    );
  }
}