import 'dart:async';
import 'package:flutter/material.dart';
import '../data/app_settings.dart';
import '../data/scores_repository.dart';
import '../logic/puzzle_logic.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/puzzle_board.dart';

/// Pantalla de la partida. Guarda el estado que cambia mientras se juega:
/// el tablero, los movimientos y el tiempo. Por eso es un StatefulWidget.
class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.difficulty = Difficulty.medium,
    required this.scores,
    this.tileStyle = TileStyle.classic,
  });

  /// Dificultad elegida: define el tamaño del tablero y el límite de movimientos.
  final Difficulty difficulty;

  /// Donde se guardan los récords de las victorias.
  final ScoresRepository scores;
  // Estilo visual de las piezas, elegido en Configuración.
  final TileStyle tileStyle;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int> _tiles;
  int _moves = 0;
  int _seconds = 0;
  bool _finished = false;
  Timer? _timer;

  int get _size => widget.difficulty.size;
  int get _maxMoves => widget.difficulty.maxMoves;

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
      _tiles = PuzzleLogic.generateShuffled(_size);
      _moves = 0;
      _seconds = 0;
      _finished = false;
    });
  }

  /// Se ejecuta cuando el usuario toca una pieza.
  void _onTileTap(int index) {
    // Con la partida terminada, el tablero ya no responde.
    if (_finished) return;

    // La lógica decide si el movimiento es válido (null = no válido).
    final newTiles = PuzzleLogic.moveTile(_tiles, _size, index);
    if (newTiles == null) return;

    // El cronómetro arranca con el primer movimiento.
    if (_moves == 0) _startTimer();

    setState(() {
      _tiles = newTiles;
      _moves++;
    });

    if (PuzzleLogic.isSolved(_tiles)) {
      _finish(won: true);
    } else if (_moves >= _maxMoves) {
      _finish(won: false);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  /// Termina la partida: detiene el cronómetro, guarda el récord si gana,
  /// muestra el resultado y actúa según lo que elija el usuario.
  Future<void> _finish({required bool won}) async {
    _timer?.cancel();
    setState(() => _finished = true);

    // Solo las victorias cuentan para los marcadores.
    final isRecord = won
        ? await widget.scores.submit(
            widget.difficulty,
            seconds: _seconds,
            moves: _moves,
          )
        : false;
    if (!mounted) return;

    final action = await showDialog<GameOverAction>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameOverDialog(
        won: won,
        timeText: _formatTime(_seconds),
        moves: _moves,
        difficulty: widget.difficulty,
        isNewRecord: isRecord,
      ),
    );

    // Si el usuario salió de la pantalla mientras tanto, no hacemos nada.
    if (!mounted) return;

    if (action == GameOverAction.restart) {
      _startNewGame();
    } else {
      // Volver al menú principal.
      Navigator.of(context).pop();
    }
  }

  /// Convierte segundos a formato mm:ss (ej. 75 -> "01:15").
  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Aviso visual: los movimientos se ponen en rojo cuando quedan pocos.
    final almostOut = _maxMoves - _moves <= 10;

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
                          label: 'Tiempo',
                          value: _formatTime(_seconds),
                        ),
                        _StatCard(
                          label: 'Movimientos',
                          value: '$_moves / $_maxMoves',
                          color: almostOut ? scheme.error : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PuzzleBoard(
                     tiles: _tiles,
                      size: _size,
                      style: widget.tileStyle,
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
  const _StatCard({required this.label, required this.value, this.color});

  final String label;
  final String value;

  /// Color opcional para destacar el valor.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(label, style: textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}