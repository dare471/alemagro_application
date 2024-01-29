// calendar_state.dart
part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class MeetingsFetched extends CalendarState {
  final List<Visit> meetings;
  final List<CountMeeting> countMeetings;
  MeetingsFetched(this.meetings, this.countMeetings);

  @override
  List<Object> get props => [meetings];
}

class CalendarPageLoaded extends CalendarState {
  final int currentPage;

  CalendarPageLoaded(this.currentPage);
}

class MeetingsFetchFailed extends CalendarState {
  final String error;

  MeetingsFetchFailed(this.error);

  @override
  List<Object> get props => [error];
}

class CalendarMonthViewState extends CalendarState {}

class CalendarWeekViewState extends CalendarState {}
