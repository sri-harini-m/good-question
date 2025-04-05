import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

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
  String optimizationInput = '';

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
      await dotenv.load(fileName: "../../.env");
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) throw Exception('API Key not found in .env');

      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      String? fileContentBase64;
      final fileContentMatch =
          RegExp(r'File Content: (.*)$', multiLine: true).firstMatch(inputData);
      if (fileContentMatch != null && fileContentMatch.group(1) != "None") {
        fileContentBase64 = fileContentMatch.group(1);
      }

      String prompt = fileContentBase64 != null
          ? 'Given the following input parameters:\n$inputData\nAnd the base64-encoded content of the uploaded file (PDF/DOC):\n$fileContentBase64\nDecode the base64 content to access the file data, then optimize or improve the molecule described in the file based on the input parameters. Return: molecular structure of drug candidate (give name if exists as medication already), SMILES notation string, properties of drug, potential side effects, estimated shelf life, description of the drug and how it interacts with the protein.Do not have diffrent sizes for the text, and do not reply like a chat bot'
          : 'Generate a potential molecule that interacts with protein, has these properties: $inputData. Return: molecular structure of drug candidate (give name if exists as medication already), SMILES notation string, properties of drug, potential side effects, estimated shelf life, description of the drug and how it interacts with the protein.Do not have diffrent sizes for the text, and do not reply like a chat bot';

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
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

  Future<void> optimizeMolecule() async {
    if (optimizationInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter optimization changes')),
      );
      return;
    }

    try {
      await dotenv.load(fileName: "../../.env");
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) throw Exception('API Key not found in .env');

      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      String prompt =
          'Optimize the following molecule based on the previous output and user changes:\n'
          'Previous Output:\n$generatedMolecule\n'
          'User Changes/Instructions:\n$optimizationInput\n'
          'Return: updated molecular structure of drug candidate (give name if exists as medication already), SMILES notation string, properties of drug, potential side effects, estimated shelf life, description of the drug and how it interacts with the protein. Do not have diffrent sizes for the text, and do not reply like a chat bot';

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
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
              "No molecule optimized";
          optimizationInput = '';
        });
      } else {
        setState(() {
          generatedMolecule =
              "Error: Failed to optimize molecule (Status: ${response.statusCode})";
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

  Future<void> _downloadReport() async {
    try {
      if (kIsWeb) {
        final blob = html.Blob([generatedMolecule], 'text/plain');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'generated_molecule_report.txt')
          ..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report downloaded')),
        );
      } else {
        if (await Permission.storage.request().isGranted) {
          final directory = await getExternalStorageDirectory();
          if (directory != null) {
            final file =
                File('${directory.path}/generated_molecule_report.txt');
            await file.writeAsString(generatedMolecule);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Report saved to: ${file.path}')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Could not access storage directory')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Generation Progress")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  generatedMolecule,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
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
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _downloadReport,
                      child: const Text('Download Report'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Optimize Molecule',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter changes or optimization instructions',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onChanged: (value) =>
                      setState(() => optimizationInput = value),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: optimizeMolecule,
                  child: const Text('Optimize'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
