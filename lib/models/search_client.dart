class BusinessEntity {
  final int id;
  final String? name;
  final String? iinBin;
  final String? address;
  final String? businessCategory;
  final String? activity;
  final String? cato;
  final List<Visit> visits;
  // final List<Order> orders;
  final List<ContactInf> contactInf;

  BusinessEntity(
      {required this.id,
      this.name,
      this.iinBin,
      this.address,
      this.businessCategory,
      this.activity,
      this.cato,
      required this.visits,
      // required this.orders,
      required this.contactInf});

  factory BusinessEntity.fromJson(Map<String, dynamic> json) {
    var oid = json['_id']; // Поддержка чтения _id
    return BusinessEntity(
      id: json['id'] as int,
      name: json['name'] as String?,
      iinBin: json['iinBin'] as String?,
      address: json['address'] as String?,
      businessCategory:
          json['buisnessCategory'] as String?, // Оставлено как в исходном JSON
      activity: json['activity'] as String?,
      cato: json['cato'] as String?,
      visits: (json['visits'] as List<dynamic>?)
              ?.map((e) => Visit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      contactInf: (json['contactInf'] as List<dynamic>?)
              ?.map((e) => ContactInf.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Add fromJson and toJson methods for JSON serialization
}

class ContactInf {
  final int id;
  final String? name;
  final String? position;
  final String? phNumber;
  final String? email;
  final String? updatetime;

  ContactInf(
      {required this.id,
      required this.name,
      required this.position,
      required this.phNumber,
      required this.email,
      required this.updatetime});
  factory ContactInf.fromJson(Map<String, dynamic> json) => ContactInf(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      phNumber: json['phNumber'],
      email: json['email'],
      updatetime: json['updatetime']);
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        "position": position,
        "phNumber": phNumber,
        "email": email,
        "updatetime": updatetime,
      };
}

bool parseBool(dynamic value) {
  if (value is int) {
    return value != 0;
  }
  // Добавьте здесь дополнительные проверки для других типов данных, если нужно
  return false; // Или `throw FormatException('Cannot parse to bool')` если это считается ошибкой
}

class Visit {
  DateTime createToVisit;
  DateTime dateToVisit;
  String? targetDescription;
  String? placeDescription;
  bool isAllDay;
  DateTime? dateToStart;
  DateTime? dateToFinish;

  Visit({
    required this.createToVisit,
    required this.dateToVisit,
    required this.targetDescription,
    required this.placeDescription,
    required this.isAllDay,
    required this.dateToStart,
    required this.dateToFinish,
  });
  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        createToVisit: DateTime.parse(json['createToVisit']),
        dateToVisit: DateTime.parse(json['dateToVisit']),
        targetDescription: json['targetDescription'],
        placeDescription: json['placeDescription'],
        isAllDay: parseBool(json['isAllDay']),
        dateToStart: DateTime.parse(json['dateToStart']),
        dateToFinish: DateTime.parse(json['dateToFinish']),
      );

  Map<String, dynamic> toJson() => {
        'createToVisit': createToVisit.toIso8601String(),
        'dateToVisit': dateToVisit.toIso8601String(),
        'targetDescription': targetDescription,
        'placeDescription': placeDescription,
        'isAllDay': isAllDay,
        'dateToStart': dateToStart?.toIso8601String(),
        'dateToFinish': dateToFinish?.toIso8601String(),
      };
  // Add fromJson and toJson methods
}

class Order {
  final String productName;
  final int count;
  final String? provider;
  final double totalCostWithVat;

  Order({
    required this.productName,
    required this.count,
    required this.provider,
    required this.totalCostWithVat,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        productName: json['productName'],
        count: json['count'],
        provider: json['provider'],
        totalCostWithVat: json['total_cost_with_vat'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'count': count,
        'provider': provider,
        'total_cost_with_vat': totalCostWithVat,
      };
  // Add fromJson and toJson methods
}
