import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';
import 'dart:async';

class MemoryFlipGame extends StatefulWidget {
  final GameData gameData;
  const MemoryFlipGame({super.key, required this.gameData});

  @override
  State<MemoryFlipGame> createState() => _MemoryFlipGameState();
}

class _MemoryFlipGameState extends State<MemoryFlipGame> {
  late List<MemoryCard> _cards;
  int _matchesFound = 0;
  bool _isProcessing = false;
  MemoryCard? _firstFlipped;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    List<IconData> icons = [
      Icons.star, Icons.star,
      Icons.favorite, Icons.favorite,
      Icons.pets, Icons.pets,
      Icons.face, Icons.face,
    ];
    icons.shuffle();
    _cards = List.generate(8, (index) => MemoryCard(id: index, icon: icons[index]));
  }

  void _onCardTap(MemoryCard card) {
    if (_isProcessing || card.isFlipped || card.isMatched) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstFlipped == null) {
      _firstFlipped = card;
    } else {
      _isProcessing = true;
      if (_firstFlipped!.icon == card.icon) {
        // Match!
        _firstFlipped!.isMatched = true;
        card.isMatched = true;
        _matchesFound++;
        _firstFlipped = null;
        _isProcessing = false;
        
        // Force rebuild to checks
        setState(() {});

      } else {
        // No Match
        Timer(const Duration(milliseconds: 1000), () {
           if (mounted) {
             setState(() {
               _firstFlipped!.isFlipped = false;
               card.isFlipped = false;
               _firstFlipped = null;
               _isProcessing = false;
             });
           }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameShell(
      gameData: widget.gameData,
      currentScore: _matchesFound,
      totalPotentialScore: 4, // 4 pairs
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              return _buildCard(_cards[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(MemoryCard card) {
    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched ? Colors.white : Colors.indigo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.indigo.shade200, width: 4),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
          ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Icon(card.icon, size: 64, color: Colors.indigo)
              : const Icon(Icons.help_outline, size: 64, color: Colors.white54),
        ),
      ),
    );
  }
}

class MemoryCard {
  final int id;
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  MemoryCard({required this.id, required this.icon, this.isFlipped = false, this.isMatched = false});
}
