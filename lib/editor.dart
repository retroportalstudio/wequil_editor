import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:wequil_editor/components/components.dart';
import 'package:wequil_editor/core/modals/embed_data/we_custom_embed_data.dart';
import 'package:wequil_editor/state/wequil_editor_controller.dart';

class WequilEditor extends StatelessWidget {
  final WEquilEditorController controller;
  final FocusNode focusNode;
  final EdgeInsets? padding;
  final Function(String url) onLaunchUrl;
  final DefaultStyles customStyles;
  final Widget Function(WECustomEmbedData embedData)? attachmentEmbedBuilder;

  const WequilEditor(
      {super.key,
      this.padding,
      required this.focusNode,
      required this.onLaunchUrl,
      required this.customStyles,
      required this.controller,
      this.attachmentEmbedBuilder,});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WEquilEditorController>.value(
        value: controller,
        builder: (context, _) {
          final WEquilEditorController controller =
              context.watch<WEquilEditorController>();
          return QuillEditor(
            controller: controller.quillController,
            scrollController: controller.scrollController,
            scrollable: true,
            focusNode: focusNode,
            autoFocus: false,
            readOnly: false,
            placeholder: "Write your post here",
            expands: true,
            padding: padding ?? EdgeInsets.zero,
            onLaunchUrl: onLaunchUrl,
            customStyles: customStyles,
            embedBuilders: [
              WEAttachmentEmbedBuilder(embedBuilder: attachmentEmbedBuilder),
            ],
            // embedBuilder: quillEditingEmbedBuilder,
          );
        });
  }
}
