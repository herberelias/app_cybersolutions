import 'package:flutter/material.dart';
import '../../services/quiz_service.dart';
import 'quiz_result_screen.dart';

class QuizActiveScreen extends StatefulWidget {
  const QuizActiveScreen({super.key});

  @override
  State<QuizActiveScreen> createState() => _QuizActiveScreenState();
}

class _QuizActiveScreenState extends State<QuizActiveScreen> {
  final QuizService _quizService = QuizService();
  List<dynamic> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  final Map<int, String> _userAnswers = {}; // Map<QuestionID, Option>
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final result = await _quizService.getQuestions();
    if (mounted) {
      setState(() {
        if (result['success']) {
          _questions = result['data'] ?? [];
        }
        _isLoading = false;
      });
    }
  }

  void _selectOption(String option) {
    setState(() {
      _userAnswers[_questions[_currentIndex]['id']] = option;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  Future<void> _submitQuiz() async {
    if (_userAnswers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor responde todas las preguntas')),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    // Preparar lista para enviar
    List<Map<String, dynamic>> answersToSend = [];
    _userAnswers.forEach((key, value) {
      answersToSend.add({'id': key, 'option': value});
    });

    final result = await _quizService.submitQuiz(answersToSend);

    if (mounted) {
      setState(() {
        _submitting = false;
      });

      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(resultData: result),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No se pudieron cargar las preguntas.')),
      );
    }

    final question = _questions[_currentIndex];
    final selectedOption = _userAnswers[question['id']];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${_currentIndex + 1} de ${_questions.length}'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 20),

            // Categoría
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question['category'] ?? 'General',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),

            // Pregunta
            Text(
              question['question_text'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Opciones
            Expanded(
              child: ListView(
                children: [
                  _buildOptionCard('A', question['option_a'], selectedOption),
                  _buildOptionCard('B', question['option_b'], selectedOption),
                  _buildOptionCard('C', question['option_c'], selectedOption),
                  _buildOptionCard('D', question['option_d'], selectedOption),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botones de navegación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Anterior'),
                  )
                else
                  const SizedBox(),

                if (_submitting)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentIndex == _questions.length - 1
                          ? Colors.green
                          : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _currentIndex == _questions.length - 1
                          ? 'Finalizar'
                          : 'Siguiente',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String optionKey,
    String text,
    String? selectedOption,
  ) {
    final isSelected = selectedOption == optionKey;
    return GestureDetector(
      onTap: () => _selectOption(optionKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.grey.shade200,
              ),
              child: Center(
                child: Text(
                  optionKey,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.blue[900] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
