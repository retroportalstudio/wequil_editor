import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/utils/editor_functions.dart';

const double _defaultIconSize = 20;
const QuillIconTheme _defaultIconTheme = QuillIconTheme(
    iconSelectedColor: Colors.white,
    iconUnselectedColor: Colors.black,
    iconSelectedFillColor: Colors.black,
    iconUnselectedFillColor: Colors.transparent);

class WEquilEditorController extends ChangeNotifier {
  final QuillController _quillController = QuillController.basic();
  final ScrollController _scrollController = ScrollController();

  WETheme _theme =
  const WETheme(iconTheme: _defaultIconTheme, iconSize: _defaultIconSize);

  final ValueNotifier<Set<Attribute>> _selectedAttributes =
  ValueNotifier<Set<Attribute>>({});

  bool _allowCursor = true;
  bool _hasChanged = false;
  ValueNotifier<double> fontSize = ValueNotifier<double>(12);

  WEquilEditorController() {
    quillController.addListener(() {
      _hasChanged = true;
    });
  }

  QuillController get quillController => _quillController;

  ScrollController get scrollController => _scrollController;

  WETheme get theme => _theme;

  ValueNotifier<Set<Attribute>> get selectedAttributesNotifier =>
      _selectedAttributes;

  Set<Attribute<dynamic>> get selectedAttributes => _selectedAttributes.value;

  bool get allowCursor => _allowCursor;

  bool get isEmpty => quillController.document.isEmpty();

  bool get hasChanged => _hasChanged;

  List<dynamic> get delta => quillController.document.toDelta().toJson();

  Map<String, dynamic> get content => {"delta": delta};

  setContent(Map<String, dynamic>? content) {
    if (content != null && content['delta'] != null) {
      Delta delta = Document.fromJson(content['delta']).toDelta();
      delta.trim();
      quillController.compose(
        delta,
        const TextSelection(baseOffset: 0, extentOffset: 0),
        ChangeSource.LOCAL,
      );
      notifyListeners();
    }
  }

  setIconTheme(QuillIconTheme theme) {
    _theme = _theme.copyWith(iconTheme: theme);
  }

  setIconSize(double newSize) {
    _theme = _theme.copyWith(iconSize: newSize);
  }

  toggleSelectedAttribute(Attribute attribute) {
    if (selectedAttributes.contains(attribute)) {
      _selectedAttributes.value.remove(attribute);
    } else {
      _selectedAttributes.value.add(attribute);
    }
    _selectedAttributes.notifyListeners();
  }

  setFontSize(double size) {
    fontSize.value = size;
    quillController.formatSelection(Attribute.fromKeyValue('size', size));
  }

  incrementFontSize() {
    fontSize.value += 1;
    quillController
        .formatSelection(Attribute.fromKeyValue('size', fontSize.value.ceil()));
  }

  decrementFontSize() {
    fontSize.value -= 1;
    quillController.formatSelection(
        Attribute.fromKeyValue('size', fontSize.value.floor()));
  }

  addVideoEmbedToEditor(WECustomVideoEmbedData data) {
    WequilEditorFunctions.addVideoEmbedToEditor(this, data);
  }

  modifyVideoEmbedInEditor(WECustomVideoEmbedData data) {
    WequilEditorFunctions.modifyEmbed(controller: this, updatedData: data);
  }

  addAttachmentToEditor(WECustomAttachmentData data) {
    WequilEditorFunctions.addAttachmentToEditor(this, data);
  }

  modifyEditorAttachment(WECustomAttachmentData data) {
    WequilEditorFunctions.modifyAttachment(controller: this, updatedData: data);
  }

  scrollToCursorPosition() {
    int cursorPosition = quillController.selection.end;
    quillController.moveCursorToPosition(cursorPosition);
  }

  disableCursor() {
    _allowCursor = false;
    notifyListeners();
  }

  enableCursor() {
    _allowCursor = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _quillController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
