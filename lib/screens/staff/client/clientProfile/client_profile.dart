import 'package:alemagro_application/models/search_client.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientProfile extends StatefulWidget {
  final BusinessEntity data;

  const ClientProfile({required this.data});

  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<Tab> tabs = <Tab>[
    const Tab(
      icon: Icon(Icons.person_pin_rounded),
      text: 'Контакты',
    ),
    const Tab(
      icon: Icon(Icons.person_pin_rounded),
      text: 'Визиты',
    ),
    const Tab(
      icon: Icon(Icons.person_pin_rounded),
      text: 'Визиты',
    ),
    const Tab(
      icon: Icon(Icons.person_pin_rounded),
      text: 'Визиты',
    ),
    const Tab(
      icon: Icon(Icons.person_pin_rounded),
      text: 'Визиты',
    )
  ];
  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: 5,
        vsync: this,
        animationDuration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueDark,
        title: Text(data.name ?? 'Неизвестный'),
      ),
      body: Column(
        children: <Widget>[
          _buildCard(data),
          // Блок с кнопками действий для этого клиента
          TabBar(
              isScrollable: true,
              controller: _controller,
              labelColor: AppColors.blueLight,
              unselectedLabelColor: Colors.grey[600],
              tabs: tabs),
          Expanded(
            // This will take the remaining space
            child: TabBarView(
              controller: _controller,
              children: [
                _buildContactsView(widget.data.contactInf),
                _buildVisitsView(widget.data.visits),
                // Страницы для других вкладок...
                Text('Файлы'),
                Text('Контракты'),
                Text('Поля'),
              ],
            ),
          ), // ... другие блоки
        ],
      ),
    );
  }

  Widget _buildContactsView(List<ContactInf> contacts) {
    return ListView.builder(
      itemCount: contacts.length + 1,
      itemBuilder: (context, index) {
        if (index == contacts.length) {
          return _buildFloatingActionButton();
        }
        return _buildContactInf(contacts[index]);
      },
    );
  }

  Widget _buildVisitsView(List<Visit> visits) {
    return ListView.builder(
      itemCount: visits.length + 1,
      itemBuilder: (context, index) {
        if (index == visits.length) {
          return _buildFloatingActionButton();
        }
        return _buildVisitList(visits[index]);
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: () {
          print('ss');
          _importContacts; // Обработчик нажатия
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildClientInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.offWhite),
          ),
          const Gap(5),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: AppColors.offWhite),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BusinessEntity data) {
    return Card(
      color: AppColors.blueDarkV2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfoRow("Клиент:", data.name ?? 'Нет имени'),
            _buildClientInfoRow("ИИН/БИН:", data.iinBin ?? 'Нет имени'),
            _buildClientInfoRow("Деятельность:", data.activity ?? 'Нет имени'),
            _buildClientInfoRow("Адрес:", data.address ?? 'Нет имени'),
            _buildClientInfoRow(
                "Категория:", data.businessCategory ?? 'Нет имени'),
            _buildClientInfoRow("Като:", data.cato ?? 'Нет имени'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(Order orders) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.blueLight,
      shadowColor: AppColors.blueLight,
      elevation: 5,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(15),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Продукт: ${orders.productName ?? 'N/A'}",
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.offWhite),
                      softWrap: true,
                      overflow: TextOverflow.visible),
                  const Gap(5),
                  Text(
                    "К-во: ${orders.count ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.offWhite),
                  ),
                  const Gap(5),
                  Text(
                    "Сумма: ${orders.totalCostWithVat ?? 'N/A'}",
                    style: const TextStyle(
                        color: AppColors.offWhite, fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  const Gap(5),
                  Text(
                    "Поставщик: ${orders.provider ?? 'N/A'}",
                    style: const TextStyle(
                        color: AppColors.offWhite, fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  // Добавьте другие поля из ContactInf здесь, если необходимо
                ],
              ),
            ),
            const Gap(20),
          ]),
        ),
        onTap: () {
          print("pressed call");
        },
      ),
    );
  }

  Widget _buildVisitList(Visit visitList) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.blueLight,
      shadowColor: AppColors.blueLight,
      elevation: 5,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(15),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Дата: ${visitList.createToVisit ?? 'N/A'}",
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.offWhite),
                ),
                const Gap(5),
                Text(
                  "Начало: ${visitList.dateToStart ?? 'N/A'}",
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.offWhite),
                ),
                const Gap(5),
                Text(
                  "Конец: ${visitList.dateToFinish ?? 'N/A'}",
                  style:
                      const TextStyle(color: AppColors.offWhite, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                const Gap(5),
                Text(
                  "Весь день: ${visitList.isAllDay ?? 'N/A'}",
                  style:
                      const TextStyle(color: AppColors.offWhite, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                const Gap(5),
                Text(
                  "Место: ${visitList.placeDescription ?? 'N/A'}",
                  style:
                      const TextStyle(color: AppColors.offWhite, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                const Gap(5),
                Text(
                  "Цель встречи: ${visitList.targetDescription ?? 'N/A'}",
                  style:
                      const TextStyle(color: AppColors.offWhite, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                // Добавьте другие поля из ContactInf здесь, если необходимо
              ],
            ),
            const Gap(20),
          ]),
        ),
        onTap: () {
          print("pressed call");
        },
      ),
    );
  }

  Widget _buildContactInf(ContactInf contactInf) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.blueLight,
      shadowColor: AppColors.blueLight,
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ФИО: ${contactInf.name ?? 'N/A'}",
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.offWhite),
                ),
                const Gap(5),
                Text(
                  "Должность: ${contactInf.position ?? 'N/A'}",
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.offWhite),
                ),
                const Gap(5),
                Text(
                  "Тел: ${contactInf.phNumber ?? 'N/A'}",
                  style:
                      const TextStyle(color: AppColors.offWhite, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                const Gap(5),
                Text(
                  "Email: ${contactInf.email ?? 'N/A'}",
                  style:
                      const TextStyle(color: AppColors.offWhite, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                // Добавьте другие поля из ContactInf здесь, если необходимо
              ],
            ),
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
    );
  }

  Future<void> _importContacts() async {
    // Запросите разрешение на доступ к контактам
    var permissionStatus = await Permission.contacts.status;
    if (permissionStatus.isDenied) {
      await Permission.contacts.request();
      permissionStatus = await Permission.contacts.status;
    }

    // Если разрешение получено, загрузите контакты
    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        print('Found contact: ${contact.displayName}');
        // Тут можно добавить логику для сохранения контактов в вашем приложении
      }
    } else {
      print('Access to contacts denied');
    }
  }
}
