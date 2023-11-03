import 'dart:convert';
import 'package:http/http.dart' as http;

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
