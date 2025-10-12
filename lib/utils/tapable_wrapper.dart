import 'package:flutter/material.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';

class TappableWrapper extends StatelessWidget {
  const TappableWrapper({
    super.key,
    this.decoration,
    required this.child,
    required this.onTap,
  });
  final BoxDecoration? decoration;
  final Widget child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      type: MaterialType.transparency,
      borderRadius: decoration?.borderRadius,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          hoverColor: AppColor.maroon.withOpacity(0.1),
          splashColor: AppColor.maroon.withOpacity(0.3),
          customBorder:
              decoration != null && decoration!.borderRadius != null
                  ? RoundedRectangleBorder(
                    borderRadius: decoration!.borderRadius!,
                  )
                  : null,
          child: child,
        ),
      ),
    );
  }
}
