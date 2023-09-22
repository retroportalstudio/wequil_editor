import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:wequil_editor/core/core.dart';

class WEAttachmentEmbedBuilder extends quill.EmbedBuilder {
  final Widget Function(WECustomEmbedData embedData, quill.Embed node,
      bool readOnly, bool inline, TextStyle textStyle)? embedBuilder;

  WEAttachmentEmbedBuilder({this.embedBuilder});

  @override
  String get key => WEAttachmentBlockEmbed.customType;

  @override
  Widget build(BuildContext context, quill.QuillController controller,
      quill.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    try {
      if (node.value.type == key) {
        final WECustomEmbedData data =
            WECustomEmbedData.fromMap(jsonDecode(node.value.data as String));
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
  final WECustomEmbedData data;

  const _DefaultImageBuilder({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(data.url),
    );
  }
}

class _DefaultVideoBuilder extends StatelessWidget {
  final WECustomEmbedData data;

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
  final WECustomEmbedData data;

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
  final WECustomEmbedData data;

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
  final WECustomEmbedData data;

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
