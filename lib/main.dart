import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const VoiceNoteApp());
}

class VoiceNoteApp extends StatelessWidget {
  const VoiceNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Note Recorder',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto', // Change to your preferred font, or add a custom font
        scaffoldBackgroundColor: const Color(0xFF101820),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 1.1),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
