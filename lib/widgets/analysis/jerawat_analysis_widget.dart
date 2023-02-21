import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utility/notification_card_widget.dart';
import '../../helpers/json.dart';
import '../../helpers/draw_circle.dart';

class JerawatAnalysisWidget extends StatelessWidget {
  const JerawatAnalysisWidget({
    super.key,
    this.isServerError = false,
    required this.jerawatCount,
    required this.imageFile,
    required this.jerawatData,
    this.saveImageButton = const SizedBox(),
  });

  final bool isServerError;
  final int jerawatCount;
  final File? imageFile;
  final List<Jerawat> jerawatData;
  final Widget saveImageButton;

  Widget _buildNotificationCard() {
    if (isServerError) {
      return const NotificationCard(
          cardColor: Color(0xFFC61717), cardIcon: Icons.cancel_outlined, cardText: 'Maaf, Server sedang tidak tersedia');
    }

    if (jerawatData.isEmpty) return const SizedBox();

    return NotificationCard(
        cardColor: const Color(0xFF17C672), cardIcon: Icons.check_circle_outline, cardText: 'Terdeteksi $jerawatCount jerawat');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: (imageFile == null)
          ? Column(
              children: [
                Lottie.asset('assets/lotties/63534-image-preloader.json'),
                const Text(
                  'Unggah foto wajahmu untuk melakukan analisis',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )
          : Column(
              children: [
                _buildNotificationCard(),
                CustomPaint(
                  foregroundPainter: DrawCircle(
                    jerawats: jerawatData,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFCACACA),
                          ),
                        ),
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      saveImageButton,
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
