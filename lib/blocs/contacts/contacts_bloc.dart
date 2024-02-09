import 'dart:convert';

import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import '../../database/database_helper.dart';
import '../../models/contact/contact.dart';

part 'contacts_state.dart';
part 'contacts_event.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;

  ContactBloc({required this.contactRepository}) : super(ContactInitial()) {
    on<GetContact>(_onFetchContacts);
  }

  Future<void> _onFetchContacts(
      GetContact event, Emitter<ContactState> emit) async {
    try {
      List<ContactModel> data = await contactRepository.fetchMeetingsFromAPI();
      emit(ContactFetched(data));
    } catch (e) {
      emit(ContactFetchedFailed(e.toString()));
    }
  }
}

class ContactRepository {
  Future<List<ContactModel>> fetchMeetingsFromAPI() async {
    try {
      final userProfileData = DatabaseHelper.getUserProfileData();
      final body = jsonEncode(
          {"type": "contactInf", "action": "getContact", "clientId": 2});

      final response = await http.post(
        Uri.parse(API.managerWorkspace),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        // print("Failed to load meetings, status code: ${response.statusCode}");
        throw Exception(
            "Failed to load meetings, status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }
}
