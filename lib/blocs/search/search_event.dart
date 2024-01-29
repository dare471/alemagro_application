abstract class ClientSearchEvent {}

class ClientSearchTextChanged extends ClientSearchEvent {
  final String searchText;

  ClientSearchTextChanged({required this.searchText});
}

class ClientSearchByName extends ClientSearchEvent {
  final String name;
  ClientSearchByName({required this.name});
}

class ClientSearchById extends ClientSearchEvent {
  final int id;
  ClientSearchById({required this.id});
}
