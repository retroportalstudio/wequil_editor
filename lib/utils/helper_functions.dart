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
}
