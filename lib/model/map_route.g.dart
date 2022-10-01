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
      listOfPoints: (fields[0] as List?)?.cast<RoutePoint>(),
    )
      ..startTime = fields[1] as DateTime?
      ..endTime = fields[2] as DateTime?
      ..distanceTraveled = fields[3] as double
      ..photoData = (fields[4] as List).cast<Uint8List>()
      ..name = fields[5] == null ? 'Untitled Route' : fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, MapRoute obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.listOfPoints)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.distanceTraveled)
      ..writeByte(4)
      ..write(obj.photoData)
      ..writeByte(5)
      ..write(obj.name);
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
