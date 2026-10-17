import 'package:flutter/material.dart';
import '../data/app_settings.dart';
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
    this.style = TileStyle.classic,
  });

  /// Estado actual del tablero, ej. [1, 2, 3, 4, 5, 6, 7, 8, 0].
  final List<int> tiles;

  /// Cuántas piezas hay por lado (3, 4 o 5).
  final int size;

  /// Se llama con el índice de la pieza tocada.
  final void Function(int index) onTileTap;

  /// Estilo visual de las piezas.
  final TileStyle style;

  /// Crea la pieza con los colores que corresponden al estilo elegido.
  Widget _buildTile(BuildContext context, int number, int index) {
    final scheme = Theme.of(context).colorScheme;
    void onTap() => onTileTap(index);

    switch (style) {
      case TileStyle.classic:
        return PuzzleTile(number: number, color: scheme.primary, onTap: onTap);

      case TileStyle.colorful:
        // Cada número recibe un tono distinto del arcoíris, así las
        // piezas vecinas en orden tienen colores parecidos.
        final totalPieces = tiles.length - 1;
        final hue = (number - 1) / totalPieces * 300;
        final color = HSLColor.fromAHSL(1, hue, 0.65, 0.55).toColor();
        return PuzzleTile(number: number, color: color, onTap: onTap);

      case TileStyle.minimal:
        // Piezas planas, sin relleno de color y con borde fino.
        return PuzzleTile(
          number: number,
          color: scheme.surface,
          textColor: scheme.onSurface,
          borderColor: scheme.outline,
          elevation: 0,
          onTap: onTap,
        );
    }
  }

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

            return _buildTile(context, number, index);
          },
        ),
      ),
    );
  }
}