import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiGenerationScreen extends StatefulWidget {
  final String userInput;
  const AiGenerationScreen({super.key, required this.userInput});

  @override
  _AiGenerationScreenState createState() => _AiGenerationScreenState();
}

class _AiGenerationScreenState extends State<AiGenerationScreen> {
  String generatedMolecule =
      "Generating potential molecules...\nAI is currently generating potential drug candidates...";
  int elapsedTime = 0;
  bool isPaused = false;
  bool isStopped = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    fetchMoleculeFromAI();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!isPaused && !isStopped) {
        setState(() {
          elapsedTime++;
        });
      }
    });
  }

  Future<void> fetchMoleculeFromAI() async {
    try {
      final inputData = widget.userInput;
      // final protein = inputData['protein'];
      // final weight = inputData['weight'];
      // final properties = inputData['properties'];
      await dotenv.load(fileName: "../../.env");
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Generate a potential molecule that interacts with protein, has $inputData. Just return a molecule and its SMILES notation string maybe, just that nothing else. Output :molecular structure of drug candidate (give name if exists as medication already), properties of drug,potential side effects,estimated shelf life (how long till it expires),description of the drug and how it interacts with the protein.'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          generatedMolecule = data['candidates'][0]['content']['parts'][0]
                  ['text'] ??
              "No molecule generated";
        });
      } else {
        setState(() {
          generatedMolecule =
              "Error: Failed to fetch molecule (Status: ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        generatedMolecule = "Error: $e";
      });
    }
  }

  void togglePauseResume() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void stopGeneration() {
    setState(() {
      isStopped = true;
      timer?.cancel();
      generatedMolecule = "Generation stopped.";
    });
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
              Text(
                generatedMolecule,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              // const SizedBox(height: 16),
              // const Text(
              //   'AI is currently generating potential drug candidates...',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 16),
              // ),
              const SizedBox(height: 20),
              Text(
                'Time elapsed: ${elapsedTime}s',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: togglePauseResume,
                    child: Text(isPaused ? 'Resume' : 'Pause'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: stopGeneration,
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
