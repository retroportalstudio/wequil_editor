import 'package:flutter_quill/flutter_quill.dart';

class WEAttachmentBlockEmbed extends CustomBlockEmbed {
  const WEAttachmentBlockEmbed(String value) : super(customType, value);
  static const String customType = "we_attachment";
}

// class WEVideoBlockEmbed extends CustomBlockEmbed {
//   const WEVideoBlockEmbed(String value) : super(customType, value);
//   static const String customType = "we_video";
// }
//
// class WEDocumentBlockEmbed extends CustomBlockEmbed {
//   const WEDocumentBlockEmbed(String value) : super(customType, value);
//   static const String customType = "we_document";
// }
