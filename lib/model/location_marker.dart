import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationMarker {
  double latitude;
  double longitude;
  Color color;

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  double distanceTo(LocationMarker other) {
    return sqrt(pow((other.latitude - latitude), 2) + pow((other.longitude - longitude), 2));
  }

  Color get getMarkerColor => color;

  set setMarkerColor(Color newColor) {
    color = newColor;
  }

  LocationMarker({required this.latitude, required this.longitude, required this.color});
}

class Trail extends ValueNotifier {
  List<LocationMarker> markers = [];

  Trail(this.markers) : super(markers);

  LocationMarker get lastMarker => markers.last;

  LocationMarker markerBefore(LocationMarker marker) {
    int previousIndex = markers.indexOf(marker) - 1;
    return markers[previousIndex];
  }

  void addMarker(LocationMarker marker) {
    markers.add(marker);
    notifyListeners();
  }

  void removeAllMarkers() {
    markers.clear();
    notifyListeners();
  }
}
