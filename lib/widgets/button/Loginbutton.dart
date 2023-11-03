import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alemagro_application/blocs/auth/auth_bloc.dart';
import 'package:alemagro_application/blocs/auth/auth_event.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  LoginButton(
      {required this.usernameController, required this.passwordController});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.blue.withOpacity(0.8)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blue),
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(Size(250, 50)),
      ), // Пример размера
      onPressed: () {
        // Trigger the event for user login
        context.read<AuthBloc>().add(
              LoginRequested(
                username: usernameController.text,
                password: passwordController.text,
              ),
            );
      },
      child: Text('Авторизоваться'),
    );
  }
}

class RegisterButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  RegisterButton(
      {required this.usernameController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey),
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(Size(250, 50)),
      ),
      onPressed: () {
        print('register');
        // Trigger the event for user login
        // context.read<AuthBloc>().add(
        //       LoginRequested(
        //         username: usernameController.text,
        //         password: passwordController.text,
        //       ),
        //     );
      },
      child: Text('Регистрация'),
    );
  }
}
