import 'package:camera/camera.dart';
import 'package:trail_crumbs/model/map_route.dart';
import 'package:trail_crumbs/tabs/camera_tab/camera_tab.dart';
import 'package:trail_crumbs/tabs/camera_tab/route_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var testMapRoute = MapRoute();

  var cameraController = CameraController(
    const CameraDescription(
      name: 'example camera',
      sensorOrientation: 0,
      lensDirection: CameraLensDirection.front,
    ),
    ResolutionPreset.ultraHigh,
    imageFormatGroup: ImageFormatGroup.bgra8888,
  );

  Future<void> initializeController() {
    return cameraController.initialize();
  }

  group('camera_tab_tests', () {
    testWidgets('route camera loads successfully', (tester) async {
      await tester.pumpWidget(FutureBuilder(
        future: initializeController(),
        builder: (context, snapshot) {
          Widget body = const SizedBox.shrink();

          if (snapshot.connectionState == ConnectionState.done) {
            var routeCameraState = RouteCameraState();
            var cameraTabState = CameraTabState();

            body = RouteCamera(
              controller: cameraController,
              key: const Key('route_camera'),
              onSwitchCamera: () {
                if (cameraTabState.changeCurrentCamera == false) {
                  cameraTabState.changeCurrentCamera = true;
                } else {
                  cameraTabState.changeCurrentCamera = false;
                }
              },
            );

            // Camera Preview and Zooming Test
            var cameraPreview = find.byType(CameraPreview);
            var initialZoomLevel = routeCameraState.cameraZoomLevel;
            expect(cameraPreview, findsOneWidget);

            test('Camera Zooming Test', () async {
              var touch1 = await tester.startGesture(tester.getCenter(cameraPreview).translate(-10, 0));
              var touch2 = await tester.startGesture(tester.getCenter(cameraPreview).translate(10, 0));

              touch1.moveBy(const Offset(-100, 0));
              touch2.moveBy(const Offset(100, 0));
              expect(routeCameraState.cameraZoomLevel, greaterThan(initialZoomLevel));

              touch1.moveBy(const Offset(-10, 0));
              touch2.moveBy(const Offset(10, 0));
              expect(routeCameraState.cameraZoomLevel, lessThan(initialZoomLevel));
            });

            // Switch Camera Test
            var switchCameraButton = find.byKey(const Key('switch_camera_button'));
            expect(find.byKey(const Key('switch_camera_button')), findsOneWidget);
            expect(cameraTabState.changeCurrentCamera, equals(false));
            tester.tap(switchCameraButton).then((_) {
              expect(cameraTabState.changeCurrentCamera, equals(true));
            });

            // Take Picture Test
            var takePictureButton = find.byKey(const Key('take_picture_button'));
            expect(takePictureButton, findsOneWidget);

            expect(testMapRoute.imageDataList.length, equals(0));
            tester.tap(takePictureButton).then((_) {
              expect(testMapRoute.imageDataList.length, equals(1));
            });
          } else {
            body = const Center(child: CircularProgressIndicator());
          }

          return body;
        },
      ));
    });
  });
}
