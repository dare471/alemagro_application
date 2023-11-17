class ExecutionPlan {
  final int userId;
  final String userName;
  final String monthName;
  final String planSum2021;
  final String executeSumPlan2021;
  final String planSum2022;
  final String executeSumPlan2022;
  final String planSum2023;
  final double executeSumPlan2023;
  final double planSum2024;
  final double executeSumPlan2024;

  ExecutionPlan({
    required this.userId,
    required this.userName,
    required this.monthName,
    required this.planSum2021,
    required this.executeSumPlan2021,
    required this.planSum2022,
    required this.executeSumPlan2022,
    required this.planSum2023,
    required this.executeSumPlan2023,
    required this.planSum2024,
    required this.executeSumPlan2024,
  });

  // поля сделаны nullable, добавлены значения по умолчанию или исключения
  factory ExecutionPlan.fromJson(Map<String, dynamic> json) {
    if (json['data'][0]['userId'] == null) {
      throw Exception("userId is null");
    }
    if (json['data'][0]['executionPlan'] == null) {
      throw Exception("executionPlan is null");
    }
    return ExecutionPlan(
      userId: json['data'][0]['userId'] as int,
      userName:
          json['data'][0]['userName'] ?? "Unknown", // значение по умолчанию
      monthName: json['data'][0]['monthName'] ?? "0",
      planSum2021: json['data'][0]['planSum2021'] ?? "0",
      executeSumPlan2021: json['data'][0]['executeSumPlan2021'] ?? "0",
      planSum2022: json['data'][0]['planSum2022'] ?? "0",
      executeSumPlan2022: json['data'][0]['executeSumPlan2022'] ?? "0",
      planSum2023: json['data'][0]['planSum2023'] ?? "0",
      executeSumPlan2023: (json['data'][0]['executeSumPlan2023'] as num)
          .toDouble(), // сначала кастуем к num, потом к double
      planSum2024: (json['data'][0]['planSum2024'] as num).toDouble(),
      executeSumPlan2024:
          (json['data'][0]['executeSumPlan2024'] as num).toDouble(),
    );
  }
}

class ExecutionPlanList {
  final List<ExecutionPlan> data;

  ExecutionPlanList({
    required this.data,
  });

  factory ExecutionPlanList.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ExecutionPlan> dataList =
        list.map((i) => ExecutionPlan.fromJson(i)).toList();

    return ExecutionPlanList(
      data: dataList,
    );
  }
}
