import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/game_screen.dart';

/// Widget raíz de la aplicación.
/// Aquí se configura el tema y la pantalla inicial.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '15-Puzzle Flutter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // "system" significa automático: sigue el tema del dispositivo.
      // Más adelante lo controlará la pantalla de Configuración.
      themeMode: ThemeMode.system,
      home: const GameScreen(size: 4),
    );
  }
}