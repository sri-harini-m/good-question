import 'package:flutter/material.dart';

class DocumentationScreen extends StatefulWidget {
  const DocumentationScreen({super.key});

  @override
  State<DocumentationScreen> createState() => _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documentation",),
      ),  
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                
                Text(
                  "This application is a Drug Discovery Assistant powered by Generative AI. It is designed to help researchers identify, design, and optimize potential drug candidates.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                Text(
                  "How to Use:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "1. Input Screen: Start by entering the target protein, desired properties, and any existing molecules you want to consider.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text("2. AI Generation Screen: View the progress of the AI as it generates potential drug candidates based on your input parameters. You can cancel the generation process at any time.", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("3. Results Screen: Explore the list of generated candidates. Each candidate will have a short description.", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("4. Optimization Screen: Select a candidate from the results screen to start the optimization process", style: TextStyle(fontSize: 16))
              ]),
        )),
    );
  }
}