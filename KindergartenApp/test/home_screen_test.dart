import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bright_kids/features/home/home_screen.dart';
import 'package:bright_kids/features/home/animated_character.dart';
import 'package:confetti/confetti.dart';

void main() {
  testWidgets('HomeScreen displays Character and Reward Button', (WidgetTester tester) async {
    // 1. Pump the HomeScreen within a ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // 2. Verify AnimatedCharacter is present
    expect(find.byType(AnimatedCharacter), findsOneWidget);

    // 3. Verify "Welcome" text
    expect(find.text('Welcome to BrightKids!'), findsOneWidget);

    // 4. Verify "Complete Task!" button exists
    expect(find.text('Complete Task!'), findsOneWidget);

    // 5. Verify ConfettiWidget exists
    expect(find.byType(ConfettiWidget), findsOneWidget);
    
    // 6. Tap the button
    await tester.tap(find.text('Complete Task!'));
    await tester.pump(); 
  });
}
