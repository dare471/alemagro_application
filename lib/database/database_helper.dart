import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const String _userCredentialsBox = 'user_credentials';
  static const String _userProfileBox = 'user_profile';
  static const String _meetingsBox = 'get_meetings';

  // Инициализация Hive и открытие "боксов" (аналог таблиц в SQLite)
  static Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    await Hive.openBox<Map>(_userCredentialsBox);
    await Hive.openBox<Map>(_userProfileBox);
    await Hive.openBox<Map>(_meetingsBox);
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
}
