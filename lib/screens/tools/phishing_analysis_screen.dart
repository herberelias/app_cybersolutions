import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class PhishingAnalysisScreen extends StatelessWidget {
  const PhishingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Phishing')),
      drawer: const CustomDrawer(currentPage: 'Phishing'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_unread, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Herramienta de Análisis de Correos',
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
