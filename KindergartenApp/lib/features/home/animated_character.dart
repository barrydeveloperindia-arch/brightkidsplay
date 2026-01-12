import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedCharacter extends StatefulWidget {
  final String assetPath;
  final String stateMachineName;
  final String? alignment; // 'left', 'right', 'center'

  const AnimatedCharacter({
    super.key,
    this.assetPath = 'assets/rive/guide_bear.riv',
    this.stateMachineName = 'GuideSM',
    this.alignment = 'center',
  });

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter> {
  // Rive controllers would go here, but we are using a static image for now.
  
  void talk() {
    // Creating a "jump" effect to simulate talking/attention
    // In a real implementation this would trigger Rive inputs
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
