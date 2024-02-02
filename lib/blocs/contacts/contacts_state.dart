part of 'contacts_bloc.dart';

abstract class ContactState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactFetched extends ContactState {
  final List<ContactModel> data;
  ContactFetched(this.data);

  @override
  List<Object> get props => [data];
}

class ContactFetchedFailed extends ContactState {
  final String error;

  ContactFetchedFailed(this.error);

  @override
  List<Object> get props => [error];
}
