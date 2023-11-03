import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class TitleCategory extends StatefulWidget {
  final String text;
  final double height;
  final double thicknes;
  final double gap;
  final double fontSize;
  const TitleCategory(
      {super.key,
      required this.text,
      required this.height,
      required this.thicknes,
      required this.gap,
      required this.fontSize});
  @override
  // ignore: library_private_types_in_public_api
  _TitleCategoryState createState() => _TitleCategoryState();
}

class _TitleCategoryState extends State<TitleCategory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: widget.height, thickness: widget.thicknes),
        Gap(widget.gap),
        Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: widget.fontSize,
          ),
          textAlign: TextAlign.start,
        ),
        Gap(widget.gap)
      ],
    );
  }
}
