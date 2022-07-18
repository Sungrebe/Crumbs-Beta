import 'package:flutter/material.dart';

class MapLayer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Colors.green.shade100);
  }

  @override
  bool shouldRepaint(MapLayer oldDelegate) => false;
}
