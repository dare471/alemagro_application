// ignore_for_file: unused_import

import 'dart:ui';
import 'package:alemagro_application/blocs/analytics/user_analytics_bloc.dart';
import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/blocs/search/search_bloc.dart';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/models/calendar_visit.dart';
import 'package:alemagro_application/screens/staff/analytics/widget_main.dart';
import 'package:alemagro_application/screens/staff/calendar/main_list.dart';
import 'package:alemagro_application/screens/staff/calendar/meeting/meetingList/meetingList.dart';
import 'package:alemagro_application/screens/staff/calendar/second_list.dart';
import 'package:alemagro_application/screens/staff/client/clientProfile/client_profile.dart';
import 'package:alemagro_application/screens/staff/profile/my_cabinet.dart';
import 'package:alemagro_application/screens/staff/search/search.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:alemagro_application/widgets/card/Card.dart';
import 'package:alemagro_application/widgets/title/title_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../calendar/meeting/meetingCard/mainCard.dart';
import '../visitClient/visitClientForm.dart';

class MainInfoUser extends StatefulWidget {
  const MainInfoUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainInfoUserState createState() => _MainInfoUserState();
}

class _MainInfoUserState extends State<MainInfoUser> {
  final GlobalKey<FormState> eventFormKey = GlobalKey<FormState>();
  final userProfileData = DatabaseHelper.getUserProfileData();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            // CardProfile(),
            Container(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const TitleCategory(
                    text: "Показатели плана",
                    fontSize: 19,
                    height: 10,
                    thicknes: 1,
                    gap: 10,
                  ),
                  BlocProvider(
                    create: (context) => UserAnalyticBloc(),
                    child: buildInitialCard(context),
                  ),
                  Gap(5),
                  Gap(10),
                  Divider(
                    height: 10,
                    thickness: 1,
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
            Gap(15),
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
            return Container(
                padding: EdgeInsets.all(10),
                child: Center(child: CircularProgressIndicator()));
          } else if (state is MeetingsFetched) {
            if (state.meetings.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Gap(10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.blueLight.withOpacity(0.6),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Text(
                          "У вас нет визитов на сегодня",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const Gap(6),
                      const Divider(
                        height: 10,
                      ),
                      const Gap(6),
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  title: const Text('Добавить Встречу'),
                                  content: EventForm(eventBloc: '')));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_location_alt_sharp),
                            Gap(10),
                            Text("Добавить встречу"),
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
                  // Container(
                  //   padding: EdgeInsets.all(5),
                  //   child: ElevatedButton(
                  //     style: ButtonStyle(
                  //       fixedSize: MaterialStateProperty.all(
                  //         const Size(double.maxFinite, double.minPositive),
                  //       ),
                  //       backgroundColor: MaterialStateColor.resolveWith(
                  //         (states) => AppColors.blueDarkV2,
                  //       ),
                  //       shape:
                  //           MaterialStateProperty.all<RoundedRectangleBorder>(
                  //         RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //         ),
                  //       ),
                  //     ),
                  //     onPressed: () {},
                  //     child: const Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.list),
                  //         Text("Показать весь список"),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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

Widget buildMeetingList(List<Visit> meetings) {
  return ListView.builder(
    controller: ScrollController(keepScrollOffset: true),
    shrinkWrap: true,
    itemCount: meetings.length,
    itemBuilder: (context, index) {
      Visit meeting = meetings[index];
      return ListTile(
        title: Text(meeting.clientName),
        leading: const Icon(
          Icons.date_range,
          size: 32,
          color: AppColors.blueDark,
        ),
        trailing: getMeetingStatusIcon(meeting.statusVisit),
        onTap: () {
          final id = meeting.id;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainCardWidget(id: id, meetings: meetings)),
          );
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
