import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/core/modals/embed_data/we_custom_embed_data.dart';
import 'package:wequil_editor/state/state.dart';
import 'package:flutter_quill/src/widgets/link.dart';

class WequilEditorFunctions {
  static LinkTextData? extractHyperlinkFromSelection(
      WEquilEditorController controller) {
    final String? link = controller.quillController
        .getSelectionStyle()
        .attributes[Attribute.link.key]
        ?.value;
    final index = controller.quillController.selection.start;

    var text;
    if (link != null) {
      // text should be the link's corresponding text, not selection
      final leaf =
          controller.quillController.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        text = leaf.toPlainText();
      }
    }

    final len = controller.quillController.selection.end - index;
    text ??= len == 0
        ? ''
        : controller.quillController.document.getPlainText(index, len);
    return LinkTextData(text: text, link: link ?? '');
  }

  static addHyperLinkToEditor(
      {required LinkTextData value,
      required WEquilEditorController controller}) {
    var index = controller.quillController.selection.start;
    var length = controller.quillController.selection.end - index;
    if (controller.quillController
            .getSelectionStyle()
            .attributes[Attribute.link.key]
            ?.value !=
        null) {
      // text should be the link's corresponding text, not selection
      final leaf =
          controller.quillController.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        final range = getLinkRange(leaf);
        index = range.start;
        length = range.end - range.start;
      }
    }
    controller.quillController.replaceText(index, length, value.text, null);
    controller.quillController
        .formatText(index, value.text.length, LinkAttribute(value.link));
  }

  static addAttachmentToEditor(
      WEquilEditorController controller, WECustomEmbedData embedData) {
    if (embedData.url.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(
          index,
          length,
          BlockEmbed.custom(
              WEAttachmentBlockEmbed(jsonEncode(embedData.toMap()))),
          null);
    }
  }
}
