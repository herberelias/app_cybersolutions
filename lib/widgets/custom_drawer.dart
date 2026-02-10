import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/home_screen.dart';
import '../screens/tools/phishing_analysis_screen.dart';
import '../screens/tools/password_analysis_screen.dart';
import '../screens/tools/quiz_screen.dart';
import '../screens/tools/file_analysis_screen.dart';
import '../screens/tools/password_generator_screen.dart';

class CustomDrawer extends StatelessWidget {
  final String currentPage;

  const CustomDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final nombre = authProvider.user?['nombre'] ?? 'Usuario';
    final email = authProvider.user?['email'] ?? 'correo@ejemplo.com';
    final iniciales = nombre.isNotEmpty
        ? nombre.substring(0, 1).toUpperCase()
        : 'U';
    final isDark = themeProvider.isDarkMode;

    // Colores base para el diseño
    final activeColor = isDark
        ? const Color(0xFF6C63FF)
        : const Color(0xFF4834D4);
    final activeBgColor = activeColor.withOpacity(0.15);
    final inactiveColor = isDark ? Colors.white70 : Colors.black87;

    return Drawer(
      // Borde redondeado solo en la derecha para un look más moderno
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Header Diseño Premium
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                    : [
                        const Color(0xFF6C63FF).withOpacity(0.9),
                        const Color(0xFF4834D4),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: isDark
                        ? const Color(0xFF0F3460)
                        : Colors.white,
                    child: Text(
                      iniciales,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : activeColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  text: 'Inicio',
                  isActive: currentPage == 'Home',
                  activeColor: activeColor,
                  activeBgColor: activeBgColor,
                  inactiveColor: inactiveColor,
                  onTap: () => _navigate(context, const HomeScreen()),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    'HERRAMIENTAS',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.mark_email_unread_rounded,
                  text: 'Phishing',
                  isActive: currentPage == 'Phishing',
                  activeColor: activeColor,
                  activeBgColor: activeBgColor,
                  inactiveColor: inactiveColor,
                  onTap: () =>
                      _navigate(context, const PhishingAnalysisScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.password_rounded,
                  text: 'Passwords',
                  isActive: currentPage == 'Passwords',
                  activeColor: activeColor,
                  activeBgColor: activeBgColor,
                  inactiveColor: inactiveColor,
                  onTap: () =>
                      _navigate(context, const PasswordAnalysisScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.quiz_rounded,
                  text: 'Quiz',
                  isActive: currentPage == 'Quiz',
                  activeColor: activeColor,
                  activeBgColor: activeBgColor,
                  inactiveColor: inactiveColor,
                  onTap: () => _navigate(context, const QuizScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.file_present_rounded,
                  text: 'Analizar Archivos',
                  isActive: currentPage == 'Files',
                  activeColor: activeColor,
                  activeBgColor: activeBgColor,
                  inactiveColor: inactiveColor,
                  onTap: () => _navigate(context, const FileAnalysisScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.vpn_key_rounded,
                  text: 'Generador',
                  isActive: currentPage == 'Generator',
                  activeColor: activeColor,
                  activeBgColor: activeBgColor,
                  inactiveColor: inactiveColor,
                  onTap: () =>
                      _navigate(context, const PasswordGeneratorScreen()),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: isDark ? Colors.white : Colors.orange,
                    ),
                    title: Text(
                      isDark ? 'Modo Oscuro' : 'Modo Claro',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Switch(
                      value: isDark,
                      activeColor: activeColor,
                      onChanged: (val) => themeProvider.toggleTheme(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    authProvider.logout();
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'CyberSolutions v1.0.0',
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isActive,
    required Color activeColor,
    required Color activeBgColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? activeColor : inactiveColor,
          size: 26,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: isActive ? activeBgColor : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        trailing: isActive
            ? Container(
                width: 5,
                height: 30,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            : null,
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(
      context,
    ); // Close drawer to avoid stack buildup in UI before replacing
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
