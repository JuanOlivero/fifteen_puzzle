import 'dart:async';
import 'package:flutter/material.dart';
import '../logic/puzzle_logic.dart';
import '../widgets/puzzle_board.dart';

/// Pantalla de la partida. Guarda el estado que cambia mientras se juega:
/// el tablero, los movimientos y el tiempo. Por eso es un StatefulWidget.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.size = 4});

  /// Tamaño del tablero: 3 (fácil), 4 (medio) o 5 (difícil).
  final int size;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int> _tiles;
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    // Si no cancelamos el cronómetro al salir de la pantalla,
    // seguiría corriendo en segundo plano.
    _timer?.cancel();
    super.dispose();
  }

  /// Prepara una partida nueva: tablero mezclado y contadores en cero.
  void _startNewGame() {
    _timer?.cancel();
    setState(() {
      _tiles = PuzzleLogic.generateShuffled(widget.size);
      _moves = 0;
      _seconds = 0;
    });
  }

  /// Se ejecuta cuando el usuario toca una pieza.
  void _onTileTap(int index) {
    // La lógica decide si el movimiento es válido (null = no válido).
    final newTiles = PuzzleLogic.moveTile(_tiles, widget.size, index);
    if (newTiles == null) return;

    // El cronómetro arranca con el primer movimiento.
    if (_moves == 0) _startTimer();

    setState(() {
      _tiles = newTiles;
      _moves++;
    });

    if (PuzzleLogic.isSolved(_tiles)) _onWin();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _onWin() {
    _timer?.cancel();
    // Diálogo provisional: más adelante lo reemplazamos por la pantalla
    // de fin de partida completa.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('¡Ganaste!'),
        content: Text('Tiempo: ${_formatTime(_seconds)}\nMovimientos: $_moves'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text('Jugar otra vez'),
          ),
        ],
      ),
    );
  }

  /// Convierte segundos a formato mm:ss (ej. 75 -> "01:15").
  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('15-Puzzle')),
      body: SafeArea(
        child: Center(
          // SingleChildScrollView permite hacer scroll si el contenido no
          // cabe (ventanas bajas). Si cabe, Center lo deja centrado.
          child: SingleChildScrollView(
            child: ConstrainedBox(
              // Limita el ancho para que en escritorio no sea gigante.
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                            label: 'Tiempo', value: _formatTime(_seconds)),
                        _StatCard(label: 'Movimientos', value: '$_moves'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PuzzleBoard(
                      tiles: _tiles,
                      size: widget.size,
                      onTileTap: _onTileTap,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _startNewGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reiniciar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/// Tarjeta pequeña para mostrar un dato (tiempo o movimientos).
/// No tiene estado, solo recibe y muestra.
class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(label, style: textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(value, style: textTheme.headlineMedium),
      ],
    );
  }
}