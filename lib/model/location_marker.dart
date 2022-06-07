import 'package:flutter/material.dart';

class LocationMarker {
  double latitude;
  double longitude;

  LocationMarker({required this.latitude, required this.longitude});
}

class Trail extends ValueNotifier {
  List<LocationMarker> markers = [];

  Trail(this.markers) : super(markers);

  void addMarker(LocationMarker marker) {
    markers.add(marker);
    notifyListeners();
  }

  void removeAllMarkers() {
    markers.clear();
    notifyListeners();
  }
}