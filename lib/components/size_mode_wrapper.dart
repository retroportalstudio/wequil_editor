import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wequil_editor/core/core.dart';

class SizeModeWrapper extends StatelessWidget {
  final SizeMode sizeMode;

  final Widget Function(BuildContext context, Size size) builder;

  const SizeModeWrapper(
      {super.key, required this.sizeMode, required this.builder});

  Size getWidthRatioForSizeMode(SizeMode mode) {
    if (!kIsWeb) {
      if (mode == SizeMode.mini) {
        return const Size(0.4, 0.4);
      } else if (mode == SizeMode.tiny) {
        return const Size(0.5, 0.5);
      }
    }
    switch (mode) {
      case SizeMode.mini:
        return const Size(0.2, 0.2);
      case SizeMode.tiny:
        return const Size(0.4, 0.4);
      case SizeMode.small:
        return const Size(0.6, 0.6);
      case SizeMode.normal:
        return const Size(0.7, 0.7);
      case SizeMode.large:
        return const Size(0.8, 0.8);
      case SizeMode.huge:
        return const Size(0.9, 1.0);
      case SizeMode.massive:
        return const Size(1.0, 1.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final Size constraint = kIsWeb
          ? Size(constraints.maxWidth, constraints.maxHeight)
          : MediaQuery.sizeOf(context);
      final Size sizeRatio = getWidthRatioForSizeMode(sizeMode);
      final double widthConstraints = constraint.width * sizeRatio.width;
      final double maxHeight = constraint.width * sizeRatio.height;
      return Center(
        child: Container(
          constraints: BoxConstraints(
              minWidth: widthConstraints,
              maxWidth: widthConstraints,
              maxHeight: maxHeight),
          child: builder(context,
              Size(widthConstraints, constraint.width * sizeRatio.height)),
        ),
      );
    });
  }
}
