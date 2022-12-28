import 'package:crumbs/tabs/route_tab/route_tab.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  Future<LocationPermission> mockRequestPermission() async {
    return LocationPermission.whileInUse;
  }

  group('route tab tests', () {
    testWidgets('loads map successfully', (tester) async {
      await tester.pumpWidget(
        FutureBuilder(
          future: mockRequestPermission(),
          builder: (BuildContext context, AsyncSnapshot<LocationPermission> permissionSnapshot) {
            Widget mapWidget = const SizedBox.shrink();

            if (permissionSnapshot.hasError) {
              mapWidget = const Text('An error occurred.');
            } else {
              LocationPermission? permission = permissionSnapshot.data;

              switch (permissionSnapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  mapWidget = const CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if (permission == LocationPermission.whileInUse) {
                    mapWidget = const MapRouteTab();

                    expect(find.byKey(const Key('map_layer')), findsOneWidget);
                    expect(find.byKey(const Key('route_layer')), findsOneWidget);
                    expect(find.byKey(const Key('record_position_button')), findsOneWidget);
                  }
                  break;
              }
            }

            return mapWidget;
          },
        ),
      );
    });
  });
}
