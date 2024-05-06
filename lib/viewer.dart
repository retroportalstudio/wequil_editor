import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wequil_editor/components/components.dart';
import 'package:wequil_editor/core/core.dart';

class WequilEditorPreview extends StatefulWidget {
  final EdgeInsets padding;
  final Function(String url) onLaunchUrl;
  final List<dynamic> delta;
  final TextStyle? textStyle;
  final bool expands;
  final Widget Function(WECustomAttachmentData embedData, Embed node,
      bool readOnly, bool inline, TextStyle textStyle)? attachmentEmbedBuilder;
  final Widget Function(WECustomVideoEmbedData embedData, Embed node,
      bool readOnly, bool inline, TextStyle textStyle)? videoEmbedBuilder;
  final List<dynamic> customEmbedBuilders;
  final DefaultStyles? customStyle;

  const WequilEditorPreview({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.onLaunchUrl,
    this.attachmentEmbedBuilder,
    this.videoEmbedBuilder,
    this.customEmbedBuilders = const [],
    required this.delta,
    this.textStyle,
    required this.expands,
    this.customStyle,
  });

  @override
  State<WequilEditorPreview> createState() => _WequilEditorPreviewState();
}

class _WequilEditorPreviewState extends State<WequilEditorPreview> {
  final _quillController = QuillController.basic();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant WequilEditorPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.delta, oldWidget.delta)) {
      updateDelta();
    }
  }

  void updateDelta() {
    final document = Document.fromJson(
      widget.delta,
    );

    _quillController.clear();

    _quillController.compose(
      document.toDelta(),
      const TextSelection(baseOffset: 0, extentOffset: 0),
      ChangeSource.local,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateDelta();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _quillController.readOnly = true;
    return QuillEditor(
      scrollController: _scrollController,

      focusNode: _focusNode,

      configurations: QuillEditorConfigurations(
        controller: _quillController,
        autoFocus: false,
        scrollable: true,
        padding: widget.padding,
        showCursor: false,
        onLaunchUrl: widget.onLaunchUrl,
        readOnly: true,
        expands: widget.expands,
        customStyles: widget.customStyle,
        embedBuilders: [
          DefaultWEAttachmentEmbedBuilder(
              embedBuilder: widget.attachmentEmbedBuilder),
          DefaultWEVideoEmbedBuilder(embedBuilder: widget.videoEmbedBuilder),
          ...widget.customEmbedBuilders
        ],
      ),
      // embedBuilder: quillEmbedBuilder,
    );
  }
}
