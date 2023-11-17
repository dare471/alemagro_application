abstract class AnalyticDetailState {}

class AnalyticDetailInitial extends AnalyticDetailState {}

class AnalyticDetailError extends AnalyticDetailState {
  final String error;

  AnalyticDetailError(this.error);
}

class AnalyticDetailFetched extends AnalyticDetailState {
  final List<dynamic> listItems;

  AnalyticDetailFetched(this.listItems);
}
