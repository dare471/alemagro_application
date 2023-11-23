import 'dart:convert';

class UserStats {
  final int userId;
  final String userName;
  final String countProduct;
  final String planSum;
  final String planCountProduct;
  final String factCountProduct;
  final String sumShipment;
  final String countShipment;
  final int executionPlan;

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

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'],
      userName: json['userName'],
      countProduct: json['countProduct'],
      planSum: json['planSum'],
      planCountProduct: json['planCountProduct'],
      factCountProduct: json['factCountProduct'],
      sumShipment: json['sumShipment'],
      countShipment: json['countShipment'],
      executionPlan: json['executionPlan'],
    );
  }
}

List<UserStats> parseUserStats(String responseBody) {
  try {
    final parsed = json.decode(responseBody);
    final List<dynamic> dataList = parsed['data'];
    return dataList.map<UserStats>((json) => UserStats.fromJson(json)).toList();
  } catch (e) {
    print('Error parsing user stats: $e');
    rethrow; // Чтобы ошибка была перехвачена в `_onFetchUserAnalytics`
  }
}
