import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimalSoundsGame extends StatefulWidget {
  final GameData gameData;
  const AnimalSoundsGame({super.key, required this.gameData});

  @override
  State<AnimalSoundsGame> createState() => _AnimalSoundsGameState();
}

class _AnimalSoundsGameState extends State<AnimalSoundsGame> {
  late AudioPlayer _audioPlayer;
  int _score = 0;
  int _currentQuestionIndex = 0;
  bool _isPlayingSound = false;

  final List<AnimalQuestion> _questions = [
    AnimalQuestion(soundId: 'cow', correctId: 'cow', options: ['cow', 'cat', 'dog', 'bird']),
    AnimalQuestion(soundId: 'cat', correctId: 'cat', options: ['mouse', 'cat', 'elephant', 'bird']),
    AnimalQuestion(soundId: 'dog', correctId: 'dog', options: ['fish', 'dog', 'cow', 'lion']),
    AnimalQuestion(soundId: 'bird', correctId: 'bird', options: ['bird', 'frog', 'cat', 'dog']),
    AnimalQuestion(soundId: 'lion', correctId: 'lion', options: ['lion', 'elephant', 'mouse', 'fish']),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playCurrentSound();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCurrentSound() async {
    if (_isPlayingSound) return;

    setState(() {
      _isPlayingSound = true;
    });

    final soundId = _questions[_currentQuestionIndex].soundId;
    final url = _getSoundUrl(soundId);

    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    } finally {
      // Allow re-play after a short delay or when done
      // For simple UX, we'll just timeout the visual state
       Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isPlayingSound = false;
          });
        }
      });
    }
  }

  String _getSoundUrl(String id) {
    // using reliable google assets for demo
    switch (id) {
      case 'cow': return 'https://www.google.com/logos/fnbx/animal_sounds/cow.mp3';
      case 'cat': return 'https://www.google.com/logos/fnbx/animal_sounds/cat.mp3';
      case 'dog': return 'https://www.google.com/logos/fnbx/animal_sounds/dog.mp3';
      case 'bird': return 'https://www.google.com/logos/fnbx/animal_sounds/bird.mp3';
      case 'lion': return 'https://www.google.com/logos/fnbx/animal_sounds/lion.mp3';
      default: return 'https://www.google.com/logos/fnbx/animal_sounds/cow.mp3';
    }
  }

  void _answer(String selectedId) {
    if (_questions[_currentQuestionIndex].correctId == selectedId) {
      // Correct
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _playCurrentSound();
    } else {
      // Finish - GameShell handles score check, but we need to trigger it.
      // Since GameShell checks score on widget update, setting state here works.
    }
  }

  IconData _getIcon(String id) {
    switch (id) {
      case 'cow': return Icons.grass; // Mooo
      case 'cat': return Icons.pets;
      case 'dog': return Icons.cruelty_free; // Closest to dog/paw
      case 'bird': return Icons.flutter_dash;
      case 'lion': return Icons.wb_sunny;
      case 'elephant': return Icons.airline_seat_legroom_extra; 
      case 'mouse': return Icons.mouse;
      case 'fish': return Icons.water;
      case 'frog': return Icons.bug_report;
      default: return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return GameShell(
      gameData: widget.gameData,
      currentScore: _score,
      totalPotentialScore: _questions.length,
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFA5D6A7), Color(0xFF81C784)], // Jungle Green
          ),
        ),
        child: Opacity(
          opacity: 0.1,
          child: Center(child: Icon(Icons.park, size: 300, color: Colors.white)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Play Button / Visualizer
          GestureDetector(
            onTap: _playCurrentSound,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _isPlayingSound ? Colors.orangeAccent : Colors.orange,
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,5))],
              ),
              child: Icon(
                _isPlayingSound ? Icons.volume_up : Icons.play_arrow,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
           const SizedBox(height: 10),
           Text(
             _isPlayingSound ? "Listening..." : "Tap to Listen",
             style: const TextStyle(fontSize: 18, color: Colors.indigo),
           ),
           
           const Spacer(),

           // Options Grid
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
               itemCount: question.options.length,
               itemBuilder: (context, index) {
                 final optionId = question.options[index];
                 return ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     foregroundColor: Colors.indigo,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     elevation: 5,
                   ),
                   onPressed: () => _answer(optionId),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(_getIcon(optionId), size: 40),
                       Text(optionId.toUpperCase()),
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

class AnimalQuestion {
  final String soundId;
  final String correctId;
  final List<String> options;
  AnimalQuestion({required this.soundId, required this.correctId, required this.options});
}
