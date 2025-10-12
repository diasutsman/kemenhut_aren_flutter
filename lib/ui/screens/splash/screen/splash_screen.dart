import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/splash/controller/splash_controller.dart';
import 'package:kemenhut_aren_flutter/ui/widgets/_index.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SplashController(context);

    return Semantics(
      identifier: 'splash_screen',
      child: AppWidgetWrapper(
        child: GetBuilder(
          init: controller,
          builder: (context) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Hero(
                          tag: 'logo',
                          child: Semantics(
                            identifier: 'logo',
                            child: Image.asset(AppImage.logo, height: 120.h),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      identifier: 'loading',
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
