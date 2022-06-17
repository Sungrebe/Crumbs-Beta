import 'package:crumbs/model/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Trail tests', () {
    Trail exampleTrail = Trail([]);
    test('marker can be added to trail', () {
      expect(exampleTrail.markers.length, 0);
    });

    test('markers can be removed from trail', () {
      expect(exampleTrail.markers.length, isNonZero);
      exampleTrail.removeAllMarkers();
      expect(exampleTrail.markers.length, isZero);
    });
  });
}
