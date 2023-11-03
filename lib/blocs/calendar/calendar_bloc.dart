import 'dart:async';
import 'dart:convert';
import 'package:alemagro_application/models/calendar_visit.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

part 'calendar_state.dart';
part 'calendar_event.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial());

  // ignore: override_on_non_overriding_member
  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    print("Received event: $event");
    if (event is FetchMeetings) {
      try {
        List<Meeting> meetings = await fetchMeetingsFromAPI();
        yield MeetingsFetched(meetings);
      } catch (e) {
        yield MeetingsFetchFailed(e.toString());
      }
    }
  }

  Future<List<Meeting>> fetchMeetingsFromAPI() async {
    final authData = Hive.box('authBox').get('data');
    final url = 'https://crm.alemagro.com:8080/api/planned/mobile';
    final body = jsonEncode({
      "type": "plannedMeeting",
      "action": "getMeetings",
      "userId": authData['user']['id'],
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse.map((json) => Meeting.fromJson(json)).toList();
    } else {
      // print("Failed to load meetings, status code: ${response.statusCode}");
      throw Exception(
          "Failed to load meetings, status code: ${response.statusCode}");
    }
  }
}
