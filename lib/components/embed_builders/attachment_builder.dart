import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/state/state.dart';

class DefaultWEAttachmentEmbedBuilder extends quill.EmbedBuilder {
  final Widget Function(WECustomAttachmentData embedData, quill.Embed node,
      bool readOnly, bool inline, TextStyle textStyle)? embedBuilder;

  DefaultWEAttachmentEmbedBuilder({this.embedBuilder});

  @override
  String get key => WEAttachmentBlockEmbed.customType;

  @override
  Widget build(BuildContext context, quill.QuillController controller,
      quill.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    try {
      if (node.value.type == key) {
        final WECustomAttachmentData data = WECustomAttachmentData.fromMap(
            jsonDecode(node.value.data as String));
        return embedBuilder?.call(data, node, readOnly, inline, textStyle) ??
            Builder(builder: (context) {
              if (data.isImage) {
                return _DefaultImageBuilder(data: data);
              } else if (data.isVideo) {
                return _DefaultVideoBuilder(data: data);
              } else if (data.isDocument) {
                return _DefaultDocumentBuilder(data: data);
              } else if (data.isAudio) {
                return _DefaultAudioBuilder(data: data);
              } else {
                return _DefaultOtherBuilder(data: data);
              }
            });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return Container();
  }
}

class _DefaultImageBuilder extends StatelessWidget {
  final WECustomAttachmentData data;

  const _DefaultImageBuilder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(data.url),
    );
  }
}

class _DefaultVideoBuilder extends StatelessWidget {
  final WECustomAttachmentData data;

  const _DefaultVideoBuilder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Center(
        child: Image.network(data.url),
      ),
    );
  }
}

class _DefaultDocumentBuilder extends StatelessWidget {
  final WECustomAttachmentData data;

  const _DefaultDocumentBuilder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Center(
        child: Text("Document File ${data.extension.toUpperCase()}"),
      ),
    );
  }
}

class _DefaultAudioBuilder extends StatelessWidget {
  final WECustomAttachmentData data;

  const _DefaultAudioBuilder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Center(
        child: Text("Audio File ${data.extension.toUpperCase()}"),
      ),
    );
  }
}

class _DefaultOtherBuilder extends StatelessWidget {
  final WECustomAttachmentData data;

  const _DefaultOtherBuilder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Center(
        child: Text("Unsupported File ${data.extension.toUpperCase()}"),
      ),
    );
  }
}
