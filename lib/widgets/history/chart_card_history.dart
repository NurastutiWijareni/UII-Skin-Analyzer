import 'package:flutter/material.dart';
import 'package:uii_skin_analyzer/widgets/history/chart_widget.dart';

import '../../models/analysis_history.dart';

class ChartCardHistory extends StatefulWidget {
  const ChartCardHistory({super.key, required this.analysisHistory});

  final List<AnalysisHistory> analysisHistory;

  @override
  State<ChartCardHistory> createState() => _ChartCardHistoryState();
}

class _ChartCardHistoryState extends State<ChartCardHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: ChartWidget(analysisHistory: widget.analysisHistory),
          ),
        ],
      ),
    );
  }
}
