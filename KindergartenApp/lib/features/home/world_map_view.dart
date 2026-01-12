import 'package:flutter/material.dart';

class WorldMapView extends StatelessWidget {
  const WorldMapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded level nodes for the prototype
    final nodes = [
      _LevelNode(id: '1', label: 'A', color: Colors.redAccent, offset: const Offset(50, 0)),
      _LevelNode(id: '2', label: '1', color: Colors.blueAccent, offset: const Offset(200, 100)),
      _LevelNode(id: '3', label: '😊', color: Colors.orangeAccent, offset: const Offset(350, -50)),
      _LevelNode(id: '4', label: '🎨', color: Colors.purpleAccent, offset: const Offset(500, 50)),
      _LevelNode(id: '5', label: '🎵', color: Colors.green, offset: const Offset(650, -20)),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFFE0F7FA)], // Sky Blue to Light Cyan
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 900, // Long width for scrolling
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // 1. The Winding Path
              Positioned.fill(
                child: CustomPaint(
                  painter: MapPathPainter(nodes: nodes),
                ),
              ),

              // 2. The Level Nodes
              ...nodes.map((node) {
                return Positioned(
                  left: node.offset.dx,
                  top: (MediaQuery.of(context).size.height / 2) + node.offset.dy - 40, // Centered Y + offset
                  child: _NodeWidget(node: node),
                );
              }).toList(),
              
              // 3. Decor Elements (Clouds/Trees)
              const Positioned(top: 50, left: 100, child: Icon(Icons.cloud, color: Colors.white, size: 60)),
              const Positioned(top: 80, left: 400, child: Icon(Icons.cloud, color: Colors.white54, size: 80)),
              const Positioned(bottom: 0, left: 0, right: 0, height: 100, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF90EE90)))), // Grass
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelNode {
  final String id;
  final String label;
  final Color color;
  final Offset offset; // Relative from center-left line

  _LevelNode({required this.id, required this.label, required this.color, required this.offset});
}

class _NodeWidget extends StatelessWidget {
  final _LevelNode node;

  const _NodeWidget({required this.node});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Tapped level ${node.id}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening Level ${node.label}!")),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: node.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            node.label,
            style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// Draws a curved line connecting the nodes
class MapPathPainter extends CustomPainter {
  final List<_LevelNode> nodes;

  MapPathPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Start at the first node
    final centerY = size.height / 2;
    final startPt = Offset(nodes.first.offset.dx + 40, centerY + nodes.first.offset.dy);
    
    path.moveTo(startPt.dx, startPt.dy);

    for (int i = 0; i < nodes.length - 1; i++) {
      final p1 = Offset(nodes[i].offset.dx + 40, centerY + nodes[i].offset.dy);
      final p2 = Offset(nodes[i+1].offset.dx + 40, centerY + nodes[i+1].offset.dy);
      
      // Simple cubic bezier for smoothness
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);

      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
