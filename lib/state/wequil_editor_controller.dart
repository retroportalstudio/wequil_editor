import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wequil_editor/core/core.dart';
import 'package:wequil_editor/core/modals/embed_data/we_custom_embed_data.dart';
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

  ValueNotifier<Set<Attribute>> _selectedAttributes =
      ValueNotifier<Set<Attribute>>({});

  bool _hasChanged = false;

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

  bool get isEmpty => quillController.document.isEmpty();

  bool get hasChanged => _hasChanged;

  List<dynamic> get delta => quillController.document.toDelta().toJson();

  Map<String, dynamic> get content => {"delta": delta};

  setContent(Map<String, dynamic>? content) {
    if (content != null && content['delta'] != null) {
      quillController.compose(
        Document.fromJson(content['delta']).toDelta(),
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

  addAttachmentToEditor(WECustomEmbedData data) {
    WequilEditorFunctions.addAttachmentToEditor(this, data);
  }


  @override
  void dispose() {
    _quillController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
