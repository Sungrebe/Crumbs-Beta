import 'package:crumbs/tabs/route_tab/map_route_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('route tab tests', () {
    var mapRouteTab = const MapRouteTab();

    testWidgets('shows spinner when loading map', (WidgetTester tester) async {
      await tester.pumpWidget(mapRouteTab);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loads map', (WidgetTester tester) async {
      // code goes here
    });
  });
}
