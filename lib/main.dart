import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './widgets/utility/splash_screen.dart';
import './widgets/onboarding/onboarding_screen.dart';
import './widgets/main_screen.dart';
import './widgets/analysis/jerawat_analysis_screen.dart';
import './widgets/analysis/keriput_analysis_screen.dart';
import './widgets/analysis/kemerahan_analysis_screen.dart';
import './widgets/analysis/bercak_hitam_analysis_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        KeriputAnalysisScreen.routeName: (context) => const KeriputAnalysisScreen(),
        KemerahanAnalysisScreen.routeName: (context) => const KemerahanAnalysisScreen(),
        BercakHitamAnalysisScreen.routeName: (context) => const BercakHitamAnalysisScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
      },
    );
  }
}
