class Meeting {
  final int id;
  final int clientId;
  final int statusVisit;
  final DateTime date;
  final String targetDescription;
  final String clientName;
  final String clientAddress;
  final String? typeVisitName;
  // Добавьте другие поля, которые вам нужны

  Meeting({
    required this.id,
    required this.clientId,
    required this.statusVisit,
    required this.date,
    required this.targetDescription,
    required this.clientName,
    required this.clientAddress,
    this.typeVisitName,
    // Инициализация других полей
  });

  // Метод для создания объекта Meeting из JSON
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      clientId: json['clientId'],
      statusVisit: json['statusVisit'],
      date: DateTime.parse(json['dateVisit']),
      targetDescription: json['targetDescription'],
      clientName: json['properties']['clientName'],
      clientAddress: json['properties']['clientAddres'],
      typeVisitName:
          json['properties']?['typeVisitName'] ?? null, // вложенное свойство

      // Инициализация других полей из json
    );
  }
}
