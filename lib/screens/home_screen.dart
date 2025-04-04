import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drug Discovery Assistant')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Text(
              'Drug Discovery Assistant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Welcome to the future of drug discovery',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/input');
            },
            child: Text('Input'),
          ),
          // SizedBox(height: 10),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/results');
          //   },
          //   child: Text('Results'),
          // ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/optimization');
            },
            child: Text('Optimization'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/documentation');
            },
            child: Text('Documentation'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            child: Text('About'),
          ),
        ],
      ),
    );
  }
}
