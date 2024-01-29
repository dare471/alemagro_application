import 'package:alemagro_application/screens/staff/calendar/main_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/theme/app_color.dart';

class SecondList extends StatefulWidget {
  @override
  _SecondListState createState() => _SecondListState();
}

class _SecondListState extends State<SecondList> {
  int _selectedIndex = 0; // Добавление переменной индекса

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(),
      child: Builder(
        // Использование Builder для создания нового контекста
        builder: (newContext) {
          return Scaffold(
            floatingActionButton: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(0),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.blueDarkV2),
                ),
                onPressed: () {
                  setState(() {
                    // Переключение между 0 и 1
                    _selectedIndex = _selectedIndex == 0 ? 1 : 0;
                    BlocProvider.of<CalendarBloc>(newContext)
                        .pageController
                        .jumpToPage(_selectedIndex);
                  });
                },
                // Выбор иконки на основе _selectedIndex
                child: Icon(_selectedIndex == 0
                    ? Icons.table_rows
                    : Icons.calendar_month),
              ),
            ),
            body: Column(
              children: <Widget>[
                Flexible(
                  child: PageView(
                    controller: BlocProvider.of<CalendarBloc>(newContext)
                        .pageController, // Использование нового контекста
                    onPageChanged: (int page) {
                      setState(() {
                        _selectedIndex = page;
                      });
                    },
                    children: <Widget>[
                      MainListVisit(page: _selectedIndex),
                      // Первая страница
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
