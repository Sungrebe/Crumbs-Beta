import 'package:camera/camera.dart';
import 'package:trail_crumbs/tabs/camera_tab/route_camera.dart';
import 'package:flutter/material.dart';

class CameraTab extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraTab({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraTab> createState() => CameraTabState();
}

@visibleForTesting
class CameraTabState extends State<CameraTab> {
  late CameraController _controller;
  bool changeCurrentCamera = false;

  @override
  void initState() {
    super.initState();
    _getCamera();
  }

  void _getCamera() {
    var camera = widget.cameras![0];

    if (changeCurrentCamera) {
      camera = widget.cameras![1];
    }

    _controller = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return RouteCamera(
            controller: _controller,
            onSwitchCamera: () {
              setState(() {
                if (changeCurrentCamera) {
                  changeCurrentCamera = false;
                } else {
                  changeCurrentCamera = true;
                }

                _getCamera();
              });
            },
            key: const Key('route_camera'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
