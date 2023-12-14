import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper {
  static const String _userCredentialsBox = 'user_credentials';
  static const String _userProfileBox = 'user_profile';
  static const String _meetingsBox = 'get_meetings';
  static const String _userAnalyticsBox = 'user_analytics_box';

  // Инициализация Hive и открытие "боксов" (аналог таблиц в SQLite)
  static Future<void> initHive() async {
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    } else {
      Hive.initFlutter();
    }

    await Hive.openBox<Map>(_userCredentialsBox);
    await Hive.openBox<Map>(_userProfileBox);
    await Hive.openBox<Map>(_meetingsBox);
    await Hive.openBox<Map>(_userAnalyticsBox);
  }

  static Future<void> saveToken(String token, int userId) async {
    var box = Hive.box<Map>(_userCredentialsBox);
    await box.put('token', {'token': token, 'userId': userId});
  }

  static String? getToken() {
    var box = Hive.box<Map>(_userCredentialsBox);
    var tokenData = box.get('token');
    return tokenData?['token'];
  }

  static Future<void> deleteToken() async {
    var box = Hive.box<Map>(_userCredentialsBox);
    await box.delete('token');
  }

  static Future<void> saveUserProfileData(Map<String, dynamic> userData) async {
    var box = Hive.box<Map>(_userProfileBox);
    await box.put('userDataProfile', userData);
  }

  static Map? getUserProfileData() {
    var box = Hive.box<Map>(_userProfileBox);
    return box.get('userDataProfile');
  }

  static Future<void> saveAnalyticsData(String responseBody) async {
    final parsed = json.decode(responseBody);
    var box = Hive.box('_userAnalyticsBox');
    await box.put('userAnalytics', parsed);
  }

  static Map? getAnalyticsData() {
    var box = Hive.box('_userAnalyticsBox'); // Исправьте на строку в кавычках
    return box.get('userAnalytics');
  }

  static Future<void> saveMeetingData(
      Map<String, dynamic> meetingData, userId) async {
    var box = Hive.box<Map>(_meetingsBox);
    await box.put('meetingList', meetingData);
  }

  static Map? getMeeting() {
    var box = Hive.box<Map>(_meetingsBox);
    return box.get('meetingList');
  }
}
