import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/analysis_history.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.analysisHistory,
    required this.onChangeDate,
    required this.calendarFormat,
    this.header = true,
    this.date,
  });

  final List<AnalysisHistory> analysisHistory;
  final Function(DateTime, List<AnalysisHistory> Function(DateTime)) onChangeDate;
  final CalendarFormat calendarFormat;
  final bool header;
  final DateTime? date;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final _kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final _kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  late DateTime _focusedDay;
  DateTime? _selectedDay;

  List<AnalysisHistory> _getEventForDay(DateTime day) {
    List<AnalysisHistory> analysisHistory = [];
    for (var element in widget.analysisHistory) {
      if (!isSameDay(DateTime.parse(element.date), day)) continue;

      analysisHistory.add(element);
    }

    return analysisHistory;
  }

  @override
  void initState() {
    super.initState();

    _focusedDay = widget.date ?? DateTime.now();
    _selectedDay = _focusedDay;
    widget.onChangeDate(widget.date ?? _focusedDay, _getEventForDay);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
      firstDay: _kFirstDay,
      lastDay: _kLastDay,
      focusedDay: _focusedDay,
      currentDay: _focusedDay,
      eventLoader: _getEventForDay,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: null,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: null,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        markerDecoration: BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
        ),
      ),
      locale: "id_ID",
      calendarFormat: widget.calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          widget.onChangeDate(selectedDay, _getEventForDay);
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      headerVisible: widget.header,
    );
  }
}
