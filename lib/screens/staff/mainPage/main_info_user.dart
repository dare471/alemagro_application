// ignore_for_file: unused_import

import 'dart:ui';
import 'package:alemagro_application/blocs/analytics/user_analytics_bloc.dart';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/screens/staff/analytics/widget_main.dart';
import 'package:alemagro_application/widgets/card/Card.dart';
import 'package:alemagro_application/widgets/title/title_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    gap: 10,
                  ),
                  BlocProvider(
                    create: (context) => UserAnalyticBloc(),
                    child: buildInitialCard(context),
                  ),
                  const TitleCategory(
                    text: "Ваши визиты",
                    fontSize: 19,
                    height: 10,
                    thicknes: 1,
                    gap: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
