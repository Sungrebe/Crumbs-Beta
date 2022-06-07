import 'package:crumbs/main.dart' as app;
import 'package:crumbs/tabs/trail/trail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('end-to-end-test', () {
    testWidgets('user can navigate between tabs', (WidgetTester tester) async {
      app.main();
      await tester.pump();

      expect(find.byKey(const Key('bottom_navigation_bar')), findsOneWidget);

      final Finder trailTab = find.text('Trail');
      await tester.tap(trailTab);
      expect(find.byKey(const Key('trail_tab')), findsOneWidget);
    });

    testWidgets('Trail map loads successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return const MaterialApp(
            home: Scaffold(
              body: TrailTab(),
            ),
          );
        })
      );

      find.byKey(const Key('trail_tab'));
      matchesGoldenFile('initial.png');

      const MethodChannel('flutter.baseflow.com/geolocator').setMockMethodCallHandler((call) async {
        if (call.method == 'requestPermission') {
          await tester.pump(Duration.zero);
          expectLater(
            find.byKey(const Key('trail_map')), 
            matchesGoldenFile('initial.png'),
          );
        }
      });
    });
  });
}