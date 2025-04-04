import 'package:flutter/material.dart';


class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final List<String> candidateNames = [
    'Candidate A',
    'Candidate B',
    'Candidate C',
    'Candidate D',
    'Candidate E'
  ];

  final List<String> candidateDescriptions = [
    'This candidate has a high predicted binding affinity and good solubility',
    'This candidate has shown promising results in preliminary toxicity tests',
    'This candidate has a unique structure with potential for multi-target activity',
    'This candidate is predicted to be highly stable in biological environments',
    'This candidate exhibits a novel mechanism of action'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Generated Results",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                itemCount: candidateNames.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(candidateNames[index],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      subtitle: Text(candidateDescriptions[index]),
                      contentPadding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}