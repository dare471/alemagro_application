import 'package:alemagro_application/blocs/analytics/user_analytics_bloc.dart';
import 'package:alemagro_application/screens/staff/analytics/main_analytic_screen.dart';
import 'package:alemagro_application/widgets/metrics/metricItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

final authData = Hive.box('authBox').get('data');
Widget buildInitialCard(BuildContext parentContext) {
  return BlocBuilder<UserAnalyticBloc, UserAnalyticState>(
    builder: (context, state) {
      final UserAnalyticBloc userAnalyticBloc =
          BlocProvider.of<UserAnalyticBloc>(context);
      if (state is AnalyticInitialState) {
        // userAnalyticBloc.add(FetchUserAnalytics(1));
        userAnalyticBloc.add(FetchUserAnalytics(
            authData['user']['id'])); // Замените 1 на нужный userId
      }
      if (state is LoadingState) {
        return const CircularProgressIndicator();
      } else if (state is LoadedState) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MetricSItem(title: state.data.planSum, value: 'План', blocId: 1),
              MetricSItem(
                  title: state.data.sumShipment,
                  value: 'Реализация',
                  blocId: 2),
              MetricSItem(
                  title: state.data.executionPlan.toString() + '%',
                  value: "Выполнено",
                  blocId: 3)
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF035AA6)),
                  shape: MaterialStateProperty.all<OutlinedBorder?>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
              child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 10),
                    Text('Посмотреть Аналитику ')
                  ]),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainAnalyseScreen()));
              },
            ),
          )
        ]);

        ///Text('Загружены данные: ${state.data}');
      } else if (state is ErrorState) {
        return Text("Ваши данные по показателям еще не сформированны.");
        // return Text('Ошибка: ${state.message}');
      }
      return const CircularProgressIndicator(); // Начальное состояние или необработанное состояние
    },
  );
}
