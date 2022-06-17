import 'dart:async';

import 'package:crumbs/globals.dart';
import 'package:crumbs/model/location_marker.dart';
import 'package:crumbs/tabs/trail/background_layer.dart';
import 'package:crumbs/tabs/trail/trail_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// horse-ERG
class TrailTab extends StatefulWidget {
  const TrailTab({Key? key}) : super(key: key);

  @override
  State<TrailTab> createState() => _TrailTabState();
}

class _TrailTabState extends State<TrailTab> {
  void _doRecording() {
    LocationSettings settings = const LocationSettings(distanceFilter: 20);
    Geolocator.getPositionStream(locationSettings: settings).listen((Position position) {
      if (recording) {
        LocationMarker lastLocation = LocationMarker(
          latitude: position.latitude,
          longitude: position.longitude,
          color: Colors.green,
        );

        Provider.of<Trail>(context, listen: false).addMarker(lastLocation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Geolocator.getCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> positionSnapshot) {
        Widget body = const SizedBox.shrink();

        if (positionSnapshot.hasError) {
          body = const Text('An error occurred.');
        } else {
          Position? initialPosition = positionSnapshot.data;

          switch (positionSnapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              body = const CircularProgressIndicator();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              body = Stack(
                alignment: Alignment.topRight,
                children: [
                  FlutterMap(
                    key: const Key('trail_tab'),
                    options: MapOptions(
                      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      center: LatLng(initialPosition!.latitude, initialPosition.longitude),
                      minZoom: 18,
                      maxZoom: 18.4,
                    ),
                    children: [
                      const BackgroundLayer(),
                      Consumer<Trail>(
                        builder: (context, trail, child) {
                          return TrailLayer(locationMarkers: trail.markers);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      color: Colors.green,
                      child: IconButton(
                        color: Colors.white,
                        key: const Key('trail_button'),
                        onPressed: () {
                          if (recording) {
                            recording = false;
                          } else {
                            Provider.of<Trail>(context, listen: false).removeAllMarkers();
                            recording = true;
                          }

                          _doRecording();
                          Future.delayed(Duration(seconds: timeInterval), () {
                            _doRecording();
                          });
                        },
                        icon: recording ? const Icon(Icons.stop) : const Icon(Icons.hiking),
                      ),
                    ),
                  ),
                ],
              );
              break;
          }
        }

        return Center(child: body);
      },
    );
  }
}
