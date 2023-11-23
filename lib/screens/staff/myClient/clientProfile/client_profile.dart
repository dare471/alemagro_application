import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 4),
          // Блок информации о клиенте
          Container(
            padding: const EdgeInsets.all(10),
            child: const ClientInfoCard(
              clientName: 'TOO "РОДНОЙ КРАЙ"',
              bin: '140240012840',
              category: 'A',
              manager: 'Не заполнено',
              address:
                  'АКМОЛИНСКАЯ ОБЛАСТЬ, САНДЫКТАУСКИЙ РАЙОН, ЖАМБЫЛСКИЙ С.О., С.ПРИОЗЕРНОЕ, УЛИЦА ЦЕНТРАЛЬНАЯ, 1',
              // ... другие параметры
            ),
          ),
          // Блок с кнопками действий для этого клиента
          TabBar(
            isScrollable: true,
            controller: _controller,
            labelColor: AppColors.blueLight,
            unselectedLabelColor: Colors.grey[600],
            tabs: const [
              Tab(
                icon: Icon(Icons.person_pin_rounded),
                text: 'Контакты',
              ),
              Tab(
                  icon: Icon(
                    Icons.analytics_outlined,
                  ),
                  text: 'Аналитика'),
              Tab(icon: Icon(Icons.file_copy_sharp), text: 'Файлы'),
              Tab(icon: Icon(Icons.file_copy_sharp), text: 'Контракты'),
              Tab(
                  icon: Icon(Icons.crop_original_outlined),
                  text: 'Посевные Поля'),
            ],
          ),
          Expanded(
            flex: 1,
            // This will take the remaining space
            child: TabBarView(
              controller: _controller,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: AppColors.blueLight,
                        shadowColor: AppColors.blueLight,
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.ltr,
                                children: [
                                  Text(
                                    "ФИО: Пользователь Пользователь",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.offWhite),
                                  ),
                                  Gap(5),
                                  Text(
                                    "Сот.номер: +777 888 ****",
                                    style: TextStyle(
                                        color: AppColors.offWhite,
                                        fontSize: 14),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              GestureDetector(
                                onTap: () {
                                  print("pressed call");
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.green,
                                  child: Icon(
                                    Icons.call_rounded,
                                    color: AppColors.offWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0,
                        color: AppColors.blueLightV,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.green),
                          shadowColor:
                              MaterialStateProperty.all<Color>(AppColors.green),
                          fixedSize:
                              MaterialStateProperty.all(const Size(250, 50)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          print("pressed add");
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text("Добавить пользователя"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: SfCircularChart(series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ])),
                Container(child: const Text('Файлы')),
                Container(child: const Text('Контракты')),
                Container(child: const Text('Поля')),
              ],
            ),
          ), // ... другие блоки
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
  );
  final String x;
  final double y;
}

class ClientInfoCard extends StatelessWidget {
  final String clientName;
  final String bin;
  final String category;
  final String manager;
  final String address;
  // ... другие поля

  const ClientInfoCard({
    required this.clientName,
    required this.bin,
    required this.category,
    required this.manager,
    required this.address,
    // ... другие параметры
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.blueLight,
      ),
      padding: const EdgeInsets.all(15.0),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 16, color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              clientName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('БИН/ИНН: $bin'),
            const Divider(color: Colors.white),
            Text('Адрес: $address'),
            // ... другие разделы с информацией
          ],
        ),
      ),
    );
  }
}
