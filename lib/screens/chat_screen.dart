import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente IA')),
      drawer: const CustomDrawer(currentPage: 'Chat'),
      body: const Center(child: Text('Chat Screen Placeholder')),
    );
  }
}
