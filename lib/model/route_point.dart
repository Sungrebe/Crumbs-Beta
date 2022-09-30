import 'package:hive_flutter/hive_flutter.dart';

part 'route_point.g.dart';

@HiveType(typeId: 1)
class RoutePoint {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  bool hasPhoto = false;

  RoutePoint({required this.latitude, required this.longitude});
}
