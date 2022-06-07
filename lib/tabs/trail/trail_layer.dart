import 'dart:math';

import 'package:crumbs/globals.dart';
import 'package:crumbs/model/location_marker.dart';
import 'package:flutter/material.dart';

class TrailLayer extends CustomPainter {
  Trail trail;

  TrailLayer({required this.trail});

  @override
  void paint(Canvas canvas, Size size) {
    if (trail.value.isNotEmpty) {
      LocationMarker startingLocation = trail.value.first;

      double latOffset = (1 / milesPerLatDeg) * baseLatOffset;
      double milesPerLonDeg =
          cos(startingLocation.latitude * pi / 180) * milesPerLatDeg;
      double lonOffset = (1 / milesPerLonDeg) * baseLonOffset;

      double latMin = startingLocation.latitude - latOffset;
      double latMax = startingLocation.latitude + latOffset;
      double lonMin = startingLocation.longitude - lonOffset;
      double lonMax = startingLocation.longitude + lonOffset;

      for (int i = 0; i < trail.value.length; i++) {
        if (i == 0 || i % 5 == 0) {
          double pixelX = (trail.value[i].longitude - lonMin) /
              (lonMax - lonMin) *
              size.width;
          double pixelY = (trail.value[i].latitude - latMin) /
              (latMax - latMin) *
              size.height;

          Rect markerRect = Rect.fromCenter(
            center: Offset(pixelX, pixelY),
            width: 1,
            height: 1,
          );

          Path markerPath = Path()..addArc(markerRect, 0, 2 * pi);

          canvas.drawPath(markerPath, Paint()..color = Colors.white);
        }
      }
    }
  }

  @override
  bool shouldRepaint(TrailLayer oldDelegate) => recording;
}
