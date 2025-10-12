import 'package:flutter/material.dart';

String convertFloatTimeToString(double floatTime) {
  int hours = floatTime.floor();
  int minutes = ((floatTime - hours) * 60).round();
  final data = TimeOfDay(hour: hours, minute: minutes);

  return '${data.hour}:${data.minute}';
}
