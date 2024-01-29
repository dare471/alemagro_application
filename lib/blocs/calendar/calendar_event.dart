// calendar_event.dart
part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CalendarPageChanged extends CalendarEvent {
  final int pageIndex;

  CalendarPageChanged(this.pageIndex);
}

class FetchMeetings extends CalendarEvent {}

class FetchMeetingsToday extends CalendarEvent {}

class ToggleCalendarViewEvent extends CalendarEvent {}
