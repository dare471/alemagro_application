class UserStats {
  final int userId;
  final String userName;
  final String countProduct;
  final String planSum;
  final String planCountProduct;
  final String factCountProduct;
  final String sumShipment;
  final String countShipment;
  final double executionPlan;

  UserStats({
    required this.userId,
    required this.userName,
    required this.countProduct,
    required this.planSum,
    required this.planCountProduct,
    required this.factCountProduct,
    required this.sumShipment,
    required this.countShipment,
    required this.executionPlan,
  });

  // поля сделаны nullable, добавлены значения по умолчанию или исключения
  factory UserStats.fromJson(Map<String, dynamic> json) {
    if (json['data'][0]['userId'] == null) {
      throw Exception("userId is null");
    }
    if (json['data'][0]['executionPlan'] == null) {
      throw Exception("executionPlan is null");
    }
    return UserStats(
      userId: json['data'][0]['userId'] as int,
      userName:
          json['data'][0]['userName'] ?? "Unknown", // значение по умолчанию
      countProduct: json['data'][0]['countProduct'] ?? "0",
      planSum: json['data'][0]['planSum'] ?? "0",
      planCountProduct: json['data'][0]['planCountProduct'] ?? "0",
      factCountProduct: json['data'][0]['factCountProduct'] ?? "0",
      sumShipment: json['data'][0]['sumShipment'] ?? "0",
      countShipment: json['data'][0]['countShipment'] ?? "0",
      executionPlan: (json['data'][0]['executionPlan'] as num)
          .toDouble(), // сначала кастуем к num, потом к double
    );
  }
}

class UserStatsList {
  final List<UserStats> data;

  UserStatsList({
    required this.data,
  });

  factory UserStatsList.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<UserStats> dataList = list.map((i) => UserStats.fromJson(i)).toList();

    return UserStatsList(
      data: dataList,
    );
  }
}
