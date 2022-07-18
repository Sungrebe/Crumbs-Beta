import 'package:crumbs/tabs/route_tab/map_route_tab.dart';
import 'package:crumbs/model/map_route.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<MapRoute>(
      create: (context) => MapRoute(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Crumbs',
      home: HomePage(title: 'Crumbs'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _tabs = [
    const MapRouteTab(key: Key('trail_tab')),
    const SizedBox.expand(),
    const SizedBox.expand(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Geolocator.requestPermission(),
          builder: (BuildContext context, AsyncSnapshot<LocationPermission> permissionSnapshot) {
            Widget body = const SizedBox.shrink();

            if (permissionSnapshot.hasError) {
              body = const Text('An error occurred.');
            } else {
              LocationPermission? permission = permissionSnapshot.data;

              switch (permissionSnapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  body = const CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if (permission == LocationPermission.whileInUse) {
                    body = _tabs.elementAt(_selectedIndex);
                  }
                  break;
              }
            }

            return body;
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('bottom_navigation_bar'),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hiking),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
