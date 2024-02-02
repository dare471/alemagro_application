// blocs/user_analytics_bloc.dart
import 'dart:convert';

import 'package:alemagro_application/blocs/favoritesClient/favorites_event.dart';
import 'package:alemagro_application/blocs/favoritesClient/favorites_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

import '../../models/favorites/favorites.dart';

class FavoritesClientBloc
    extends Bloc<FavoritesClientEvent, FavoritesClientState> {
  List<Favorites> allFavorites = []; // Переменная для хранения всех избранных

  FavoritesClientBloc() : super(FavoritesInitialState()) {
    on<FetchFavoritesClient>(_onFetchFavorites);
    on<FilterFavoritesClient>(_onFilterFavoritesClient);
  }

  void _onFilterFavoritesClient(
      FilterFavoritesClient event, Emitter<FavoritesClientState> emit) {
    var filteredList = allFavorites
        .where((favorite) => favorite.clientName
            .toLowerCase()
            .contains(event.query.toLowerCase()))
        .toList();

    if (event.isSortedByMargin) {
      filteredList.sort((a, b) =>
          b.yearlyData.first.margin.compareTo(a.yearlyData.first.margin));
    }

    emit(LoadedState(filteredList));
  }

  void _onFetchFavorites(
      FetchFavoritesClient event, Emitter<FavoritesClientState> emit) async {
    emit(LoadingState());
    try {
      List<Favorites> favoritesList = await _fetchUserData(event.userId);
      if (favoritesList.isNotEmpty) {
        emit(LoadedState(favoritesList)); // Теперь передаем весь список
      } else {
        emit(ErrorState('No data found for the given user ID.'));
      }
    } catch (e) {
      print('Exception details: $e');
      emit(ErrorState(e.toString()));
    }
  }
}

Future<List<Favorites>> _fetchUserData(int userId) async {
  // Замените на ваш базовый URL API
  final response = await http.post(
    Uri.parse(API.favorites),
    body: jsonEncode({
      "type": "favorites",
      "action": "getClient",
      "userId": userId,
    }),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    return parseFavorites(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Response body: ${response.body}');
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
