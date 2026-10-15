import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../data/settings_controller.dart';
import '../data/scores_repository.dart';
import 'menu_screen.dart';

/// Pantalla de carga: muestra el título con una animación de entrada
/// y pasa sola al menú a los 3 segundos, o antes si se pulsa "Saltar".
/// Es StatefulWidget porque maneja un temporizador.
class SplashScreen extends StatefulWidget {
 const SplashScreen({
    super.key,
    required this.controller,
    required this.scores,
  });

  final SettingsController controller;
  final ScoresRepository scores;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  // Evita navegar dos veces (por ejemplo, pulsar "Saltar" justo
  // cuando el temporizador termina).
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _goToMenu);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToMenu() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _timer?.cancel();

    // pushReplacement reemplaza el splash por el menú, así el botón
    // "atrás" no puede volver a la pantalla de carga.
        Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MenuScreen(
          controller: widget.controller,
          scores: widget.scores,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final animated = widget.controller.settings.animationsEnabled;

    final logo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.grid_view_rounded, size: 96, color: scheme.primary),
        const SizedBox(height: 16),
        Text(
          '15-Puzzle Flutter',
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              // Entrada: aparece con fundido y crece desde pequeño.
              // Si el usuario desactivó las animaciones, se muestra directo.
              child: animated
                  ? FadeIn(
                      duration: const Duration(milliseconds: 900),
                      child: ZoomIn(
                        duration: const Duration(milliseconds: 900),
                        child: logo,
                      ),
                    )
                  : logo,
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: TextButton(
                onPressed: _goToMenu,
                child: const Text('Saltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}