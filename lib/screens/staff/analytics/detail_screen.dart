import 'dart:async';
import 'package:alemagro_application/blocs/analytics/analytic_detail_bloc.dart';
import 'package:alemagro_application/blocs/analytics/analytic_event.dart';
import 'package:alemagro_application/blocs/analytics/analytic_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailAnalyticUser extends StatefulWidget {
  const DetailAnalyticUser({Key? key}) : super(key: key);

  @override
  _DetailAnalyticUserState createState() => _DetailAnalyticUserState();
}

class _DetailAnalyticUserState extends State<DetailAnalyticUser> {
  String _connectionStatus = 'Unknown';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<AnalyticDetailBloc>(context, listen: false)
        .add(FetchAnalytic());
  }

  void _fetchData() {
    // Trigger the event to fetch data
    BlocProvider.of<AnalyticDetailBloc>(context, listen: false)
        .add(FetchAnalytic());
  }

  @override
  Widget build(BuildContext context) {
    // ... ваш существующий код отрисовки
    return BlocBuilder<AnalyticDetailBloc, AnalyticDetailState>(
      builder: (context, state) {
        // Здесь вы можете обрабатывать различные состояния вашего BLoC и отображать соответствующий UI.
        if (state is AnalyticDetailInitial) {
          return const CircularProgressIndicator(); // пример индикатора загрузки
        } else if (state is AnalyticDetailFetched) {
          // Отобразите данные, используя state.data или аналогичный доступ к вашим данным.
          return const Text('Data Fetched Successfully');
        } else if (state is AnalyticDetailError) {
          return Text('Error: $state');
        } else {
          return Text('State: $_connectionStatus');
        }
      },
    );
  }
}
