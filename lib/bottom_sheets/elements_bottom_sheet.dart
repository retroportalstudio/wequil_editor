import 'package:flutter/material.dart';
import 'package:wequil_editor/state/state.dart';

class WEElementsBottomSheet extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle, itemTextStyle;
  final double? iconSize;
  final Color? iconColor;
  final WEquilEditorController controller;
  final Function()? onInsertHyperlink;
  final Function()? onInsertMedia;

  const WEElementsBottomSheet(
      {super.key,
      required this.controller,
      this.title = "Insert",
      this.titleTextStyle,
      this.itemTextStyle,
      this.iconSize,
      this.iconColor,
      this.onInsertHyperlink,
      this.onInsertMedia});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const double defaultIconSize = 20;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: titleTextStyle ?? textTheme.titleLarge,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            dense: true,
            onTap: () {
              Navigator.of(context).pop();
              onInsertHyperlink?.call();
            },
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.link,
                size: iconSize ?? defaultIconSize,
                color: iconColor ?? Colors.black),
            title: Text(
              "Link",
              style: itemTextStyle ?? textTheme.bodyMedium,
            ),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            dense: true,
            onTap: () {
              Navigator.of(context).pop();
              onInsertMedia?.call();
            },
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.image,
                size: iconSize ?? defaultIconSize,
                color: iconColor ?? Colors.black),
            title: Text(
              "Media",
              style: itemTextStyle ?? textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
