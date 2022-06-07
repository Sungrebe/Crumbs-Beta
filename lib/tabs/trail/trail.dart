import 'package:crumbs/globals.dart';
import 'package:crumbs/model/location_marker.dart';
import 'package:crumbs/tabs/trail/background_layer.dart';
import 'package:crumbs/tabs/trail/trail_layer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TrailTab extends StatefulWidget {
  const TrailTab({Key? key}) : super(key: key);

  @override
  State<TrailTab> createState() => _TrailTabState();
}

class _TrailTabState extends State<TrailTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Geolocator.requestPermission(),
      builder: (BuildContext context,
          AsyncSnapshot<LocationPermission> permissionSnapshot) {
        Widget body = const SizedBox.shrink();

        if (permissionSnapshot.hasError) {
          body = const Text('An error occurred.');
        } else {
          LocationPermission? permission = permissionSnapshot.data;

          switch (permissionSnapshot.connectionState) {
            case ConnectionState.none:
              body = const Text('Not connected.');
              break;
            case ConnectionState.waiting:
              body = const CircularProgressIndicator();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (permission == LocationPermission.whileInUse ||
                  permission == LocationPermission.always) {
                body = Consumer<Trail>(
                  builder: (context, trail, child) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox.fromSize(
                          size: Size.infinite,
                          child: Transform.scale(
                            scale: 5,
                            child: CustomPaint(
                              key: const Key('trail_map'),
                              painter: BackgroundLayer(),
                              foregroundPainter: TrailLayer(trail: trail),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (recording) {
                                recording = false;
                              } else {
                                recording = true;
                                trail.removeAllMarkers();

                                _doRecording(trail);

                                Future.delayed(const Duration(seconds: 5), () {
                                  _doRecording(trail);
                                });
                              }
                            });
                          },
                          child: const Text('Begin Location Recording'),
                        ),
                      ],
                    );
                  },
                );
              }

              break;
          }
        }

        return Center(child: body);
      },
    );
  }

  void _doRecording(Trail trail) {
    LocationSettings settings = const LocationSettings(distanceFilter: 3);
    Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      LocationMarker currentLocation = LocationMarker(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );

      trail.addMarker(currentLocation);
    });
  }
}
