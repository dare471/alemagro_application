part of 'commentary_bloc.dart';

abstract class CommentaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CommentaryInitial extends CommentaryState {}

class CommentaryFetched extends CommentaryState {
  final List<CommentaryNote> data;
  CommentaryFetched(this.data);

  @override
  List<Object> get props => [data];
}

class CommentaryFetchedFailed extends CommentaryState {
  final String error;

  CommentaryFetchedFailed(this.error);

  @override
  List<Object> get props => [error];
}
