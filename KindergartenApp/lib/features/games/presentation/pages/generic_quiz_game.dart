import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';

class GenericQuizGame extends StatefulWidget {
  final GameData gameData;
  final List<QuizLevelConfig> levels;

  const GenericQuizGame({super.key, required this.gameData, required this.levels});

  @override
  State<GenericQuizGame> createState() => _GenericQuizGameState();
}

class _GenericQuizGameState extends State<GenericQuizGame> {
  int _currentLevelIndex = 0;
  int _score = 0;

  void _handleAnswer(String selectedId) {
    if (widget.levels[_currentLevelIndex].correctId == selectedId) {
       setState(() {
         _score++;
       });
    }

    if (_currentLevelIndex < widget.levels.length - 1) {
      setState(() {
        _currentLevelIndex++;
      });
    } else {
       // Finished
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.levels[_currentLevelIndex];

    return GameShell(
      gameData: widget.gameData,
      currentScore: _score,
      totalPotentialScore: widget.levels.length,
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Question Area
          Text(config.questionText, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
          const SizedBox(height: 20),
          if (config.questionIcon != null)
            Icon(config.questionIcon, size: 100, color: Colors.orange),
          
          const Spacer(),

          // Options
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                 crossAxisSpacing: 20,
                 mainAxisSpacing: 20,
                 childAspectRatio: 1.5,
              ),
              itemCount: config.options.length,
              itemBuilder: (context, index) {
                final option = config.options[index];
                return ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     foregroundColor: Colors.indigo,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     elevation: 4,
                   ),
                   onPressed: () => _handleAnswer(option.id),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       if (option.icon != null) Icon(option.icon, size: 40),
                       Text(option.label, textAlign: TextAlign.center),
                     ],
                   ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class QuizLevelConfig {
  final String questionText;
  final IconData? questionIcon;
  final String correctId;
  final List<QuizOption> options;

  QuizLevelConfig({required this.questionText, this.questionIcon, required this.correctId, required this.options});
}

class QuizOption {
  final String id;
  final String label;
  final IconData? icon;
  QuizOption({required this.id, required this.label, this.icon});
}
