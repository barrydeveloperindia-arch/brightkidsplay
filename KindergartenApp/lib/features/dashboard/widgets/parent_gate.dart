
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentGate extends StatefulWidget {
  final VoidCallback onSuccess;
  
  const ParentGate({super.key, required this.onSuccess});

  @override
  State<ParentGate> createState() => _ParentGateState();
}

class _ParentGateState extends State<ParentGate> {
  late int _num1;
  late int _num2;
  late int _answer;
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    _num1 = random.nextInt(10) + 1; // 1-10
    _num2 = random.nextInt(10) + 1; // 1-10
    _answer = _num1 * _num2; // Multiplication for slightly older restriction, or just add.
    // Let's stick to multiplication as it's a standard "Parent Gate" (e.g. 3 x 4)
  }

  void _checkAnswer() {
    if (_controller.text == _answer.toString()) {
      widget.onSuccess();
    } else {
      setState(() {
        _error = "Incorrect, try again!";
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Parent Gate"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please solve this to continue:"),
          const SizedBox(height: 16),
          Text(
            "$_num1 x $_num2 = ?", 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _error,
              hintText: "Answer",
            ),
            onSubmitted: (_) => _checkAnswer(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _checkAnswer,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}

// Helper to show the gate
void showParentGate(BuildContext context, VoidCallback onSuccess) {
  showDialog(
    context: context,
    builder: (context) => ParentGate(
      onSuccess: () {
        Navigator.of(context).pop(); // Close dialog
        onSuccess();
      },
    ),
  );
}
