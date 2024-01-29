import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class FavoritesClient extends StatefulWidget {
  const FavoritesClient({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesClientState createState() => _FavoritesClientState();
}

class _FavoritesClientState extends State<FavoritesClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueDarkV2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Мои избранные клиенты'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _body(),
            _list(),
          ],
        ),
      ),
    );
  }
}

Widget _list() {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.all(Radius.circular(10))),
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text("sss"),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text("sss"),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text("sss"),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text("sss"),
        ),
      ],
    ),
  );
}

Widget _body() {
  return Card(
    elevation: 5,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AppColors.blueDarkV2,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: const Column(
        children: [
          Text('1'),
          Text('2'),
          Text('3'),
        ],
      ),
    ),
  );
}
