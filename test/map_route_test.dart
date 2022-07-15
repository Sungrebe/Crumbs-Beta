import 'package:crumbs/model/map_route.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Route tests', () {
    MapRoute exampleRoute = MapRoute();
    RoutePoint examplePoint = RoutePoint(
      latitude: 37.432483,
      longitude: -122.091763,
    );
    RoutePoint examplePoint2 = RoutePoint(
      latitude: 37.43251,
      longitude: -122.09173,
    );

    double mapWidth = 600;
    double mapHeight = 800;

    List<Offset> examplePixelList = [];

    test('updateRoute', () {
      expect(exampleRoute.numberOfPoints, equals(0));
      exampleRoute.update(examplePoint);
      expect(exampleRoute.numberOfPoints, equals(1));

      double quarterMile = 0.0036231884;

      expect(exampleRoute.minLatitude, equals(examplePoint.latitude - quarterMile));
      expect(exampleRoute.maxLatitude, equals(examplePoint.latitude + quarterMile));
      expect(exampleRoute.minLongitude, equals(examplePoint.longitude - quarterMile));
      expect(exampleRoute.maxLongitude, equals(examplePoint.longitude + quarterMile));

      if (examplePoint2.latitude < exampleRoute.minLatitude) {
        expect(examplePoint2.latitude, equals(exampleRoute.minLatitude - quarterMile));
      } else if (examplePoint.latitude > exampleRoute.maxLatitude) {
        expect(examplePoint2.latitude, equals(exampleRoute.maxLatitude + quarterMile));
      } else if (examplePoint.longitude < exampleRoute.minLongitude) {
        expect(examplePoint2.longitude, equals(exampleRoute.minLongitude - quarterMile));
      } else if (examplePoint.longitude > exampleRoute.maxLongitude) {
        expect(examplePoint.longitude, equals(exampleRoute.maxLongitude + quarterMile));
      }
    });

    test('plotRoute', () {
      exampleRoute.update(examplePoint);
      examplePixelList = exampleRoute.plotPoints(mapWidth, mapHeight);

      expect(examplePixelList.first.dx, equals(300));
      expect(examplePixelList.first.dy, equals(400));
    });

    test('drawLineBetweenPixels', () {
      exampleRoute.update(examplePoint);
      exampleRoute.update(examplePoint2);
      examplePixelList = exampleRoute.plotPoints(mapWidth, mapHeight);

      var exampleRoutePath = exampleRoute.drawLineBetweenPixels(examplePixelList);
      expect(exampleRoutePath.contains(examplePixelList[1]), equals(true));
    });
  });
}
