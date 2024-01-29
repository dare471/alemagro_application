// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitAdapter extends TypeAdapter<VisitLocal> {
  @override
  final int typeId = 0;

  @override
  VisitLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitLocal()
      ..id = fields[0] as int?
      ..clientId = fields[1] as int?
      ..statusVisit = fields[2] as int?
      ..source = fields[3] as String?
      ..dateVisitStamp = fields[4] as int?
      ..dateVisit = fields[5] as String?
      ..targetDescription = fields[6] as String?
      ..properties = fields[7] as Properties?;
  }

  @override
  void write(BinaryWriter writer, VisitLocal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientId)
      ..writeByte(2)
      ..write(obj.statusVisit)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.dateVisitStamp)
      ..writeByte(5)
      ..write(obj.dateVisit)
      ..writeByte(6)
      ..write(obj.targetDescription)
      ..writeByte(7)
      ..write(obj.properties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
