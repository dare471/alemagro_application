import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/blocs/pincode/pin_code_bloc.dart';

import 'package:alemagro_application/screens/staff/calendar/second_list.dart';
import 'package:alemagro_application/screens/staff/favorites/mainPage.dart';
import 'package:alemagro_application/screens/staff/mainPage/main_info_user.dart';
import 'package:alemagro_application/screens/staff/profile/my_cabinet.dart';
import 'package:alemagro_application/screens/staff/search/search.dart';
import 'package:alemagro_application/screens/staff/visitClient/visitClientForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../blocs/search/search_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> pageTitles = [
    "Главная",
    "Календарь",
    "Мои клиенты"
  ]; // заголовки для каждой страницы

  int _currentIndex = 0;
  late final PageController _pageController;
  PinBloc pinBloc = PinBloc();
  final GlobalKey<FormState> eventFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CalendarBloc>().add(FetchMeetingsToday());
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
      SecondList(),
      BlocProvider<ClientSearchBloc>(
        create: (context) => ClientSearchBloc(),
        child: MySearchWidget(),
      ),
      MyCabinet()
    ];
  }

  Widget _buildBottomNavigationBar() {
    return BlocListener<CalendarBloc, CalendarState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Встречи обновлены!')));
      // Добавьте здесь логику, если вам нужно реагировать на определенные изменения состояния
    }, child:
            BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      CalendarBloc().add(FetchMeetingsToday());
      int meetingCount = 0;
      if (state is MeetingsFetched) {
        meetingCount = state.countMeetings
            .fold(0, (count, item) => count + item.countVisit);
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
            label: 'Менеджер встреч',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Мои клиенты',
          ),
        ],
      );
    }));
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
            actions: [
              if (_currentIndex == 0)
                IconButton(
                  highlightColor: AppColors.blueLightV,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoritesClient()),
                    );
                  },
                  icon: const Icon(
                    Icons.auto_graph_outlined,
                    size: 30,
                  ),
                ),
              if (_currentIndex == 1)
                IconButton(
                    icon: const Icon(
                      Icons.add_alert_outlined,
                      size: 30,
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
                    })
              else
                Gap(5)
              // SizedBox.shrink(),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 4,
            backgroundColor: AppColors.blueDark,
            title: Text(pageTitles[_currentIndex])),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _buildPageChildren(),
        ),

        // floatingActionButton: buildFloatingActionButton(context, _currentIndex),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}
