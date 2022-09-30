import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

//import 'package:crumbs/globals.dart';
//import 'package:crumbs/utilities/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RoutePoint {
  double latitude;
  double longitude;
  bool hasPhoto = false;

  RoutePoint({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class MapRoute extends ChangeNotifier {
  final List<RoutePoint> _points = [];
  StreamSubscription<Position>? _subscription;
  final _stopwatch = Stopwatch();
  //final _localStorage = LocalStorage();

  double distanceTraveled = 0;
  Duration timeElapsed = Duration.zero;
  DateTime? startTime;
  DateTime? endTime;

  int locationReadings = 0;
  double minLatitude = double.negativeInfinity;
  double maxLatitude = double.infinity;
  double minLongitude = double.negativeInfinity;
  double maxLongitude = double.infinity;

  final List<ui.Image> _listOfPhotos = [];
  final List<Uint8List> _photoData = [];

  int get numberOfPoints => _points.length;
  RoutePoint get lastPoint => _points.last;
  List<RoutePoint> get points => _points;
  List<ui.Image> get listOfPhotos => _listOfPhotos;

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
      var lastPoint = _points.last;
      var secondToLastPoint = _points[_points.indexOf(lastPoint) - 1];
      distanceTraveled += Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        secondToLastPoint.latitude,
        secondToLastPoint.longitude,
      );
    }
  }

  String formattedRouteDuration() {
    var timeInHours = timeElapsed.inHours.toString().padLeft(2, '0');
    var timeInMinutes = timeElapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    var timeInSeconds = timeElapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$timeInHours:$timeInMinutes:$timeInSeconds';
  }

  void recordPosition() {
    distanceTraveled = 0;
    _stopwatch.reset();
    _stopwatch.start();

    startTime = DateTime.now();

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
    endTime = DateTime.now();

    //saveRoute();
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

  List<Offset> plotPoints(double mapWidth, double mapHeight, List<RoutePoint> pointList) {
    List<Offset> pixels = [];

    for (var point in pointList) {
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

  Map<String, dynamic> toMap() {
    var savedPointsList = [];

    for (var point in _points) {
      savedPointsList.add(point.toMap());
    }

    return {
      'title': 'Untitled Route',
      'points': savedPointsList,
      'startTime': startTime!.toLocal().toIso8601String(),
      'endTime': endTime!.toLocal().toIso8601String(),
      'distance': distanceTraveled,
      'photos': _photoData,
    };
  }

  /*void saveRoute() async {
    var routeDir = Directory(await localStorage.documentsDirectory + '/routes/');

    File routeFile;
    if (await routeDir.exists()) {
      var files = await _localStorage.getAllRouteFiles();
      routeFile = await _localStorage.createFile('Untitled Route ${files.length + 1}');
    } else {
      routeFile = await _localStorage.createFile('Untitled Route');
    }

    _localStorage.writeContent(json.encode(toMap()), routeFile);
  }*/

  void addPhoto(File photoFile) async {
    var byteData = await photoFile.readAsBytes();
    var imageData = await decodeImageFromList(byteData);
    _listOfPhotos.add(imageData);
    _points.last.hasPhoto = true;
    notifyListeners();

    ByteData? bytes = await imageData.toByteData(format: ui.ImageByteFormat.png);
    Uint8List data = bytes!.buffer.asUint8List();
    _photoData.add(data);
  }
}
