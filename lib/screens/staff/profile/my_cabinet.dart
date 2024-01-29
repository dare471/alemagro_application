import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../database/database_helper.dart';

class MyCabinet extends StatefulWidget {
  @override
  _MyCabinetState createState() => _MyCabinetState();
}

class _MyCabinetState extends State<MyCabinet> {
  Map<String, dynamic>?
      userProfileData; // Объявляем переменную для данных пользователя
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  @override
  void initState() {
    super.initState();
    loadUserProfile(); // Загружаем данные пользователя при инициализации
  }

  // Функция для асинхронной загрузки данных пользователя
  void loadUserProfile() async {
    var data = await DatabaseHelper.getUserProfileData();
    setState(() {
      userProfileData = data?.cast<String,
          dynamic>(); // Сохраняем данные пользователя в состоянии
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppColors.blueDarkV2,
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: userProfileData?['avatar'] != null
                        ? NetworkImage(userProfileData!['avatar'])
                        : null,
                    child: userProfileData?['avatar'] == null
                        ? Icon(Icons.person_outline)
                        : null,
                  ),
                  Gap(10),
                  Text(
                    userProfileData?['name'] ?? 'Loading...',
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Должность'),
                    Gap(5),
                    Text(userProfileData?['position'] ?? 'Нет Данных'),
                    Divider(height: 20),
                    Text('Почта'),
                    Gap(5),
                    Text(userProfileData?['email'] ?? 'Нет Данных'),
                    Divider(height: 20),
                    // Исправлено расстояние для Divider
                    ButtonBar(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  Colors.redAccent), // Исправлено стиль кнопки
                          onPressed: () {
                            showDialog<AlertDialog>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Are you sure?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Отмена"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Выйти"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors
                                            .red), // Исправлено стиль кнопки
                                    onPressed: () {
                                      // Добавьте здесь логику удаления аккаунта
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text('Выйти'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
