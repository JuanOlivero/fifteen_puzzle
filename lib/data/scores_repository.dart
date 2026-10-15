import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings.dart';

/// Mejor resultado de una dificultad.
class ScoreRecord {
  const ScoreRecord({
    required this.bestSeconds,
    required this.bestMoves,
    required this.date,
  });

  /// Mejor tiempo, en segundos.
  final int bestSeconds;

  /// Menor número de movimientos.
  final int bestMoves;

  /// Fecha en que se estableció el último récord.
  final DateTime date;
}

/// Guarda y lee los marcadores en el almacenamiento local.
/// Un marcador por dificultad: mejor tiempo, menos movimientos y fecha.
class ScoresRepository {
  ScoresRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _fields = ['seconds', 'moves', 'date'];

  String _key(Difficulty d, String field) => 'score_${d.name}_$field';

  /// Devuelve el marcador de una dificultad, o null si no hay partidas.
  ScoreRecord? load(Difficulty difficulty) {
    final seconds = _prefs.getInt(_key(difficulty, 'seconds'));
    final moves = _prefs.getInt(_key(difficulty, 'moves'));
    final dateText = _prefs.getString(_key(difficulty, 'date'));
    if (seconds == null || moves == null || dateText == null) return null;

    final date = DateTime.tryParse(dateText);
    if (date == null) return null;

    return ScoreRecord(bestSeconds: seconds, bestMoves: moves, date: date);
  }

  /// Registra una victoria. Devuelve true si mejoró el tiempo o los
  /// movimientos (es decir, si es un nuevo récord).
  Future<bool> submit(
    Difficulty difficulty, {
    required int seconds,
    required int moves,
  }) async {
    final current = load(difficulty);
    final betterTime = current == null || seconds < current.bestSeconds;
    final betterMoves = current == null || moves < current.bestMoves;

    if (!betterTime && !betterMoves) return false;

    // Cada marca se actualiza por separado: si solo mejoraste el tiempo,
    // los movimientos anteriores se conservan.
    final newSeconds = betterTime ? seconds : current!.bestSeconds;
    final newMoves = betterMoves ? moves : current!.bestMoves;

    await _prefs.setInt(_key(difficulty, 'seconds'), newSeconds);
    await _prefs.setInt(_key(difficulty, 'moves'), newMoves);
    await _prefs.setString(
      _key(difficulty, 'date'),
      DateTime.now().toIso8601String(),
    );
    return true;
  }

  /// Borra todos los marcadores de todas las dificultades.
  Future<void> clearAll() async {
    for (final d in Difficulty.values) {
      for (final field in _fields) {
        await _prefs.remove(_key(d, field));
      }
    }
  }
}