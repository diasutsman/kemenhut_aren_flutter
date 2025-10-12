import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.maroon,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(15.h),
        SizedBox(
          height: 2.sp,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 1.sp,
                  width: double.maxFinite,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 2.sp,
                width: 80.sp,
                color: Colors.blue.shade800,
              ),
            ],
          ),
        ),
        Gap(15.h),
      ],
    );
  }
}
