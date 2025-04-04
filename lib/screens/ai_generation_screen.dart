import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class AiGenerationScreen extends StatefulWidget {
  final String userInput;
  const AiGenerationScreen({super.key, required this.userInput});

  @override
  State<AiGenerationScreen> createState() => _AiGenerationScreenState();
}

class _AiGenerationScreenState extends State<AiGenerationScreen> {
  bool _isRunning = true;
  int _elapsedTime = 0;
  late Timer _timer;

  String geminiOutput = "Generating potential molecules..."; // Placeholder text

  @override
  void initState() {
    super.initState();
    _startTimer();
    _getGeminiResponse(widget.userInput);
  }

  Future<void> _getGeminiResponse(String userInput) async {
    String? apiKey;
    try {
      final fileContent = await DefaultAssetBundle.of(
        context,
      ).loadString('.idx/integrations.json');
      final jsonData = jsonDecode(fileContent);
      apiKey = jsonData['gemini_api'];
    } catch (e) {}
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        geminiOutput =
            'No \$GEMINI_API_KEY environment variable set.'; // Same error message
      });
      return; // Ensure early exit
    }
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [
      Content.text(
        'Based on this data: $userInput, what could be a potential drug or molecule that interacts with it?',
      ),
    ];
    final response = await model.generateContent(content);
    setState(() {
      geminiOutput = response.text ?? 'No response from Gemini API';
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        setState(() {
          _elapsedTime++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _stopGeneration() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
    print("Generation stopped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Generation Progress")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(geminiOutput),
              const SizedBox(height: 16),
              const Text(
                'AI is currently generating potential drug candidates...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Time elapsed: ${_elapsedTime}s',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleTimer,
                    child: Text(_isRunning ? 'Pause' : 'Resume'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _stopGeneration,
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
