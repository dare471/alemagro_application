import 'dart:async';
import 'dart:convert';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/models/calendar_visit.dart';
import 'package:alemagro_application/models/properties.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

import 'package:hive/hive.dart';
import 'package:alemagro_application/models/visit.dart'; // Импортируйте вашу модель данных

part 'calendar_state.dart';
part 'calendar_event.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    // Register event handler for FetchMeetings
    on<FetchMeetings>(_onFetchMeetings);
    on<ToggleCalendarViewEvent>(_onToggleCalendarView);
  }

  // Event handler for FetchMeetings
  Future<void> _onFetchMeetings(
      FetchMeetings event, Emitter<CalendarState> emit) async {
    try {
      List<Meeting> meetings = await fetchMeetingsFromAPI();
      print(meetings);
      emit(MeetingsFetched(meetings)); // Emitting the fetched meetings state
    } catch (e) {
      emit(MeetingsFetchFailed(e.toString())); // Emitting the error state
    }
  }

  // Обработчик события ToggleCalendarViewEvent
  void _onToggleCalendarView(
      ToggleCalendarViewEvent event, Emitter<CalendarState> emit) {
    if (state is CalendarMonthViewState) {
      if (state is MeetingsFetched) {
        // сохраняем текущие встречи
        final meetings = (state as MeetingsFetched).meetings;
        emit(CalendarWeekViewState());
        // восстанавливаем встречи
      } else {
        emit(CalendarWeekViewState());
      }
    } else {
      if (state is MeetingsFetched) {
        final meetings = (state as MeetingsFetched).meetings;
        emit(CalendarMonthViewState());
        emit(MeetingsFetched(meetings));
      } else {
        emit(CalendarMonthViewState());
      }
    }
  }

  Future<List<Meeting>> fetchMeetingsFromAPI() async {
    final userProfileData = DatabaseHelper.getUserProfileData();
    const url = 'https://crm.alemagro.com:8080/api/planned/mobile';
    final body = jsonEncode({
      "type": "plannedMeeting",
      "action": "getMeetings",
      "userId": userProfileData?['id'] ?? '',
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      print(body);
      return jsonResponse.map((json) => Meeting.fromJson(json)).toList();
    } else {
      // print("Failed to load meetings, status code: ${response.statusCode}");
      throw Exception(
          "Failed to load meetings, status code: ${response.statusCode}");
    }
  }

  Future<void> saveDataToHive(dynamic data) async {
    var box = await Hive.openBox<Visit>('visits'); // Откройте коробку Hive

    // Преобразуйте данные из JSON в список объектов Visit
    List<Visit> visits = (data as List).map((item) {
      var properties = Properties()
        ..statusVisit = item['properties']['statusVisit']
        ..id = item['properties']['id']
        ..clientAddress = item['properties']['clientAddres'];
      // ... продолжите заполнение остальных полей для properties

      return Visit()
        ..id = item['id']
        ..clientId = item['clientId']
        // ... продолжите заполнение остальных полей для Visit
        ..properties = properties;
    }).toList();

    // Сохраните все объекты Visit в коробке Hive
    for (var visit in visits) {
      await box.add(visit);
    }

    // Закройте коробку, если это необходимо в вашем приложении
    // await box.close();
  }
}
