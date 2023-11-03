// calendar_state.dart
part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class MeetingsFetched extends CalendarState {
  final List<Meeting> meetings;

  MeetingsFetched(this.meetings);

  @override
  List<Object> get props => [meetings];
}

class MeetingsFetchFailed extends CalendarState {
  final String error;

  MeetingsFetchFailed(this.error);

  @override
  List<Object> get props => [error];
}
