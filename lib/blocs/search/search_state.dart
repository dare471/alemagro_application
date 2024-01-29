import '../../models/search_client.dart';

abstract class ClientSearchState {}

class ClientSearchInitial extends ClientSearchState {}

class ClientSearchLoading extends ClientSearchState {}

class ClientSearchSuccess extends ClientSearchState {
  final List<BusinessEntity> clients;

  ClientSearchSuccess({required this.clients});
}

class ClientSearchFailure extends ClientSearchState {
  final String error;

  ClientSearchFailure({required this.error});
}
