import 'package:flutter/material.dart';
import 'puzzle_tile.dart';

/// Dibuja el tablero completo como una cuadrícula de piezas.
/// Recibe la lista de números (el 0 es el hueco) y avisa con [onTileTap]
/// cuál posición tocó el usuario. Las reglas viven en PuzzleLogic.
class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    super.key,
    required this.tiles,
    required this.size,
    required this.onTileTap,
  });

  /// Estado actual del tablero, ej. [1, 2, 3, 4, 5, 6, 7, 8, 0].
  final List<int> tiles;

  /// Cuántas piezas hay por lado (3, 4 o 5).
  final int size;

  /// Se llama con el índice de la pieza tocada.
  final void Function(int index) onTileTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // AspectRatio(1) fuerza que el tablero sea siempre cuadrado,
    // sea cual sea el espacio disponible.
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GridView.builder(
          // El tablero no debe hacer scroll.
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final number = tiles[index];

            // El hueco no se dibuja: queda un espacio vacío.
            if (number == 0) return const SizedBox.shrink();

            return PuzzleTile(
              number: number,
              color: scheme.primary,
              onTap: () => onTileTap(index),
            );
          },
        ),
      ),
    );
  }
}