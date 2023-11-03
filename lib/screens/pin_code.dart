import 'package:alemagro_application/app.dart';
import 'package:alemagro_application/screens/staff/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final storage = const FlutterSecureStorage();

  Future<void> savePin(String pin) async {
    await storage.write(key: 'pincode', value: pin);
  }

  Future<String?> getStoredPin() async {
    return await storage.read(key: 'pincode');
  }

  Future<String?> deletedStoredPin() async {
    await storage.deleteAll();
    return null;
  }

  String _enteredPin = '';

  void _onNumButtonPressed(String num) {
    setState(() {
      if (_enteredPin.length < 4) {
        _enteredPin += num;
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
          title: const Text('Введите PIN-код'),
          backgroundColor: const Color(0xFF08428C),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              onPressed: () {
                _deletedStoredPin();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Здесь может быть любой виджет для отображения _enteredPin, например:
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(''.padRight(_enteredPin.length, '*'),
                    style: const TextStyle(fontSize: 40))),
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
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1462A6),
                    shape: const CircleBorder(),
                    fixedSize: const Size(20, 20),
                  ),
                  onPressed: () => _onNumButtonPressed((index + 1).toString()),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 28),
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
                    backgroundColor: Color(0xFF1462A6),
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
            const SizedBox(
                height: 20), // Отступ между текстовым полем и кнопкой
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 67, 145, 50),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  fixedSize: const Size(150, 50),
                ),
                onPressed: _verifyPin,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.input_rounded),
                      Text(
                        'Войти',
                        style: TextStyle(fontSize: 19),
                      ),
                    ])),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _deletedStoredPin() async {
    await storage.deleteAll();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _verifyPin() async {
    final storedPin = await getStoredPin(); // Получение сохраненного кода
    if (_enteredPin == storedPin) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
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
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // Показать ошибку
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Неверный PIN код')));
    }
  }
}
