import 'package:flutter/material.dart';

class BmiGraph extends CustomPainter {
  final double height;
  final double weight;

  BmiGraph({super.repaint, required this.height, required this.weight});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = Colors.redAccent
        ..strokeWidth = 25
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

    final double center = size.height / 2;
    const double startPoint = 20;
    final double endPoint = size.width - 20;

    Path path = Path();
    path.moveTo(startPoint, center);
    path.lineTo(endPoint, center);
    canvas.drawPath(path, paint);
    path.reset();

    paint.color = Colors.yellow;
    paint.strokeCap = StrokeCap.butt;
    path.moveTo(startPoint, center);
    path.lineTo(endPoint * (25 / 40), center);
    canvas.drawPath(path, paint);
    path.reset();

    paint.color = Colors.lightGreen;
    paint.strokeCap = StrokeCap.butt;
    path.moveTo(startPoint, center);
    path.lineTo(endPoint * (23 / 40), center);
    canvas.drawPath(path, paint);
    path.reset();

    paint.color = Colors.blueAccent;
    paint.strokeCap = StrokeCap.butt;
    path.moveTo(startPoint, center);
    path.lineTo(endPoint * (18.5 / 40), center);
    canvas.drawPath(path, paint);
    path.reset();

    paint.strokeCap = StrokeCap.round;
    path.moveTo(startPoint, center);
    path.lineTo(startPoint, center);
    canvas.drawPath(path, paint);
    path.reset();

    final mHeight = height / 100;
    final bmi = weight / (mHeight * mHeight);

    paint.color = Colors.black;
    path.moveTo(endPoint * (bmi / 40), center - paint.strokeWidth / 2);
    path.lineTo(endPoint * (bmi / 40), center + paint.strokeWidth / 2);
    paint.strokeWidth = 5;
    paint.strokeCap = StrokeCap.butt;
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }


}
