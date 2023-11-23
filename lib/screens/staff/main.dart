import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/blocs/pincode/pin_code_bloc.dart';
import 'package:alemagro_application/screens/staff/calendar/main_list.dart';
import 'package:alemagro_application/screens/staff/mainPage/main_info_user.dart';
import 'package:alemagro_application/screens/staff/myClient/clientProfile/client_profile.dart';
import 'package:alemagro_application/widgets/floatingActionButton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> pageTitles = [
    "Главная",
    "Календарь",
    "Клиенты",
    "Мой профиль",
  ]; // заголовки для каждой страницы

  int _currentIndex = 0;
  late final PageController _pageController;
  PinBloc pinBloc = PinBloc();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavigationBarTap(int index) {
    _pageController.jumpToPage(index);
  }

  List<Widget> _buildPageChildren() {
    return [
      const MainInfoUser(),
      MainListVisit(),
      ClientProfile(),
      TestScreen(),
      TestScreen(),
    ];
  }

  BlocBuilder<CalendarBloc, CalendarState> _buildBottomNavigationBar() {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      int meetingCount = 0;
      if (state is MeetingsFetched) {
        meetingCount = state.meetings.length;
      }
      return BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 12,
        iconSize: 26.0,
        selectedIconTheme:
            const IconThemeData(size: 32, color: AppColors.blueLight),
        unselectedIconTheme: const IconThemeData(size: 28),
        backgroundColor: AppColors.offWhite,
        selectedItemColor: AppColors.blueDark,
        unselectedItemColor: AppColors.blueLightV,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onBottomNavigationBarTap,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: countVisit(meetingCount),
            label: 'Календарь',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.agriculture_outlined),
            label: 'Клиенты',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      );
    });
  }

  Stack countVisit(int count) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Icon(Icons.calendar_month),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 15,
              minHeight: 15,
            ),
            child: Text(
              count.toString(), // Display dynamic count
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // Or dark
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 4,
          backgroundColor: AppColors.blueDark,
          title: Text(pageTitles[_currentIndex]),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _buildPageChildren(),
        ),
        floatingActionButton: buildFloatingActionButton(context, _currentIndex),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: const Text('ss'),
    );
  }
}
