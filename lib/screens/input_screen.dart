import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> selectedProteins = [];
  String otherProtein = '';
  String molecularWeight = '';
  List<String> proteinOptions = ['BRCA1', 'EGFR', 'VEGF', 'TP53', 'TNF-alpha', 'ACE2'];
  String? filePath;


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
                onChanged: (value) {
                  setState(() {
                    otherProtein = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter molecular weight',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => molecularWeight = value,
              ),             
              const SizedBox(height: 15),
              const Text("Desired Properties"),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter desired properties',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) => otherProtein = value,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // FilePickerResult? result = await FilePicker.platform.pickFiles();

                  // if (result != null) {
                  //     setState(() {
                  //        filePath = result.files.single.path;
                  //     });
                    
                  //   print('File path: ${result.files.single.path}');
                  // } else {
                  //   print('No file selected');
                  // }
                },
                child: const Text('Select Existing Molecules File'),
              ),
                 if (filePath != null)
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text('Selected file path: $filePath'),
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
    String userInput = 'Selected Proteins: ${selectedProteins.join(", ")}\n'
        'Molecular Weight: $molecularWeight\n'
        'Other Protein: $otherProtein';
    print(userInput);

    Navigator.pushNamed(
      context,
      '/ai_generation',
      arguments: userInput,
    );
  }
}