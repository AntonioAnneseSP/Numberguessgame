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
  final List<GuessHistoryEntry> _guessHistory = [];

  DifficultyLevel get difficulty => _difficulty;
  int? get secretNumber => _secretNumber;
  int get attempts => _attempts;
  int get remainingAttempts => _difficulty.maxAttempts - _attempts;
  List<int> get higherGuesses => _higherGuesses;
  List<int> get lowerGuesses => _lowerGuesses;
  List<Map<String, dynamic>> get gameHistory => _gameHistory;
  List<GuessHistoryEntry> get guessHistory => _guessHistory;

  void setDifficulty(DifficultyLevel level) {
    _difficulty = level;
    _resetGame();
  }

  void _resetGame() {
    _secretNumber = Random().nextInt(_difficulty.maxNumber) + 1;
    _attempts = 0;
    _higherGuesses.clear();
    _lowerGuesses.clear();
    _guessHistory.clear();
  }

  void resetSecretNumber() {
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

    final result = _evaluateGuess(number);
    _guessHistory.add(GuessHistoryEntry(guess: number, result: result));

    if (result == GuessResult.correct) {
      _gameHistory.add({
        'number': number,
        'result': true,
        'attempts': _attempts,
        'difficulty': _difficulty.name,
      });
    }

    return result;
  }

  GuessResult _evaluateGuess(int number) {
    if (number == _secretNumber) {
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

class GuessHistoryEntry {
  final int guess;
  final GuessResult result;

  GuessHistoryEntry({
    required this.guess,
    required this.result,
  });
}
