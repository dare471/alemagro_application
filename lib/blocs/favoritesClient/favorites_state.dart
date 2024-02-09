// states/user_analytics_state.dart

import 'package:alemagro_application/models/favorites/favorites.dart';

abstract class FavoritesClientState {}

class FavoritesInitialState extends FavoritesClientState {}

class LoadingState extends FavoritesClientState {}

class LoadedState extends FavoritesClientState {
  final List<Favorites> data;

  LoadedState(this.data);
}

class ErrorState extends FavoritesClientState {
  final String message;

  ErrorState(this.message);
}
