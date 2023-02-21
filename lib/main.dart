import 'package:flutter/material.dart';

import './widgets/utility/splash_screen.dart';
import './widgets/analysis/jerawat_analysis_screen.dart';
import './widgets/main_screen.dart';
import './widgets/onboarding_screen/onboarding_screen.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UII Skin Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        MainScreen.routeName: (context) => const MainScreen(),
        JerawatAnalysisScreen.routeName: (context) => const JerawatAnalysisScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
      },
    );
  }
}
