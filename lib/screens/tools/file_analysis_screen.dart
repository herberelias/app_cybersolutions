import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class FileAnalysisScreen extends StatelessWidget {
  const FileAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Archivos')),
      drawer: const CustomDrawer(currentPage: 'Files'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_present_rounded, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Scanner de Malware en Archivos',
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
