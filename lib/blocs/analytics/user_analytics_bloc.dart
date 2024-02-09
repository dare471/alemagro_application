import 'dart:convert';
import 'package:alemagro_application/blocs/analytics/user_analytics_events.dart';
import 'package:alemagro_application/blocs/analytics/user_analytics_state.dart';
import 'package:alemagro_application/models/UserAnalyticDashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:alemagro_application/repositories/user_repository.dart';

// blocs/user_analytics_bloc.dart
class UserAnalyticBloc extends Bloc<UserAnalyticsEvent, UserAnalyticState> {
  UserAnalyticBloc() : super(AnalyticInitialState()) {
    on<FetchUserAnalytics>(_onFetchUserAnalytics);
  }

  void _onFetchUserAnalytics(
      FetchUserAnalytics event, Emitter<UserAnalyticState> emit) async {
    emit(LoadingState());
    try {
      List<UserStats> statsList = await _fetchUserData(event.userId);
      // If there's data, emit the LoadedState with the first item, or modify accordingly
      if (statsList.isNotEmpty) {
        emit(LoadedState(
            statsList.first)); // Emit the first item if the list is not empty
      } else {
        emit(ErrorState('No data found for the given user ID.'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

Future<List<UserStats>> _fetchUserData(int userId) async {
  // Замените на ваш базовый URL API
  final response = await http.post(
    Uri.parse(API.dashboard),
    body: jsonEncode({
      "type": "planFactUserGroup",
      "userId": userId,
    }),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    return parseUserStats(response.body);
    // return UserStats.fromJson(jsonDecode(response.body));
  } else {
    // Лучше использовать более специфическое сообщение об ошибке в зависимости от статуса ответа
    throw Exception(
        "Не удалось загрузить данные. Статус: ${response.statusCode}");
  }
}
