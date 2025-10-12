import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';
import 'package:kemenhut_aren_flutter/ui/widgets/_index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return AppWidgetWrapper(
          child: SafeArea(
            child: LayoutBuilderWrapper(
              childBuilder: (context, constraints, isTablet) {
                return Scaffold(
                  body: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tr('home.title'), style: AppFont.h1TextStyle),
                        Gap(10.h),
                        AppButton(
                          title: tr('home.sync_dialog'),
                          onTap: controller.openSyncDialog,
                          width: 200.sp,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
