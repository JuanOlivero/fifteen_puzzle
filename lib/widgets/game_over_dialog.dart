import 'package:flutter/material.dart';
import '../data/app_settings.dart';

/// Opciones que puede elegir el usuario al terminar la partida.
enum GameOverAction { restart, exit }

/// Cuadro que se muestra al ganar o perder. No sabe nada de las reglas:
/// solo recibe el resultado y lo muestra.
class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.won,
    required this.timeText,
    required this.moves,
    required this.difficulty,
    this.isNewRecord = false,
  });

  final bool won;
  final String timeText;
  final int moves;
  final Difficulty difficulty;
  final bool isNewRecord;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(
        won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
        size: 56,
        color: won ? scheme.primary : scheme.error,
      ),
      title: Text(won ? '¡Ganaste!' : 'Perdiste', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNewRecord) ...[
            Text(
              '¡Nuevo récord!',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],
          if (!won) ...[
            const Text('Te quedaste sin movimientos.'),
            const SizedBox(height: 12),
          ],
          _SummaryRow(label: 'Tiempo', value: timeText),
          _SummaryRow(label: 'Movimientos', value: '$moves'),
          _SummaryRow(label: 'Dificultad', value: difficulty.label),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(GameOverAction.exit),
          child: const Text('Salir al menú'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(GameOverAction.restart),
          child: const Text('Reiniciar'),
        ),
      ],
    );
  }
}

/// Una fila "etiqueta ... valor" del resumen. Solo se usa en este archivo.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}