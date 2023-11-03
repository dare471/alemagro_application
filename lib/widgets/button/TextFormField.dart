import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final TextEditingController passwordController;
  final String label;
  final String hintText;
  final bool isPassword;
  // Requiring the controller to be passed in the constructor of the widget.
  FormInputField(
      {required this.passwordController,
      required this.label,
      required TextEditingController controller,
      required this.hintText,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    // Вы можете вынести цвета в централизованный файл стилей или конфигурации для более удобного управления.
    const primaryColor =
        Color.fromARGB(255, 183, 205, 233); // светло-голубой серый
    const secondaryColor = Color.fromARGB(255, 158, 174, 187);
    const errorColor = Colors.red;

    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 17),
      controller: passwordController,
      decoration: InputDecoration(
        // labelText: label,
        hintText: hintText,
        filled: true,
        fillColor:
            secondaryColor, // использование белого цвета для заполнения делает поле ярким и чистым
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        isDense: true, // делает поле ввода немного компактнее
        errorStyle: const TextStyle(color: errorColor), // Цвет текста ошибки
        labelStyle: const TextStyle(color: Colors.white), // цвет лейбла
        hintStyle: const TextStyle(color: Colors.white), // цвет подсказки

        // Общий стиль границы, чтобы упростить и избежать дублирования
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(20), // немного увеличен радиус для мягкости
          borderSide: const BorderSide(
              width: 5,
              color: Colors
                  .white), // отсутствие видимой границы делает дизайн чище
        ),

        // В фокусе
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),

        // Когда поле активировано/доступно для ввода
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),

        // Ошибка валидации
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
              color: errorColor), // используем красный для ошибок
        ),
      ),
      obscureText: isPassword, // скрытие текста для полей пароля
      // Здесь могут быть дополнительные свойства, такие как валидаторы и т.д.
    );
  }
}
