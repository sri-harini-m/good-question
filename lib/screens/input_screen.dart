import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> selectedProteins = [];
  String otherProtein = '';
  String smileStructure = '';
  String proteinProperties = '';
  String potency = '';
  String? ingestionMethod;
  String constraints = '';
  String? fileContentBase64;

  List<String> proteinOptions = [
    'BRCA1',
    'EGFR',
    'VEGF',
    'TP53',
    'TNF-alpha',
    'ACE2'
  ];
  List<String> ingestionOptions = [
    'Injection',
    'Pill',
    'Syrup',
    'Dissolving in Water',
    'Inhaling'
  ];

  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            fileContentBase64 = base64Encode(bytes);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Could not read file bytes')),
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Input parameters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Target Proteins'),
              Wrap(
                spacing: 8.0,
                children: proteinOptions.map((protein) {
                  return FilterChip(
                    label: Text(protein),
                    selected: selectedProteins.contains(protein),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedProteins.add(protein);
                        } else {
                          selectedProteins.remove(protein);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Add other target protein',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => otherProtein = value),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter SMILES structure (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => smileStructure = value),
              ),
              const SizedBox(height: 15),
              const Text('Properties of Target Protein'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter protein properties',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (value) => setState(() => proteinProperties = value),
              ),
              const SizedBox(height: 15),
              const Text('Desired Drug Properties'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter potency (nM)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => potency = value),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select method of ingestion',
                  border: OutlineInputBorder(),
                ),
                value: ingestionMethod,
                items: ingestionOptions.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    ingestionMethod = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text('Constraints'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter any constraints (e.g., other medications)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (value) => setState(() => constraints = value),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickPDF,
                child: const Text('Upload PDF Report'),
              ),
              if (fileContentBase64 != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'File uploaded successfully',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() {
    String proteinsText = selectedProteins.isEmpty
        ? 'None selected'
        : selectedProteins.join(", ");
    String otherProteinText =
        otherProtein.isEmpty ? 'Not specified' : otherProtein;
    String smileText =
        smileStructure.isEmpty ? 'Not specified' : smileStructure;
    String propertiesText =
        proteinProperties.isEmpty ? 'Not specified' : proteinProperties;
    String potencyText = potency.isEmpty ? 'Not specified' : '$potency nM';
    String ingestionText = ingestionMethod ?? 'Not specified';
    String constraintsText = constraints.isEmpty ? 'None' : constraints;
    String fileText = fileContentBase64 ?? 'None';

    String userInput = 'Selected Proteins: $proteinsText\n'
        'Other Protein: $otherProteinText\n'
        'SMILES Structure: $smileText\n'
        'Protein Properties: $propertiesText\n'
        'Desired Potency: $potencyText\n'
        'Ingestion Method: $ingestionText\n'
        'Constraints: $constraintsText\n'
        'File Content: $fileText';

    print(userInput);

    Navigator.pushNamed(
      context,
      '/ai_generation',
      arguments: userInput,
    );
  }
}
