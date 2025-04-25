import 'package:flutter/material.dart';
import 'difficulty_level.dart';
import 'game_model.dart';
import 'guess_result.dart';

class GameProvider extends ChangeNotifier {
  final GameModel _gameModel = GameModel();
  final TextEditingController _guessController = TextEditingController();
  GuessResult? _lastResult;
  bool _showSecretNumber = false;

  GameProvider() {
    _gameModel.startNewGame();
  }

  GameModel get gameModel => _gameModel;
  TextEditingController get guessController => _guessController;
  GuessResult? get lastResult => _lastResult;
  bool get showSecretNumber => _showSecretNumber;

  void initGame() {
    _gameModel.resetSecretNumber();
    _lastResult = null;
    _guessController.clear();
    notifyListeners();
  }

  void setDifficulty(DifficultyLevel level) {
    _gameModel.setDifficulty(level);
    _lastResult = null;
    _guessController.clear();
    notifyListeners();
  }

  void toggleSecretNumberVisibility() {
    _showSecretNumber = !_showSecretNumber;
    notifyListeners();
  }

  void submitGuess() {
    if (_guessController.text.isEmpty) return;

    _lastResult = _gameModel.makeGuess(_guessController.text);
    _guessController.clear();
    notifyListeners();

    // Si adivinó el número o se acabaron los intentos, iniciar nuevo juego después de un delay
    if (_lastResult == GuessResult.correct ||
        _lastResult == GuessResult.gameOver) {
      Future.delayed(const Duration(seconds: 2), () {
        initGame();
      });
    }
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }
}
