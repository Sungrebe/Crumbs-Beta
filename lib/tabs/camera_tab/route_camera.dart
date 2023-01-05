import 'dart:io';

import 'package:camera/camera.dart';
import 'package:trail_crumbs/model/map_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteCamera extends StatefulWidget {
  final CameraController controller;
  final VoidCallback onSwitchCamera;
  const RouteCamera({Key? key, required this.controller, required this.onSwitchCamera}) : super(key: key);

  @override
  State<RouteCamera> createState() => RouteCameraState();
}

@visibleForTesting
class RouteCameraState extends State<RouteCamera> {
  late CameraController initialController;
  double cameraZoomLevel = 2;

  @override
  void initState() {
    super.initState();
    widget.controller.setZoomLevel(cameraZoomLevel);
  }

  void _changeCameraZoomLevel(ScaleUpdateDetails details) async {
    var minZoom = await widget.controller.getMinZoomLevel();
    var maxZoom = await widget.controller.getMaxZoomLevel();

    if (details.scale < 1 && cameraZoomLevel > minZoom) {
      cameraZoomLevel -= 0.05;
    } else if (details.scale > 1 && cameraZoomLevel < maxZoom) {
      cameraZoomLevel += 0.05;
    }

    widget.controller.setZoomLevel(cameraZoomLevel);
  }

  void _takePicture() {
    if (Provider.of<MapRoute>(context, listen: false).points.isNotEmpty) {
      widget.controller.takePicture().then((pictureFile) {
        setState(() {
          var photo = File(pictureFile.path);
          Provider.of<MapRoute>(context, listen: false).addPhoto(photo);
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('You can only take photos once you have started a route.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onScaleUpdate: _changeCameraZoomLevel,
              child: CameraPreview(widget.controller),
            ),
          ),
          Positioned(
            top: 25,
            left: 25,
            child: ElevatedButton(
              key: const Key('switch_camera_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
              ),
              onPressed: widget.onSwitchCamera,
              child: const Icon(Icons.switch_camera),
            ),
          ),
          Positioned(
            bottom: 25,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: ElevatedButton(
              key: const Key('take_picture_button'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
              ),
              onPressed: _takePicture,
              child: const Icon(Icons.photo_camera),
            ),
          ),
        ],
      ),
    );
  }
}
