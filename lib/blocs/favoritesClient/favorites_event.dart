abstract class FavoritesClientEvent {}

class FetchFavoritesClient extends FavoritesClientEvent {
  final int userId;

  FetchFavoritesClient(this.userId);
}

class FilterFavoritesClient extends FavoritesClientEvent {
  final String query;
  final bool isSortedByMargin;

  FilterFavoritesClient(this.query, this.isSortedByMargin);
}
