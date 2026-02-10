import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz de Ciberseguridad')),
      drawer: const CustomDrawer(currentPage: 'Quiz'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text('Evaluación de Conocimientos', style: TextStyle(fontSize: 18)),
            Text(
              '(Espacio reservado para desarrollo)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
