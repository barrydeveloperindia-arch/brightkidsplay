import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';

class ShapeMatcherGame extends StatefulWidget {
  final GameData gameData;

  const ShapeMatcherGame({super.key, required this.gameData});

  @override
  State<ShapeMatcherGame> createState() => _ShapeMatcherGameState();
}

class _ShapeMatcherGameState extends State<ShapeMatcherGame> {
  // Shape Data
  final List<ShapeItem> _shapes = [
    ShapeItem(id: 'circle', icon: Icons.circle, color: Colors.red),
    ShapeItem(id: 'square', icon: Icons.crop_square, color: Colors.blue),
    ShapeItem(id: 'triangle', icon: Icons.warning_amber, color: Colors.green), // Rough triangle
  ];

  final Map<String, bool> _matched = {};

  @override
  Widget build(BuildContext context) {

    int currentScore = _matched.length;

    return GameShell(
      gameData: widget.gameData,
      currentScore: currentScore,
      totalPotentialScore: _shapes.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Title
          const Text(
            "Match the Shapes!",
            style: TextStyle(
               fontSize: 32, 
               fontWeight: FontWeight.bold,
               color: Colors.indigo,
            ),
          ),

          // Targets (Holes)
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: _shapes.map((shape) {
               return DragTarget<String>(
                 builder: (context, candidateData, rejectedData) {
                   final isMatched = _matched[shape.id] == true;
                   return TweenAnimationBuilder<double>(
                     duration: const Duration(milliseconds: 300),
                     tween: Tween(begin: 1.0, end: isMatched ? 1.2 : 1.0),
                     builder: (context, scale, child) {
                       return Transform.scale(
                         scale: scale,
                         child: Container(
                           width: 100,
                           height: 100,
                           decoration: BoxDecoration(
                             color: isMatched ? shape.color.withOpacity(0.2) : Colors.black12,
                             border: Border.all(
                               color: isMatched ? shape.color : Colors.grey,
                               width: 3,
                               style: BorderStyle.solid,
                             ),
                             shape: shape.id == 'circle' ? BoxShape.circle : BoxShape.rectangle,
                             borderRadius: shape.id == 'square' ? BorderRadius.circular(10) : null,
                           ),
                           child: isMatched 
                              ? Icon(shape.icon, size: 60, color: shape.color)
                              : const Center(
                                   child: Text("?", style: TextStyle(fontSize: 40, color: Colors.black26)),
                                ),
                         ),
                       );
                     },
                   );
                 },
                 onWillAccept: (data) => data == shape.id,
                 onAccept: (data) {
                   setState(() {
                     _matched[data] = true;
                   });
                 },
               );
             }).toList(),
          ),

          // Draggables (Sources)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _shapes.map((shape) {
               if (_matched[shape.id] == true) {
                 return const SizedBox(width: 80, height: 80); // Empty placeholder
               }
               return Draggable<String>(
                 data: shape.id,
                 feedback: Icon(shape.icon, size: 80, color: shape.color.withOpacity(0.8)),
                 childWhenDragging: Opacity(
                   opacity: 0.3, 
                   child: Icon(shape.icon, size: 80, color: shape.color),
                 ),
                 child: Icon(shape.icon, size: 80, color: shape.color),
               );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ShapeItem {
  final String id;
  final IconData icon;
  final Color color;
  ShapeItem({required this.id, required this.icon, required this.color});
}
