class WEquilEditorContentPreview {
  final List<dynamic> content;
  final bool isOriginal;

  const WEquilEditorContentPreview({
    required this.content,
    required this.isOriginal,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isOriginal': isOriginal,
    };
  }

  factory WEquilEditorContentPreview.fromMap(Map<String, dynamic> map) {
    return WEquilEditorContentPreview(
      content: List<dynamic>.from(map['content']),
      isOriginal: map['isOriginal'] as bool,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WEquilEditorContentPreview &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          isOriginal == other.isOriginal;

  @override
  int get hashCode => content.hashCode ^ isOriginal.hashCode;
}