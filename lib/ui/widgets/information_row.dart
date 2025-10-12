import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kemenhut_aren_flutter/ui/widgets/shimmer_widget.dart';

class InformationRow extends StatelessWidget {
  const InformationRow(
    this.title,
    this.data, {
    super.key,
    this.child,
    this.isLoading = false,
    this.useBottomPadding = true,
    this.leadingIcon,
    this.titleStyle,
    this.dataStyle,
    this.maxLines,
    this.customPadding,
  });
  final String title;
  final String data;
  final Widget? leadingIcon;
  final Widget? child;
  final bool isLoading;
  final bool useBottomPadding;
  final TextStyle? titleStyle;
  final TextStyle? dataStyle;
  final int? maxLines;
  final double? customPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: useBottomPadding ? customPadding ?? 15.h : 0,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    if (leadingIcon != null)
                      Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: leadingIcon!,
                      ),
                    Flexible(
                      child: Text(
                        title,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style:
                            titleStyle ??
                            TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (child != null)
                    child!
                  else if (isLoading)
                    Expanded(
                      child: ShimmerWidget(
                        height: 20.h,
                        width: double.maxFinite,
                        radius: 5.w,
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        data,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style:
                            dataStyle ??
                            TextStyle(fontSize: 12.sp, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
