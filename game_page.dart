import 'package:flutter/material.dart';
import 'difficulty_level.dart';
import 'game_model.dart';
import 'guess_result.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameModel _gameModel = GameModel();
  final TextEditingController _guessController = TextEditingController();
  GuessResult? _lastResult;
  bool _showSecretNumber = false;

  @override
  void initState() {
    super.initState();
    _gameModel.startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adivina el Número'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDifficultySelector(),
            const SizedBox(height: 20),
            _buildGameInfo(),
            const SizedBox(height: 20),
            _buildGuessInput(),
            if (_lastResult != null) _buildResultMessage(),
            const SizedBox(height: 20),
            _buildGameColumns(),
            const SizedBox(height: 20),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nivel de Dificultad:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: DifficultyLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(level.name),
                  selected: _gameModel.difficulty == level,
                  onSelected: (selected) {
                    setState(() {
                      _gameModel.setDifficulty(level);
                      _lastResult = null;
                      _guessController.clear();
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Intentos:'),
                Text(
                    '${_gameModel.attempts}/${_gameModel.difficulty.maxAttempts}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rango:'),
                Text('1 - ${_gameModel.difficulty.maxNumber}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Número secreto:'),
                IconButton(
                  icon: Icon(
                    _showSecretNumber ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showSecretNumber = !_showSecretNumber;
                    });
                  },
                ),
              ],
            ),
            if (_showSecretNumber && _gameModel.secretNumber != null)
              Text(
                '${_gameModel.secretNumber}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuessInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _guessController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa tu número',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitGuess,
              child: const Text('Adivinar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultMessage() {
    return Card(
      color: _lastResult!.color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _lastResult!.message,
          style: TextStyle(
            color: _lastResult!.color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildGameColumns() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildNumberColumn(
            title: 'Mayor que',
            numbers: _gameModel.higherGuesses,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildNumberColumn(
            title: 'Menor que',
            numbers: _gameModel.lowerGuesses,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberColumn({
    required String title,
    required List<int> numbers,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: numbers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      numbers[index].toString(),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Juegos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _gameModel.gameHistory.length,
                itemBuilder: (context, index) {
                  final game = _gameModel.gameHistory[index];
                  return ListTile(
                    leading: Icon(
                      game['result'] ? Icons.check : Icons.close,
                      color: game['result'] ? Colors.green : Colors.red,
                    ),
                    title: Text('Número: ${game['number']}'),
                    subtitle: Text(
                      'Dificultad: ${game['difficulty']}, Intentos: ${game['attempts']}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitGuess() {
    if (_guessController.text.isEmpty) return;

    setState(() {
      _lastResult = _gameModel.makeGuess(_guessController.text);
      if (_lastResult == GuessResult.correct ||
          _lastResult == GuessResult.gameOver) {
        _guessController.clear();
      }
    });
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }
}
