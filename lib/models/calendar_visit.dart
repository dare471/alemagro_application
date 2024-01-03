class Meeting {
  final int countVisit;
  final int id;
  final int clientId;
  final int statusVisit;
  final DateTime date;
  // final DateTime dateStart;
  // final DateTime dateFinish;
  final String targetDescription;
  final String clientName;
  final String clientAddress;
  final String? typeVisitName;
  // Добавьте другие поля, которые вам нужны

  Meeting({
    required this.countVisit,
    required this.id,
    required this.clientId,
    required this.statusVisit,
    required this.date,
    // required this.dateStart,
    // required this.dateFinish,
    required this.targetDescription,
    required this.clientName,
    required this.clientAddress,
    this.typeVisitName,
    // Инициализация других полей
  });

  // Метод для создания объекта Meeting из JSON
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      countVisit: json['countVisit'],
      id: json['id'],
      clientId: json['clientId'],
      statusVisit: json['statusVisit'],
      date: DateTime.parse(json['dateVisit']),
      //  dateStart: json['properties']['startVisit'] != null ? DateTime.fromMillisecondsSinceEpoch(json['properties']['startVisit'] *1000) // If timestamp is in seconds : DateTime.now(), // Default or error handling
      //  dateFinish: json['properties']['finishVisit'] != null ? DateTime.fromMillisecondsSinceEpoch(json['properties']['finishVisit'] * 1000)   : DateTime.now(),
      targetDescription: json['targetDescription'],
      clientName: json['properties']['clientName'],
      clientAddress: json['properties']
          ['clientAddres'], // Ensure this key matches your JSON key
      typeVisitName: json['properties']
          ['typeVisitName'], // Handle nulls as per your requirement
      // ... other fields
    );
  }
}
