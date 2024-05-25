import 'dart:convert';
import 'dart:math';

import 'package:flutter_quill/quill_delta.dart';
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
}
