import 'dart:math';
import 'package:flutter/material.dart';

import './json.dart';

class DrawCircle extends CustomPainter {
  DrawCircle({required this.jerawats});
  final List<Jerawat> jerawats;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color(0xff1572A1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (var jerawat in jerawats) {
      if (jerawat.score! > 0.3) {
        var ymin = jerawat.ymin, xmin = jerawat.xmin, ymax = jerawat.ymax, xmax = jerawat.xmax;
        var left = xmin! * size.width;
        var right = xmax! * size.width;
        var top = ymin! * size.height;
        var bottom = ymax! * size.height;
        var boxH = bottom - top, boxW = right - left;
        var radius = sqrt(pow(boxH, 2) + pow(boxW, 2)) / 2;

        canvas.drawCircle(
            Offset(
              left + boxW / 2,
              top + boxH / 2,
            ),
            radius,
            paint1);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
