import 'dart:math';

/// Lógica pura del rompecabezas. No importa nada de Flutter:
/// así se puede probar sin interfaz y la UI solo la "consume".
///
/// El tablero es una lista plana de enteros. El 0 representa el hueco.
/// Ejemplo 3x3 resuelto: [1, 2, 3, 4, 5, 6, 7, 8, 0]
class PuzzleLogic {
  /// Tablero ordenado: 1, 2, 3 ... (size*size - 1) y el hueco al final.
  static List<int> solvedBoard(int size) {
    return [...List.generate(size * size - 1, (i) => i + 1), 0];
  }

  /// ¿Está el tablero en su posición final?
  static bool isSolved(List<int> tiles) {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  /// Cuenta las inversiones: parejas de piezas donde una mayor
  /// aparece antes que una menor (ignorando el hueco).
  static int countInversions(List<int> tiles) {
    int inversions = 0;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] == 0) continue;
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[j] == 0) continue;
        if (tiles[i] > tiles[j]) inversions++;
      }
    }
    return inversions;
  }

  /// Validación matemática de resolubilidad (paridad de inversiones).
  /// - Ancho impar (3x3, 5x5): resoluble si las inversiones son pares.
  /// - Ancho par (4x4): resoluble si (inversiones + fila del hueco
  ///   contada desde abajo, empezando en 1) es impar.
  static bool isSolvable(List<int> tiles, int size) {
    final inversions = countInversions(tiles);
    if (size.isOdd) return inversions.isEven;

    final blankRowFromBottom = size - (tiles.indexOf(0) ~/ size);
    return (inversions + blankRowFromBottom).isOdd;
  }

  /// Genera un tablero desordenado, garantizado resoluble
  /// y que no esté ya resuelto.
  static List<int> generateShuffled(int size, {Random? random}) {
    final rng = random ?? Random();
    final tiles = solvedBoard(size);

    do {
      tiles.shuffle(rng);
      if (!isSolvable(tiles, size)) {
        // Intercambiar dos piezas (no el hueco) cambia la paridad,
        // lo que convierte un tablero irresoluble en resoluble.
        final a = tiles.indexWhere((t) => t != 0);
        final b = tiles.indexWhere((t) => t != 0, a + 1);
        final tmp = tiles[a];
        tiles[a] = tiles[b];
        tiles[b] = tmp;
      }
    } while (isSolved(tiles));

    return tiles;
  }

  /// ¿Puede moverse la pieza en [index]? Solo si es adyacente al hueco
  /// (misma fila y columnas contiguas, o misma columna y filas contiguas).
  static bool canMove(List<int> tiles, int size, int index) {
    final blank = tiles.indexOf(0);
    final rowDiff = (index ~/ size - blank ~/ size).abs();
    final colDiff = (index % size - blank % size).abs();
    return rowDiff + colDiff == 1;
  }

  /// Devuelve un tablero NUEVO con la pieza movida al hueco,
  /// o null si el movimiento no es válido.
  static List<int>? moveTile(List<int> tiles, int size, int index) {
    if (!canMove(tiles, size, index)) return null;
    final newTiles = List<int>.from(tiles);
    final blank = newTiles.indexOf(0);
    newTiles[blank] = newTiles[index];
    newTiles[index] = 0;
    return newTiles;
  }
}