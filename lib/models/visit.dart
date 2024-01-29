import 'package:alemagro_application/models/properties.dart';
import 'package:hive/hive.dart';

part 'visit.g.dart';

@HiveType(typeId: 0)
class VisitLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? clientId;

  @HiveField(2)
  int? statusVisit;

  @HiveField(3)
  String? source;

  @HiveField(4)
  int? dateVisitStamp;

  @HiveField(5)
  String? dateVisit;

  @HiveField(6)
  String? targetDescription;

  @HiveField(7)
  Properties? properties;
}
