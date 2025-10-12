import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/widgets/app_button.dart';

class SynchronizationProgress extends StatelessWidget {
  const SynchronizationProgress({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColor.maroon),
          strokeWidth: 3,
        ),
        Gap(10.h),
        Text('Synchronizing', style: AppFont.subheading1TextStyle),
        Gap(10.h),
        AppButton(title: 'Check Status', onTap: onTap),
      ],
    );
  }
}
