import 'dart:math';
import 'difficulty_level.dart';
import 'guess_result.dart';

class GameModel {
  DifficultyLevel _difficulty = DifficultyLevel.easy;
  int? _secretNumber;
  int _attempts = 0;
  final List<int> _higherGuesses = [];
  final List<int> _lowerGuesses = [];
  final List<Map<String, dynamic>> _gameHistory = [];

  DifficultyLevel get difficulty => _difficulty;
  int? get secretNumber => _secretNumber;
  int get attempts => _attempts;
  int get remainingAttempts => _difficulty.maxAttempts - _attempts;
  List<int> get higherGuesses => _higherGuesses;
  List<int> get lowerGuesses => _lowerGuesses;
  List<Map<String, dynamic>> get gameHistory => _gameHistory;

  void setDifficulty(DifficultyLevel level) {
    _difficulty = level;
    _resetGame();
  }

  void _resetGame() {
    _secretNumber = Random().nextInt(_difficulty.maxNumber) + 1;
    _attempts = 0;
    _higherGuesses.clear();
    _lowerGuesses.clear();
  }

  GuessResult makeGuess(String input) {
    if (_attempts >= _difficulty.maxAttempts) {
      _gameHistory.add({
        'number': _secretNumber,
        'result': false,
        'attempts': _attempts,
        'difficulty': _difficulty.name,
      });
      return GuessResult.gameOver;
    }

    final number = int.tryParse(input);
    if (number == null || number < 1 || number > _difficulty.maxNumber) {
      return GuessResult.invalid;
    }

    _attempts++;

    if (number == _secretNumber) {
      _gameHistory.add({
        'number': number,
        'result': true,
        'attempts': _attempts,
        'difficulty': _difficulty.name,
      });
      return GuessResult.correct;
    } else if (number > _secretNumber!) {
      _higherGuesses.add(number);
      return GuessResult.tooHigh;
    } else {
      _lowerGuesses.add(number);
      return GuessResult.tooLow;
    }
  }

  void startNewGame() {
    _resetGame();
  }
}
