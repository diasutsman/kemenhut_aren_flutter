import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppWidgetWrapper extends StatelessWidget {
  const AppWidgetWrapper({
    super.key,
    required this.child,
    this.onRefresh,
  });
  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: onRefresh != null
            ? RefreshIndicator(onRefresh: onRefresh!, child: child)
            : child,
      ),
    );
  }
}
