import 'package:crumbs/model/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrailLayer extends StatefulWidget {
  final List<LocationMarker> locationMarkers;

  const TrailLayer({
    Key? key,
    required this.locationMarkers,
  }) : super(key: key);

  @override
  State<TrailLayer> createState() => _TrailLayerState();
}

class _TrailLayerState extends State<TrailLayer> {
  @override
  Widget build(BuildContext context) {
    return MarkerLayerWidget(
      key: const Key('trail_layer'),
      options: MarkerLayerOptions(
        markers: widget.locationMarkers.map((locMarker) {
          return Marker(
            point: LatLng(locMarker.latitude, locMarker.longitude),
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  print('tapped on marker ${widget.locationMarkers.indexOf(locMarker)}');
                },
                child: Container(
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: locMarker.color,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.locationMarkers.indexOf(locMarker).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
