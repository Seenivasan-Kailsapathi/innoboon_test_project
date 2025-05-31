
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inno_boon_interview/core/constants/app_colors.dart';
import 'package:inno_boon_interview/core/constants/app_images.dart';
import 'package:inno_boon_interview/feature/authenticate/view/auth_state_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<double> logoAnimation;


  @override
  void initState() {
    super.initState();

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutBack),
    );

    logoController.forward();

    // Navigates to AuthStateScreen to check user previously logged-in or not

    Timer(
      const Duration(seconds: 3), () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthStateScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     backgroundColor: AppColors().splashBackgroundColor.shade300,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: logoAnimation,
                child: Image.asset(
                  AppImages().splashIcon,
                  color: Colors.white,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
