import 'package:flutter/material.dart';
import 'quiz_welcome_screen.dart';

// Este archivo actúa como wrapper o redirección hacia la nueva implementación del Quiz
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuizWelcomeScreen();
  }
}
