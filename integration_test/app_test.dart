import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:integration_test/integration_test.dart';

import 'package:crumbs/main.dart' as app;
import 'package:crumbs/tabs/trail/trail.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end-test', () {
    testWidgets('user can navigate between tabs', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('bottom_navigation_bar')), findsOneWidget);

      final Finder trailTab = find.text('Trail');
      await tester.tap(trailTab);
      expect(find.byKey(const Key('trail_tab')), findsOneWidget);
    });

    testWidgets('Trail map loads successfully', (WidgetTester tester) async {
      Completer futureCompleter = Completer<LocationPermission>();

      await tester.pumpWidget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return const MaterialApp(
            home: Scaffold(
              body: TrailTab(),
            ),
          );
        })
      );

      futureCompleter.complete(Geolocator.requestPermission());
      await tester.pump(Duration.zero);
      expect(find.byKey(const Key('trail_map')), findsOneWidget);
    });
  });
}