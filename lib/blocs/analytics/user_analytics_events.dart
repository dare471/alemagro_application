// events/user_analytics_event.dart

abstract class UserAnalyticsEvent {}

class FetchUserAnalytics extends UserAnalyticsEvent {
  final int userId;

  FetchUserAnalytics(this.userId);
}
