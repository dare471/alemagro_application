import 'dart:ui';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/widgets/card/Card.dart';
import 'package:alemagro_application/widgets/title/title_category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainInfoUser extends StatefulWidget {
  _MainInfoUserState createState() => _MainInfoUserState();
}

class _MainInfoUserState extends State<MainInfoUser> {
  final userProfileData = DatabaseHelper.getUserProfileData();
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            CardProfile(),
            Container(
              padding: const EdgeInsets.all(0),
              child: const Column(
                children: [
                  TitleCategory(
                    text: "Показатели плана",
                    fontSize: 19,
                    height: 10,
                    thicknes: 1,
                    gap: 10,
                  ),
                  // BlocProvider(
                  //   create: (context) => UserAnalyticBloc(),
                  //   child: buildInitialCard(context),
                  // )
                  TitleCategory(
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
