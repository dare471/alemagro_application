// ignore_for_file: unused_import

import 'dart:ui';
import 'package:alemagro_application/blocs/analytics/user_analytics_bloc.dart';
import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/models/calendar_visit.dart';
import 'package:alemagro_application/screens/staff/analytics/widget_main.dart';
import 'package:alemagro_application/screens/staff/calendar/main_list.dart';
import 'package:alemagro_application/screens/staff/myClient/clientProfile/client_profile.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:alemagro_application/widgets/card/Card.dart';
import 'package:alemagro_application/widgets/title/title_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class MainInfoUser extends StatefulWidget {
  const MainInfoUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainInfoUserState createState() => _MainInfoUserState();
}

class _MainInfoUserState extends State<MainInfoUser> {
  final userProfileData = DatabaseHelper.getUserProfileData();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            CardProfile(),
            Container(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const TitleCategory(
                    text: "Показатели плана",
                    fontSize: 19,
                    height: 10,
                    thicknes: 1,
                    gap: 1,
                  ),
                  BlocProvider(
                    create: (context) => UserAnalyticBloc(),
                    child: buildInitialCard(context),
                  ),
                  const TitleCategory(
                    text: "Ваши визиты на сегодня",
                    fontSize: 19,
                    height: 10,
                    thicknes: 1,
                    gap: 5,
                  ),
                  BlocProvider(
                    create: (context) => CalendarBloc(),
                    child: buildCalendar(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCalendar(BuildContext context) {
  // Use BlocProvider to provide the CalendarBloc to the widget tree
  return BlocProvider<CalendarBloc>(
    create: (context) => CalendarBloc()
      ..add(
          FetchMeetingsToday()), // Trigger fetching meetings when the widget is created
    child: Card(
      elevation: 10,
      shadowColor: const Color.fromARGB(176, 3, 90, 166),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state is CalendarInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MeetingsFetched) {
            if (state.meetings.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const Text(
                        "Нет запланированных визитов",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Gap(6),
                      const Divider(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(double.maxFinite, double.minPositive),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.blueDarkV2,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MainListVisit()));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.list),
                            Text("Показать все встречи"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  buildMeetingList(state.meetings),
                  const Divider(),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size(double.maxFinite, double.minPositive),
                        ),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.blueDarkV2,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list),
                          Text("Показать весь список"),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          } else if (state is MeetingsFetchFailed) {
            return Center(child: Text('Failed to load meetings'));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    ),
  );
}

Widget buildMeetingList(List<Meeting> meetings) {
  return ListView.builder(
    controller: ScrollController(keepScrollOffset: true),
    shrinkWrap: true,
    itemCount: meetings.length,
    itemBuilder: (context, index) {
      Meeting meeting = meetings[index];
      return ListTile(
        title: Text(meeting.clientName),
        leading: const Icon(
          Icons.date_range,
          size: 32,
          color: AppColors.blueDark,
        ),
        trailing: getMeetingStatusIcon(meeting.statusVisit),
        onTap: () {
          // Handle onTap event
        },
      );
    },
  );
}

Widget getMeetingStatusIcon(int status) {
  switch (status) {
    case 1:
      return const Icon(Icons.check_circle, color: Color(0xFF5D8E77));
    case 2:
      return Icon(Icons.remove_circle_outlined, color: Colors.red[700]);
    case 0:
      return const Icon(Icons.access_time_filled_sharp,
          color: Color(0xFFF2C879));
    default:
      return Icon(Icons.remove_circle_outlined, color: Colors.red[700]);
  }
}
