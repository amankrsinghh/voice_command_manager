import 'package:flutter/material.dart';
import 'package:voice_command_manager/voice_command_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Command Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Voice Command Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _lastCommand = 'None';
  bool _saved = false;

  void _nextPage() {
    setState(() {
      _counter++;
      _lastCommand = 'next';
    });
  }

  void _goBack() {
    setState(() {
      _counter = _counter > 0 ? _counter - 1 : 0;
      _lastCommand = 'back';
    });
  }

  void _saveData() {
    setState(() {
      _saved = true;
      _lastCommand = 'save';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data Saved via Voice Command!')),
    );
    
    // Reset saved state after a short delay
    Future.delayed(const Duration(seconds: 2), () {
        if(mounted) setState((){ _saved = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VoiceCommandManager(
      commands: {
        "next": _nextPage,
        "back": _goBack,
        "save": _saveData,
      },
      onCommandMatched: (command) {
        debugPrint('App recognized command: $command');
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Say "next", "back", or "save"',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Current Page/Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
               const SizedBox(height: 20),
              Text(
                'Last Command Recognized: $_lastCommand',
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),
              if (_saved) 
                 const Icon(Icons.check_circle, color: Colors.green, size: 48),
            ],
          ),
        ),
      ),
    );
  }
}
