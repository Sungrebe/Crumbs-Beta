import 'package:flutter/material.dart';

class MapLayer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(MapLayer oldDelegate) => false;
}
