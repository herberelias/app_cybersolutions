import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../services/biometric_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/custom_drawer.dart';
import 'chat_screen.dart';
import 'tools/phishing_analysis_screen.dart';
import 'tools/password_analysis_screen.dart';
import 'tools/quiz_screen.dart';
import 'tools/file_analysis_screen.dart';
import 'tools/password_generator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricSetup();
    });
  }

  Future<void> _checkBiometricSetup() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (await authProvider.hasStoredCredentials()) return;

    final canCheckBiometrics = await BiometricService.checkBiometrics();
    if (!canCheckBiometrics) return;

    final prefs = await SharedPreferences.getInstance();
    final declined = prefs.getBool('biometric_declined') ?? false;
    if (declined) return;

    if (!mounted) return;

    _showBiometricDialog(authProvider, prefs);
  }

  void _showBiometricDialog(
    AuthProvider authProvider,
    SharedPreferences prefs,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.fingerprint, color: Color(0xFF6C63FF), size: 28),
            SizedBox(width: 10),
            Text('Activar Huella'),
          ],
        ),
        content: const Text(
          '¿Quieres activar el inicio de sesión con huella digital para entrar más rápido la próxima vez?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await prefs.setBool('biometric_declined', true);
              if (mounted) Navigator.pop(context);
            },
            child: const Text(
              'No, gracias',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.enableBiometrics();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Huella activada correctamente!'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Activar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final nombre = authProvider.user?['nombre'] ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(currentPage: 'Home'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInRight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, $nombre',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Panel de Ciberseguridad',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
                children: [
                  _buildToolCard(
                    context,
                    title: 'Phishing',
                    subtitle: 'Analizar Correos',
                    icon: Icons.mark_email_unread,
                    color: const Color(0xFFFF6B6B),
                    delay: 100,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PhishingAnalysisScreen(),
                      ),
                    ),
                  ),
                  _buildToolCard(
                    context,
                    title: 'Passwords',
                    subtitle: 'Auditoría',
                    icon: Icons.password,
                    color: const Color(0xFF4ECDC4),
                    delay: 200,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PasswordAnalysisScreen(),
                      ),
                    ),
                  ),
                  _buildToolCard(
                    context,
                    title: 'Quiz',
                    subtitle: 'Aprende',
                    icon: Icons.quiz,
                    color: const Color(0xFFFFD93D),
                    delay: 300,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                  _buildToolCard(
                    context,
                    title: 'Archivos',
                    subtitle: 'Scan Malware',
                    icon: Icons.file_present_rounded,
                    color: const Color(0xFF6C63FF),
                    delay: 400,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FileAnalysisScreen(),
                      ),
                    ),
                  ),
                  _buildToolCard(
                    context,
                    title: 'Generador',
                    subtitle: 'Claves Seguras',
                    icon: Icons.vpn_key,
                    color: const Color(0xFFFF9F43),
                    delay: 500,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PasswordGeneratorScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
    required VoidCallback onTap,
  }) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: GlassCard(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
