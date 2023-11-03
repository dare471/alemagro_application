import 'dart:convert';

import 'package:alemagro_application/database/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart'; // Ваш хелпер для работы с базой данных
import 'package:alemagro_application/repositories/user_repository.dart'; // Ваш репозиторий, содержащий методы для взаимодействия с API

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  // Инжектируем репозиторий в ваш BLoC
  AuthBloc({required this.userRepository}) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<CheckPinStored>(_onCheckPinStored);

    on<LoginRequested>(
        _onLoginRequested); // Событие для начала процесса аутентификации
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final token = await DatabaseHelper.getToken();
    if (token != null) {
      emit(AuthSuccess(token: token));
    } else {
      emit(AuthFailure(error: 'Сообщение об ошибке здесь'));
      // передача сообщения об ошибке в состояние
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Оповещаем UI о том, что идет процесс загрузки

    try {
      final userCredential = await userRepository.authenticate(
        email: event.username,
        password: event.password,
      );

      final decodedUserCredential = jsonDecode(userCredential);
      print('Успешное получение данных от сервера: $decodedUserCredential');

      int userId = decodedUserCredential['user']['id'];
      String token = decodedUserCredential['token'];
      Map<String, dynamic> userData = decodedUserCredential['user'];
      await DatabaseHelper.saveToken(token, userId);
      await DatabaseHelper.saveUserProfileData(userData);
      emit(AuthSuccess(token: token)); // после успешной авторизации
      // add(CheckPinStored()); // проверяем наличие PIN-кода
    } catch (error) {
      print('Ошибка в процессе аутентификации: $error');
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    // Этот метод теперь может быть просто для обработки дополнительной логики или состояний, если это необходимо после того, как пользователь был аутентифицирован и токен сохранен
    emit(AuthSuccess(token: event.token));
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await DatabaseHelper.deleteToken();
    emit(AuthFailure(error: 'Не удалось удалить'));
  }

  Future<void> _onCheckPinStored(
      CheckPinStored event, Emitter<AuthState> emit) async {
    final storage = FlutterSecureStorage();
    String? pin = await storage.read(key: 'pin');
    if (pin != null) {
      emit(
          AuthPinCheck()); // Вы можете использовать это состояние для перехода на экран ввода PIN-кода
    } else {
      emit(AuthFailure(
          error:
              'PIN not set')); // Вы можете использовать это состояние для перехода на экран установки PIN-кода
    }
  }
}
