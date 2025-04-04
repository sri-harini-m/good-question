import 'package:flutter/material.dart';
import 'package:goodquestion/screens/about_screen.dart';
import 'package:goodquestion/screens/ai_generation_screen.dart';
import 'package:goodquestion/screens/documentation_screen.dart';
import 'package:goodquestion/screens/home_screen.dart';
import 'package:goodquestion/screens/input_screen.dart';
import 'package:goodquestion/screens/optimization_screen.dart';
import 'package:goodquestion/screens/results_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drug Discovery Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/input': (context) => const InputScreen(),
        '/ai_generation': (context) => AiGenerationScreen(userInput: ModalRoute.of(context)!.settings.arguments as String),
        '/results': (context) => const ResultsScreen(),
        '/optimization': (context) => const OptimizationScreen(),
        '/documentation': (context) => const DocumentationScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
