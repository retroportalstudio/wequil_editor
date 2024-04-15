import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/state/wequil_editor_controller.dart';

class WEUndoButton extends StatelessWidget {
  final WEquilEditorController controller;
  final IconData? icon;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;

  const WEUndoButton({super.key, required this.controller, this.icon, this.iconSize, this.afterPressed, this.iconTheme});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarHistoryButton(
      controller: controller.quillController,
      options: QuillToolbarHistoryButtonOptions(
        iconData: icon ?? Icons.undo,
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        afterButtonPressed: () {
          afterPressed?.call();
        },
      ),
      isUndo: true,
    );
  }
}

class WERedoButton extends StatelessWidget {
  final WEquilEditorController controller;
  final IconData? icon;
  final double? iconSize;
  final QuillIconTheme? iconTheme;

  final Function()? afterPressed;

  const WERedoButton({super.key, required this.controller, this.icon, this.iconSize, this.afterPressed, this.iconTheme});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarHistoryButton(
      options: QuillToolbarHistoryButtonOptions(
          iconSize: iconSize ?? controller.theme.iconSize,
          iconTheme: iconTheme ?? controller.theme.iconTheme,
          afterButtonPressed: () {
            afterPressed?.call();
          },
          iconData: icon ?? Icons.redo),
      controller: controller.quillController,
      isUndo: false,
    );
  }
}

class WEStyleButton extends StatelessWidget {
  final Attribute attribute;
  final WEquilEditorController controller;
  final IconData icon;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;

  const WEStyleButton(
      {super.key, required this.controller, required this.icon, this.iconSize, this.iconTheme, this.afterPressed, required this.attribute});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarToggleStyleButton(
      attribute: attribute,
      options: QuillToolbarToggleStyleButtonOptions(
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        afterButtonPressed: () {
          controller.toggleSelectedAttribute(attribute);
          afterPressed?.call();
        },
        iconData: icon,
      ),
      controller: controller.quillController,
    );
  }
}

class WEListButton extends StatelessWidget {
  final WEListType type;
  final WEquilEditorController controller;
  final IconData? icon;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;

  const WEListButton({super.key, required this.type, required this.controller, this.icon, this.iconSize, this.afterPressed, this.iconTheme});

  @override
  Widget build(BuildContext context) {
    if (type == WEListType.bullet) {
      return QuillToolbarToggleStyleButton(
        attribute: Attribute.ul,
        options: QuillToolbarToggleStyleButtonOptions(
          tooltip: "Bullet List",
          iconData: Icons.format_list_bulleted,
          iconSize: iconSize ?? controller.theme.iconSize,
          iconTheme: iconTheme ?? controller.theme.iconTheme,
          afterButtonPressed: () {
            controller.toggleSelectedAttribute(Attribute.ul);
            afterPressed?.call();
          },
        ),
        controller: controller.quillController,
      );
    } else if (type == WEListType.numbered) {
      return QuillToolbarToggleStyleButton(
        attribute: Attribute.ol,
        options: QuillToolbarToggleStyleButtonOptions(
          tooltip: "Numbered List",
          iconData: Icons.format_list_numbered,
          iconSize: iconSize ?? controller.theme.iconSize,
          iconTheme: iconTheme ?? controller.theme.iconTheme,
          afterButtonPressed: () {
            controller.toggleSelectedAttribute(Attribute.ol);
            afterPressed?.call();
          },
        ),
        controller: controller.quillController,
      );
    } else {
      return QuillToolbarToggleCheckListButton(
        options: QuillToolbarToggleCheckListButtonOptions(
          attribute: Attribute.unchecked,
          tooltip: "Checklist",
          iconData: Icons.checklist,
          iconSize: iconSize ?? controller.theme.iconSize,
          iconTheme: iconTheme ?? controller.theme.iconTheme,
          afterButtonPressed: () {
            controller.toggleSelectedAttribute(Attribute.unchecked);
            afterPressed?.call();
          },
        ),
        controller: controller.quillController,
      );
    }
  }
}

class WEHeaderStyleButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;

  const WEHeaderStyleButton({
    super.key,
    required this.controller,
    this.iconSize,
    this.iconTheme,
    this.afterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return QuillToolbarSelectHeaderStyleButtons(
      options: QuillToolbarSelectHeaderStyleButtonsOptions(
        tooltip: "Header Style",
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
      ),
      controller: controller.quillController,
    );
  }
}

class WEFontSizeButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;
  final Function(dynamic)? onSelected;

  const WEFontSizeButton({super.key, required this.controller, this.iconSize, this.iconTheme, this.onSelected, this.afterPressed});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarFontSizeButton(
      controller: controller.quillController,
      options: QuillToolbarFontSizeButtonOptions(
        iconSize: iconSize ?? controller.theme.iconSize,
        // iconTheme ?? controller.theme.iconTheme,
        tooltip: "Font Size",
        attribute: Attribute.size,
        onSelected: onSelected,
        rawItemsMap: const {'Small': 'small', 'Large': 'large', 'Huge': 'huge', 'Clear': '0'},
        afterButtonPressed: afterPressed,
      ),
    );
  }
}

class WEFontColorButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;
  final bool forBackground;

  const WEFontColorButton({super.key, required this.controller, this.iconSize, this.iconTheme, required this.forBackground, this.afterPressed});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarColorButton(
      controller: controller.quillController,
      options: QuillToolbarColorButtonOptions(
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        tooltip: forBackground ? "Background Color" : "Text Color",
        afterButtonPressed: afterPressed,
        iconData: Icons.color_lens,
      ),
      isBackground: forBackground,
    );
  }
}

class WEIndentButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;
  final bool increase;

  const WEIndentButton({super.key, required this.controller, this.iconSize, this.iconTheme, required this.increase, this.afterPressed});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIndentButton(
      controller: controller.quillController,
      options: QuillToolbarIndentButtonOptions(
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        tooltip: "${increase ? "Increase" : "Decrease"} Indent",
        iconData: increase ? Icons.format_indent_increase_outlined : Icons.format_indent_decrease_rounded,
        afterButtonPressed: afterPressed,
      ),
      isIncrease: increase,
    );
  }
}
