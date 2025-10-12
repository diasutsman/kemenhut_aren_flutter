import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationColumn extends StatelessWidget {
  const InformationColumn(
    this.title,
    this.data, {
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.useBottomPadding = true,
    this.child,
    this.titleStyle,
    this.dataStyle,
    this.maxLines,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
  final String title;
  final String data;
  final MainAxisAlignment mainAxisAlignment;
  final bool useBottomPadding;
  final Widget? child;
  final TextStyle? titleStyle;
  final TextStyle? dataStyle;
  final int? maxLines;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: useBottomPadding ? 15.h : 0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: SizedBox(
              width: double.maxFinite,
              child: Text(
                title,
                style: titleStyle ??
                    TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: crossAxisAlignment == CrossAxisAlignment.end
                    ? TextAlign.end
                    : crossAxisAlignment == CrossAxisAlignment.center
                        ? TextAlign.center
                        : null,
              ),
            ),
          ),
          if (child != null)
            child!
          else
            Text(
              data,
              style: dataStyle ??
                  TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
