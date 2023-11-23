class UserAnalyticsData {
  final int userId;
  final String userName;
  final String provider;
  final String productName;
  final int planSum;
  final int planCount;
  final int factSumma;
  final int factCount;
  final int sumShipped;
  final int countShipped;
  final double executionPlan;

  UserAnalyticsData({
    required this.userId,
    required this.userName,
    required this.provider,
    required this.productName,
    required this.planSum,
    required this.planCount,
    required this.factSumma,
    required this.factCount,
    required this.sumShipped,
    required this.countShipped,
    required this.executionPlan,
  });

  // Добавим методы `fromJSON` и `toJSON` для сериализации.

  factory UserAnalyticsData.fromJSON(Map<String, dynamic> json) {
    return UserAnalyticsData(
      userId: json['userId'],
      userName: json['userName'],
      provider: json['provider'],
      productName: json['productName'],
      planSum: json['planSum'],
      planCount: json['planCount'],
      factSumma: json['factSumma'],
      factCount: json['factCount'],
      sumShipped: json['sumShipped'],
      countShipped: json['countShipped'],
      executionPlan: json['executionPlan']
          .toDouble(), // Поскольку это число с плавающей точкой, нам нужно убедиться, что мы правильно обрабатываем его из JSON.
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'userId': userId,
      'userName': userName,
      'provider': provider,
      'productName': productName,
      'planSum': planSum,
      'planCount': planCount,
      'factSumma': factSumma,
      'factCount': factCount,
      'sumShipped': sumShipped,
      'countShipped': countShipped,
      'executionPlan': executionPlan,
    };
  }
}

class UserAnalyticsList {
  final List<UserAnalyticsData> analytics;

  UserAnalyticsList({required this.analytics});

  factory UserAnalyticsList.fromJSON(List<dynamic> jsonList) {
    List<UserAnalyticsData> analyticsList =
        jsonList.map((json) => UserAnalyticsData.fromJSON(json)).toList();
    return UserAnalyticsList(analytics: analyticsList);
  }
}
