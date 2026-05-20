import 'package:flutter/material.dart';
import 'app_logo.dart';
import 'main.dart'; 
import 'login_screen.dart';
import 'context_extensions.dart';

/// 🚀 Écran de démarrage professionnel et réactif
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialisation réactive via l'Initializer
    await AppInitializer.initialize(context);
    
    // Temps d'affichage minimal pour la fluidité visuelle
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Design de fond moderne adaptatif
          Positioned(
            top: -100,
            right: -100,
            child: _buildDecorativeCircle(brandColor.withOpacity(0.05), 300),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildDecorativeCircle(brandColor.withOpacity(0.03), 200),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: const AppLogo(size: 180),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        "BALAGH DZ",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: brandColor,
                          letterSpacing: 4,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.isArabic ? "نظام التبليغ عن الحوادث" : "Incident Reporting System",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Indicateur de progression RÉACTIF
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 2,
                      child: LinearProgressIndicator(
                        backgroundColor: brandColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(brandColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ✅ ÉCOUTE DU CHANGEMENT D'ÉTAT
                    ValueListenableBuilder<String>(
                      valueListenable: AppInitializer.loadingStep,
                      builder: (context, step, child) {
                        return Text(
                          step.toUpperCase(),
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
