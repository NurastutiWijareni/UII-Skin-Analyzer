import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import './calendar_card_history.dart';
import '../../helpers/json.dart';
import '../../helpers/db.dart';
import '../../models/analysis_history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

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

  List<Jerawat> _generateJerawats(String rawData) {
    List<Jerawat> jerawats = [];
    var decodedJSON = json.decode(rawData);
    for (var i = 0; i < decodedJSON.length; i++) {
      if (decodedJSON[i]['score'] > 0.3) {
        var jerawat = Jerawat(
          xmax: decodedJSON[i]['xmax'],
          ymax: decodedJSON[i]['ymax'],
          xmin: decodedJSON[i]['xmin'],
          ymin: decodedJSON[i]['ymin'],
          score: decodedJSON[i]['score'],
        );
        jerawats.add(jerawat);
      }
    }
    return jerawats;
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
                AspectRatio(
                  aspectRatio: 1.70,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                        left: 12,
                        top: 24,
                        bottom: 12,
                      ),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(show: false),
                          minX: 0,
                          maxX: 31,
                          minY: 0,
                          maxY: 31,
                          lineBarsData: [
                            LineChartBarData(
                              spots: snapshot.data!
                                  .map(
                                    (item) => FlSpot(
                                      DateTime.parse(item.date).day.toDouble(),
                                      _generateJerawats(item.jerawatResult!).length.toDouble(),
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: gradientColors,
                              ),
                              barWidth: 5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
