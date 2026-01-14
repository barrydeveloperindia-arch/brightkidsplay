import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bright_kids/features/content/domain/content_node.dart';
import 'package:bright_kids/core/reward_service.dart';
import 'package:go_router/go_router.dart';

class QuizPlayerWidget extends ConsumerStatefulWidget {
  final ContentNode content;

  const QuizPlayerWidget({super.key, required this.content});

  @override
  ConsumerState<QuizPlayerWidget> createState() => _QuizPlayerWidgetState();
}

class _QuizPlayerWidgetState extends ConsumerState<QuizPlayerWidget> {
  int _currentIndex = 0;
  List<dynamic> _questions = [];
  bool _answered = false;
  bool _isCorrect = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _questions = widget.content.metadata['questions'] ?? [];
  }

  void _handleAnswer(String selected, String correct) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _isCorrect = selected == correct;
      if (_isCorrect) {
        _score++;
      }
    });

    // Auto-advance after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _isCorrect = false;
        });
      } else {
        // Quiz Finished
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    // Trigger Reward!
    if (_score > 0) { // Only reward if they got at least one right? or simple participation? Left simple for now.
       ref.read(rewardServiceProvider).triggerSuccess();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Great Job!", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              "You got $_score out of ${_questions.length} correct!",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(), // Close dialog
            child: const Text("Stay Here"),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Exit player
            },
            child: const Text("Finish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(child: Text("No questions found!", style: TextStyle(color: Colors.white)));
    }

    final questionData = _questions[_currentIndex];
    final questionText = questionData['question'];
    final options = List<String>.from(questionData['options']);
    final correctAnswer = questionData['answer'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[200],
            color: Colors.purple,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 32),
          
          // Question
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionText,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'ComicNeue',
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Options
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: options.map((option) {
                Color cardColor = Colors.blue.shade50;
                Color textColor = Colors.blue.shade900;
                
                if (_answered) {
                  if (option == correctAnswer) {
                    cardColor = Colors.green.shade100;
                    textColor = Colors.green.shade900;
                  } else if (option != correctAnswer && _answered) {
                     // Grey out other options
                     cardColor = Colors.grey.shade100;
                     textColor = Colors.grey;
                  }
                }

                return Material(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _handleAnswer(option, correctAnswer),
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Status Feedback
          SizedBox(
            height: 50,
            child: Center(
              child: _answered
                  ? Text(
                      _isCorrect ? "Correct! 🎉" : "Oops! The answer was $correctAnswer",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
