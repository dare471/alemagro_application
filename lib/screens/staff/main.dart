import 'package:alemagro_application/screens/staff/mainPage/main_info_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alemagro_application/theme/app_color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> pageTitles = [
    "Главная",
    "Календарь",
    "Оплаты клиентов",
    "Клиенты",
    "Мой профиль",
  ]; // заголовки для каждой страницы

  int _currentIndex = 0;
  late final PageController _pageController;

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
      MainInfoUser(),
      TestScreen(),
      TestScreen(),
      TestScreen(),
      TestScreen()
    ];
    //   BlocProvider<CalendarBloc>(
    //     create: (context) => CalendarBloc()..add(FetchMeetings()),
    //     child: MainInfoUser(),
    //   ),
    //   BlocProvider(
    //     create: (context) => CalendarBloc()..add(FetchMeetings()),
    //     child: Calendar(),
    //   ),
    //   BlocProvider(
    //     create: (context) =>
    //         SchedulePaymentBloc()..add(CheckSchedulePaymentEvent()),
    //     child: SchedulePaymentPage(),
    //   ),
    //   BlocProvider(
    //     create: (context) => ClientBloc()..add(ClientEvent('ТОО')),
    //     child: MyClient(),
    //   ),
    //   Center(child: UserBlock()),
    // ];
  }

  BottomNavigationBar _buildBottomNavigationBar() {
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Календарь',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_document),
          label: 'Оплаты',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.agriculture_outlined),
          label: 'Клиенты',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _buildPageChildren(),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('ss'),
    );
  }
}
