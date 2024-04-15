import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/state/state.dart';
import 'package:flutter_quill/src/widgets/others/link.dart';

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

  static clearFormattingForSelection(WEquilEditorController controller) {
    final attrs = <Attribute>{};
    for (final style in controller.quillController.getAllSelectionStyles()) {
      for (final attr in style.attributes.values) {
        attrs.add(attr);
      }
    }
    for (final attr in attrs) {
      controller.quillController.formatSelection(Attribute.clone(attr, null));
    }
  }

  static addTextElementToEditor(
      WEquilEditorController controller, String text) {
    if (text.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(index, length, text, null);

      controller.quillController.moveCursorToPosition(index + text.length);
    }
  }

  static addHyperLinkToEditor(
      {required LinkTextData value,
      required WEquilEditorController controller,
      required TextSelection selection,
      required Style selectionStyle}) {
    var index = selection.start;
    var length = selection.end - index;
    if (selectionStyle.attributes[Attribute.link.key]?.value != null) {
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

  static addVideoEmbedToEditor(
      WEquilEditorController controller, WECustomVideoEmbedData embedData) {
    if (embedData.url.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(
          index,
          length,
          BlockEmbed.custom(
              WEVideoEmbedBlockEmbed(jsonEncode(embedData.toMap()))),
          null);
      controller.quillController.moveCursorToPosition(index + 1);
      addTextElementToEditor(controller, "\n");
    }
  }

  static modifyEmbed(
      {required WEquilEditorController controller,
      required WECustomVideoEmbedData updatedData}) {
    List<dynamic> deltas =
        controller.quillController.document.toDelta().toJson();

    int index = deltas.indexWhere((element) {
      if (element['insert'] is Map) {
        Map<String, dynamic> data = element['insert'];
        if (data.containsKey("custom")) {
          String value = data['custom'];
          if (value.contains(updatedData.id)) {
            return true;
          }
        }
      }
      return false;
    });
    if (index != -1) {
      deltas[index] = {
        "insert": {
          "custom": BlockEmbed.custom(
                  WEVideoEmbedBlockEmbed(jsonEncode(updatedData.toMap())))
              .data
        }
      };

      int cursorPosition = controller.quillController.selection.baseOffset;

      controller.quillController.clear();

      controller.quillController.document
          .compose(Document.fromJson(deltas).toDelta(), ChangeSource.local);
      controller.quillController.moveCursorToPosition(cursorPosition);
    }
    // controller.quillController.queryNode(offset)
  }

  static modifyAttachment(
      {required WEquilEditorController controller,
      required WECustomAttachmentData updatedData}) {
    List<dynamic> deltas =
        controller.quillController.document.toDelta().toJson();

    int index = deltas.indexWhere((element) {
      if (element['insert'] is Map) {
        Map<String, dynamic> data = element['insert'];
        if (data.containsKey("custom")) {
          String value = data['custom'];
          if (value.contains(updatedData.id)) {
            return true;
          }
        }
      }
      return false;
    });
    if (index != -1) {
      deltas[index] = {
        "insert": {
          "custom": BlockEmbed.custom(
                  WEAttachmentBlockEmbed(jsonEncode(updatedData.toMap())))
              .data
        }
      };

      int cursorPosition = controller.quillController.selection.start;

      controller.quillController.clear();

      controller.quillController.document
          .compose(Document.fromJson(deltas).toDelta(), ChangeSource.local);
      controller.quillController.moveCursorToPosition(cursorPosition);
    }
    // controller.quillController.queryNode(offset)
  }

  static addAttachmentToEditor(
      WEquilEditorController controller, WECustomAttachmentData embedData) {
    if (embedData.url.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(
          index,
          length,
          BlockEmbed.custom(
              WEAttachmentBlockEmbed(jsonEncode(embedData.toMap()))),
          null);
      controller.quillController.moveCursorToPosition(index + 1);
      addTextElementToEditor(controller, "\n");
    }
  }
}
