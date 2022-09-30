// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_route.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MapRouteAdapter extends TypeAdapter<MapRoute> {
  @override
  final int typeId = 2;

  @override
  MapRoute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapRoute(
      points: (fields[1] as List?)?.cast<RoutePoint>(),
    )
      ..name = fields[0] as String
      ..startTime = fields[2] as DateTime?
      ..endTime = fields[3] as DateTime?
      ..distanceTraveled = fields[4] as double
      ..photoData = (fields[5] as List?)?.cast<Uint8List>();
  }

  @override
  void write(BinaryWriter writer, MapRoute obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.distanceTraveled)
      ..writeByte(5)
      ..write(obj.photoData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapRouteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
