import 'dart:math';

import 'package:flutter/material.dart';

class CircularGraph extends CustomPainter {
  final Color primaryColor;
  final Color backgroundColor;
  final double strokeWidth;
  final int currentValue;
  final int goalValue;

  CircularGraph({
    super.repaint,
    required this.primaryColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.currentValue,
    required this.goalValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - (paint.strokeWidth / 2);

    canvas.drawCircle(center, radius, paint);

    paint.color = primaryColor;
    final double percentage = (2 * pi) * (currentValue / goalValue);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      percentage,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
