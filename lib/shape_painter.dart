import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  final double i;

  ShapePainter(this.i);

  @override
  void paint(Canvas canvas, Size size) async {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.height * i);
    Offset endingPoint = Offset(size.width * i, size.height * i);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
