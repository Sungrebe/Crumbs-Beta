import 'package:crumbs/model/route_point.dart';
import 'package:crumbs/tabs/camera_tab/camera_tab.dart';
import 'package:crumbs/tabs/route_tab/route_tab.dart';
import 'package:crumbs/model/map_route.dart';
import 'package:crumbs/tabs/saved_tab/saved_tab.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RoutePointAdapter());
  Hive.registerAdapter(MapRouteAdapter());

  await Hive.openBox('mapRoutes');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      ChangeNotifierProvider<MapRoute>(
        create: (context) => MapRoute(),
        child: const App(),
      ),
    );
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crumbs',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _tabs = [
    FutureBuilder(
      future: Geolocator.requestPermission(),
      builder: (BuildContext context, AsyncSnapshot<LocationPermission> snapshot) {
        if ((snapshot.connectionState == ConnectionState.done) &&
            (snapshot.data == LocationPermission.whileInUse || snapshot.data == LocationPermission.always)) {
          return const MapRouteTab(key: Key('route_tab'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
    FutureBuilder(
      future: availableCameras(),
      builder: (BuildContext context, AsyncSnapshot<List<CameraDescription>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraTab(key: const Key('camera_tab'), cameras: snapshot.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
    SavedTab(box: Hive.box('mapRoutes')),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
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
