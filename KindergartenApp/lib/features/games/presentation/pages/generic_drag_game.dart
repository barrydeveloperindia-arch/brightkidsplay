import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';

class GenericDragGame extends StatefulWidget {
  final GameData gameData;
  final List<DragItem> items;
  final List<DragTargetItem> targets;
  final String instruction;

  const GenericDragGame({
    super.key, 
    required this.gameData, 
    required this.items, 
    required this.targets,
    required this.instruction,
  });

  @override
  State<GenericDragGame> createState() => _GenericDragGameState();
}

class _GenericDragGameState extends State<GenericDragGame> {
  final Map<String, bool> _matched = {};

  @override
  Widget build(BuildContext context) {
    return GameShell(
      gameData: widget.gameData,
      currentScore: _matched.length,
      totalPotentialScore: widget.items.length,
      child: Column(
        children: [
           const SizedBox(height: 20),
           Text(
             widget.instruction, 
             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
             textAlign: TextAlign.center,
           ),
           
           const Spacer(),

           // Targets
           Wrap(
             spacing: 20,
             runSpacing: 20,
             alignment: WrapAlignment.center,
             children: widget.targets.map((target) {
               final isMatched = _matched[target.id] == true;
               return DragTarget<String>(
                 builder: (context, candidates, rejects) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isMatched ? Colors.green.withOpacity(0.2) : Colors.black12,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isMatched 
                         ? Icon(target.icon, size: 60, color: Colors.green)
                         : Icon(target.icon, size: 60, color: Colors.grey),
                    );
                 },
                 onWillAccept: (data) => data == target.id,
                 onAccept: (data) {
                    setState(() {
                      _matched[data] = true;
                    });
                 },
               );
             }).toList(),
           ),

           const Spacer(),

           // Items
           Wrap(
             spacing: 20,
             runSpacing: 20,
             alignment: WrapAlignment.center,
             children: widget.items.map((item) {
               if (_matched[item.targetId] == true) {
                 return const SizedBox(width: 80, height: 80);
               }
               return Draggable<String>(
                 data: item.targetId,
                 feedback: Icon(item.icon, size: 80, color: Colors.blueAccent),
                 childWhenDragging: Opacity(opacity: 0.2, child: Icon(item.icon, size: 80, color: Colors.blue)),
                 child: Icon(item.icon, size: 80, color: Colors.blue),
               );
             }).toList(),
           ),
           const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class DragItem {
  final String id;
  final String targetId;
  final IconData icon;
  DragItem({required this.id, required this.targetId, required this.icon});
}

class DragTargetItem {
  final String id;
  final IconData icon;
  DragTargetItem({required this.id, required this.icon});
}
