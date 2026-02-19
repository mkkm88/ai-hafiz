import 'package:flutter/material.dart';
import '../../selector/screens/selector_screen.dart';
import '../../../core/enums/app_mode.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Icon(
                  Icons.auto_awesome,
                  size: 64,
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'AI Hafiz',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your Personal Quran Coach',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                _buildModeCard(
                  context,
                  title: 'Prompt Mode',
                  description:
                      'Supportive coaching with quick hints. Best for practice.',
                  icon: Icons.lightbulb_outline,
                  color: AppTheme.primaryColor,
                  onTap: () => _navigateToSelector(context, AppMode.prompt),
                ),
                const SizedBox(height: 16),
                _buildModeCard(
                  context,
                  title: 'Test Mode',
                  description:
                      'Strict checking with minimal help. Evaluate your Hifz.',
                  icon: Icons.verified_user_outlined,
                  color:
                      AppTheme.errorColor, // Use a distinct color for Test Mode
                  onTap: () => _navigateToSelector(context, AppMode.test),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSelector(BuildContext context, AppMode mode) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => SelectorScreen(mode: mode)));
  }
}
