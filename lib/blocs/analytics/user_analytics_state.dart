// states/user_analytics_state.dart

import 'package:alemagro_application/models/UserAnalyticDashboard.dart';

abstract class UserAnalyticState {}

class AnalyticInitialState extends UserAnalyticState {}

class LoadingState extends UserAnalyticState {}

class LoadedState extends UserAnalyticState {
  final UserStats data;

  LoadedState(this.data);
}

class ErrorState extends UserAnalyticState {
  final String message;

  ErrorState(this.message);
}
