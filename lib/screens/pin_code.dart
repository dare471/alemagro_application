import 'package:alemagro_application/app.dart';
import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/screens/staff/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPinDisplay(),
            _buildNumberPad(),
            _buildControlButtons(),
            const Gap(30),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Введите PIN-код'),
      backgroundColor: const Color(0xFF08428C),
      actions: <Widget>[
        IconButton(
          iconSize: 30,
          onPressed: _deletedStoredPin,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }

  Widget _buildPinDisplay() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(''.padRight(_enteredPin.length, '*'),
          style: const TextStyle(fontSize: 40)),
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
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
        return _buildNumberButton((index + 1).toString());
      },
    );
  }

  ElevatedButton _buildNumberButton(String number) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1462A6),
        shape: const CircleBorder(),
      ),
      onPressed: () => _onNumButtonPressed(number),
      child: Text(
        number,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: IconButton(
            onPressed: _authenticateWithFaceID,
            icon: const Icon(Icons.fingerprint,
                size: 40, color: Color(0xFF1462A6)),
          ),
        ),
        Expanded(
          child: _buildZeroButton(),
        ),
        Expanded(
          child: IconButton(
            icon:
                const Icon(Icons.backspace, size: 32, color: Color(0xFF1462A6)),
            onPressed: _onDeleteButtonPressed,
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildZeroButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1462A6),
          shape: const CircleBorder(),
          fixedSize: Size(90.0, 90.0)),
      onPressed: () => _onNumButtonPressed("0"),
      child: const Text("0", style: TextStyle(fontSize: 28)),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
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
            Text('Войти', style: TextStyle(fontSize: 19)),
          ]),
    );
  }

  void _deletedStoredPin() async {
    await storage.deleteAll();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> _authenticateWithFaceID() async {
    // Реализация аутентификации через Face ID
    var canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    var availableBiometrics = await auth.getAvailableBiometrics();

    if (canAuthenticateWithBiometrics &&
        availableBiometrics.contains(BiometricType.face)) {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Пожалуйста, авторизуйтесь для доступа',
      );
      if (authenticated) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      // Обработка случаев, когда Face ID недоступен
      print("Face ID недоступен");
    }
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
          builder: (context) => BlocProvider<CalendarBloc>(
            create: (context) => CalendarBloc()..add(FetchMeetings()),
            child: HomePage(),
          ),
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
