import 'package:flutter/material.dart';
import '../data/app_settings.dart';

/// Pantalla de instrucciones. No guarda estado: solo muestra texto,
/// por eso es StatelessWidget.
class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cómo jugar')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _InfoCard(
                  icon: Icons.flag,
                  title: 'Objetivo',
                  children: [
                    Text(
                      'Ordena las piezas en orden numérico utilizando el '
                      'espacio vacío para deslizar las piezas adyacentes.',
                    ),
                  ],
                ),
                const _InfoCard(
                  icon: Icons.touch_app,
                  title: 'Cómo se mueve',
                  children: [
                    Text(
                      'Toca una pieza que esté pegada al espacio vacío '
                      '(arriba, abajo, a la izquierda o a la derecha) y se '
                      'deslizará hasta ocuparlo. Las piezas en diagonal o '
                      'lejos del hueco no se mueven.',
                    ),
                  ],
                ),
                const _InfoCard(
                  icon: Icons.emoji_events,
                  title: 'Cómo se gana',
                  children: [
                    Text(
                      'Ganas cuando todas las piezas quedan en orden, de '
                      'izquierda a derecha y de arriba hacia abajo, con el '
                      'espacio vacío al final.',
                    ),
                  ],
                ),
                _InfoCard(
                  icon: Icons.sentiment_dissatisfied,
                  title: 'Cómo se pierde',
                  children: [
                    const Text(
                      'Cada dificultad tiene un número máximo de movimientos. '
                      'Si lo agotas antes de ordenar el tablero, pierdes la '
                      'partida.',
                    ),
                    const SizedBox(height: 8),
                    for (final d in Difficulty.values)
                      Text(
                        '${d.label} (${d.size}x${d.size}): '
                        '${d.maxMoves} movimientos',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                const _InfoCard(
                  icon: Icons.timer,
                  title: 'Tiempo y récords',
                  children: [
                    Text(
                      'El cronómetro empieza con tu primer movimiento. Al '
                      'ganar, se guardan en Marcadores tu mejor tiempo y tu '
                      'menor número de movimientos de cada dificultad.',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.home),
                  label: const Text('Volver al menú'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta con icono, título y contenido. Solo se usa en este archivo.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}