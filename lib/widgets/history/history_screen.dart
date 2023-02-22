import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uii_skin_analyzer/widgets/history/chart_card_history.dart';

import './calendar_card_history.dart';
import '../../helpers/json.dart';
import '../../helpers/db.dart';
import '../../models/analysis_history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<List<AnalysisHistory>> _fetchAndSetAnalysisHistory() async {
    final rawData = await DBHelper.getData('analysis_results');
    return rawData
        .map(
          (data) => AnalysisHistory(
            id: data['id'],
            imagePath: data['image_path'],
            jerawatResult: data['jerawat_result'],
            keriputResult: data['keriput_result'],
            kemerahanResult: data['kemerahan_result'],
            bercakHitamResult: data['bercak_hitam_result'],
            jenisKulitResult: data['jenis_kulit_result'],
            date: data['date'],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchAndSetAnalysisHistory(),
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                CalendarCardHistory(analysisHistory: snapshot.data!),
                ChartCardHistory(analysisHistory: snapshot.data!),
              ],
            ),
    );
  }
}
