import 'package:flutter_quill/flutter_quill.dart';

class WETheme {
  final QuillIconTheme iconTheme;
  final double iconSize;

  const WETheme({
    required this.iconTheme,
    required this.iconSize,
  });

  WETheme copyWith({
    QuillIconTheme? iconTheme,
    double? iconSize,
  }) {
    return WETheme(
      iconTheme: iconTheme ?? this.iconTheme,
      iconSize: iconSize ?? this.iconSize,
    );
  }
}