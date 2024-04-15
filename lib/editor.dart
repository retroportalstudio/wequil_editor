import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:wequil_editor/components/components.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/state/wequil_editor_controller.dart';

class WequilEditor extends StatelessWidget {
  static const List<dynamic> emptyContent = [
    {"insert": " \n"}
  ];

  final WEquilEditorController controller;
  final FocusNode focusNode;
  final EdgeInsets? padding;
  final bool autoFocus;
  final Function(String url) onLaunchUrl;
  final DefaultStyles customStyles;
  final bool readOnly, cursorEnabled;
  final Widget Function(WECustomAttachmentData embedData, Embed node, bool readOnly, bool inline, TextStyle textStyle)? attachmentEmbedBuilder;
  final Widget Function(WECustomVideoEmbedData embedData, Embed node, bool readOnly, bool inline, TextStyle textStyle)? videoEmbedBuilder;
  final List<dynamic> customEmbedBuilders;
  final String? hint;

  const WequilEditor({
    super.key,
    this.padding,
    required this.focusNode,
    required this.onLaunchUrl,
    required this.customStyles,
    required this.controller,
    this.autoFocus = true,
    this.attachmentEmbedBuilder,
    this.videoEmbedBuilder,
    this.readOnly = false,
    this.cursorEnabled = true,
    this.customEmbedBuilders = const [],
    this.hint = "Write your post here",
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WEquilEditorController>.value(
        value: controller,
        builder: (context, _) {
          final WEquilEditorController controller = context.watch<WEquilEditorController>();
          return QuillEditor(
            configurations: QuillEditorConfigurations(
              controller: controller.quillController,
              autoFocus: autoFocus,
              readOnly: readOnly || !controller.allowCursor,
              placeholder: hint,
              expands: true,
              showCursor: cursorEnabled && controller.allowCursor,
              padding: padding ?? EdgeInsets.zero,
              onLaunchUrl: onLaunchUrl,
              customStyles: customStyles,
              embedBuilders: [
                DefaultWEAttachmentEmbedBuilder(embedBuilder: attachmentEmbedBuilder),
                DefaultWEVideoEmbedBuilder(embedBuilder: videoEmbedBuilder),
                ...customEmbedBuilders
              ],
              scrollable: true,
            ),
            scrollController: controller.scrollController,
            focusNode: focusNode,
            // embedBuilder: quillEditingEmbedBuilder,
          );
        });
  }
}
