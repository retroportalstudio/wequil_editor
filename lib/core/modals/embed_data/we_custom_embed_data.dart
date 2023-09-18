import 'package:wequil_editor/core/core.dart';

class WECustomEmbedData {
  static List<String> photoExtensions = [
    'jpg',
    'jpeg',
    'png',
    'JPG',
    'JPEG',
    'PNG',
    'gif',
    'GIF'
  ];
  static List<String> videoExtensions = ['mp4', 'MP4', 'mov', 'MOV'];
  static List<String> audioExtensions = [
    'mp3',
    'MP3',
    'aac',
    'AAC',
    'wav',
    'WAV',
    "webm",
    "WEBM"
  ];
  static List<String> documentExtensions = [
    'doc',
    'docx',
    'DOCX',
    'DOC',
    'pdf',
    'PDF',
    'xls',
    'xlsx',
    'csv',
    'XLS',
    'XLSX',
    'CSV'
  ];

  static List<String> otherExtensions = ['html', 'css', 'js'];

  final String id;
  final String url;
  final String extension;
  final WEImageAlignment alignment;
  final String? thumbnail;
  final double aspectRatio;
  final String? caption;

  const WECustomEmbedData({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.extension,
    this.aspectRatio = 16 / 9,
    required this.alignment,
    required this.caption,
  });

  bool get isImage => photoExtensions.contains(extension);

  bool get isVideo => videoExtensions.contains(extension);

  bool get isDocument => documentExtensions.contains(extension);

  bool get isAudio => audioExtensions.contains(extension);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WECustomEmbedData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          thumbnail == other.thumbnail &&
          extension == other.extension &&
          aspectRatio == other.aspectRatio &&
          alignment == other.alignment &&
          caption == other.caption;

  @override
  int get hashCode =>
      id.hashCode ^
      url.hashCode ^
      thumbnail.hashCode ^
      extension.hashCode ^
      aspectRatio.hashCode ^
      alignment.hashCode ^
      caption.hashCode;

  WECustomEmbedData copyWith({
    String? id,
    String? url,
    String? extension,
    double? aspectRatio,
    WEImageAlignment? alignment,
    String? caption,
  }) {
    return WECustomEmbedData(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      extension: extension ?? this.extension,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      alignment: alignment ?? this.alignment,
      caption: caption ?? this.caption,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'url': this.url,
      'thumbnail': this.thumbnail,
      'extension': this.extension,
      'aspectRatio': this.aspectRatio,
      'alignment': this.alignment.name,
      'caption': this.caption,
    };
  }

  factory WECustomEmbedData.fromMap(Map<String, dynamic> map) {
    return WECustomEmbedData(
      id: map['id'] as String,
      url: map['url'] as String,
      thumbnail: map['thumbnail'] as String?,
      extension: map['extension'] as String,
      aspectRatio: map['aspectRatio'] as double,
      alignment:
          WEImageAlignment.values.firstWhere((e) => e.name == map['alignment']),
      caption: map['caption'] as String?,
    );
  }
}
