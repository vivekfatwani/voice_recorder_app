import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101820),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your photo (ensure the asset exists and is declared in pubspec.yaml)
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/vivek_fatwani.jpg'),
            ),
            const SizedBox(height: 24),
            const Text(
              "Voice Recorder App",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "A simple and modern voice recording app.\n\n"
              "Made by Vivek Fatwani",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
