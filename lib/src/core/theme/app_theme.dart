import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() {

  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.mainBlue,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: AppColors.mainBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    navigationBarTheme: base.navigationBarTheme.copyWith(
      indicatorColor: AppColors.mainBlue.withOpacity(0.12),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.mainBlue);
          }
          return const IconThemeData(color: Colors.grey);
        },
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) {
          return TextStyle(
            color: states.contains(WidgetState.selected) ? AppColors.mainBlue : Colors.grey,
          );
        },
      ),
    ),
  );
}

