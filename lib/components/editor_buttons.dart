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

  const WEUndoButton(
      {super.key,
      required this.controller,
      this.icon,
      this.iconSize,
      this.afterPressed,
      this.iconTheme});

  @override
  Widget build(BuildContext context) {
    return HistoryButton(
      icon: icon ?? Icons.undo,
      controller: controller.quillController,
      undo: true,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
      afterButtonPressed: () {
        afterPressed?.call();
      },
    );
  }
}

class WERedoButton extends StatelessWidget {
  final WEquilEditorController controller;
  final IconData? icon;
  final double? iconSize;
  final QuillIconTheme? iconTheme;

  final Function()? afterPressed;

  const WERedoButton(
      {super.key,
      required this.controller,
      this.icon,
      this.iconSize,
      this.afterPressed,
      this.iconTheme});

  @override
  Widget build(BuildContext context) {
    return HistoryButton(
      icon: icon ?? Icons.redo,
      controller: controller.quillController,
      undo: false,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
      afterButtonPressed: () {
        afterPressed?.call();
      },
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
      {super.key,
      required this.controller,
      required this.icon,
      this.iconSize,
      this.iconTheme,
      this.afterPressed,
      required this.attribute});

  @override
  Widget build(BuildContext context) {
    return ToggleStyleButton(
      attribute: attribute,
      icon: icon,
      controller: controller.quillController,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
      afterButtonPressed: () {
        controller.toggleSelectedAttribute(attribute);
        afterPressed?.call();
      },
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

  const WEListButton(
      {super.key,
      required this.type,
      required this.controller,
      this.icon,
      this.iconSize,
      this.afterPressed,
      this.iconTheme});

  @override
  Widget build(BuildContext context) {
    if (type == WEListType.bullet) {
      return ToggleStyleButton(
        attribute: Attribute.ul,
        tooltip: "Bullet List",
        controller: controller.quillController,
        icon: Icons.format_list_bulleted,
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        afterButtonPressed: () {
          controller.toggleSelectedAttribute(Attribute.ul);
          afterPressed?.call();
        },
      );
    } else if (type == WEListType.numbered) {
      return ToggleStyleButton(
        attribute: Attribute.ol,
        tooltip: "Numbered List",
        icon: Icons.format_list_numbered,
        controller: controller.quillController,
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        afterButtonPressed: () {
          controller.toggleSelectedAttribute(Attribute.ol);
          afterPressed?.call();
        },
      );
    } else {
      return ToggleCheckListButton(
        attribute: Attribute.unchecked,
        tooltip: "Checklist",
        controller: controller.quillController,
        icon: Icons.checklist,
        iconSize: iconSize ?? controller.theme.iconSize,
        iconTheme: iconTheme ?? controller.theme.iconTheme,
        afterButtonPressed: () {
          controller.toggleSelectedAttribute(Attribute.unchecked);
          afterPressed?.call();
        },
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
    return SelectHeaderStyleButton(
      tooltip: "Header Style",
      controller: controller.quillController,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
    );
  }
}

class WEFontSizeButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;
  final Function(dynamic)? onSelected;

  const WEFontSizeButton(
      {super.key,
      required this.controller,
      this.iconSize,
      this.iconTheme,
      this.onSelected,
      this.afterPressed});

  @override
  Widget build(BuildContext context) {
    return QuillFontSizeButton(
      controller: controller.quillController,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
      tooltip: "Font Size",
      attribute: Attribute.size,
      onSelected: onSelected,
      rawItemsMap: const {
        'Small': 'small',
        'Large': 'large',
        'Huge': 'huge',
        'Clear': '0'
      },
      afterButtonPressed: afterPressed,
    );
  }
}

class WEFontColorButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;
  final bool forBackground;

  const WEFontColorButton(
      {super.key,
      required this.controller,
      this.iconSize,
      this.iconTheme,
      required this.forBackground,
      this.afterPressed});

  @override
  Widget build(BuildContext context) {
    return ColorButton(
      controller: controller.quillController,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
      tooltip: forBackground ? "Background Color" : "Text Color",
      background: forBackground,
      afterButtonPressed: afterPressed,
      icon: Icons.color_lens,
    );
  }
}

class WEIndentButton extends StatelessWidget {
  final WEquilEditorController controller;
  final double? iconSize;
  final QuillIconTheme? iconTheme;
  final Function()? afterPressed;
  final bool increase;

  const WEIndentButton(
      {super.key,
      required this.controller,
      this.iconSize,
      this.iconTheme,
      required this.increase,
      this.afterPressed});

  @override
  Widget build(BuildContext context) {
    return IndentButton(
      controller: controller.quillController,
      iconSize: iconSize ?? controller.theme.iconSize,
      iconTheme: iconTheme ?? controller.theme.iconTheme,
      tooltip: "${increase ? "Increase" : "Decrease"} Indent",
      isIncrease: increase,
      icon: increase
          ? Icons.format_indent_increase_outlined
          : Icons.format_indent_decrease_rounded,
      afterButtonPressed: afterPressed,
    );
  }
}
