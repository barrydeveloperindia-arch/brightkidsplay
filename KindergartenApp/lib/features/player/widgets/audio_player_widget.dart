import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bright_kids/features/content/domain/content_node.dart';
import 'package:bright_kids/core/reward_service.dart';

class AudioPlayerWidget extends ConsumerStatefulWidget {
  final ContentNode content;

  const AudioPlayerWidget({super.key, required this.content});

  @override
  ConsumerState<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends ConsumerState<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // Set up listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
       // Trigger Reward on Completion
       ref.read(rewardServiceProvider).triggerSuccess();
       if (mounted) {
         setState(() {
           _position = Duration.zero;
           _isPlaying = false;
         });
       }
    });
    
    _initAudio();
  }

  Future<void> _initAudio() async {
    // For web/network URLs
    try {
      if (widget.content.resourceUrl.isNotEmpty) {
         await _audioPlayer.setSourceUrl(widget.content.resourceUrl);
      }
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A0944), // Deep Space Purple
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF3B185F),
            const Color(0xFF2A0944),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album Art / Visual with Glow
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Colors.purpleAccent, Colors.transparent],
                  stops: [0.5, 1.0],
                ),
                boxShadow: [
                   BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 10,
                   )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipOval(
                  child: Image.asset(
                    widget.content.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.music_note, size: 100, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            
            // Title
            Text(
              widget.content.title,
              style: const TextStyle(
                // fontFamily: 'Fredoka', // Inherited from Theme
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbColor: Colors.amber,
                  activeTrackColor: Colors.amber,
                  inactiveTrackColor: Colors.white24,
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    _audioPlayer.seek(position);
                  },
                ),
              ),
            ),
            
            // Duration Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_position), style: const TextStyle(color: Colors.white70)),
                  Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                  onPressed: () {
                     final newPos = _position - const Duration(seconds: 10);
                     _audioPlayer.seek(newPos < Duration.zero ? Duration.zero : newPos);
                  },
                ),
                const SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  child: IconButton(
                    iconSize: 60,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.resume();
                      }
                    },
                    padding: const EdgeInsets.all(10), // Bigger hit area
                  ),
                ),
                const SizedBox(width: 20),
                 IconButton(
                  icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                  onPressed: () {
                     final newPos = _position + const Duration(seconds: 10);
                     _audioPlayer.seek(newPos > _duration ? _duration : newPos);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) {
      return "${d.inHours}:${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    }
    return "${d.inMinutes}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }
}
