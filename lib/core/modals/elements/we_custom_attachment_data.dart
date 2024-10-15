import 'package:random_string/random_string.dart';
import 'package:wequil_editor/core/core.dart';

class WECustomAttachmentData {
  static List<String> photoExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'heic',
    'heif',
    'webp',
    'WEBP',
    'JPG',
    'JPEG',
    'PNG',
    'GIF',
    'HEIC',
    'HEIF'
  ];
  static List<String> videoExtensions = ['mp4', 'mov', 'MP4', 'MOV'];
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
  final String mediaID;
  final String url;
  final String extension;
  final WEImageAlignment alignment;
  final String? thumbnail;
  final double aspectRatio;
  final String? caption;
  final SizeMode sizeMode;
  final Map<String, dynamic> data;

  static String createID() {
    return "attachment_${randomAlphaNumeric(14)}";
  }

  const WECustomAttachmentData({required this.id,
    required this.mediaID,
    required this.url,
    this.thumbnail,
    required this.extension,
    this.aspectRatio = 16 / 9,
    required this.alignment,
    this.sizeMode = SizeMode.normal,
    this.caption,
    this.data = const {}});

  bool get isImage => photoExtensions.contains(extension);

  bool get isVideo => videoExtensions.contains(extension);

  bool get isPDF =>
      [ 'pdf',
        'PDF'].contains(extension);

  bool get isDocument => documentExtensions.contains(extension);

  bool get isAudio => audioExtensions.contains(extension);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WECustomAttachmentData &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              mediaID == other.mediaID &&
              url == other.url &&
              thumbnail == other.thumbnail &&
              extension == other.extension &&
              aspectRatio == other.aspectRatio &&
              alignment == other.alignment &&
              sizeMode == other.sizeMode &&
              data == other.data &&
              caption == other.caption;

  @override
  int get hashCode =>
      id.hashCode ^
      mediaID.hashCode ^
      url.hashCode ^
      thumbnail.hashCode ^
      extension.hashCode ^
      sizeMode.hashCode ^
      aspectRatio.hashCode ^
      alignment.hashCode ^
      data.hashCode ^
      caption.hashCode;

  WECustomAttachmentData clearCaption() {
    return WECustomAttachmentData(
      id: id,
      mediaID: mediaID,
      url: url,
      thumbnail: thumbnail,
      extension: extension,
      aspectRatio: aspectRatio,
      sizeMode: sizeMode,
      alignment: alignment,
      caption: null,
      data: data,
    );
  }

  WECustomAttachmentData copyWith({
    String? id,
    String? mediaID,
    String? url,
    String? extension,
    double? aspectRatio,
    SizeMode? sizeMode,
    WEImageAlignment? alignment,
    String? caption,
    Map<String, dynamic>? data,
  }) {
    return WECustomAttachmentData(
      id: id ?? this.id,
      mediaID: mediaID ?? this.mediaID,
      url: url ?? this.url,
      thumbnail: thumbnail ?? thumbnail,
      extension: extension ?? this.extension,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      sizeMode: sizeMode ?? this.sizeMode,
      alignment: alignment ?? this.alignment,
      caption: caption ?? this.caption,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mediaID': mediaID,
      'url': url,
      'thumbnail': thumbnail,
      'extension': extension,
      'sizeMode': sizeMode.name,
      'aspectRatio': aspectRatio,
      'alignment': alignment.name,
      'caption': caption,
      'data': data,
    };
  }

  factory WECustomAttachmentData.fromMap(Map<String, dynamic> map) {
    return WECustomAttachmentData(
        id: map['id'] as String,
        mediaID: map['mediaID'] as String,
        url: map['url'] as String,
        thumbnail: map['thumbnail'] as String?,
        extension: map['extension'] as String,
        aspectRatio: map['aspectRatio'] as double,
        sizeMode: SizeMode.values
            .firstWhere((element) => element.name == map['sizeMode']),
        alignment: WEImageAlignment.values
            .firstWhere((e) => e.name == map['alignment']),
        caption: map['caption'] as String?,
        data: map['data']);
  }
}
