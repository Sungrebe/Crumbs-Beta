import 'package:crumbs/model/map_route.dart';

import 'package:flutter/material.dart';

class RouteLayer extends CustomPainter {
  MapRoute route;

  RouteLayer({required this.route}) : super(repaint: route);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    var routePixels = route.plotPoints(size.width, size.height);
    canvas.drawPath(route.drawLineBetweenPixels(routePixels), paint);
  }

  @override
  bool shouldRepaint(RouteLayer oldDelegate) {
    return oldDelegate.route.numberOfPoints != route.numberOfPoints;
  }
}
