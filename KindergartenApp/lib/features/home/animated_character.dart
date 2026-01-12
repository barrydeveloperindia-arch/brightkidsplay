import 'package:flutter/material.dart';

class AnimatedCharacter extends StatefulWidget {
  final String alignment; // 'left', 'right', 'center'

  const AnimatedCharacter({
    super.key,
    this.alignment = 'center',
  });

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter> {
  void talk() {
    debugPrint("Character talking!");
  }
  
  void cheer() {
    debugPrint("Character cheering!"); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: ClipOval(
        child: Image.asset(
          'assets/images/guide_character.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
             return const Icon(Icons.face, size: 200, color: Colors.brown);
          },
        ),
      ),
    );
  }
}
