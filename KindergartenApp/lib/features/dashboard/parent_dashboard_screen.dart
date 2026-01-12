import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text("Progress Reports & Settings go here."),
      ),
    );
  }
}
