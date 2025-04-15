enum DifficultyLevel {
  easy,
  medium,
  advanced,
  extreme,
}

extension DifficultyLevelExtension on DifficultyLevel {
  String get name {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Fácil';
      case DifficultyLevel.medium:
        return 'Medio';
      case DifficultyLevel.advanced:
        return 'Avanzado';
      case DifficultyLevel.extreme:
        return 'Extremo';
    }
  }

  int get maxNumber {
    switch (this) {
      case DifficultyLevel.easy:
        return 10;
      case DifficultyLevel.medium:
        return 20;
      case DifficultyLevel.advanced:
        return 100;
      case DifficultyLevel.extreme:
        return 1000;
    }
  }

  int get maxAttempts {
    switch (this) {
      case DifficultyLevel.easy:
        return 5;
      case DifficultyLevel.medium:
        return 8;
      case DifficultyLevel.advanced:
        return 15;
      case DifficultyLevel.extreme:
        return 25;
    }
  }
}
