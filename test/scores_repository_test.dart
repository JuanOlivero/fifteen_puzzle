import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fifteen_puzzle/data/app_settings.dart';
import 'package:fifteen_puzzle/data/scores_repository.dart';

void main() {
  late ScoresRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repo = ScoresRepository(await SharedPreferences.getInstance());
  });

  test('sin partidas guardadas no hay marcador', () {
    expect(repo.load(Difficulty.easy), isNull);
  });

  test('la primera victoria siempre es récord', () async {
    final isRecord =
        await repo.submit(Difficulty.easy, seconds: 60, moves: 40);

    expect(isRecord, isTrue);
    expect(repo.load(Difficulty.easy)!.bestSeconds, 60);
    expect(repo.load(Difficulty.easy)!.bestMoves, 40);
  });

  test('un resultado peor no reemplaza al mejor', () async {
    await repo.submit(Difficulty.easy, seconds: 60, moves: 40);
    final isRecord =
        await repo.submit(Difficulty.easy, seconds: 90, moves: 70);

    expect(isRecord, isFalse);
    expect(repo.load(Difficulty.easy)!.bestSeconds, 60);
    expect(repo.load(Difficulty.easy)!.bestMoves, 40);
  });

  test('mejorar solo el tiempo conserva los mejores movimientos', () async {
    await repo.submit(Difficulty.easy, seconds: 60, moves: 40);
    final isRecord =
        await repo.submit(Difficulty.easy, seconds: 45, moves: 70);

    expect(isRecord, isTrue);
    expect(repo.load(Difficulty.easy)!.bestSeconds, 45);
    expect(repo.load(Difficulty.easy)!.bestMoves, 40);
  });

  test('los marcadores son independientes por dificultad', () async {
    await repo.submit(Difficulty.easy, seconds: 60, moves: 40);

    expect(repo.load(Difficulty.medium), isNull);
    expect(repo.load(Difficulty.hard), isNull);
  });

  test('borrar todo elimina los marcadores', () async {
    await repo.submit(Difficulty.easy, seconds: 60, moves: 40);
    await repo.submit(Difficulty.hard, seconds: 300, moves: 200);

    await repo.clearAll();

    expect(repo.load(Difficulty.easy), isNull);
    expect(repo.load(Difficulty.hard), isNull);
  });
}