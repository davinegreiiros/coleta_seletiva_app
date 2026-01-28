import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'municipe_screen.dart';
import 'gestor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Title
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0969DA), Color(0xFF1F6FEB)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.4),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Text(
                    '🗑️',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Coleta Seletiva',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sistema de Gestão de Rotas',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),

                // Menu buttons
                _buildMenuButton(
                  context,
                  icon: '👤',
                  title: 'Coletas',
                  subtitle: 'Acompanhe a coleta em tempo real',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MunicipeScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: '📊',
                  title: 'Gestor',
                  subtitle: 'Gerencie rotas e veículos',
                  isSecondary: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GestorScreen()),
                  ),
                ),

                const SizedBox(height: 48),
                Text(
                  'Versão 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSecondary
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF238636), Color(0xFF2EA043)],
                ),
          color: isSecondary ? Colors.white.withOpacity(0.05) : null,
          borderRadius: BorderRadius.circular(16),
          border: isSecondary
              ? Border.all(color: Colors.white.withOpacity(0.1))
              : null,
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.successGreen.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSecondary
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSecondary ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSecondary
                          ? AppTheme.textSecondary
                          : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isSecondary
                  ? AppTheme.textSecondary
                  : Colors.white.withOpacity(0.8),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
