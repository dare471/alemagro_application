import 'package:alemagro_application/database/database_helper.dart';
import 'package:flutter/material.dart';

class CardProfile extends StatefulWidget {
  @override
  _CardProfileState createState() => _CardProfileState();
}

class _CardProfileState extends State<CardProfile> {
  Widget buildUserInfoCard(Map<String, dynamic>? userProfileData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Color(0xFF035AA6),
      elevation: 4.2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Добро пожаловать!"),
              Text(userProfileData?['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(userProfileData?['email'] ?? '',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Используйте buildUserInfoCard внутри вашего build метода
    final userProfileData = DatabaseHelper.getUserProfileData();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            buildUserInfoCard(userProfileData?.cast<String, dynamic>()),
            // Остальной код остается без изменений
            // ...
          ],
        ),
      ),
    );
  }
}
