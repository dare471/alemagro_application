import 'package:alemagro_application/blocs/auth/auth_state.dart';
import 'package:alemagro_application/blocs/pincode/pin_code_bloc.dart';
import 'package:alemagro_application/repositories/user_repository.dart';
import 'package:alemagro_application/screens/pin_code.dart';
import 'package:alemagro_application/screens/save_pin_code.dart';
import 'package:alemagro_application/widgets/button/Loginbutton.dart';
import 'package:alemagro_application/widgets/button/TextFormField.dart';
import 'package:alemagro_application/widgets/messsage/TextMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alemagro_application/blocs/auth/auth_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:alemagro_application/theme/app_color.dart';

class LoginPage extends StatelessWidget {
  // Контроллеры для текстовых полей
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Извлекаем UserRepository, который был предоставлен выше в дереве виджетов
    final userRepository = RepositoryProvider.of<UserRepository>(context);
    // Переводим hex-цвета в объекты Color

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Пропорции для адаптивного дизайна
    double appBarHeightProportion = 0.4; // 40% от высоты экрана
    double logoWidthProportion = 0.8; // 80% от ширины экрана
    double logoHeightProportion = 0.3; // 30% от высоты экрана
    ///let's goo
    return BlocProvider<AuthBloc>(
      // создаем AuthBloc с UserRepository
      create: (context) => AuthBloc(userRepository: userRepository),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print('Состояние: $state');
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => PinBloc(),
                  child: PinSetupScreen(),
                ),
              ),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Вы неправильно ввели Логин/Пароль'),
              ),
            );
          }
          // Если требуется, добавьте обработчики для других состояний здесь
        },
        child: Scaffold(
          // Используем CustomScrollView для интеграции SliverAppBar
          body: Container(
            // Добавление Container
            color: Colors.white, // Установка цвета фона
            child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: <Widget>[
                // SliverAppBar даёт больше возможностей для настройки, чем обычный AppBar
                SliverAppBar(
                  title: const Text('Авторизация'),
                  centerTitle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30), // радиус закругления
                    ),
                  ),
                  floating:
                      false, // AppBar будет появляться при прокрутке вверх
                  // Добавьте сюда ваше содержимое, если требуется
                  expandedHeight: screenHeight * appBarHeightProportion,
                  backgroundColor: AppColors.blueDark,
                  // Это высота, при которой AppBar полностью расширяется
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // Определяем, расширен ли наш AppBar или свернут
                      bool isExpanded =
                          constraints.biggest.height > (screenHeight * 0.4);

                      return Container(
                        decoration: const BoxDecoration(
                          // Добавим градиент для более красивого перехода цветов
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.blueDark,
                              AppColors.blueLight
                            ], // Переход от темно-синего к светло-синему
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Можно использовать несколько изображений в виджете Stack для создания сложного фона
                            Positioned(
                              top: (isExpanded)
                                  ? 10
                                  : 20, // Если AppBar расширен, изображение будет немного выше
                              child: Opacity(
                                opacity: isExpanded
                                    ? 1
                                    : 0.9, // Уменьшаем прозрачность, если AppBar свернут
                                child: Image.asset(
                                  'assets/logo.png', // Путь к вашему изображению
                                  fit: BoxFit
                                      .fitWidth, // Используйте BoxFit, чтобы решить, как лучше подогнать изображение
                                ),
                              ),
                            ),
                            // Другие изображения или виджеты можно расположить по вашему усмотрению
                            Positioned(
                              left: 20,
                              bottom: 20,
                              child: Text(
                                'Добро пожаловать', // Приветственный текст
                                style: TextStyle(
                                  color: AppColors.offWhite,
                                  fontSize: isExpanded
                                      ? 32
                                      : 24, // Разный размер текста в зависимости от состояния AppBar
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            // Ваш логотип
                            Center(
                              child: AnimatedOpacity(
                                // Используйте AnimatedOpacity для плавного перехода прозрачности
                                duration: const Duration(milliseconds: 400),
                                opacity: isExpanded
                                    ? 1
                                    : 0.6, // Полностью прозрачный, когда AppBar свернут
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: screenWidth / 1.3,
                                  height: screenHeight / 1.3,
                                  color: AppColors.offWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Высота, когда AppBar полностью раскрыт
                ),
                // Теперь у нас есть область под SliverAppBar, куда мы можем добавить наши поля ввода и кнопку
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB0C4DE), // светло-голубой серый
                          Color.fromARGB(255, 255, 255, 255), // белый
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Остальная часть вашего интерфейса остается прежней
                          FormInputField(
                            isPassword: false,
                            controller: _usernameController,
                            label: 'Почта',
                            hintText: "Введите свою почту",
                            passwordController: _usernameController,
                          ),
                          const SizedBox(height: 24.0),
                          FormInputField(
                            isPassword: true,
                            controller: _passwordController,
                            label: 'Пароль',
                            hintText: "Введите свой пароль",
                            passwordController: _passwordController,
                          ),
                          const SizedBox(height: 24.0),
                          Column(
                            children: [
                              LoginButton(
                                usernameController: _usernameController,
                                passwordController: _passwordController,
                              ),
                              const SizedBox(height: 16.0),
                              TextMessage(
                                title:
                                    'Если вы не проходили еще регистрацию, то просим пройти её для получения доступа.',
                              ),
                              const SizedBox(height: 16.0),
                              RegisterButton(
                                usernameController: _usernameController,
                                passwordController: _passwordController,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                'version 1.0.1',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkPinAndRedirect();
  }

  Future<void> _checkPinAndRedirect() async {
    bool hasPin = await hasPinStored();
    if (hasPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PinCodeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: CircularProgressIndicator()), // Show a loading spinner
    );
  }
}

Future<bool> hasPinStored() async {
  final _storage = FlutterSecureStorage();
  String? pin = await _storage.read(key: 'pincode');
  return pin != null && pin.isNotEmpty;
}
