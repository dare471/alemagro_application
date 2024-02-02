import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static const String baseUrl = "https://crm.alemagro.com:8080/api";
  static const String auth = '$baseUrl/auth/login';
  static const String planned = '$baseUrl/planned/mobile';
  static const String comment = '$baseUrl/comment';
  static const String dashboard = '$baseUrl/mobile/client/dashboard';
  static const String favorites = '$baseUrl/workspace/mobile';
  static const String managerWorkspace = '$baseUrl/manager/workspace';
}

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  // Метод для аутентификации пользователя. Возвращает токен в случае успеха.
  Future<String> authenticate({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/auth/login'), // Предположим, что '/login' - это конечная точка вашего API для аутентификации.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      // Если сервер возвращает ответ с кодом 200 OK, то мы разбираем JSON.
      // print(response.body);
      return response.body;
      // return jsonDecode(response.body)[
      //     'token']; // Предположим, что токен находится в теле ответа.
    } else {
      throw Exception('Failed to authenticate user');
    }
  }
  // Другие методы для работы с данными пользователя (например, получение информации о профиле, обновление профиля и т.д.) могут быть добавлены здесь.
}
