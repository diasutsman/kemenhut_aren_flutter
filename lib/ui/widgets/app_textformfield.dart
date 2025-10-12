import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.title,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isUnderline = true,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.onEditingComplete,
    this.keyboardType,
    this.labelBehavior,
    this.useDecoration = true,
    this.style,
    this.onChanged,
    this.suffixText,
    this.focusNode,
    this.maxLines = 1,
    this.textCapitalization,
    this.inputFormatters,
    this.textInputAction,
    this.hintStyle,
    this.contentPadding,
    this.fillColor,
    this.enabledBorderColor,
    this.textAlign = TextAlign.start,
    this.titleStyle,
    this.height,
  });

  final TextEditingController controller;
  final String? title;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isUnderline;
  final bool enabled;
  final bool readOnly;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final FloatingLabelBehavior? labelBehavior;
  final bool useDecoration;
  final TextStyle? style;
  final TextStyle? titleStyle;
  final Function(String)? onChanged;
  final String? suffixText;
  final FocusNode? focusNode;
  final int maxLines;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final TextAlign textAlign;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title!, style: titleStyle ?? AppFont.h3TextStyle),
            _textformfield(),
          ],
        )
        : _textformfield();
  }

  Widget _textformfield() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height ?? 40.h),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColor.maroon,
        obscureText: obscureText,
        onEditingComplete: onEditingComplete,
        style: style ?? TextStyle(fontSize: 14.sp, color: Colors.black),
        enabled: enabled,
        onTap: onTap,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onChanged: onChanged,
        focusNode: focusNode,
        maxLines: maxLines,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        textAlign: textAlign,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          labelText: label,
          fillColor: fillColor,
          isCollapsed: height != null,
          filled: fillColor != null,
          hintText: hint,
          suffixText: suffixText,
          suffixStyle: style ?? TextStyle(fontSize: 14.sp, color: Colors.black),
          alignLabelWithHint: true,
          floatingLabelBehavior: labelBehavior,
          hintStyle:
              hintStyle ?? TextStyle(fontSize: 12.sp, color: Colors.grey),
          border:
              !useDecoration
                  ? InputBorder.none
                  : isUnderline
                  ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.maroon.withOpacity(0.5),
                      width: 3,
                    ),
                  )
                  : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp),
                    borderSide: BorderSide(
                      color: AppColor.maroon.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
          enabledBorder:
              !useDecoration
                  ? InputBorder.none
                  : isUnderline
                  ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: enabledBorderColor ?? Colors.grey,
                    ),
                  )
                  : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp),
                    borderSide: BorderSide(
                      color: enabledBorderColor ?? Colors.black,
                    ),
                  ),
          focusedBorder:
              !useDecoration
                  ? InputBorder.none
                  : isUnderline
                  ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.maroon.withOpacity(0.5),
                      width: 3,
                    ),
                  )
                  : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp),
                    borderSide: BorderSide(
                      color: AppColor.maroon.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
          prefixIcon: prefixIcon,
          suffixIcon:
              suffixIcon != null
                  ? Padding(
                    padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    child: suffixIcon,
                  )
                  : (onTap != null ? const Icon(Icons.arrow_drop_down) : null),
          suffixIconConstraints:
              isUnderline ? BoxConstraints(minWidth: 20.w) : null,
          contentPadding:
              contentPadding ??
              (isUnderline
                  ? null
                  : EdgeInsets.symmetric(
                    horizontal: 10.sp,
                    vertical: maxLines != 1 ? 10.h : 0,
                  )),
        ),
        validator: validator,
      ),
    );
  }
}
