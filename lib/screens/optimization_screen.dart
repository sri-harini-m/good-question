import 'package:flutter/material.dart';


class OptimizationScreen extends StatefulWidget {
  const OptimizationScreen({super.key});

  @override
  State<OptimizationScreen> createState() => _OptimizationScreenState();
}

class _OptimizationScreenState extends State<OptimizationScreen> {
  final String candidateName = 'Candidate A';
  final List<String> optimizationOptions = [
    'Binding Affinity',
    'Solubility',
    'Toxicity',
    'Stability'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Optimization")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Optimization Interface",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "You are currently optimizing $candidateName",
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select an option to improve:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: optimizationOptions.map((option) {
                return InkWell(
                  onTap: () {
                    print("Optimizing: $option");
                  },
                  child: Chip(
                    label: Text(option),
                    padding: const EdgeInsets.all(8.0),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("Optimization Submitted");
                },
                child: const Text("Submit Optimization"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}