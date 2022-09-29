import 'package:crumbs/model/map_route.dart';
import 'package:flutter/material.dart';

class RouteLayer extends CustomPainter {
  MapRoute route;

  RouteLayer({required this.route}) : super(repaint: route);

  @override
  void paint(Canvas canvas, Size size) {
    var routePixels = route.plotPoints(size.width, size.height);
    Paint routePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    if (routePixels.isNotEmpty) {
      canvas.drawPath(route.drawLineBetweenPixels(routePixels), routePaint);
      canvas.drawCircle(routePixels.first, 3, Paint()..color = Colors.black);
      canvas.drawCircle(routePixels.last, 3, Paint()..color = Colors.red);

      if (route.lastPoint.hasPhoto) {
        paintImage(
          canvas: canvas,
          rect: Rect.fromCircle(center: routePixels.last, radius: 10),
          image: route.listOfPhotos.last,
        );
      }
    }
  }

  @override
  bool shouldRepaint(RouteLayer oldDelegate) {
    return oldDelegate.route.numberOfPoints != route.numberOfPoints;
  }
}
