import 'package:flutter/material.dart';
import '../data/app_settings.dart';
import '../data/scores_repository.dart';

/// Pantalla de Marcadores: muestra el mejor resultado de cada dificultad.
/// Es StatefulWidget porque al borrar los marcadores hay que redibujarla.
class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key, required this.scores});

  final ScoresRepository scores;

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  /// ¿Hay al menos un marcador guardado en alguna dificultad?
  bool get _hasAny =>
      Difficulty.values.any((d) => widget.scores.load(d) != null);

  /// Pide confirmación y, si el usuario acepta, borra todos los marcadores.
  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrar marcadores'),
        content: const Text(
          'Se eliminarán los marcadores de todas las dificultades. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await widget.scores.clearAll();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasAny = _hasAny;

    return Scaffold(
      appBar: AppBar(title: const Text('Marcadores')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!hasAny) const _EmptyMessage(),
                if (hasAny)
                  for (final d in Difficulty.values)
                    _ScoreCard(
                      difficulty: d,
                      record: widget.scores.load(d),
                    ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: hasAny ? _confirmClear : null,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Borrar marcadores'),
                ),
                const SizedBox(height: 12),
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

/// Mensaje amigable cuando todavía no se ha ganado ninguna partida.
class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 72, color: scheme.outline),
          const SizedBox(height: 16),
          Text(
            'Aún no hay marcadores',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Gana una partida y tu mejor resultado aparecerá aquí.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Tarjeta con el mejor resultado de una dificultad.
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.difficulty, required this.record});

  final Difficulty difficulty;
  final ScoreRecord? record;

  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = difficulty.size;
    final r = record;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${difficulty.label} (${size}x$size)',
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (r == null)
              const Text('Sin partidas ganadas')
            else ...[
              _Row(label: 'Mejor tiempo', value: _formatTime(r.bestSeconds)),
              _Row(label: 'Menos movimientos', value: '${r.bestMoves}'),
              _Row(label: 'Fecha', value: _formatDate(r.date)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Fila "etiqueta ... valor". Solo se usa en este archivo.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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