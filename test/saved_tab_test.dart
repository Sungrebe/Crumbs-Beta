import 'package:crumbs/model/map_route.dart';
import 'package:crumbs/model/route_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crumbs/tabs/saved_tab/saved_tab.dart';
import 'package:mockito/mockito.dart';

import 'route_test.mocks.dart';

void main() {
  var mockHiveInterface = MockHiveInterface();
  var mockBox = MockBox();

  var route1 = MapRoute();
  route1.updatePoints(RoutePoint(latitude: 37.433001, longitude: -122.087954, hasPhoto: false));

  var route2 = MapRoute();
  route2.updatePoints(RoutePoint(latitude: 37.343020, longitude: -121.715906, hasPhoto: false));

  setUp(() async {
    mockHiveInterface.registerAdapter(RoutePointAdapter());
    mockHiveInterface.registerAdapter(MapRouteAdapter());
  });

  group('saved tab tests', () {
    testWidgets('displays information about saved routes', (widgetTester) async {
      when(mockHiveInterface.openBox('mapRoutes')).thenAnswer((_) async {
        await widgetTester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SavedTab(),
          ),
        ));

        return mockBox;
      });

      when(mockBox.isEmpty).thenAnswer((_) {
        expect(find.text('You haven\'t created any routes yet.'), findsOneWidget);
        return true;
      });

      int numEntries = 0;

      when(mockBox.add(route1)).thenAnswer((_) async {
        numEntries++;
        return 0;
      });

      when(mockBox.add(route2)).thenAnswer((_) async {
        numEntries++;
        return 1;
      });

      when(mockBox.length).thenAnswer((_) => numEntries);

      when(mockBox.isNotEmpty).thenAnswer((_) {
        expect(find.byType(ListTile), findsNWidgets(numEntries));

        return true;
      });
    });
  });
}
