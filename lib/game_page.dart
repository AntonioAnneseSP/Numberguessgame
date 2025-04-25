import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'difficulty_level.dart';
import 'game_provider.dart';
import 'guess_result.dart';
import 'regular_exp.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adivina el Número'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Primera fila: Input y Dificultad
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input y botón
                  Expanded(
                    flex: 2,
                    child: _buildGuessInput(context),
                  ),
                  const SizedBox(width: 8),
                  // Selector de dificultad
                  Expanded(
                    flex: 1,
                    child: _buildDifficultySelector(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Segunda fila: Info del juego y resultado
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info del juego
                  Expanded(
                    flex: 2,
                    child: _buildGameInfo(context),
                  ),
                  const SizedBox(width: 8),
                  // Mensaje de resultado
                  Expanded(
                    flex: 1,
                    child: _buildResultMessage(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Tercera fila: Columnas de números y historial
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columnas de números
                  Expanded(
                    flex: 2,
                    child: _buildGameColumns(context),
                  ),
                  const SizedBox(width: 8),
                  // Historial
                  Expanded(
                    flex: 1,
                    child: _buildHistorySection(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultySelector(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dificultad:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: DifficultyLevel.values.map((level) {
                return Transform.scale(
                  scale: 0.7,
                  child: ChoiceChip(
                    label: Text(level.name),
                    selected: gameProvider.gameModel.difficulty == level,
                    onSelected: (selected) {
                      gameProvider.setDifficulty(level);
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Intentos:'),
                Text(
                    '${gameProvider.gameModel.attempts}/${gameProvider.gameModel.difficulty.maxAttempts}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rango:'),
                Text('1 - ${gameProvider.gameModel.difficulty.maxNumber}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Número:'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      tooltip: 'Reiniciar juego',
                      onPressed: () {
                        gameProvider.initGame();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        gameProvider.showSecretNumber
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () {
                        gameProvider.toggleSecretNumberVisibility();
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (gameProvider.showSecretNumber &&
                gameProvider.gameModel.secretNumber != null)
              Text(
                '${gameProvider.gameModel.secretNumber}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuessInput(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: gameProvider.guessController,
              keyboardType: TextInputType.number,
              inputFormatters:
                  RegularExp.getFormatters(gameProvider.gameModel.difficulty),
              decoration: const InputDecoration(
                labelText: 'Ingresa tu número',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: gameProvider.submitGuess,
              child: const Text('Adivinar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultMessage(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    if (gameProvider.lastResult == null) return const SizedBox.shrink();

    final result = gameProvider.lastResult!;
    return Card(
      color: result.color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          result.message,
          style: TextStyle(
            color: result.color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildGameColumns(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildNumberColumn(
                    title: 'Mayor que',
                    numbers: gameProvider.gameModel.higherGuesses,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildNumberColumn(
                    title: 'Menor que',
                    numbers: gameProvider.gameModel.lowerGuesses,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberColumn({
    required String title,
    required List<int> numbers,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: numbers.length,
            itemBuilder: (context, index) {
              return Text(
                numbers[index].toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: gameProvider.gameModel.guessHistory.length,
                itemBuilder: (context, index) {
                  final guess = gameProvider.gameModel.guessHistory[index];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${index + 1}: ${guess.guess}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      guess.result.message,
                      style: const TextStyle(fontSize: 10),
                    ),
                    tileColor: guess.result.color.withOpacity(0.1),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
