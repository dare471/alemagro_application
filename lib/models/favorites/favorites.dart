import 'dart:convert';

class Favorites {
  final int clientId;
  final String clientName;
  final String clientBin;
  final List<YearlyData> yearlyData;

  Favorites({
    required this.clientId,
    required this.clientName,
    required this.clientBin,
    required this.yearlyData,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) {
    var list = json['yearlyData'] as List;
    List<YearlyData> yearlyDataList =
        list.map((i) => YearlyData.fromJson(i)).toList();

    return Favorites(
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientBin: json['clientBin'],
      yearlyData: yearlyDataList,
    );
  }
}

class YearlyData {
  final String year;
  final String salesAmount;
  final double margin;

  YearlyData({
    required this.year,
    required this.salesAmount,
    required this.margin,
  });

  factory YearlyData.fromJson(Map<String, dynamic> json) {
    return YearlyData(
      year: json['year'],
      salesAmount: json['salesAmount'],
      margin: json['margin'].toDouble(),
    );
  }
}

List<Favorites> parseFavorites(String responseBody) {
  final parsed = json.decode(responseBody) as List;
  return parsed.map<Favorites>((json) => Favorites.fromJson(json)).toList();
}
