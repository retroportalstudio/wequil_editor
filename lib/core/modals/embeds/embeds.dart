import 'package:flutter_quill/flutter_quill.dart';

class SpellCheckBlockEmbed extends BlockEmbed{
  const SpellCheckBlockEmbed(String value) : super(customType, value);
  static const String customType = "we_attachment";
}

class WEAttachmentBlockEmbed extends CustomBlockEmbed {
  const WEAttachmentBlockEmbed(String value) : super(customType, value);
  static const String customType = "we_attachment";
}

class WEVideoEmbedBlockEmbed extends CustomBlockEmbed {
  const WEVideoEmbedBlockEmbed(String value) : super(customType, value);
  static const String customType = "we_video_embed";
}
