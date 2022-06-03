import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crumbs/tabs/trail/map.dart';

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
      builder: (BuildContext context, AsyncSnapshot<LocationPermission> permissionSnapshot) {
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
              if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                body = const TrailMap(key: Key('trail_map'));
              }

              break;
          }
        }

        return Center(child: body);
      },
    );
  }
}