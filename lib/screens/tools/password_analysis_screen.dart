import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class PasswordAnalysisScreen extends StatelessWidget {
  const PasswordAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Contraseñas')),
      drawer: const CustomDrawer(currentPage: 'Passwords'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.password, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Herramienta de Auditoría de Passwords',
              style: TextStyle(fontSize: 18),
            ),
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
