import 'dart:convert';

import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import '../../database/database_helper.dart';
import '../../models/commentary/main_model.dart';

part 'commentary_state.dart';
part 'commentary_event.dart';

class CommentaryBloc extends Bloc<CommentaryEvent, CommentaryState> {
  final CommentaryRepository commentaryRepository;

  CommentaryBloc({required this.commentaryRepository})
      : super(CommentaryInitial()) {
    on<FetchData>(_onFetchMeetings);
    on<FetchAnalyse>(_onFetchAnalyse);
  }

  Future<void> _onFetchMeetings(
      FetchData event, Emitter<CommentaryState> emit) async {
    try {
      List<CommentaryNote> data =
          await commentaryRepository.fetchMeetingsFromAPI();
      emit(CommentaryFetched(data));
    } catch (e) {
      emit(CommentaryFetchedFailed(e.toString()));
    }
  }

  Future<void> _onFetchAnalyse(
      FetchAnalyse event, Emitter<CommentaryState> emit) async {
    try {
      List<CommentaryNote> data =
          await commentaryRepository.fetchMeetingsFromAPI();
      emit(CommentaryFetched(data));
    } catch (e) {
      emit(CommentaryFetchedFailed(e.toString()));
    }
  }
}

class CommentaryRepository {
  Future<List<CommentaryNote>> fetchMeetingsFromAPI() async {
    final userProfileData = DatabaseHelper.getUserProfileData();
    final body = jsonEncode({
      "type": "notesToTheClient",
      "action": "viewsComment",
      "clientId": 1555
    });

    final response = await http.post(
      Uri.parse(API.comment),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      print(response.body);
      return jsonResponse.map((json) => CommentaryNote.fromJson(json)).toList();
    } else {
      // print("Failed to load meetings, status code: ${response.statusCode}");
      throw Exception(
          "Failed to load meetings, status code: ${response.statusCode}");
    }
  }
}
