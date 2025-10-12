import 'package:flutter/material.dart';

const kDefaultTableBreakpoints = 600;

class LayoutBuilderWrapper extends StatelessWidget {
  const LayoutBuilderWrapper({super.key, required this.childBuilder});
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    bool isTablet,
  ) childBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return childBuilder(
          context,
          constraints,
          constraints.maxWidth >= kDefaultTableBreakpoints,
        );
      },
    );
  }
}
