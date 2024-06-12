import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/providers/splash_provider.dart';
import 'package:health_app_2/presentation/screens/login_screen.dart';
import 'package:health_app_2/presentation/screens/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashProvider provider = di.get<SplashProvider>();

  void updateScreen() => setState(() {});

  double opacity = 0;

  @override
  void initState() {
    provider.checkLoginUser();
    Future.delayed(const Duration(milliseconds: 500), () => setState(() {
      if (mounted) {
        opacity = 1;
      }
    }));
    Future.delayed(const Duration(milliseconds: 4000), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => provider.isLoginUser ? TabScreen() : LoginScreen()),
            (route) => false,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: opacity,
          child: const Text(
            'MY Health DATA',
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}
