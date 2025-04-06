import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
    with SingleTickerProviderStateMixin {
  List<String> selectedProteins = [];
  String otherProtein = '';
  String smileStructure = '';
  String proteinProperties = '';
  String potency = '';
  String? ingestionMethod;
  String constraints = '';
  String? fileContentBase64;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

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

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  Widget _sectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            color: Colors.deepPurpleAccent,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: const Text(
          'Drug Design Assistant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            child: const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/documentation');
            },
            child: const Text(
              'Documentation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeIn,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/header.jpg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Drug Design Assistant",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Describe your target drug properties and let our AI assist in your discovery process.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      color: Colors.black12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader("Target Proteins"),
                    Wrap(
                      spacing: 8,
                      children: proteinOptions.map((protein) {
                        return FilterChip(
                          label: Text(protein),
                          selected: selectedProteins.contains(protein),
                          onSelected: (selected) {
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
                      decoration: _inputDecoration("Other target protein"),
                      onChanged: (val) => setState(() => otherProtein = val),
                    ),
                    _sectionHeader("SMILES Structure"),
                    TextField(
                      decoration: _inputDecoration("Enter SMILES structure"),
                      onChanged: (val) => setState(() => smileStructure = val),
                    ),
                    _sectionHeader("Protein Properties"),
                    TextField(
                      maxLines: 3,
                      decoration:
                          _inputDecoration("Enter protein characteristics"),
                      onChanged: (val) =>
                          setState(() => proteinProperties = val),
                    ),
                    _sectionHeader("Drug Characteristics"),
                    TextField(
                      decoration: _inputDecoration("Potency (nM)"),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => setState(() => potency = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Select ingestion method"),
                      value: ingestionMethod,
                      items: ingestionOptions.map((method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => ingestionMethod = val),
                    ),
                    _sectionHeader("Constraints"),
                    TextField(
                      maxLines: 3,
                      decoration:
                          _inputDecoration("Enter constraints or conditions"),
                      onChanged: (val) => setState(() => constraints = val),
                    ),
                    _sectionHeader("Supporting Documents"),
                    ElevatedButton.icon(
                      onPressed: _pickPDF,
                      icon: const Icon(Icons.attach_file),
                      label: const Text("Upload PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    if (fileContentBase64 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '📄 File uploaded successfully',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
