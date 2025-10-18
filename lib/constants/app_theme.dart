import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class AppTheme {
  static final theme = ThemeData(
    fontFamily: AppFont.fontFamily,
    primaryColor: AppColor.maroon,
    colorScheme: const ColorScheme.light(
      primary: AppColor.maroon,
      secondary: AppColor.maroon,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB7997A),
      foregroundColor: Colors.white,
      scrolledUnderElevation: 0.0,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColor.maroon),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.maroon,
      selectionColor: AppColor.maroon.withOpacity(0.2),
      selectionHandleColor: AppColor.maroon,
    ),
    dialogTheme: DialogTheme(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
    ),
    datePickerTheme: const DatePickerThemeData(surfaceTintColor: Colors.white),
  );
}
