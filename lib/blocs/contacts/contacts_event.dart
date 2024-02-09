// calendar_event.dart
part of 'contacts_bloc.dart';

abstract class ContactEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetContact extends ContactEvent {}
