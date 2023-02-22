import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../helpers/json.dart';
import '../../models/analysis_history.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key, required this.analysisHistory});

  final List<AnalysisHistory> analysisHistory;

  final List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

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
    return LineChart(
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
            spots: analysisHistory
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
    );
  }
}
