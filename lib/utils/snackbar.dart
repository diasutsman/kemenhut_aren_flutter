import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';

void showSnackbar(
  BuildContext context,
  String message,
  bool isSuccess, {
  bool floating = true,
  Color? color,
  EdgeInsetsGeometry? margin,
  String actionLabel = 'Open',
  Function()? actionOnTap,
  Duration? durationTime,
  String? titleMessage,
}) {
  Flushbar(
    backgroundColor: color ?? (isSuccess ? Colors.green : Colors.red),
    message: message,
    titleText: Text(
      titleMessage ?? (isSuccess ? 'Success' : 'Error Occured'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
      ),
    ),
    icon: Icon(
      isSuccess ? Icons.check_circle : Icons.warning,
      color: Colors.white,
      size: 20.sp,
    ),
    mainButton: actionOnTap != null
        ? TextButton(
            onPressed: actionOnTap,
            child: Text(
              actionLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          )
        : null,
    duration: durationTime ?? Duration(seconds: actionOnTap != null ? 5 : 3),
    padding: EdgeInsets.all(8.sp),
    borderRadius: BorderRadius.circular(5.sp),
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    margin: EdgeInsets.all(10.sp),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}

void showLoadingSnackbar(String message, BuildContext context, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(hours: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
          const CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
      backgroundColor: color,
    ),
  );
}
