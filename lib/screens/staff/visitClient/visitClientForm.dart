import 'dart:convert';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../../database/database_helper.dart';
import '../../../models/visit_options.dart';
import '../../../models/visit_search_model.dart';

class EventForm extends StatefulWidget {
  final eventBloc;

  EventForm({this.eventBloc});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedFinishTime = TimeOfDay.now();
  List<Client> _clients = [];
  int? _selectedClientId;
  String? _selectedCity;
  String? _selectedOption; // Переменная для хранения выбранного значения
  String? _selectedPlaceOption;
  bool _isAllDay = false; // Переменная состояния для чекбокса "На весь день"

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Client>> fetchClients(String clientName) async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/planned/mobile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'type': 'plannedMeeting',
        'action': 'searchSmartClient',
        'clientName': clientName,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> clientsJson = jsonDecode(response.body);
      return clientsJson.map((json) => Client.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }

  void _updateClientsList(String query) async {
    if (query.isEmpty) {
      setState(() {
        _clients = [];
      });
      return;
    }

    try {
      var fetchedClients = await fetchClients(query);
      setState(() {
        _clients = fetchedClients;
      });
    } catch (e) {
      print('Ошибка при загрузке клиентов: $e');
    }
  }

  Widget _buildAutoCompleteClient() {
    return Padding(
      padding:
          const EdgeInsets.all(8.0), // Измените отступ по вашему усмотрению
      child: Container(
        width: 500, // Укажите желаемую ширину
        child: Autocomplete<Client>(
          optionsMaxHeight: 500,
          optionsBuilder: (TextEditingValue textEditingValue) {
            _updateClientsList(textEditingValue.text);
            return _clients.where((Client client) {
              return client.name
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: (Client client) =>
              '${client.name} (БИН: ${client.iin})',
          onSelected: (Client selection) {
            setState(() {
              _selectedClientId = selection.id;
            });
            print('Выбрали клиента: ${selection.name} с ID: ${selection.id}');
            // Здесь вы можете выполнять дополнительные действия с выбранным клиентом
          },
        ),
      ),
    );
  }

  DateTime combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> sendMeetingData() async {
    final userProfileData = DatabaseHelper.getUserProfileData();
    DateTime _combinedStartDateTime =
        combineDateTime(_selectedDate, _selectedStartTime);
    DateTime _combinedEndDateTime =
        combineDateTime(_selectedDate, _selectedFinishTime);

    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/planned/mobile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'type': 'plannedMeeting',
        'action': 'setMeeting',
        'userId': userProfileData?['id'] ??
            '1174', // Предположим, что это фиксированное значение
        'clientId': _selectedClientId, // ID клиента, выбранного из dropdown
        'typeVisit': 1, // Тип визита, выбранный из dropdown
        'placeMeeting': 2, // Место встречи, выбранное из dropdown
        'contactId': 1122, // Предположим, что это фиксированное значение
        'dateToVisit': DateFormat('yyyy-MM-dd')
            .format(_selectedDate), // Форматирование даты
        'dateToStart':
            DateFormat('yyyy-MM-dd HH:mm:ss').format(_combinedStartDateTime),
        'dateToFinish': DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(_combinedEndDateTime), // Форматирование даты и времени
        'isAllDay': _isAllDay, // Флаг "На весь день"
        'targetDescription': _selectedOption, // Описание цели
        'placeDescription': _selectedPlaceOption, // Описание места
      }),
    );

    if (response.statusCode == 200) {
      // Успешный ответ
      print('Встреча успешно запланирована');
    } else {
      // Обработка ошибок
      print('Ошибка при планировании встречи: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildAutoCompleteClient(),
            ListTile(
              title: Text(
                  'Дата: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            Gap(10),
            CheckboxListTile(
              title: Text('На весь день'),
              value: _isAllDay,
              onChanged: (bool? value) {
                setState(() {
                  _isAllDay = value!;
                  if (_isAllDay) {
                    // Сбросить или установить времена начала и конца встречи
                    // Например, _selectedTime = TimeOfDay(hour: 0, minute: 0);
                  }
                });
              },
            ),

            // Показывать только если чекбокс "На весь день" не активирован
            if (!_isAllDay) Gap(10),
            if (!_isAllDay)
              ListTile(
                title: Text('Начало: ${_selectedStartTime.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: _selectedStartTime,
                  );
                  if (time != null) {
                    setState(() {
                      _selectedStartTime = time;
                    });
                  }
                },
              ),
            if (!_isAllDay) Gap(10),
            if (!_isAllDay)
              ListTile(
                title: Text('Конец : ${_selectedFinishTime.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: _selectedFinishTime,
                  );
                  if (time != null) {
                    setState(() {
                      _selectedFinishTime = time;
                    });
                  }
                },
              ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Выберите цель встречи',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Скругление границ для более мягкого вида
                    borderSide:
                        BorderSide(color: AppColors.blueDarkV2, width: 2),
                  ),
                ),
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                items: MeetingOptions.options
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Выберите место встречи',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Скругление границ для более мягкого вида
                    borderSide:
                        BorderSide(color: AppColors.blueDarkV2, width: 2),
                  ),
                ),
                value: _selectedPlaceOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlaceOption = newValue;
                  });
                },
                items: MeetingOptions.placeMeeting
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
            ),
            Gap(10),
            Gap(10),
            if (_selectedPlaceOption == 'На посевном поле')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Выберите место область',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Скругление границ для более мягкого вида
                      borderSide:
                          BorderSide(color: AppColors.blueDarkV2, width: 2),
                    ),
                  ),
                  value: _selectedCity,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                  items: MeetingOptions.cityMeeting
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
              ),
            Gap(10),
            if (_selectedPlaceOption == 'На посевном поле')
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Введите адрес',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Дополнительные параметры для TextField
                ),
              ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.blueDarkV2),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Показать прогресс-бар
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text("Пожалуйста, подождите..."),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
// Отправка данных
                        await sendMeetingData();
// Закрыть прогресс-бар
                        Navigator.of(context).pop();
// Показать сообщение о завершении
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Встреча добавлена"),
                            duration: Duration(seconds: 2),
                          ),
                        );

// Закрыть текущее окно
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Сохранить'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.blueDarkV2),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Отмена'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
