import 'dart:async';
import 'dart:convert';

import 'package:alemagro_application/blocs/search/search_event.dart';
import 'package:alemagro_application/blocs/search/search_state.dart';
import 'package:alemagro_application/models/search_client.dart';
import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ClientSearchBloc extends Bloc<ClientSearchEvent, ClientSearchState> {
  ClientSearchBloc() : super(ClientSearchInitial()) {
    on<ClientSearchTextChanged>(_onClientSearchTextChanged);
    on<ClientSearchById>(_onClientSearchById);
    on<ClientSearchByName>(_onClientSearchByName);
  }

  void _onClientSearchTextChanged(
      ClientSearchTextChanged event, Emitter<ClientSearchState> emit) async {
    print("Handling search event: ${event.searchText}"); // Для отладки

    if (event.searchText.isEmpty) {
      emit(ClientSearchInitial());
      return;
    }

    emit(ClientSearchLoading());

    try {
      final response =
          await searchClient(event.searchText, 'name'); // для поиска по имени
// Имплементация функции поиска

      emit(ClientSearchSuccess(clients: response));
    } catch (e) {
      emit(ClientSearchFailure(error: e.toString()));
    }
  }

  void _onClientSearchById(
      ClientSearchById event, Emitter<ClientSearchState> emit) async {
    emit(ClientSearchLoading());

    try {
      final clients = await searchClient(event.id, 'id');
      emit(ClientSearchSuccess(clients: clients));
    } catch (e) {
      emit(ClientSearchFailure(error: e.toString()));
    }
  }

  void _onClientSearchByName(
      ClientSearchByName event, Emitter<ClientSearchState> emit) async {
    emit(ClientSearchLoading());

    try {
      final clients = await searchClient(event.name, 'name');
      emit(ClientSearchSuccess(clients: clients));
    } catch (e) {
      emit(ClientSearchFailure(error: e.toString()));
    }
  }

  Future<List<BusinessEntity>> searchClient(
      dynamic searchText, String searchType) async {
    if (searchText is String && searchText.isEmpty) {
      return [];
    }

    try {
      var url = Uri.parse(API.planned);
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': 'plannedMeeting',
          'action': 'searchClient',
          searchType == 'id' ? 'clientId' : 'clientName': searchText,
        }),
      );
      print(jsonEncode({
        'type': 'plannedMeeting',
        'action': 'searchClient',
        searchType == 'id' ? 'clientId' : 'clientName': searchText,
      }));
      print(response.body);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => BusinessEntity.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error occurred during search: $e');
    }
  }
}
