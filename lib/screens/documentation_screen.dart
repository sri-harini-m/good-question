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
                  "1. Input: Start by entering the target protein, desired properties, and any other details to be considered.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text("2. Generation: View the potential drug candidate based on your input parameters.", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("3. Optimization: Add new details to optimize the results.", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("4. Download: Download the results as a report.", style: TextStyle(fontSize: 16))
              ]),
        )),
    );
  }
}