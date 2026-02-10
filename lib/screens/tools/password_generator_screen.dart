import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class PasswordGeneratorScreen extends StatelessWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generador Seguro')),
      drawer: const CustomDrawer(currentPage: 'Generator'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.vpn_key, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Generador de Contraseñas Robustas',
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
