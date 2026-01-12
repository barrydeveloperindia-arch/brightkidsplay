import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

// Controller for UI Confetti
final confettiControllerProvider = Provider.autoDispose<ConfettiController>((ref) {
  final controller = ConfettiController(duration: const Duration(seconds: 2));
  ref.onDispose(() => controller.dispose());
  return controller;
});

class RewardService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConfettiController _confettiController;

  RewardService(this._confettiController);

  Future<void> triggerSuccess() async {
    // 1. Play Sound
    // Note: Ensure 'assets/audio/success.mp3' exists in pubspec
    try {
      await _audioPlayer.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      debugPrint("Audio playback failed: $e");
    }

    // 2. Trigger Visuals
    _confettiController.play();
  }
}

final rewardServiceProvider = Provider<RewardService>((ref) {
  final confetti = ref.watch(confettiControllerProvider);
  return RewardService(confetti);
});
