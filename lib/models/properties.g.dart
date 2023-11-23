// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertiesAdapter extends TypeAdapter<Properties> {
  @override
  final int typeId = 1;

  @override
  Properties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Properties()
      ..statusVisit = fields[0] as int?
      ..id = fields[1] as int?
      ..visitId = fields[2] as int?
      ..clientId = fields[3] as int?
      ..clientName = fields[4] as String?
      ..clientAddress = fields[5] as String?
      ..typeVisitId = fields[6] as int?
      ..typeVisitName = fields[7] as String?
      ..typeMeetingId = fields[8] as int?
      ..typeMeetingName = fields[9] as String?
      ..startVisit = fields[10] as int?
      ..finishVisit = fields[11] as int?
      ..mainDescription = fields[12] as String?
      ..placeDescription = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, Properties obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.statusVisit)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.visitId)
      ..writeByte(3)
      ..write(obj.clientId)
      ..writeByte(4)
      ..write(obj.clientName)
      ..writeByte(5)
      ..write(obj.clientAddress)
      ..writeByte(6)
      ..write(obj.typeVisitId)
      ..writeByte(7)
      ..write(obj.typeVisitName)
      ..writeByte(8)
      ..write(obj.typeMeetingId)
      ..writeByte(9)
      ..write(obj.typeMeetingName)
      ..writeByte(10)
      ..write(obj.startVisit)
      ..writeByte(11)
      ..write(obj.finishVisit)
      ..writeByte(12)
      ..write(obj.mainDescription)
      ..writeByte(13)
      ..write(obj.placeDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
