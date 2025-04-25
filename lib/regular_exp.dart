import 'package:flutter/services.dart';
import 'difficulty_level.dart';

class RegularExp {
  static List<TextInputFormatter> getFormatters(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^([1-9]|10)$')),
          LengthLimitingTextInputFormatter(2)
        ];
      case DifficultyLevel.medium:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^([1-9]|1[0-9]|20)$')),
          LengthLimitingTextInputFormatter(2)
        ];
      case DifficultyLevel.advanced:
        return [
          FilteringTextInputFormatter.allow(
              RegExp(r'^([1-9]|[1-9][0-9]|100)$')),
          LengthLimitingTextInputFormatter(3)
        ];
      case DifficultyLevel.extreme:
        return [
          FilteringTextInputFormatter.allow(
              RegExp(r'^([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|1000)$')),
          LengthLimitingTextInputFormatter(4)
        ];
    }
  }
}
