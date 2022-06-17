import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

class BackgroundLayer extends StatefulWidget {
  const BackgroundLayer({Key? key}) : super(key: key);

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  @override
  Widget build(BuildContext context) {
    return TileLayerWidget(
      key: const Key('background_layer'),
      options: TileLayerOptions(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c'],
        attributionBuilder: (_) {
          return const Text("© OpenStreetMap contributors");
        },
      ),
    );
  }
}
