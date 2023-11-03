// calendar_event.dart
part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMeetings extends CalendarEvent {}
