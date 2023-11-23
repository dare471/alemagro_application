import 'package:alemagro_application/blocs/analytics/user_analytics_bloc.dart';
import 'package:alemagro_application/blocs/analytics/user_analytics_events.dart';
import 'package:alemagro_application/blocs/analytics/user_analytics_state.dart';
import 'package:alemagro_application/database/database_helper.dart';
import 'package:alemagro_application/widgets/metrics/metricItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

Widget buildInitialCard(BuildContext parentContext) {
  final userProfileData = DatabaseHelper.getUserProfileData();

  return BlocBuilder<UserAnalyticBloc, UserAnalyticState>(
    builder: (context, state) {
      final UserAnalyticBloc userAnalyticBloc =
          BlocProvider.of<UserAnalyticBloc>(context);
      if (state is AnalyticInitialState) {
        userAnalyticBloc.add(FetchUserAnalytics(
            userProfileData?['id'] ?? '')); // Замените 1 на нужный userId
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
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF035AA6)),
                  shape: MaterialStateProperty.all<OutlinedBorder?>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
              child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.analytics),
                    Gap(5),
                    Text('Мои показатели по плану')
                  ]),
              onPressed: () {},
            ),
          )
        ]);
      } else if (state is ErrorState) {
        return Text("Ваши данные по показателям еще не сформированны.");
        // return Text('Ошибка: ${state.message}');
      }
      return const CircularProgressIndicator(); // Начальное состояние или необработанное состояние
    },
  );
}
