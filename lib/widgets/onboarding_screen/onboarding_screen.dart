import 'package:flutter/material.dart';

import './onboarding_item_widget.dart';
import '../utility/dialog_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding-screen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var _pageIndex = 0;

  final List _onboardData = const [
    {
      'text': 'Skin Analyzer membantu kamu menemukan permasalahan kulit wajahmu',
      'imagePath': 'assets/images/onboarding_illustrations/1.png',
      'italicRanges': null,
    },
    {
      'text': 'Menggunakan teknologi machine learning untuk mendapatkan hasil yang akurat',
      'imagePath': 'assets/images/onboarding_illustrations/2.png',
      'italicRanges': [
        [22, 38]
      ],
    },
    {
      'text': 'Coba gunakan aplikasi Skin Analyzer sekarang dan cari tahu masalah kulit wajah kamu dengan mudah',
      'imagePath': 'assets/images/onboarding_illustrations/3.png',
      'italicRanges': null,
    },
  ];

  Widget _buildPageIndicator(BuildContext context) {
    if (_pageIndex == _onboardData.length - 1) {
      return ElevatedButton(
        onPressed: () async {
          buildDialog(context);
        },
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text('Selanjutnya'),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_onboardData.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.only(right: 5),
            height: 5,
            width: _pageIndex == index ? 20 : 5,
            decoration: BoxDecoration(
              color: _pageIndex == index ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                children: _onboardData
                    .map(
                      (item) => OnboardingItem(
                        text: item['text'],
                        imagePath: item['imagePath'],
                        italicRanges: item['italicRanges'],
                      ),
                    )
                    .toList(),
                onPageChanged: (value) {
                  setState(() => _pageIndex = value);
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _buildPageIndicator(context),
            )
          ],
        ),
      ),
    );
  }
}
