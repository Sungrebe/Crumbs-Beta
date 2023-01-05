import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:trail_crumbs/model/map_route.dart';
import 'package:flutter/material.dart';

class RouteInfoArguments {
  final MapRoute route;

  RouteInfoArguments({required this.route});
}

class RouteInfoTab extends StatefulWidget {
  const RouteInfoTab({Key? key}) : super(key: key);

  @override
  State<RouteInfoTab> createState() => _RouteInfoTabState();
}

class _RouteInfoTabState extends State<RouteInfoTab> {
  @override
  Widget build(BuildContext context) {
    var routeInfo = ModalRoute.of(context)!.settings.arguments as RouteInfoArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(routeInfo.route.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Photos', style: TextStyle(fontSize: 20)),
              ),
              Builder(
                builder: (context) {
                  if (routeInfo.route.imageDataList.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('You didn\'t take any photos on this route.'),
                    );
                  } else {
                    return CarouselSlider(
                      options: CarouselOptions(height: 400),
                      items: routeInfo.route.imageDataList.map((photo) {
                        return Image.file(File(photo));
                      }).toList(),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'Distance Traveled: ${(routeInfo.route.distanceTraveled / 1609).toStringAsFixed(2)} miles',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                height: 800,
                child: Container(
                  color: Colors.green,
                  child: Image.memory(routeInfo.route.imageOfRouteData),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
