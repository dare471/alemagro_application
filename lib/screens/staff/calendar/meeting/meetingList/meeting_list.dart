import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/models/calendar_visit.dart';
import 'package:alemagro_application/screens/staff/calendar/meeting/meetingCalendar/meeting_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Widget buildCalendar(BuildContext context) {
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
            return buildMeetingList(context, state.meetings);
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

Widget buildNullScreen(
  BuildContext context,
  DateTime date,
  appointments,
  CalendarElement view,
) {
  return AlertDialog(
    content: Container(
      child: Text("$date \n $appointments \n $view"),
    ),
  );
}

Widget buildMeetingList(BuildContext context, List<Meeting> meetings) {
  return SfCalendar(
    view: CalendarView.month,
    dataSource: MeetingDataSource(getMeetingsAsAppointments(meetings)),
    onTap: (CalendarTapDetails details) {
      if (details.targetElement == CalendarElement.agenda ||
          details.targetElement == CalendarElement.appointment) {
        DateTime date = details.date!;
        dynamic meeting = meetings;
        dynamic appointments = details.appointments;
        CalendarElement view = details.targetElement;
        var clientId = appointments.isNotEmpty ? appointments[0].notes : null;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildNullScreen(context, date, clientId, view);
          },
        );
      }
    },
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
      agendaItemHeight: 50.0,
    ),
    initialSelectedDate: DateTime.now(),
    todayHighlightColor: Colors.amber.shade900,
    showNavigationArrow: true,
    showWeekNumber: true,
    allowDragAndDrop: true,
    // Other configurations...
  );
}

List<Appointment> getMeetingsAsAppointments(List<Meeting> meetings) {
  return meetings.map((meeting) {
    Color statusColor = getStatusColor(meeting.statusVisit);
    String subject = '${meeting.clientName}';
    return Appointment(
      subject: subject,
      notes: meeting.clientName.toString(),
      color: statusColor,
      startTime: meeting.date,
      endTime: DateTime(2023, 9, 8, 10, 00),
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
          border: OutlineInputBorder(),
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
