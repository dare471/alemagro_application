import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingViewCalendar extends StatefulWidget {
  _MeetingViewCalendarState createState() => _MeetingViewCalendarState();
}

class _MeetingViewCalendarState extends State<MeetingViewCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sss'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          numberOfWeeksInView: 6,
        ),
      ),
    );
  }
}
