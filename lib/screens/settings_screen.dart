import 'package:flutter/material.dart';
import '../data/app_settings.dart';
import '../data/settings_controller.dart';

/// Pantalla de Configuración. Cada cambio se aplica al instante
/// y se guarda en el almacenamiento local a través del controlador.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final SettingsController controller;

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'Automático',
        ThemeMode.light => 'Claro',
        ThemeMode.dark => 'Oscuro',
      };

  IconData _themeIcon(ThemeMode mode) => switch (mode) {
        ThemeMode.system => Icons.brightness_auto,
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
      };

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder redibuja la pantalla cada vez que el
    // controlador avisa de un cambio.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final settings = controller.settings;

        return Scaffold(
          appBar: AppBar(title: const Text('Configuración')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _SectionTitle('Dificultad'),
                  SegmentedButton<Difficulty>(
                    segments: [
                      for (final d in Difficulty.values)
                        ButtonSegment(value: d, label: Text(d.label)),
                    ],
                    selected: {settings.difficulty},
                    onSelectionChanged: (selection) => controller.update(
                      settings.copyWith(difficulty: selection.first),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tablero ${settings.difficulty.size}x${settings.difficulty.size}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const _SectionTitle('Tema'),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      for (final m in ThemeMode.values)
                        ButtonSegment(
                          value: m,
                          label: Text(_themeLabel(m)),
                          icon: Icon(_themeIcon(m)),
                        ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (selection) => controller.update(
                      settings.copyWith(themeMode: selection.first),
                    ),
                  ),
                  const _SectionTitle('Estilo de las piezas'),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final style in TileStyle.values)
                        ChoiceChip(
                          label: Text(style.label),
                          selected: settings.tileStyle == style,
                          onSelected: (_) => controller.update(
                            settings.copyWith(tileStyle: style),
                          ),
                        ),
                    ],
                  ),
                  const _SectionTitle('Otras opciones'),
                  SwitchListTile(
                    title: const Text('Animaciones'),
                    value: settings.animationsEnabled,
                    onChanged: (value) => controller.update(
                      settings.copyWith(animationsEnabled: value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Título de sección, solo se usa en este archivo.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}