import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/blocs/commentary/commentary_bloc.dart';
import 'package:alemagro_application/blocs/contacts/contacts_bloc.dart';
import 'package:alemagro_application/models/calendar_visit.dart';
import 'package:alemagro_application/screens/staff/calendar/meeting/meetingCalendar/meeting_calendar.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../meetingCard/mainCard.dart';

Widget buildCalendar(BuildContext context, page) {
  // Use BlocProvider to provide the CalendarBloc to the widget tree
  return BlocProvider<CalendarBloc>(
    create: (context) => CalendarBloc()
      ..add(
          FetchMeetings()), // Trigger fetching meetings when the widget is created
    child: Card(
      elevation: 10,
      shadowColor: Color.fromARGB(47, 3, 90, 166),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state is CalendarInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MeetingsFetched) {
            if (page == 0) {
              return buildMeetingList(context, state.meetings);
            } else {
              return buildSpis(context, state.meetings);
            }
          } else if (state is MeetingsFetchFailed) {
            return Center(
                child: Text('Failed to load meetings $MeetingsFetchFailed'));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    ),
  );
}

Widget buildSpis(BuildContext context, meetings) {
// Для хранения выбранного описания
  final ValueNotifier<String> searchQuery =
      ValueNotifier(""); // Поисковый запрос

  Map<String, List<Visit>> groupedMeetings = {};
  for (Visit meeting in meetings) {
    groupedMeetings
        .putIfAbsent(meeting.targetDescription, () => [])
        .add(meeting);
  }

  List<String> descriptions = groupedMeetings.keys.toList();

  List<Visit> filterMeetings(String query) {
    if (query.isEmpty) {
      return meetings;
    } else {
      return meetings
          .where((Visit meeting) =>
              meeting.clientName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        child: TextField(
          onChanged: (value) => searchQuery.value = value,
          decoration: InputDecoration(
            labelText: 'Поиск по наименованию клиента',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      Gap(10),
      SizedBox(
        height: 60, // Задайте конкретную высоту
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: descriptions.length,
          itemBuilder: (context, index) {
            String description = descriptions[index];
            List<Visit> meetingsForDescription = groupedMeetings[description]!;

            return GestureDetector(
              onTap: () {
                // Обработка выбора группы
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.blueDarkV2,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      description, // Отображение описания группы
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${meetingsForDescription.length} встреч', // Количество встреч в группе
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      Gap(10),
      Expanded(
        flex: 12,
        child: ValueListenableBuilder(
          valueListenable: searchQuery,
          builder: (context, value, _) {
            List<Visit> filteredMeetings = filterMeetings(value);
            return ListView.builder(
              itemCount: filteredMeetings.length,
              itemBuilder: (_, index) {
                final Visit meeting = filteredMeetings[index];
                // Предполагаем, что dateTime - это строка. Нужно преобразовать её в DateTime
                DateTime dateTime = DateTime.parse(meeting.dateVisit);
                DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'ru');
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dateFormat.format(dateTime)),
                                  Text(meeting.clientName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Gap(5),
                                  Text(meeting.targetDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Gap(5),
                                  meeting.statusVisit == 1
                                      ? Text("Завершенный",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall)
                                      : Text("Не пройден",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                  Gap(10),
                                  Divider(
                                    color: AppColors.blueDark,
                                    height: 4,
                                  ),
                                ])),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<CommentaryBloc>(
                                    create: (context) => CommentaryBloc(
                                      commentaryRepository:
                                          CommentaryRepository(),
                                    ),
                                  ),
                                  BlocProvider<ContactBloc>(
                                    create: (context) => ContactBloc(
                                      contactRepository: ContactRepository(),
                                    ),
                                  ),
                                  // Добавьте здесь другие BlocProvider'ы по мере необходимости
                                ],
                                child: MainCardWidget(
                                    id: meeting.id, meetings: meetings),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      )
    ],
  );
}

Widget buildMeetingList(BuildContext context, List<Visit> meetings) {
  return SfCalendar(
    view: CalendarView.month,
    dataSource: MeetingDataSource(getMeetingsAsAppointments(meetings)),
    monthViewSettings: const MonthViewSettings(
      navigationDirection: MonthNavigationDirection.vertical,
      agendaStyle: AgendaStyle(
          backgroundColor: Colors.transparent,
          appointmentTextStyle: TextStyle(
              color: Colors.white, fontSize: 17, fontStyle: FontStyle.normal),
          dayTextStyle: TextStyle(
              color: Colors.red, fontSize: 17, fontStyle: FontStyle.normal),
          dateTextStyle: TextStyle(
              color: Colors.red,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal)),
      showAgenda: true,
      agendaItemHeight: 90.0,
    ),

    onTap: (CalendarTapDetails details) {
      if (details.targetElement == CalendarElement.agenda ||
          details.targetElement == CalendarElement.appointment) {
        // Получаем первую встречу из списка appointments
        var appointment = details.appointments![0];
        // Проверяем наличие свойства id и извлекаем его
        var appointmentId = appointment.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<CommentaryBloc>(
                  create: (context) => CommentaryBloc(
                    commentaryRepository: CommentaryRepository(),
                  ),
                ),
                BlocProvider<ContactBloc>(
                  create: (context) => ContactBloc(
                    contactRepository: ContactRepository(),
                  ),
                ),
                // Добавьте здесь другие BlocProvider'ы по мере необходимости
              ],
              child: MainCardWidget(id: appointmentId, meetings: meetings),
            ),
          ),
        );
      }
    },
    initialSelectedDate: DateTime.now(),
    todayHighlightColor: Colors.amber.shade900,
    showNavigationArrow: true,
    showWeekNumber: true,
    allowDragAndDrop: true,

    // Other configurations...
  );
}

List<Appointment> getMeetingsAsAppointments(List<Visit> meetings) {
  return meetings.map((meeting) {
    DateTime dateToStart = DateTime.parse(meeting.dateToStart);
    DateTime dateToFinish = DateTime.parse(meeting.dateToFinish);
    Color statusColor = getStatusColor(meeting.statusVisit);
    var descriptionAllDay;
    if (meeting.isAllDay) {
      descriptionAllDay = 'Встреча на весь день';
    } else {
      descriptionAllDay = '';
    }
    Visit meetingInfo = meeting;

    String subject =
        // ignore: unnecessary_brace_in_string_interps
        '${meeting.clientName}\nЦель: ${meeting.targetDescription}\nМесто: ${meeting.placeDescription}\n${descriptionAllDay}';
    return Appointment(
        id: meeting.id,
        subject: subject,
        location: meetingInfo.toString(),
        notes: subject,
        color: statusColor,
        startTime: dateToStart,
        endTime: dateToFinish,
        isAllDay: meeting.isAllDay
        // Set color based on meeting status
        // Add other relevant fields if needed
        );
  }).toList();
}

Color getStatusColor(int status) {
  switch (status) {
    case 1:
      return Colors.green; // Example color for status 1
    case 2:
      return Colors.red; // Example color for status 2
    case 0:
    default:
      return Colors.amber.shade700; // Default color for other statuses
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}

Widget getMeetingStatusIcon(int status) {
  switch (status) {
    case 1:
      return const Icon(Icons.check_circle,
          color: Color.fromARGB(255, 3, 247, 97));
    case 2:
      return Icon(Icons.remove_circle_outlined, color: Colors.red[700]);
    case 0:
      return const Icon(Icons.access_time_filled_sharp,
          color: Color.fromARGB(255, 249, 188, 76));
    default:
      return Icon(Icons.remove_circle_outlined, color: Colors.red[700]);
  }
}

Widget controllerListMeeting(Type buildContext, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Gap(10),
      const TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(),
              gapPadding: 5,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: 'Поиск',
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics:
            const BouncingScrollPhysics(), // или используйте ClampingScrollPhysics() в зависимости от желаемого эффекта прокрутки
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1462A6),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MeetingViewCalendar()),
                );
              },
              child: const Text('Осмотр поля'),
            ),
            const Gap(4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1462A6),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () {},
              child: const Text('Заключение договора'),
            ),
            const Gap(4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1462A6),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () {},
              child: const Text('Заключение договора'),
            ),
            const Gap(4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1462A6),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () {},
              child: const Text('Заключение договора'),
            ),
          ],
        ),
      )
    ],
  );
}
