import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
  });
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      height: height,
      width: width,
      radius: radius,
      millisecondsDelay: 500,
      highlightColor: const Color(0xffF9F9FB),
      baseColor: const Color(0xffE6E8EB),
    );
  }
}
