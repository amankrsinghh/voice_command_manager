import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_command_manager/voice_command_manager.dart';

void main() {
  testWidgets('VoiceCommandManager renders its child', (WidgetTester tester) async {
    await tester.pumpWidget(
      VoiceCommandManager(
        commands: {'test': () {}},
        child: const MaterialApp(
          home: Scaffold(
            body: Text('Child Widget'),
          ),
        ),
      ),
    );
    
    expect(find.text('Child Widget'), findsOneWidget);
  });
}
