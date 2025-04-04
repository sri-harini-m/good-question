import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About us")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About Our Mission",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "This application was developed by a team of passionate AI and drug discovery enthusiasts, driven by the desire to revolutionize the pharmaceutical landscape.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "Our mission is to accelerate the drug discovery process by leveraging the power of Generative AI.",
                 style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                 "We are dedicated to providing researchers with cutting-edge tools to help them develop life-saving treatments, bridging the gap between innovation and accessibility.",
                 style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                "Problem Statement",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "The process of drug discovery is time-consuming, expensive, and often inefficient, with a high rate of failure in clinical trials. Traditional methods rely heavily on trial and error, requiring years of research and significant financial investment. Additionally, the complexity of biological systems and the vast chemical space make it challenging to identify promising drug candidates efficiently. Generative AI, with its ability to analyze large datasets, predict molecular interactions, and generate novel compounds, has the potential to revolutionize this process. However, there is a lack of accessible, user-friendly tools that leverage generative AI to assist researchers in accelerating drug discovery while reducing costs and improving success rates.",
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    ));
  }
}