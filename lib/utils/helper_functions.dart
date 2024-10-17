import 'dart:convert';
import 'dart:math';
import 'package:wequil_editor/core/core.dart';

class WEEditorHelperFunctions {
  static bool _isValidId(String id) =>
      RegExp(r'^[_\-a-zA-Z0-9]{11}$').hasMatch(id);

  static String? getYoutubeVideoIdFromUrl(String url) {
    const hosts = ['youtube.com', 'www.youtube.com', 'm.youtube.com'];
    if (url.contains(' ')) {
      return null;
    }

    late final Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return null;
    }

    if (!['https', 'http'].contains(uri.scheme)) {
      return null;
    }

    // youtube.com/watch?v=xxxxxxxxxxx
    if (hosts.contains(uri.host) &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'watch' &&
        uri.queryParameters.containsKey('v')) {
      final videoId = uri.queryParameters['v']!;
      return _isValidId(videoId) ? videoId : null;
    }

    // For Live
    if (hosts.contains(uri.host) && uri.path.contains('live')) {
      final videoID = uri.pathSegments.last;
      return _isValidId(videoID) ? videoID : null;
    }

    // For Shorts
    if (hosts.contains(uri.host) && uri.path.contains('shorts')) {
      final videoID = uri.pathSegments.last;
      return _isValidId(videoID) ? videoID : null;
    }

    // youtu.be/xxxxxxxxxxx
    if (uri.host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
      final videoId = uri.pathSegments.first;
      return _isValidId(videoId) ? videoId : null;
    }

    return null;
  }

  static String? getThumbnailURLFromYoutubeUrl(String url) {
    String? videoID = getYoutubeVideoIdFromUrl(url);
    if (videoID != null) {
      return "https://img.youtube.com/vi/$videoID/0.jpg";
    }
    return null;
  }

  static bool isEmptyContent(List<dynamic> content) {
    String totalContent = "";
    for (int x = 0; x < content.length; x++) {
      Map<String, dynamic> element = content[x];
      if (element['insert'] is String) {
        String stringContent = element['insert'] ?? "";
        totalContent += stringContent.trim();
      } else {
        return false;
      }
    }
    return totalContent.trim().isEmpty;
  }

  static WEquilEditorContentPreview getPreviewVersionOfContent(
      List<dynamic> content,
      {int charLimit = 200,
      int mediaLimit = 1}) {
    String totalContent = "";
    final List<dynamic> previewContent = [];

    bool original = true;
    int closingIndex = 0;
    bool nAdded = false;
    for (int x = 0; x < content.length; x++) {
      bool isLast = content.length - 1 == x;
      ++closingIndex;
      Map<String, dynamic> element = Map.from(content[x]);
      if (element['insert'] is String) {
        final String stringContent = (element['insert'] ?? "").trim();
        if (stringContent.isEmpty && !element.containsKey("attributes")) {
          continue;
        }
        final String potentialString = totalContent + stringContent;
        if (potentialString.length > charLimit) {
          int remainigLimit = potentialString.length - charLimit;
          element['insert'] =
              "${stringContent.substring(0, min((stringContent.length - remainigLimit).clamp(0, stringContent.length), stringContent.length))}...\n";
          previewContent.add(element);
          original = false;
          nAdded = true;
          break;
        } else {
          totalContent += stringContent;
          if (isLast) {
            if (!stringContent.endsWith("\n")) {
              element['insert'] = "$stringContent\n";
              nAdded = true;
            }
          }
          previewContent.add(element);
        }
      } else {
        previewContent.add(element);
        previewContent.add({"insert": " \n"});
        nAdded = true;
        break;
      }
    }
    if (!nAdded) {
      previewContent.add({"insert": " \n"});
    }

    return WEquilEditorContentPreview(
        content: previewContent,
        isOriginal: closingIndex >= content.length && original);
  }

  static String convertToText(List<dynamic> articleContent) {
    StringBuffer buffer = StringBuffer();

    for (var element in articleContent) {
      // Extract the text content
      if (element.containsKey('insert')) {
        var insertContent = element['insert'];

        // Handle text with attributes (e.g., bold, italic, underline)
        if (insertContent is String) {
          var text = insertContent;
          var attributes = element['attributes'] ?? {};

          // Apply formatting based on attributes
          if (attributes.containsKey('bold')) {
            text = '**$text**'; // Bold
          }
          if (attributes.containsKey('italic')) {
            text = '*$text*'; // Italic
          }
          if (attributes.containsKey('underline')) {
            text = '_${text}_'; // Underline
          }
          if (attributes.containsKey('strike')) {
            text = '~~$text~~'; // Strike-through
          }
          if (attributes.containsKey('code')) {
            text = '`$text`'; // Code
          }
          if (attributes.containsKey('link')) {
            text = '[${text}](${attributes['link']})'; // Hyperlink
          }

          // Handle alignment (if any)
          if (attributes.containsKey('align')) {
            var align = attributes['align'];
            text = '[$align] $text'; // Add alignment metadata
          }

          // Handle headers
          if (attributes.containsKey('header')) {
            var headerLevel = attributes['header'];
            text = '${'#' * headerLevel} $text'; // Markdown style headers
          }

          // Handle list items
          if (attributes.containsKey('list')) {
            var listType = attributes['list'];
            if (listType == 'ordered') {
              text = '1. $text'; // Numbered list item
            } else if (listType == 'bullet') {
              text = '- $text'; // Bullet point
            } else if (listType == 'unchecked') {
              text = '- [ ] $text'; // Checklist unchecked
            } else if (listType == 'checked') {
              text = '- [x] $text'; // Checklist checked
            }
          }

          buffer.writeln(text);
        }

        // Handle custom embedded content (like images, videos)
        else if (insertContent is Map && insertContent.containsKey('custom')) {
          var customContent = insertContent['custom'];

          customContent = jsonDecode(customContent);
          // Handle image attachments
          if (customContent.containsKey('we_attachment')) {
            var attachment = customContent['we_attachment'];
            attachment = jsonDecode(attachment);
            var attachmentData = attachment['url'];
            var caption = attachment['caption'];
            buffer.writeln(
                '[Attachment]\nURL:$attachmentData\nCaption:$caption\n');
          }

          // Handle video embeds
          if (customContent.containsKey('we_video_embed')) {
            var videoEmbed = customContent['we_video_embed'];
            videoEmbed = jsonDecode(videoEmbed);
            var videoUrl = videoEmbed['url'];
            var embedSource = videoEmbed['embedSource'];
            var caption = videoEmbed['caption'];
            buffer.writeln(
                '[Video Embedding]\nURL:$videoUrl\nCaption:$caption\nSource:$embedSource\n');
          }
        }
      }
    }

    return buffer.toString();
  }
}
