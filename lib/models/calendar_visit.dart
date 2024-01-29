class Visit {
  int countVisit;
  int id;
  int clientId;
  String clientName;
  String? clientAddress;
  int statusVisit;
  int source;
  int dateVisitStamp;
  String dateVisit;
  String dateToStart;
  String dateToFinish;
  String targetDescription;
  String placeDescription;
  String? notes;
  bool isAllDay;
  ClientProperties properties;

  Visit({
    required this.countVisit,
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientAddress,
    required this.statusVisit,
    required this.source,
    required this.dateVisitStamp,
    required this.dateVisit,
    required this.dateToStart,
    required this.dateToFinish,
    required this.targetDescription,
    required this.placeDescription,
    this.notes,
    required this.isAllDay,
    required this.properties,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      countVisit: json['countVisit'],
      id: json['id'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientAddress: json['clientAddress'],
      statusVisit: json['statusVisit'],
      source: json['source'],
      dateVisitStamp: json['dateVisitStamp'],
      dateVisit: json['dateVisit'],
      dateToStart: json['dateToStart'],
      dateToFinish: json['dateToFinish'],
      targetDescription: json['targetDescription'],
      placeDescription: json['placeDescription'],
      notes: json['notes'],
      isAllDay: json['isAllDay'],
      properties: ClientProperties.fromJson(json['properties']),
    );
  }
}

class ClientProperties {
  String clientName;
  String? clientAddress;
  String clientIin;
  List<ClientOrder> clientOrder;

  ClientProperties({
    required this.clientName,
    required this.clientAddress,
    required this.clientIin,
    required this.clientOrder,
  });

  factory ClientProperties.fromJson(Map<String, dynamic> json) {
    var orderList = json['clientOrder'] as List;
    List<ClientOrder> clientOrderList =
        orderList.map((i) => ClientOrder.fromJson(i)).toList();

    return ClientProperties(
      clientName: json['clientName'],
      clientAddress: json['clientAddres'],
      clientIin: json['clientIin'],
      clientOrder: clientOrderList,
    );
  }
}

class ClientOrder {
  String productName;
  int count;
  String provider;
  int totalCostWithVat;

  ClientOrder({
    required this.productName,
    required this.count,
    required this.provider,
    required this.totalCostWithVat,
  });

  factory ClientOrder.fromJson(Map<String, dynamic> json) {
    return ClientOrder(
      productName: json['productName'],
      count: json['count'],
      provider: json['provider'],
      totalCostWithVat: json['total_cost_with_vat'],
    );
  }
}
