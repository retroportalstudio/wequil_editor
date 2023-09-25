import 'package:flutter/material.dart';
import 'package:wequil_editor/components/components.dart';
import 'package:wequil_editor/state/state.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class WETextOptionsBottomSheet extends StatefulWidget {
  final String title;
  final TextStyle? titleTextStyle, itemTextStyle;
  final double? iconSize;
  final Color? iconColor;
  final WEquilEditorController controller;

  const WETextOptionsBottomSheet({
    super.key,
    required this.controller,
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    const double defaultIconSize = 20;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(controller: tabController, tabs: [
            Tab(
              child: Text(
                "Text",
                style: textTheme.titleLarge,
              ),
            ),
            Tab(
              child: Text(
                "Paragraph",
                style: textTheme.titleLarge,
              ),
            )
          ]),
          Expanded(
              child: TabBarView(controller: tabController, children: [
            _TextOptions(
              controller: widget.controller,
            ),
            _ParagraphOptions(
              controller: widget.controller,
            )
          ]))
        ],
      ),
    );
  }
}

class _TextOptions extends StatelessWidget {
  final WEquilEditorController controller;

  const _TextOptions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const double iconSize = 25;
    return Column(
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
          title: Text(
            "Style",
            style: textTheme.titleLarge,
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
          title: Text(
            "Size",
            style: textTheme.titleLarge,
          ),
          trailing: SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: controller.decrementFontSize,
                    child: const Icon(Icons.arrow_drop_down, size: 50)),
                ValueListenableBuilder<double>(
                    valueListenable: controller.fontSize,
                    builder: (context, fontSize, _) {
                      return Text(
                        "$fontSize",
                        style: textTheme.titleLarge,
                      );
                    }),
                InkWell(
                    onTap: controller.incrementFontSize,
                    child: const Icon(Icons.arrow_drop_up, size: 50)),
              ],
            ),
          ),
        ),
        const Divider(
          height: 4,
        ),
      ],
    );
  }
}

class _ParagraphOptions extends StatefulWidget {
  final WEquilEditorController controller;

  const _ParagraphOptions({super.key, required this.controller});

  @override
  State<_ParagraphOptions> createState() => _ParagraphOptionsState();
}

class _ParagraphOptionsState extends State<_ParagraphOptions> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
