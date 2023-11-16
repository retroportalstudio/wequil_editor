import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:wequil_editor/core/core.dart';

class SpellCheckBuilder extends quill.EmbedBuilder {
  @override
  Widget build(BuildContext context, quill.QuillController controller,
      quill.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    throw UnimplementedError();
  }

  @override
  // TODO: implement key
  String get key => throw UnimplementedError();
}
