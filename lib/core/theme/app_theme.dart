import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.secondary, background: AppColors.bg),
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary, foregroundColor: Colors.white, centerTitle: true, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  );

  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark));
}
