import 'package:flutter/material.dart';

class MeetingList extends StatefulWidget {
  @override
  _MeetingListState createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  List<String> meetingTitle = ["Meeting with John", "Meeting with Jane"];
  int selectedIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meetings"),
      ),
      body: ListView.builder(
        itemCount: meetingTitle.length,
        itemBuilder: (context, index) {
          return Card(
              child: InkWell(
            onTap: () => (),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(meetingTitle[index],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal))),
                Divider(),
                Row(children: <Widget>[
                  Expanded(
                      child:
                          Text('Start Time: 9 AM', textAlign: TextAlign.left)),
                  IconButton(icon: Icon(Icons.more_vert), onPressed: null)
                ])
              ],
            ),
          ));
        },
      ),
    );
  }
}
