import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final String title;
  TextMessage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
