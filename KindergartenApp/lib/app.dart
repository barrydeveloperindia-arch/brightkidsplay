import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routing/router.dart';

class BrightKidsApp extends ConsumerWidget {
  const BrightKidsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BrightKids',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
        fontFamily: 'ComicNeue', // Hypothetical playful font
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
