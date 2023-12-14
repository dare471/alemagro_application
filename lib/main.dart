import 'package:alemagro_application/app.dart';
import 'package:alemagro_application/blocs/auth/auth_bloc.dart';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() async {
  // Это необходимо для инициализации асинхронного кода перед запуском приложения.
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository = UserRepository(baseUrl: 'http://10.200.100.17/api');

  // Инициализация Hive
  await Hive.initFlutter();
  await DatabaseHelper.initHive();

  // Локализации формата дат
  await initializeDateFormatting('ru_RU', null);

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, // Include this for Cupertino localizations
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('ru'), // Russian
        // Add other supported locales here
      ],
      locale: const Locale('ru'), // Setting Russian as the default locale
      // ... other configurations
      title: 'AlemAgro CRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Теперь LoginPage будет дочерним для BlocProvider.
    );
  }
}
