import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_drawer.dart';
import '../../services/quiz_service.dart';
import '../../providers/theme_provider.dart';
import 'quiz_active_screen.dart';

class QuizWelcomeScreen extends StatefulWidget {
  const QuizWelcomeScreen({super.key});

  @override
  State<QuizWelcomeScreen> createState() => _QuizWelcomeScreenState();
}

class _QuizWelcomeScreenState extends State<QuizWelcomeScreen> {
  final QuizService _quizService = QuizService();
  List<dynamic> _history = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final result = await _quizService.getHistory();
    if (mounted) {
      setState(() {
        if (result['success']) {
          _history = result['history'] ?? [];
        }
        _isLoadingHistory = false;
      });
    }
  }

  void _startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizActiveScreen()),
    ).then((_) => _loadHistory()); // Recargar historial al volver
  }

  void _showHistoryDetail(Map<String, dynamic> item) {
    final int score = item['score'];
    final int total = item['total_questions'];
    final double percentage = (score / total) * 100;
    final String feedback = item['ai_feedback'] ?? 'Sin feedback disponible.';

    final isDark = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dialogBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final feedbackBg = isDark ? Colors.black26 : Colors.grey[100];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.history_edu, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Text('Detalle del Intento', style: TextStyle(color: textColor)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Score Circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getScoreColor(score).withOpacity(0.1),
                  border: Border.all(color: _getScoreColor(score), width: 5),
                ),
                child: Center(
                  child: Text(
                    '$score/$total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(score),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                percentage >= 70 ? '¡Aprobado!' : 'Sigue Intentando',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(score),
                ),
              ),
              const Divider(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Feedback del Mentor IA:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: feedbackBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  feedback,
                  style: TextStyle(fontSize: 14, height: 1.4, color: textColor),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Cyber Challenge')),
      drawer: const CustomDrawer(currentPage: 'Quiz'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  FadeInDown(
                    child: const Icon(
                      Icons.security_rounded,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Pon a prueba tus conocimientos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInDown(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'Responde 20 preguntas aleatorias y recibe feedback personalizado de nuestra IA.',
                      style: TextStyle(fontSize: 16, color: subTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Pulse(
                    infinite: true,
                    child: ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'COMENZAR QUIZ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historial de Intentos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (_isLoadingHistory) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (_history.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'Aún no has realizado ningún quiz.',
                      style: TextStyle(color: subTextColor),
                    ),
                  ),
                );
              }
              final item = _history[index];
              return FadeInLeft(
                delay: Duration(milliseconds: index * 100),
                child: Card(
                  color: cardColor,
                  elevation: isDark ? 2 : 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () => _showHistoryDetail(item),
                    leading: CircleAvatar(
                      backgroundColor: _getScoreColor(item['score']),
                      child: Text(
                        '${item['score']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Puntuación: ${item['score']}/${item['total_questions']}',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      item['created_at']
                          .toString()
                          .substring(0, 16)
                          .replaceAll('T', ' '),
                      style: TextStyle(color: subTextColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: subTextColor,
                    ),
                  ),
                ),
              );
            }, childCount: _history.isEmpty ? 1 : _history.length),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 18) return Colors.green;
    if (score >= 14) return Colors.orange;
    return Colors.red;
  }
}
