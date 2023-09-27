import 'package:flutter/material.dart';
import 'package:wequil_editor/components/components.dart';
import 'package:wequil_editor/state/state.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:wequil_editor/utils/editor_functions.dart';
import 'package:wequil_editor/utils/helper_functions.dart';

class WETextOptionsBottomSheet extends StatefulWidget {
  final String title;
  final TextStyle? titleTextStyle, itemTextStyle;
  final TextTheme? textTheme;
  final double? iconSize;
  final Color? iconColor;
  final WEquilEditorController controller;

  const WETextOptionsBottomSheet({
    super.key,
    required this.controller,
    this.textTheme,
    this.title = "Insert",
    this.titleTextStyle,
    this.itemTextStyle,
    this.iconSize,
    this.iconColor,
  });

  @override
  State<WETextOptionsBottomSheet> createState() =>
      _WETextOptionsBottomSheetState();
}

class _WETextOptionsBottomSheetState extends State<WETextOptionsBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = widget.textTheme ?? Theme
        .of(context)
        .textTheme;
    const double defaultIconSize = 20;
    final TextStyle? titleText = textTheme.titleMedium
        ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    return Padding(
        padding: const EdgeInsets.all(20),
        child: _TextOptions(controller: widget.controller)

      // Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     TabBar(controller: tabController, tabs: [
      //       Tab(
      //         child: Text(
      //           "Text",
      //           style: titleText,
      //         ),
      //       ),
      //       Tab(
      //         child: Text(
      //           "Paragraph",
      //           style: titleText,
      //         ),
      //       )
      //     ]),
      //     Expanded(
      //         child: TabBarView(controller: tabController, children: [
      //       _TextOptions(
      //         controller: widget.controller,
      //       ),
      //       _ParagraphOptions(
      //         controller: widget.controller,
      //       )
      //     ]))
      //   ],
      // ),
    );
  }
}

class _TextOptions extends StatelessWidget {
  final WEquilEditorController controller;

  const _TextOptions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final TextStyle? titleText = textTheme.titleMedium
        ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    const double iconSize = 20;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WEStyleButton(
                controller: controller,
                icon: Icons.format_bold,
                iconSize: iconSize,
                attribute: quill.Attribute.bold),
            WEStyleButton(
                controller: controller,
                icon: Icons.format_italic,
                iconSize: iconSize,
                attribute: quill.Attribute.italic),
            WEStyleButton(
                controller: controller,
                icon: Icons.format_underline,
                iconSize: iconSize,
                attribute: quill.Attribute.underline),
            WEStyleButton(
                controller: controller,
                icon: Icons.format_overline,
                iconSize: iconSize,
                attribute: quill.Attribute.strikeThrough),
            WEStyleButton(
                controller: controller,
                icon: Icons.superscript,
                iconSize: iconSize,
                attribute: quill.Attribute.superscript),
            WEStyleButton(
                controller: controller,
                icon: Icons.subscript,
                iconSize: iconSize,
                attribute: quill.Attribute.subscript),
          ],
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Style",
            style: titleText,
          ),
          trailing: WEHeaderStyleButton(
            controller: controller,
            iconSize: iconSize,
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Font Size",
            style: titleText,
          ),
          trailing: WEFontSizeButton(
            controller: controller,
            onSelected: (value) {
              Navigator.of(context).pop();
            },
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Font Color",
            style: titleText,
          ),
          trailing: WEFontColorButton(
            forBackground: false,
            controller: controller,
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Highlight Color",
            style: titleText,
          ),
          trailing: WEFontColorButton(
            forBackground: true,
            controller: controller,
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          onTap: () {
            WequilEditorFunctions.clearFormattingForSelection(controller);
            Navigator.of(context).pop();
          },
          title: Text(
            "Clear Formatting",
            style: titleText,
          ),
        ),
      ],
    );
  }
}

class _ParagraphOptions extends StatelessWidget {
  final WEquilEditorController controller;

  const _ParagraphOptions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
