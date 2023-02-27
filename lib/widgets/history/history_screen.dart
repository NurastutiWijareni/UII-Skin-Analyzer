import 'package:flutter/material.dart';

import './chart_card_history.dart';
import '../../helpers/functions.dart';
import './calendar_card_history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAndSetAnalysisHistory(),
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
