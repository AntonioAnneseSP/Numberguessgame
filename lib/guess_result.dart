import 'package:flutter/material.dart';

enum GuessResult {
  correct,
  tooHigh,
  tooLow,
  invalid,
  gameOver,
}

extension GuessResultExtension on GuessResult {
  String get message {
    switch (this) {
      case GuessResult.correct:
        return '¡Correcto! Has adivinado el número.';
      case GuessResult.tooHigh:
        return 'Demasiado alto. Intenta con un número más bajo.';
      case GuessResult.tooLow:
        return 'Demasiado bajo. Intenta con un número más alto.';
      case GuessResult.invalid:
        return 'Por favor ingresa un número válido dentro del rango.';
      case GuessResult.gameOver:
        return '¡Juego terminado! Has agotado todos tus intentos.';
    }
  }

  Color get color {
    switch (this) {
      case GuessResult.correct:
        return Colors.green;
      case GuessResult.tooHigh:
      case GuessResult.tooLow:
        return Colors.orange;
      case GuessResult.invalid:
      case GuessResult.gameOver:
        return Colors.red;
    }
  }
}
