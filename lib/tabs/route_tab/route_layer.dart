import 'package:trail_crumbs/model/map_route.dart';
import 'package:flutter/material.dart';

class RouteLayer extends CustomPainter {
  MapRoute route;
  Size canvasSize = Size.zero;

  RouteLayer({required this.route}) : super(repaint: route);

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;

    var routePixels = route.plotPoints(size.width, size.height, route.points);
    Paint routePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    if (routePixels.isNotEmpty) {
      canvas.drawPath(route.drawLineBetweenPixels(routePixels), routePaint);
      canvas.drawCircle(routePixels.first, 3, Paint()..color = Colors.black);
      canvas.drawCircle(routePixels.last, 3, Paint()..color = Colors.red);

      var imagePoints = route.points.where((point) => point.hasPhoto).toList();
      var imagePixels = route.plotPoints(size.width, size.height, imagePoints);

      for (int i = 0; i < imagePoints.length; i++) {
        paintImage(
          canvas: canvas,
          rect: Rect.fromCircle(center: imagePixels[i], radius: 5),
          image: route.mapImages[i],
        );
      }
    }
  }

  @override
  bool shouldRepaint(RouteLayer oldDelegate) {
    return oldDelegate.route.numberOfPoints != route.numberOfPoints;
  }
}
