import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'meeting/meetingList/meeting_list.dart';

class MainListVisit extends StatefulWidget {
  _MainListVisitState createState() => _MainListVisitState();
}

class _MainListVisitState extends State<MainListVisit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Container(
        //     padding: EdgeInsets.all(1),
        //     child: controllerListMeeting(BuildContext, context)),
        Expanded(
            child: BlocProvider(
          create: (context) => CalendarBloc(),
          child: buildCalendar(context),
        )),
      ],
    );
  }
}
