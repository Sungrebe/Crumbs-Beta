import 'package:crumbs/globals.dart';
import 'package:crumbs/main.dart' as app;
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
      const MethodChannel('flutter.baseflow.com/geolocator').setMockMethodCallHandler((call) async {
        if (call.method == 'getCurrentPosition') {
          await tester.pump(Duration.zero);

          expect(find.byKey(const Key('trail_tab')), findsOneWidget);

          expect(find.byKey(const Key('trail_map')), findsOneWidget);
          expect(find.byKey(const Key('background_layer')), findsOneWidget);

          Finder trailButton = find.byKey(const Key('trail_button'));
          expect(trailButton, findsOneWidget);

          expect(find.byIcon(Icons.hiking), findsOneWidget);
          await tester.tap(trailButton);
          expect(find.byIcon(Icons.stop), findsOneWidget);

          expect(find.byKey(const Key('trail_layer')), findsOneWidget);
        }
      });
    });
  });
}
