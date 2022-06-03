import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:crumbs/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end-test', () {
    testWidgets('user can navigate between tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('bottom_navigation_bar')), findsOneWidget);

      final Finder trailTab = find.text('Trail');
      await tester.tap(trailTab);
      expect(find.byKey(const Key('trail_tab')), findsOneWidget);
    });
  });
}