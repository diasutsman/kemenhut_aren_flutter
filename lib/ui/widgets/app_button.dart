import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.title,
    this.onTap,
    this.loading = false,
    this.height,
    this.width,
    this.child,
    this.isOutline = false,
    this.icon,
    this.fontSize,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.horizontalPadding,
    this.fontWeight,
    this.iconLeftPosition = true,
    this.loadingColor,
  }) : assert(title == null || child == null);
  final String? title;
  final Function()? onTap;
  final bool loading;
  final double? height;
  final double? width;
  final Widget? child;
  final bool isOutline;
  final Widget? icon;
  final double? fontSize;
  final Color? color;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? horizontalPadding;
  final FontWeight? fontWeight;
  final bool iconLeftPosition;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      hoverColor: isOutline ? AppColor.maroon.withOpacity(0.1) : null,
      splashColor: isOutline ? AppColor.maroon.withOpacity(0.3) : null,
      borderRadius: BorderRadius.circular(borderRadius ?? 5.sp),
      child: Container(
        height: height ?? 40.h,
        width: width,
        decoration: BoxDecoration(
          color: isOutline ? null : backgroundColor ?? AppColor.maroon,
          borderRadius: BorderRadius.circular(borderRadius ?? 5.sp),
          border:
              isOutline
                  ? Border.all(color: backgroundColor ?? AppColor.maroon)
                  : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Center(
          child:
              loading
                  ? Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          loadingColor ??
                              (isOutline ? AppColor.maroon : Colors.white),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null && iconLeftPosition)
                        Padding(
                          padding: EdgeInsets.only(right: 8.sp),
                          child: icon!,
                        ),
                      child ??
                          Text(
                            title!,
                            style: TextStyle(
                              color:
                                  color ??
                                  (isOutline ? AppColor.maroon : Colors.white),
                              fontSize: fontSize ?? 14.sp,
                              fontWeight: fontWeight ?? FontWeight.w600,
                            ),
                          ),
                      if (icon != null && !iconLeftPosition)
                        Padding(
                          padding: EdgeInsets.only(left: 8.sp),
                          child: icon!,
                        ),
                    ],
                  ),
        ),
      ),
    );
  }
}
