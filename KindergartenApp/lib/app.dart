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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A0572),
          brightness: Brightness.light,
          primary: const Color(0xFF6A0572),
          secondary: const Color(0xFFAB83A1),
          background: const Color(0xFFEBEBEB),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        // textTheme: GoogleFonts.fredokaTextTheme(
        //   Theme.of(context).textTheme,
        // ),
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadowColor: const Color(0xFF6A0572).withOpacity(0.3),
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
