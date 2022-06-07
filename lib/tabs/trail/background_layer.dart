import 'package:flutter/material.dart';

class BackgroundLayer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect background = Offset.zero & size;
    canvas.drawRect(background, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(BackgroundLayer oldDelegate) => false;
}
