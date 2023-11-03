import 'package:alemagro_application/app.dart';
import 'package:alemagro_application/blocs/auth/auth_bloc.dart';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Это необходимо для инициализации асинхронного кода перед запуском приложения.
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository =
      UserRepository(baseUrl: 'https://crm.alemagro.com:8080/api');

  // Инициализация Hive
  await Hive.initFlutter();
  await DatabaseHelper.initHive();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: userRepository),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(userRepository: userRepository),
        ),
      ],
      child: MyApp(), // Создайте виджет MyApp вместо прямого вызова LoginPage.
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlemAgro CRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Теперь LoginPage будет дочерним для BlocProvider.
    );
  }
}
