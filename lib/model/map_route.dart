import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RoutePoint {
  double latitude;
  double longitude;

  RoutePoint({required this.latitude, required this.longitude});
}

class MapRoute extends ChangeNotifier {
  final List<RoutePoint> _points = [];
  StreamSubscription<Position>? _subscription;
  final _stopwatch = Stopwatch();

  double distanceTraveled = 0;
  Duration timeElapsed = Duration.zero;

  int locationReadings = 0;
  double minLatitude = double.negativeInfinity;
  double maxLatitude = double.infinity;
  double minLongitude = double.negativeInfinity;
  double maxLongitude = double.infinity;

  int get numberOfPoints => _points.length;

  void removeAll() {
    _points.clear();
    notifyListeners();
  }

  void updateTimeElapsed() {
    timeElapsed = _stopwatch.elapsed;
    notifyListeners();
  }

  void updateDistanceTraveled() {
    if (_points.length >= 2) {
      var lastTwoPoints = _points.sublist(_points.length - 2);
      distanceTraveled += Geolocator.distanceBetween(
        lastTwoPoints[0].latitude,
        lastTwoPoints[0].longitude,
        lastTwoPoints[1].latitude,
        lastTwoPoints[1].longitude,
      );
    }
  }

  String formattedRouteDuration() {
    var timeInHours = timeElapsed.inHours.toString().padLeft(2, '0');
    var timeInMinutes = timeElapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    var timeInSeconds = timeElapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$timeInHours:$timeInMinutes:$timeInSeconds';
  }

  String formattedDistanceTraveled() {
    var distanceInMiles = distanceTraveled / 1609.34;
    return distanceInMiles.toStringAsFixed(2);
  }

  void recordPosition() {
    _stopwatch.start();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTimeElapsed();
    });

    if (_points.isNotEmpty) {
      removeAll();
    }

    LocationSettings settings = const LocationSettings(distanceFilter: 10);
    _subscription = Geolocator.getPositionStream(locationSettings: settings).listen((Position pos) {
      locationReadings++;
      updatePoints(RoutePoint(latitude: pos.latitude, longitude: pos.longitude));

      updateDistanceTraveled();
    });
  }

  void stopRecordPosition() {
    _subscription?.cancel();
    _stopwatch.stop();
  }

  void updatePoints(RoutePoint point) {
    _points.add(point);
    notifyListeners();

    double quarterMileOffset = 0.0036231884;
    var lastPoint = _points.last;
    if (_points.length == 1) {
      minLatitude = (lastPoint.latitude - quarterMileOffset);
      maxLatitude = (lastPoint.latitude + quarterMileOffset);
      minLongitude = (lastPoint.longitude - quarterMileOffset);
      maxLongitude = (lastPoint.longitude + quarterMileOffset);
    } else {
      if (lastPoint.latitude < minLatitude) {
        minLatitude = (lastPoint.latitude - quarterMileOffset);
        notifyListeners();
      } else if (lastPoint.latitude > maxLatitude) {
        maxLatitude = (lastPoint.latitude + quarterMileOffset);
        notifyListeners();
      } else if (lastPoint.longitude < minLongitude) {
        minLongitude = (lastPoint.longitude - quarterMileOffset);
        notifyListeners();
      } else if (lastPoint.longitude > maxLongitude) {
        maxLongitude = (lastPoint.longitude + quarterMileOffset);
        notifyListeners();
      }
    }
  }

  List<Offset> plotPoints(double mapWidth, double mapHeight) {
    List<Offset> pixels = [];

    for (var point in _points) {
      var pixelX = (minLatitude - point.latitude) / (minLatitude - maxLatitude) * mapWidth;
      var pixelY = (maxLongitude - point.longitude) / (maxLongitude - minLongitude) * mapHeight;

      pixels.add(Offset(pixelX, pixelY));
    }

    return pixels;
  }

  Path drawLineBetweenPixels(List<Offset> listOfPixels) {
    var routePath = Path();

    for (int i = 1; i < listOfPixels.length; i++) {
      routePath
        ..moveTo(listOfPixels[i - 1].dx, listOfPixels[i - 1].dy)
        ..lineTo(listOfPixels[i].dx, listOfPixels[i].dy);
    }

    return routePath;
  }
}
