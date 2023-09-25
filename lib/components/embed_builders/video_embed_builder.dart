import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:wequil_editor/components/components.dart';
import 'package:wequil_editor/core/core.dart';

class DefaultWEVideoEmbedBuilder extends quill.EmbedBuilder {
  final Widget Function(WECustomVideoEmbedData embedData, quill.Embed node,
      bool readOnly, bool inline, TextStyle textStyle)? embedBuilder;

  DefaultWEVideoEmbedBuilder({this.embedBuilder});

  @override
  String get key => WEVideoEmbedBlockEmbed.customType;

  @override
  Widget build(BuildContext context, quill.QuillController controller,
      quill.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    try {
      if (node.value.type == key) {
        final WECustomVideoEmbedData data = WECustomVideoEmbedData.fromMap(
            jsonDecode(node.value.data as String));
        return embedBuilder?.call(data, node, readOnly, inline, textStyle) ??
            SizeModeWrapper(
              sizeMode: data.sizeMode,
              builder: (BuildContext context, Size size) {
                return AspectRatio(
                  aspectRatio: data.aspectRatio,
                  child: Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                          child: Text("Video Embed Implementation"))),
                );
              },
            );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return Container();
  }
}
