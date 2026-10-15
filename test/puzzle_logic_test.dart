import 'package:flutter_test/flutter_test.dart';
import 'package:fifteen_puzzle/logic/puzzle_logic.dart';

void main() {
  test('el tablero resuelto se detecta como resuelto', () {
    expect(PuzzleLogic.isSolved(PuzzleLogic.solvedBoard(4)), isTrue);
  });

  test('un tablero con dos piezas intercambiadas no es resoluble (4x4)', () {
    final board = PuzzleLogic.solvedBoard(4);
    final tmp = board[0];
    board[0] = board[1];
    board[1] = tmp;
    expect(PuzzleLogic.isSolvable(board, 4), isFalse);
  });

  test('los tableros generados siempre son resolubles', () {
    for (final size in [3, 4, 5]) {
      for (int i = 0; i < 300; i++) {
        final board = PuzzleLogic.generateShuffled(size);
        expect(PuzzleLogic.isSolvable(board, size), isTrue);
        expect(PuzzleLogic.isSolved(board), isFalse);
      }
    }
  });

  test('solo se mueven piezas adyacentes al hueco', () {
    final board = PuzzleLogic.solvedBoard(3); // hueco en el índice 8
    expect(PuzzleLogic.canMove(board, 3, 7), isTrue); // izquierda del hueco
    expect(PuzzleLogic.canMove(board, 3, 5), isTrue); // arriba del hueco
    expect(PuzzleLogic.canMove(board, 3, 0), isFalse); // lejos
  });

  test('moveTile mueve la pieza y deja el hueco en su lugar anterior', () {
    final board = PuzzleLogic.solvedBoard(3);
    final moved = PuzzleLogic.moveTile(board, 3, 7)!;
    expect(moved[8], 8);
    expect(moved[7], 0);
  });
}