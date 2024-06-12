import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health_app_2/presentation/component/colors.dart';

class BarGraph extends CustomPainter {
  final List<int> data;
  final int maxValue;

  BarGraph({super.repaint, required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = primary
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke;

    final double gap = ((size.width) - (paint.strokeWidth)) / (data.length - 1);
    double distance = paint.strokeWidth / 2;

    Path path = Path();

    for (int val in data) {
      if (val > maxValue) val = maxValue;
      path.moveTo(distance, size.height);
      path.lineTo(distance, size.height - (size.height * (val / maxValue)));
      canvas.drawPath(path, paint);
      path.reset();
      distance += gap;
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}