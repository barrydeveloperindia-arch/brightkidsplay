import 'package:flutter/material.dart';

class AnimatedCharacter extends StatefulWidget {
  final String alignment; // 'left', 'right', 'center'
  final VoidCallback? onTap;

  const AnimatedCharacter({
    super.key,
    this.alignment = 'center',
    this.onTap,
  });

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter> with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _actionController;
  
  late Animation<double> _floatAnimation;
  late Animation<double> _breatheAnimation;
  
  Animation<double>? _scaleAction;
  Animation<double>? _rotateAction;
  Animation<double>? _jumpAction;

  @override
  void initState() {
    super.initState();
    // Idle Loop (Float + Breathe)
    _idleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );
    
    _breatheAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );

    // One-shot Actions (Talk, Cheer)
    _actionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _actionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _actionController.reset();
        _scaleAction = null;
        _rotateAction = null;
        _jumpAction = null;
      }
    });
  }

  @override
  void dispose() {
    _idleController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  void talk() {
    if (_actionController.isAnimating) return;
    debugPrint("Character talking!");
    
    final sequence = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 1),
    ]);

    _scaleAction = sequence.animate(
      CurvedAnimation(parent: _actionController, curve: Curves.linear)
    );
        
    _actionController.forward();
  }
  
  void cheer() {
     if (_actionController.isAnimating) return;
    debugPrint("Character cheering!");
    
    // Jump up and down
    _jumpAction = TweenSequence<double>([
       TweenSequenceItem(tween: Tween(begin: 0.0, end: -100.0).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
       TweenSequenceItem(tween: Tween(begin: -100.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_actionController);
    
    // Spin while jumping
    _rotateAction = Tween<double>(begin: 0, end: 6.28).animate(
      CurvedAnimation(parent: _actionController, curve: Curves.easeInOutBack),
    );
    
    _actionController.duration = const Duration(milliseconds: 1200);
    _actionController.forward().then((_) {
      _actionController.duration = const Duration(milliseconds: 500); // Reset duration
      _scaleAction = null;
      _rotateAction = null;
      _jumpAction = null;
    });
  }
  
  void _handleTap() {
    cheer();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _actionController]),
      builder: (context, child) {
        // Base Idle Transforms
        double translateY = _floatAnimation.value;
        double scale = _breatheAnimation.value;
        double rotation = 0;

        // Apply Action TransformsOverride
        if (_actionController.isAnimating) {
           if (_jumpAction != null) translateY += _jumpAction!.value;
           if (_scaleAction != null) scale *= _scaleAction!.value;
           if (_rotateAction != null) rotation += _rotateAction!.value;
        }

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2), // More "premium" colored shadow
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: ClipOval(
            child: Image.asset(
              'assets/images/guide_character.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                 return const Center(child: Icon(Icons.pets, size: 150, color: Colors.orange));
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Helper to simpler sequence building if package not used
extension SequenceHelper on SequenceAnimationBuilder {
    // ... mocked helper logic or just use Tweens directly if package not imported.
    // Actually, to avoid adding dependencies, I will simplify the logic in `talk` to use a simple chaining or just a single TweenSequence.
}

// Redefining pure flutter approach without external deps
class SequenceAnimationBuilder {
   // Placeholder... actually let's re-write `talk` to use TweenSequence which is built-in.
}
