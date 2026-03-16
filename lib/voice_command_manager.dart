import 'package:flutter/material.dart';
import 'src/command_handler.dart';
export 'src/command_handler.dart';

/// A widget that manages continuous background voice command listening.
/// Wrap your app or a specific widget tree with this manager.
class VoiceCommandManager extends StatefulWidget {
  final Widget child;
  final Map<String, VoidCallback> commands;
  final String localeId;
  final Function(String)? onCommandMatched;

  const VoiceCommandManager({
    super.key,
    required this.child,
    required this.commands,
    this.localeId = '',
    this.onCommandMatched,
  });

  @override
  State<VoiceCommandManager> createState() => _VoiceCommandManagerState();
}

class _VoiceCommandManagerState extends State<VoiceCommandManager> {
  late CommandHandler _commandHandler;

  @override
  void initState() {
    super.initState();
    _commandHandler = CommandHandler();
    _commandHandler.commands = widget.commands;
    _commandHandler.onCommandMatched = widget.onCommandMatched;
    // We add a slight delay to allow initialization before starting
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _startListeningContinuous();
    });
  }
  
  @override
  void didUpdateWidget(VoiceCommandManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.commands != widget.commands) {
      _commandHandler.commands = widget.commands;
    }
    if (oldWidget.onCommandMatched != widget.onCommandMatched) {
        _commandHandler.onCommandMatched = widget.onCommandMatched;
    }
  }

  void _startListeningContinuous() async {
     // Start listening. The command handler will trigger callbacks when words match.
     _commandHandler.startListening(localeId: widget.localeId);
     
     // Listen to the handler to restart if it stops (e.g., due to a timeout)
     _commandHandler.addListener(_onSpeechStateChanged);
  }
  
  void _onSpeechStateChanged() {
    // If speech initialization is done but it's not listening (maybe it timed out or stopped),
    // and we want continuous listening, we can restart it.
    // For simplicity in this version, we will just start it if it stopped.
    // Adding a short delay to prevent thrashing if it errors out rapidly.
    if (_commandHandler.isSpeechEnabled && !_commandHandler.isListening) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_commandHandler.isListening) {
           _commandHandler.startListening(localeId: widget.localeId);
        }
      });
    }
  }

  @override
  void dispose() {
    _commandHandler.removeListener(_onSpeechStateChanged);
    _commandHandler.stopListening();
    _commandHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We optionally provide the handler down the tree via an InheritedWidget if needed later.
    // For now, it just wraps the child.
    return widget.child;
  }
}
