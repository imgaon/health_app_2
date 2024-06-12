import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ArchGraph extends CustomPainter {
  final int currentValue;
  final int targetValue;
  final double strokeWidth;
  final double rulerWidth;
  final Color backgroundColor;
  final Color primaryColor;
  final Color rulerColor;
  final double startAngle;
  final double sweepAngle;
  final bool useCenter;
  final PaintingStyle style;

  ArchGraph({
    super.repaint,
    required this.currentValue,
    required this.targetValue,
    required this.strokeWidth,
    required this.rulerWidth,
    required this.backgroundColor,
    required this.primaryColor,
    required this.rulerColor,
    required this.startAngle,
    required this.sweepAngle,
    required this.useCenter,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = style;

    final center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width / 2) - (paint.strokeWidth / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      useCenter,
      paint,
    );

    paint.color = primaryColor;
    double percentage = sweepAngle * (currentValue / targetValue);
    if (currentValue > targetValue) percentage = sweepAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      percentage,
      useCenter,
      paint,
    );
    
    paint.color = rulerColor;
    paint.strokeWidth = rulerWidth;
    radius -= 30;

    final Path path = Path();
    path.addArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle);

    const double dashSpace = 20;
    double distance = 0;

    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        final Path extractPath = measurePath.extractPath(distance, distance);
        canvas.drawPath(extractPath, paint);
        distance += dashSpace;
      }
      distance = 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
