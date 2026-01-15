import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';

class NumberTraceGame extends StatefulWidget {
  final GameData gameData;
  const NumberTraceGame({super.key, required this.gameData});

  @override
  State<NumberTraceGame> createState() => _NumberTraceGameState();
}

class _NumberTraceGameState extends State<NumberTraceGame> {
  int _currentNumber = 1;
  int _score = 0;
  List<int> _hitPoints = [];
  Offset? _currentDrag;

  // Simple hardcoded paths for 1, 2, 3 (normalized 0.0 to 1.0)
  final Map<int, List<Offset>> _paths = {
    1: [Offset(0.5, 0.2), Offset(0.5, 0.8)],
    2: [Offset(0.2, 0.3), Offset(0.8, 0.3), Offset(0.2, 0.8), Offset(0.8, 0.8)], // Z shape
    3: [Offset(0.2, 0.2), Offset(0.8, 0.2), Offset(0.5, 0.5), Offset(0.8, 0.8), Offset(0.2, 0.8)], 
    4: [Offset(0.2, 0.2), Offset(0.2, 0.5), Offset(0.8, 0.5), Offset(0.8, 0.2), Offset(0.8, 0.8)],
    5: [Offset(0.8, 0.2), Offset(0.2, 0.2), Offset(0.2, 0.5), Offset(0.8, 0.5), Offset(0.8, 0.8), Offset(0.2, 0.8)],
  };

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _currentDrag = details.localPosition;
    });

    final points = _paths[_currentNumber]!;
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    for (int i = 0; i < points.length; i++) {
      if (_hitPoints.contains(i)) continue;

      // Check strict order: must hit previous point first
      if (i > 0 && !_hitPoints.contains(i - 1)) break;

      final target = Offset(points[i].dx * width, points[i].dy * height);
      if ((details.localPosition - target).distance < 40) {
        setState(() {
          _hitPoints.add(i);
        });
        
        // Complete?
        if (_hitPoints.length == points.length) {
            _handleCompletion();
        }
        break; 
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentDrag = null;
      // If not complete, reset or keep? 
      // For kids, maybe keep progress or strict reset? 
      // Strict reset makes it harder/better practice.
      if (_hitPoints.length != _paths[_currentNumber]!.length) {
          _hitPoints.clear();
      }
    });
  }

  void _handleCompletion() {
    setState(() {
      _score++;
    });

    if (_currentNumber < 3) { // Limit to 3 for prototype demo 
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _currentNumber++;
          _hitPoints.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3 numbers to trace for level 5
    return GameShell(
      gameData: widget.gameData,
      currentScore: _score,
      totalPotentialScore: 3, 
      child: LayoutBuilder(
        builder: (context, constraints) {
          final points = _paths[_currentNumber]!;
          return GestureDetector(
            onPanUpdate: (d) => _onPanUpdate(d, constraints),
            onPanEnd: _onPanEnd,
            child: Container(
              color: Colors.transparent, // Hit test
              child: Stack(
                children: [
                   // Large Number Display Watermark
                   Center(
                     child: Text(
                       "$_currentNumber",
                       style: TextStyle(
                         fontSize: 300, 
                         fontWeight: FontWeight.bold,
                         color: Colors.grey.withOpacity(0.1),
                       ),
                     ),
                   ),
                   // Guide Text
                   Align(
                     alignment: Alignment.topCenter,
                     child: Padding(
                       padding: const EdgeInsets.only(top: 20.0),
                       child: Text("Trace the Number $_currentNumber", style: const TextStyle(fontSize: 24, color: Colors.indigo)),
                     ),
                   ),
                   
                   // Draw Lines (Progress)
                   CustomPaint(
                     size: Size(constraints.maxWidth, constraints.maxHeight),
                     painter: TracePainter(points, _hitPoints),
                   ),

                   // Draw Dots
                   ...points.asMap().entries.map((entry) {
                      final i = entry.key;
                      final p = entry.value;
                      final isHit = _hitPoints.contains(i);
                      final isNext = !_hitPoints.contains(i) && (i == 0 || _hitPoints.contains(i-1));
                      
                      return Positioned(
                        left: (p.dx * constraints.maxWidth) - 20,
                        top: (p.dy * constraints.maxHeight) - 20,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: isHit ? Colors.green : (isNext ? Colors.orange : Colors.grey),
                          child: Text("${i+1}", style: const TextStyle(color: Colors.white)),
                        ),
                      );
                   }).toList(),

                   // Current Drag Finger
                   if (_currentDrag != null)
                     Positioned(
                       left: _currentDrag!.dx - 15,
                       top: _currentDrag!.dy - 15,
                       child: const Icon(Icons.fingerprint, size: 30, color: Colors.blueAccent),
                     ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TracePainter extends CustomPainter {
  final List<Offset> points;
  final List<int> hitIndices;

  TracePainter(this.points, this.hitIndices);

  @override
  void paint(Canvas canvas, Size size) {
    if (hitIndices.length < 2) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Move to first hit point
    final start = points[hitIndices[0]];
    path.moveTo(start.dx * size.width, start.dy * size.height);

    for (int i = 1; i < hitIndices.length; i++) {
       // Only connect if indices are sequential in hit list? 
       // Simpler: Just connect sequential points that are hit
       // But hitIndices might collect out of order if logic incorrect, but our logic is strict.
       final p = points[hitIndices[i]];
       path.lineTo(p.dx * size.width, p.dy * size.height);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
