import 'package:flutter/material.dart';
import '../../domain/game_data.dart';
import '../game_shell.dart';

class ColorSorterGame extends StatefulWidget {
  final GameData gameData;

  const ColorSorterGame({super.key, required this.gameData});

  @override
  State<ColorSorterGame> createState() => _ColorSorterGameState();
}

class _ColorSorterGameState extends State<ColorSorterGame> {
  // Items to sort
  late List<SortItem> _items;
  
  // Buckets
  final List<SortBucket> _buckets = [
    SortBucket(id: 'red', color: Colors.red, label: 'Red'),
    SortBucket(id: 'green', color: Colors.green, label: 'Green'),
    SortBucket(id: 'blue', color: Colors.blue, label: 'Blue'),
  ];

  final Map<String, int> _itemsSortedCount = {
    'red': 0,
    'green': 0,
    'blue': 0,
  };

  @override
  void initState() {
    super.initState();
    _items = [
      SortItem(id: 'apple', colorId: 'red', icon: Icons.apple, color: Colors.red),
      SortItem(id: 'leaf', colorId: 'green', icon: Icons.eco, color: Colors.green),
      SortItem(id: 'water', colorId: 'blue', icon: Icons.water_drop, color: Colors.blue),
      SortItem(id: 'cherry', colorId: 'red', icon: Icons.coronavirus, color: Colors.red), // Cherry-ish
      SortItem(id: 'frog', colorId: 'green', icon: Icons.bug_report, color: Colors.green),
    ];
    _items.shuffle();
  }

  void _onItemSorted(SortItem item) {
    setState(() {
      _items.remove(item);
      _itemsSortedCount[item.colorId] = (_itemsSortedCount[item.colorId] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Score is total items sorted
    int totalItemsInitially = 5;
    int currentScore = totalItemsInitially - _items.length;

    return GameShell(
      gameData: widget.gameData,
      currentScore: currentScore,
      totalPotentialScore: totalItemsInitially,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Sort by Color!",
            style: TextStyle(
               fontSize: 32, 
               fontWeight: FontWeight.bold,
               color: Colors.indigo,
            ),
          ),
          
          const Spacer(),

          // Draggable Items (scattered or in a row)
          // Showing only top 3 to keep UI clean or all in a wrap
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: _items.map((item) {
              return Draggable<SortItem>(
                data: item,
                feedback: Transform.scale(
                  scale: 1.2,
                  child: Icon(item.icon, size: 60, color: item.color),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.0, 
                  child: Icon(item.icon, size: 60, color: item.color),
                ),
                child: Icon(item.icon, size: 60, color: item.color),
              );
            }).toList(),
          ),

          const Spacer(),

          // Buckets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buckets.map((bucket) {
              return DragTarget<SortItem>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: bucket.color.withOpacity(0.3),
                      border: Border.all(color: bucket.color, width: 4),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(20)),
                      boxShadow: [
                         BoxShadow(
                           color: bucket.color.withOpacity(0.2),
                           blurRadius: 10,
                           offset: const Offset(0, 5)
                         )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          bucket.label,
                          style: TextStyle(
                            color: bucket.color.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
                onWillAccept: (item) => item?.colorId == bucket.id,
                onAccept: (item) {
                   _onItemSorted(item);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class SortItem {
  final String id;
  final String colorId; // 'red', 'green', 'blue'
  final IconData icon;
  final Color color;
  SortItem({required this.id, required this.colorId, required this.icon, required this.color});
}

class SortBucket {
  final String id;
  final Color color;
  final String label;
  SortBucket({required this.id, required this.color, required this.label});
}
