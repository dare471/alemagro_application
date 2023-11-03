import 'package:alemagro_application/blocs/pincode/pin_code_bloc.dart';
import 'package:alemagro_application/blocs/pincode/pin_code_event.dart';
import 'package:alemagro_application/screens/staff/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinSetupScreen extends StatefulWidget {
  @override
  _PinSetupScreenState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _enteredPin = '';

  void _onNumButtonPressed(String num) {
    setState(() {
      if (_enteredPin.length < 4) {
        _enteredPin += num;
      }

      if (_enteredPin.length == 4) {
        // Сохраняем PIN
        // await savePin(_enteredPin);

        // Переходим к следующему экрану или отображаем сообщение
        // ...
      }
    });
  }

  void _onDeleteButtonPressed() {
    setState(() {
      if (_enteredPin.isNotEmpty) {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Введите PIN-код'),
        backgroundColor: Color(0xFF08428C),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Здесь может быть любой виджет для отображения _enteredPin, например:
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(''.padRight(_enteredPin.length, '*'),
                    style: TextStyle(fontSize: 40))),
            GridView.builder(
              padding: const EdgeInsets.all(30),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
              ),
              itemCount: 9,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1462A6),
                    shape: CircleBorder(),
                    fixedSize: Size(20, 20),
                  ),
                  onPressed: () => _onNumButtonPressed((index + 1).toString()),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 28),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                    width:
                        40), // Этот виджет нужен для центрирования кнопки "0" и кнопки удаления по сетке
                // Кнопка "0"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1462A6),
                    shape: const CircleBorder(),
                    fixedSize: Size(105, 105),
                  ),
                  onPressed: () => _onNumButtonPressed("0"),
                  child: const Text(
                    "0",
                    style: TextStyle(fontSize: 28),
                  ),
                ),

                // Кнопка удаления
                IconButton(
                  icon: const Icon(
                    Icons.backspace,
                    size: 32,
                    color: Color(0xFF1462A6),
                  ),
                  onPressed: _onDeleteButtonPressed,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1462A6),
                  fixedSize: const Size.fromHeight(60),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                context.read<PinBloc>().add(SavePinEvent(_enteredPin));
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
              },
              child: const Text(
                "Сохранить Пин-Код",
                style: TextStyle(fontSize: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
