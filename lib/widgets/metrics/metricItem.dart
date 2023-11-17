import 'package:flutter/material.dart';

class MetricSItem extends StatelessWidget {
  final String title;
  final String value;
  final int blocId;

  MetricSItem({required this.title, required this.value, required this.blocId});

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.039;
    double widthSize = MediaQuery.of(context).size.width * 0.3;
    double heightSize = MediaQuery.of(context).size.height * 0.15;
    return Column(
      children: [
        SizedBox(
          height: 13,
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: widthSize, // Same as 2 * radius for CircleAvatar
          height: heightSize, // Same as 2 * radius for CircleAvatar
          decoration: BoxDecoration(
              color: blocId == 1
                  ? const Color(0xFFD9933D).withOpacity(0.9)
                  : (blocId == 2
                      ? Color(0xFFF2C879).withOpacity(0.9)
                      : Color(0xFF035AA6).withOpacity(0.9)),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
