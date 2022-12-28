import 'package:crumbs/model/map_route.dart';
import 'package:crumbs/tabs/route_tab/route_layer.dart';
import 'package:crumbs/tabs/route_tab/map_layer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class MapRouteTab extends StatefulWidget {
  const MapRouteTab({Key? key}) : super(key: key);

  @override
  State<MapRouteTab> createState() => _MapRouteTabState();
}

class _MapRouteTabState extends State<MapRouteTab> {
  bool _recordPosition = false;
  late final Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('mapRoutes');
  }

  @override
  Widget build(BuildContext context) {
    final _textController = TextEditingController();
    var currentMapRoute = Provider.of<MapRoute>(context, listen: false);

    return SafeArea(
      child: Stack(
        children: [
          CustomPaint(
            key: const Key('map_layer'),
            size: Size.infinite,
            painter: MapLayer(),
          ),
          Align(
            alignment: Alignment.lerp(Alignment.center, Alignment.topCenter, 0.05)!,
            child: Consumer<MapRoute>(
              builder: (context, currentRoute, child) {
                return CustomPaint(
                  key: const Key('route_layer'),
                  size: Size(
                    MediaQuery.of(context).size.width * 0.95,
                    MediaQuery.of(context).size.height * 0.7,
                  ),
                  painter: RouteLayer(route: currentRoute),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              key: const Key('record_position_button'),
              style: ElevatedButton.styleFrom(
                foregroundColor: _recordPosition ? Colors.red : Colors.green,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (_recordPosition) {
                    _recordPosition = false;
                    currentMapRoute.stopRecordPosition();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Save Route'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Give your route a name before saving it.'),
                                TextField(
                                  controller: _textController,
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  box.add(
                                    MapRoute()
                                      ..listOfPoints = currentMapRoute.listOfPoints
                                      ..startTime = currentMapRoute.startTime
                                      ..endTime = currentMapRoute.endTime
                                      ..distanceTraveled = currentMapRoute.distanceTraveled
                                      ..imageDataList = currentMapRoute.imageDataList
                                      ..name = _textController.text,
                                  );

                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Save Route',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  } else {
                    _recordPosition = true;
                    currentMapRoute.recordPosition();
                  }
                });
              },
              child: Text(_recordPosition ? 'Stop Recording' : 'Start Recording'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<MapRoute>(
              builder: (context, currentRoute, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Duration: ${currentRoute.formattedRouteDuration()}',
                      style: const TextStyle(color: Color.fromRGBO(251, 252, 248, 1)),
                    ),
                    Text(
                      'Traveled: ${(currentRoute.distanceTraveled / 1609).toStringAsFixed(2)} miles',
                      style: const TextStyle(color: Color.fromRGBO(248, 238, 236, 1)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
