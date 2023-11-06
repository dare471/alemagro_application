import 'package:alemagro_application/blocs/analytics/analytic_detail_bloc.dart';
import 'package:alemagro_application/blocs/analytics/analytic_event.dart';
import 'package:alemagro_application/blocs/analytics/user_analytics_bloc.dart';
import 'package:alemagro_application/screens/staff/analytics/detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

final authData = Hive.box('authBox').get('data');

class MainAnalyseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Аналитический отчет'),
        backgroundColor: Color(0xFF035AA6), // Основной цвет AppBar
        elevation: 0.0, // Уберем тень AppBar для соответствия дизайну
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: _CustomButton(
                      icon: Icons.checklist_sharp,
                      label: "Какую продукцию часто продаю",
                    )),
                    Flexible(
                      child: _CustomButton(
                        icon: Icons.edit_document,
                        label: "Мои\nДоговора",
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<UserAnalyticBloc, UserAnalyticState>(
                  builder: (context, state) {
                if (state is AnalyticInitialState) {
                  BlocProvider.of<UserAnalyticBloc>(context)
                      .add(FetchUserAnalytics(authData['user']['id']));
                  // userAnalyticBloc.add(FetchUserAnalytics(
                  //     authData['user']['id'])); // Замените 1 на нужный userId
                }
                if (state is LoadingState) {
                  return CircularProgressIndicator();
                } else if (state is LoadedState) {
                  // Access the state data
                  final data = state.data;
                  return Column(children: [
                    //  ReportTitle(title: 'Отчет о прогрессе'),
                    ProgressPieChart(progress: data.executionPlan / 100),
                    MetricsList(
                      Data: data,
                    ),
                  ]); // or whatever properties UserStats has
                } else if (state is ErrorState) {
                  return Text(state.message);
                } else {
                  return Text("По вам еще данные не сформированы");
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CustomButton({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF035AA6)),
        fixedSize: MaterialStateProperty.all<Size>(Size(180, 80)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailAnalyticUser()),
        ).then((_) {
          // Это событие будет добавлено после возвращения из DetailAnalyticUser.
          // Если вам нужно вызвать событие BLoC непосредственно после перехода на экран,
          // перенесите этот вызов в initState метод DetailAnalyticUser.
          BlocProvider.of<AnalyticDetailBloc>(context).add(FetchAnalytic());
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 5), // Изменил width на height
            Text(
              label,
              style: const TextStyle(fontSize: 14),
              softWrap: true,
              textWidthBasis: TextWidthBasis.parent,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ReportTitle extends StatelessWidget {
  final String title;

  ReportTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProgressPieChart extends StatefulWidget {
  final double progress;

  const ProgressPieChart({super.key, required this.progress});

  @override
  // ignore: library_private_types_in_public_api
  _ProgressPieChartState createState() => _ProgressPieChartState();
}

class _ProgressPieChartState extends State<ProgressPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: 0, end: widget.progress).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            // Добавим границу вокруг диаграммы
            border: Border.all(color: Color(0xFF035AA6)!, width: 2.0),
            borderRadius: BorderRadius.circular(100),
          ),
          child: CustomPaint(
            painter: PieProgressPainter(_animation.value),
            child: Center(
                child: Text(
              '${(_animation.value * 100).toInt()}%',
              style: TextStyle(fontSize: 24),
            )),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Выполнение плана', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MetricsList extends StatelessWidget {
  final dynamic Data;

  MetricsList({required this.Data});

  Map<String, dynamic> get analyticsMetrics {
    return {
      "Ваш План": Data.planSum,
      "Ваша Реализация": Data.sumShipment,
      "Продукции по плану": Data.planCountProduct,
      "Продукции продано": Data.factCountProduct,
      "Продукции отгружено": Data.countShipment,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Updated color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: analyticsMetrics.entries
            .map(
              (entry) => Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      entry.value.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class MetricItem extends StatelessWidget {
  final String keyText;
  final String valueText;

  MetricItem({required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 10,
              color: Colors.grey[300]!,
            )
          ],
        ));
  }
}

class PieProgressPainter extends CustomPainter {
  final double progress;

  PieProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    final paint = Paint()
      ..color = Color(0xFF035AA6)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Раздел станет доступно скоро"),
      ),
    );
  }
}
