import 'package:flutter/material.dart';

class MapLayer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = const Color.fromRGBO(93, 187, 99, 1));
  }

  @override
  bool shouldRepaint(MapLayer oldDelegate) => true;
}
