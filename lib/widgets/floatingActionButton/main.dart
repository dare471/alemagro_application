import 'package:alemagro_application/blocs/calendar/calendar_bloc.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FloatingActionButton? buildFloatingActionButton(
    BuildContext context, int currentIndex) {
  return currentIndex == 1
      ? FloatingActionButton(
          backgroundColor: AppColors.blueLightV,
          onPressed: () {
            context.read<CalendarBloc>().add(ToggleCalendarViewEvent());
            // Действие при нажатии на кнопку
          },
          child: const Icon(
            Icons.calendar_month,
            color: AppColors.offWhite,
          ),
        )
      : null;
}
