// calendar_event.dart
part of 'commentary_bloc.dart';

abstract class CommentaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchData extends CommentaryEvent {}

class FetchAnalyse extends CommentaryEvent {}
