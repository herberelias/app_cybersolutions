import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import '../../services/phishing_service.dart';

class PhishingAnalysisScreen extends StatefulWidget {
  const PhishingAnalysisScreen({super.key});

  @override
  State<PhishingAnalysisScreen> createState() => _PhishingAnalysisScreenState();
}

class _PhishingAnalysisScreenState extends State<PhishingAnalysisScreen> {
  final TextEditingController _emailController = TextEditingController();
  final PhishingService _phishingService = PhishingService();

  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;
  List<dynamic> _history = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final result = await _phishingService.getHistory();
    if (mounted) {
      setState(() {
        if (result['success']) {
          _history = result['history'] ?? [];
        }
        _isLoadingHistory = false;
      });
    }
  }

  Future<void> _analyzeEmail() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor pega el contenido del correo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    final result = await _phishingService.analyzeEmail(_emailController.text);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _analysisResult = result['data'];
          _emailController.clear();
          _loadHistory(); // Recargar historial
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Phishing')),
      drawer: const CustomDrawer(currentPage: 'Phishing'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pegar contenido del correo sospechoso:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.black), // Force black text
              controller: _emailController,
              maxLines: 8,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '--- Pegar encabezados y cuerpo del correo aquí ---',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _analyzeEmail,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.analytics),
              label: Text(_isLoading ? 'Analizando...' : 'Analizar Correo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
              ),
            ),

            if (_analysisResult != null) ...[
              const SizedBox(height: 30),
              _buildResultCard(),
            ],

            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            const Text(
              'Historial de Análisis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final bool isPhishing = _analysisResult!['is_phishing'] == true;
    final Color color = isPhishing ? Colors.red : Colors.green;
    final IconData icon = isPhishing ? Icons.warning : Icons.check_circle;

    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(width: 10),
                Text(
                  isPhishing ? '¡POSIBLE PHISHING!' : 'PARECE SEGURO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Nivel de Riesgo: ${_analysisResult!['risk_level']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _analysisResult!['analysis'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDetail(Map<String, dynamic> item) {
    final bool isPhishing =
        item['is_phishing'] == 1 || item['is_phishing'] == true;
    final Color color = isPhishing ? Colors.red : Colors.green;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(isPhishing ? Icons.warning : Icons.check_circle, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isPhishing ? 'Phishing Detectado' : 'Correo Seguro',
                style: TextStyle(color: color),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Análisis:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item['analysis_result'] ?? 'Sin detalle'),
              const SizedBox(height: 15),
              const Text(
                'Contenido Analizado:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text(
                  item['email_content'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Monospace',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Fecha: ${item['created_at']?.toString().substring(0, 16).replaceAll('T', ' ')}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

  Widget _buildHistoryList() {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_history.isEmpty) {
      return const Center(child: Text('No hay análisis previos.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        final bool isPhishing =
            item['is_phishing'] == 1 || item['is_phishing'] == true;

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            onTap: () => _showHistoryDetail(item),
            leading: Icon(
              isPhishing ? Icons.warning : Icons.check_circle,
              color: isPhishing ? Colors.red : Colors.green,
            ),
            title: Text(
              isPhishing ? 'Phishing Detectado' : 'Correo Seguro',
              style: TextStyle(
                color: isPhishing ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item['email_content'] as String).length > 50
                      ? '${(item['email_content'] as String).substring(0, 50)}...'
                      : item['email_content'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['created_at'] != null
                      ? item['created_at']
                            .toString()
                            .substring(0, 16)
                            .replaceAll('T', ' ')
                      : '',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}
