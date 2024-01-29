import 'package:alemagro_application/blocs/commentary/commentary_bloc.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../models/calendar_visit.dart';
import '../../../../../models/commentary/main_model.dart';

enum TabItem {
  analytics,
  files,
  contacts,
  comments,
}

class MainCardWidget extends StatefulWidget {
  final int id;
  final List<Visit> meetings;

  MainCardWidget({required this.id, required this.meetings});

  @override
  _MainCardWidgetState createState() => _MainCardWidgetState();
}

class _MainCardWidgetState extends State<MainCardWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _location = 'Unknown';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _getLocation();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        print(_tabController.index);
        BlocProvider.of<CommentaryBloc>(context).add(FetchData());
        // Здесь вы вызываете ваш Bloc
      }
      if (_tabController.index == 1) {
        print(_tabController.index);
        BlocProvider.of<CommentaryBloc>(context).add(FetchData());
        // Здесь вы вызываете ваш Bloc
      }
      if (_tabController.index == 2) {
        print(_tabController.index);
        BlocProvider.of<CommentaryBloc>(context).add(FetchData());
        // Здесь вы вызываете ваш Bloc
      }
      // Проверьте, соответствует ли индекс вкладки индексу вкладки Commentary
      if (_tabController.index == 3) {
        print(_tabController.index);
        BlocProvider.of<CommentaryBloc>(context).add(FetchData());
        // Здесь вы вызываете ваш Bloc
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _retrieveLocation() async {
    // Your location retrieval logic here
    // Similar to what was discussed in the previous response
  }
  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
// Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue.
      // You can prompt the user to enable the location services.
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }

// When permissions are granted, get the location.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _location = "${position.latitude}, ${position.longitude}";
      print(_location);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _element =
        widget.meetings.firstWhere((element) => element.id == widget.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueDark,
        title: const Text('Карточка встречи'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          )
        ],
      ),
      endDrawer:
          EndDrawerWidget(meetings: widget.meetings), // Ваш EndDrawer виджет
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              MeetingDetailsCard(
                meeting: widget.meetings
                    .firstWhere((element) => element.id == widget.id),
              ),
              SizedBox(height: 10),
              MeetingTabBar(_tabController),
              // SizedBox(height: 10),
              MeetingTabBarView(
                  tabController: _tabController, clientId: _element.clientId),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton("Начать встречу", Icons.play_circle_outline, () {
            _getLocation(); // Ваш код для действия "Начать встречу"
          }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateColor.resolveWith((states) => AppColors.blueDarkV2),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 40),
      ],
    ),
  );
}

class MeetingActionButton extends StatelessWidget {
  const MeetingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => AppColors.blueDarkV2),
        fixedSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width * .5, 48)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
      ),
      onPressed: () {
        // Действие кнопки
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Начать встречу"),
          Icon(Icons.play_circle_outline, size: 35),
        ],
      ),
    );
  }
}

class EndDrawerWidget extends StatelessWidget {
  final List<Visit> meetings;

  EndDrawerWidget({required this.meetings});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            margin: EdgeInsets.only(bottom: 8.0),
            padding: EdgeInsets.fromLTRB(10.0, 120.0, 16.0, 8.0),
            decoration: BoxDecoration(
              color: AppColors.blueLight,
            ),
            child: Text(
              'Доп возможности',
              style: TextStyle(color: AppColors.offWhite, fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text('Посмотреть закуп'),
            onTap: () {
              print("ss");
            },
          ),
          ListTile(
            title: const Text('Посмотреть заметки'),
            onTap: () {
              print("ss");
            },
          ),
          ListTile(
            title: const Text('Отменить встречу'),
            onTap: () {
              print("ss");
            },
          ),
          ListTile(
            title: const Text('Запустить встречу'),
            onTap: () {
              print("ss");
            },
          )
        ],
      ),
    );
  }
}

class MeetingDetailsCard extends StatelessWidget {
  final Visit meeting;

  MeetingDetailsCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    DateTime dateVisit = DateTime.parse(meeting.dateVisit);
    DateTime dateToStart = DateTime.parse(meeting.dateToStart);
    DateTime dateToFinish = DateTime.parse(meeting.dateToFinish); // Преобразов

    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'ru');
    DateFormat timeFormat = DateFormat('hh:mm', 'ru');
    // Здесь код для отображения деталей встречи
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Клиент",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text(
              meeting.clientName,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            const Text(
              "Время",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            meeting.isAllDay
                ? const Text("Встреча на весь день")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Дата: ${dateFormat.format(dateVisit)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Начало: ${timeFormat.format(dateToStart)}\nКонец: ${timeFormat.format(dateToFinish)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
            const Divider(),
            const Text(
              "Адрес",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text("${meeting.clientAddress}"),
            const Divider(),
            const Text(
              "Описание места",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text(meeting.placeDescription),
            const Divider(),
            const Text(
              "Цель встречи",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text(meeting.targetDescription),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class MeetingTabBar extends StatelessWidget {
  final TabController tabController;

  MeetingTabBar(this.tabController);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          color: AppColors.blueDarkV2, borderRadius: BorderRadius.circular(20)),
      child: TabBar(
        tabAlignment: TabAlignment.center,
        isScrollable: true,
        indicator: BoxDecoration(
          border: Border.all(
            style: BorderStyle.none,
          ),
        ),
        unselectedLabelStyle: TextStyle(color: AppColors.offWhite),
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabController,
        tabs: [
          Tab(icon: Icon(Icons.analytics), text: "Аналитика"),
          Tab(icon: Icon(Icons.file_present), text: "Файлы"),
          Tab(icon: Icon(Icons.person_pin_rounded), text: "Контакты"),
          Tab(icon: Icon(Icons.comment), text: "Комментарии"),
        ],
      ),
    );
  }
}

class MeetingTabBarView extends StatelessWidget {
  final TabController tabController;
  final int clientId;

  MeetingTabBarView({required this.tabController, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 400,
        child: TabBarView(
          controller: tabController,
          children: TabItem.values.map((tabItem) {
            return ListContentView(tabItem: tabItem, clientId: clientId);
          }).toList(),
        ),
      ),
    );
  }
}

class ListContentView extends StatelessWidget {
  final TabItem tabItem;
  final int clientId;
  const ListContentView(
      {Key? key, required this.tabItem, required this.clientId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabItem) {
      case TabItem.files:
        return NoteList(tabItem.name, clientId); // Пример для вкладки "Файлы"
      case TabItem.comments:
        return NoteList(
            tabItem.name, clientId); // Пример для вкладки "Комментарии"
      case TabItem.analytics:
        return NoteList(tabItem.name, clientId);
      case TabItem.contacts:
        return NoteList(
            tabItem.name, clientId); // Пример для вкладки "Аналитика"
      default:
        return Container();
    }
  }
}

Widget NoteList(String id, int clientId) {
  return BlocBuilder<CommentaryBloc, CommentaryState>(
    builder: (context, state) {
      if (state is CommentaryInitial) {
        return CircularProgressIndicator();
      } else if (state is CommentaryFetched) {
        // Отобразите данные
        return BuildList(state.data);
      } else if (state is CommentaryFetchedFailed) {
        // Отобразите сообщение об ошибке
        return Text(state.error);
      } else {
        return Text('null');
      }
      // Другие состояния...
    },
  );
// Container(
//     decoration: BoxDecoration(
//         border: Border.all(color: AppColors.blueDarkV2),
//         borderRadius: BorderRadius.all(Radius.circular(10))),
//     padding: EdgeInsets.all(10),
//     child: Column(
//       children: [
//         Text('sss'),
//         Text(
//           clientId.toString(),
//         ),
//       ],
//     ),
//   );
}

Widget BuildList(List<CommentaryNote> commentaryList) {
  return ListView.builder(
    itemCount: commentaryList.length,
    itemBuilder: (context, index) {
      CommentaryNote item = commentaryList[index];
      return Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              item.description,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            Text(
              item.createDate,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
        // И другие элементы UI, которые вы хотите использовать
      );
    },
  );
}
