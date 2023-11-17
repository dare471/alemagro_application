import 'dart:convert';
import 'package:alemagro_application/models/UserAnalyticDashboard.dart';
import 'package:alemagro_application/models/execution_plan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Events
abstract class UserAnalyticEvent {}

class FetchUserAnalytics extends UserAnalyticEvent {
  final int userId;
  FetchUserAnalytics(this.userId);
}

class FetchUserExecutePlan extends UserAnalyticEvent {
  final int userId;
  FetchUserExecutePlan(this.userId);
}

// States
abstract class UserAnalyticState {}

class AnalyticInitialState extends UserAnalyticState {}

///State
class LoadingState extends UserAnalyticState {}

class LoadingStateExecutePlan extends UserAnalyticState {}

///Mounte state
class LoadedState extends UserAnalyticState {
  final UserStats data;
  LoadedState(this.data);
}

class LoadedStateExecutePlan extends UserAnalyticState {
  final ExecutionPlan data;
  LoadedStateExecutePlan(this.data);
}

///Error State
class ErrorState extends UserAnalyticState {
  final String message;
  ErrorState(this.message);
}

// BLoC for Plan Fact group data
class UserAnalyticBloc extends Bloc<UserAnalyticEvent, UserAnalyticState> {
  final String baseUrl = 'https://crm.alemagro.com:8080';

  UserAnalyticBloc() : super(AnalyticInitialState());

  @override
  Stream<UserAnalyticState> mapEventToState(UserAnalyticEvent event) async* {
    if (event is FetchUserAnalytics) {
      yield LoadingState();
      try {
        final UserStats userStats = await _fetchUserData(event.userId);
        yield LoadedState(userStats);
      } catch (e) {
        print("Error occurred: $e");
        yield ErrorState(e.toString());
      }
    }
  }

  Future<UserStats> _fetchUserData(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/mobile/client/dashboard'),
      body: jsonEncode({
        "type": "planFactUserGroup",
        "userId": userId,
      }),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      //print(response.body);
      return UserStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Не удалось загрузить данные");
    }
  }
}

//navigate function for Execute Plan
// _navigateExecutePlan(data) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => MainAnalyseScreen(data: data)),
//   );
// }

// BLoC for Execute Plan
class UserAnalyticExecutePlanBloc
    extends Bloc<UserAnalyticEvent, UserAnalyticState> {
  final String baseUrl = 'https://crm.alemagro.com:8080';

  UserAnalyticExecutePlanBloc() : super(AnalyticInitialState());

  @override
  Stream<UserAnalyticState> mapEventToState(UserAnalyticEvent event) async* {
    if (event is FetchUserExecutePlan) {
      yield LoadingState();
      try {
        final ExecutionPlan executePlan = await _fetchUserData(event.userId);
        //  _navigateExecutePlan(executePlan);
        yield LoadedStateExecutePlan(executePlan);
      } catch (e) {
        print("Error occurred: $e");
        yield ErrorState(e.toString());
      }
    }
  }

  Future<ExecutionPlan> _fetchUserData(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/mobile/client/dashboard'),
      body: jsonEncode({
        "type": "executePlan",
        "userId": userId,
      }),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      //print(response.body);
      return ExecutionPlan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Не удалось загрузить данные");
    }
  }
}
