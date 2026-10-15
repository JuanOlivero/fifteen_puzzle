import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/settings_controller.dart';
import 'screens/game_screen.dart';

/// Widget raíz de la aplicación.
/// Escucha al controlador de preferencias: cuando cambian,
/// el tema y la pantalla inicial se actualizan solos.
class App extends StatelessWidget {
  const App({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder redibuja solo esta parte cuando el controlador
    // llama a notifyListeners().
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final settings = controller.settings;
        return MaterialApp(
          title: '15-Puzzle Flutter',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: GameScreen(size: settings.difficulty.size),
        );
      },
    );
  }
}