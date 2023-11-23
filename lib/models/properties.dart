import 'package:hive/hive.dart';

part 'properties.g.dart';

@HiveType(typeId: 1)
class Properties extends HiveObject {
  @HiveField(0)
  int? statusVisit;

  @HiveField(1)
  int? id;

  @HiveField(2)
  int? visitId;

  @HiveField(3)
  int? clientId;

  @HiveField(4)
  String? clientName;

  @HiveField(5)
  String? clientAddress;

  @HiveField(6)
  int? typeVisitId;

  @HiveField(7)
  String? typeVisitName;

  @HiveField(8)
  int? typeMeetingId;

  @HiveField(9)
  String? typeMeetingName;

  @HiveField(10)
  int? startVisit;

  @HiveField(11)
  int? finishVisit;

  @HiveField(12)
  String? mainDescription;

  @HiveField(13)
  String? placeDescription;
}
