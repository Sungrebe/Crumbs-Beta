import 'package:crumbs/model/map_route.dart';
import 'package:crumbs/tabs/route_tab/route_layer.dart';
import 'package:crumbs/tabs/route_tab/map_layer.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MapRouteTab extends StatefulWidget {
  const MapRouteTab({Key? key}) : super(key: key);

  @override
  State<MapRouteTab> createState() => _MapRouteTabState();
}

class _MapRouteTabState extends State<MapRouteTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Geolocator.requestPermission(),
      builder: (BuildContext context, AsyncSnapshot<LocationPermission> permissionSnapshot) {
        Widget body = const SizedBox.shrink();

        if (permissionSnapshot.hasError) {
          body = const Text('An error occurred.');
        } else {
          LocationPermission? permission = permissionSnapshot.data;

          switch (permissionSnapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              body = const CircularProgressIndicator();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (permission == LocationPermission.whileInUse) {
                body = SafeArea(
                  child: Stack(
                    children: [
                      CustomPaint(
                        key: const Key('map_layer'),
                        size: Size.infinite,
                        painter: MapLayer(),
                      ),
                      Consumer<MapRoute>(
                        builder: (context, currentRoute, child) {
                          return CustomPaint(
                            key: const Key('route_layer'),
                            size: MediaQuery.of(context).size,
                            painter: RouteLayer(route: currentRoute),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          key: const Key('record_position_button'),
                          onPressed: () {
                            Provider.of<MapRoute>(context, listen: false).recordPosition();
                          },
                          icon: const Icon(Icons.hiking),
                        ),
                      ),
                    ],
                  ),
                );
              }
              break;
          }
        }

        return body;
      },
    );
  }
}
