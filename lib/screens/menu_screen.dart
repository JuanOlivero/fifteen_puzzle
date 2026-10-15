import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../data/settings_controller.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

/// Menú principal: desde aquí se llega a todas las demás pantallas.
/// No guarda estado propio (lee del controlador), por eso es StatelessWidget.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.controller});

  final SettingsController controller;

  /// Abre otra pantalla encima de esta. El botón "atrás" del AppBar
  /// de la nueva pantalla aparece solo y regresa al menú.
  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  /// Aviso temporal para las pantallas que aún no están hechas.
  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Próximamente')),
    );
  }

  /// Aplica la animación de entrada solo si el usuario no la desactivó.
  Widget _animated({
    required bool enabled,
    required int index,
    required Widget child,
  }) {
    if (!enabled) return child;
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: el menú se actualiza solo cuando cambian los ajustes.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final settings = controller.settings;
        final size = settings.difficulty.size;
        final textTheme = Theme.of(context).textTheme;
        final scheme = Theme.of(context).colorScheme;

        final buttons = <_MenuButton>[
          _MenuButton(
            icon: Icons.play_arrow,
            label: 'Jugar',
            primary: true,
            onPressed: () => _open(
              context,
              GameScreen(size: controller.settings.difficulty.size),
            ),
          ),
          _MenuButton(
            icon: Icons.emoji_events,
            label: 'Marcadores',
            onPressed: () => _comingSoon(context),
          ),
          _MenuButton(
            icon: Icons.settings,
            label: 'Configuración',
            onPressed: () =>
                _open(context, SettingsScreen(controller: controller)),
          ),
          _MenuButton(
            icon: Icons.help_outline,
            label: 'Cómo jugar',
            onPressed: () => _comingSoon(context),
          ),
        ];

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.grid_view_rounded,
                            size: 72, color: scheme.primary),
                        const SizedBox(height: 12),
                        Text(
                          '15-Puzzle',
                          style: textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dificultad: ${settings.difficulty.label} (${size}x$size)',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 32),
                        for (int i = 0; i < buttons.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _animated(
                              enabled: settings.animationsEnabled,
                              index: i,
                              child: buttons[i],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Botón grande del menú. Solo se usa en este archivo.
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  /// El botón principal (Jugar) se destaca con el color fuerte.
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(60),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );

    return SizedBox(
      width: double.infinity,
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(label),
            )
          : FilledButton.tonalIcon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(label),
            ),
    );
  }
}