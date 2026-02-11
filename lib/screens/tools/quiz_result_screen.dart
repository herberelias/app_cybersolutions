import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class QuizResultScreen extends StatelessWidget {
  final Map<String, dynamic>
  resultData; // {score, total, ai_feedback, wrong_answers}

  const QuizResultScreen({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
    final int score = resultData['score'];
    final int total = resultData['total'];
    final String feedback =
        resultData['ai_feedback'] ?? 'Sin feedback disponible.';
    final List<dynamic> wrongAnswers = resultData['wrong_answers'] ?? [];

    final double percentage = (score / total) * 100;
    final Map<String, dynamic> badge = _getBadge(percentage);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo claro para resaltar tarjetas
      appBar: AppBar(
        title: const Text('Resultados del Desafío'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // BADGE & SCORE SECTION
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: badge['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: (badge['gradient'][0] as Color).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(badge['icon'], size: 60, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      badge['title'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$score/$total',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Puntuación final',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // MENSAJE MOTIVACIONAL
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Text(
                _getMessage(percentage),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // AI MENTOR CARD
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Feedback del Mentor IA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    Text(
                      feedback,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // REVIEW ERRORS
            if (wrongAnswers.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Repaso de Errores',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wrongAnswers.length,
                itemBuilder: (context, index) {
                  final item = wrongAnswers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border(
                        left: BorderSide(color: Colors.redAccent, width: 4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['question'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tu respuesta: ${item['user_option']}',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Correcta: ${item['correct_option']}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['explanation'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'VOLVER AL INICIO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getBadge(double percentage) {
    if (percentage >= 90) {
      return {
        'title': 'MAESTRO CISO',
        'icon': Icons.security,
        'gradient': [Colors.purple, Colors.deepPurpleAccent], // Púrpura épico
      };
    } else if (percentage >= 70) {
      return {
        'title': 'EXPERTO',
        'icon': Icons.verified_user,
        'gradient': [Colors.green, Colors.teal], // Verde éxito
      };
    } else if (percentage >= 50) {
      return {
        'title': 'APRENDIZ',
        'icon': Icons.shield,
        'gradient': [Colors.orange, Colors.deepOrange], // Naranja progreso
      };
    } else {
      return {
        'title': 'NOVATO',
        'icon': Icons.warning_amber_rounded,
        'gradient': [Colors.redAccent, Colors.red.shade900], // Rojo alerta
      };
    }
  }

  String _getMessage(double percentage) {
    if (percentage >= 90) return '¡Impresionante! Eres una muralla digital.';
    if (percentage >= 70) return '¡Gran trabajo! Estás muy protegido.';
    if (percentage >= 50) return 'Aprobado. Sigue reforzando tu ciberdefensa.';
    return '¡Alerta! Tu seguridad está comprometida. Estudia los consejos.';
  }
}
