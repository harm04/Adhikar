class TextParser {
  static final RegExp _urlRegex = RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    caseSensitive: false,
  );

  static final RegExp _hashtagRegex = RegExp(
    r'#[a-zA-Z0-9_]+',
    caseSensitive: false,
  );

  static final RegExp _wwwRegex = RegExp(
    r'www\.[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    caseSensitive: false,
  );

  /// Extracts the first link from text
  static String extractLink(String text) {
    // Extract URLs (http/https)
    final urlMatches = _urlRegex.allMatches(text);
    if (urlMatches.isNotEmpty) {
      final url = urlMatches.first.group(0);
      if (url != null) {
        return url;
      }
    }

    // Extract www URLs
    final wwwMatches = _wwwRegex.allMatches(text);
    if (wwwMatches.isNotEmpty) {
      final url = wwwMatches.first.group(0);
      if (url != null) {
        return 'https://$url';
      }
    }

    return '';
  }

  /// Extracts all hashtags from text
  static List<String> extractHashtags(String text) {
    List<String> hashtags = [];
    final hashtagMatches = _hashtagRegex.allMatches(text);

    for (final match in hashtagMatches) {
      final hashtag = match.group(0);
      if (hashtag != null && !hashtags.contains(hashtag)) {
        hashtags.add(hashtag);
      }
    }

    return hashtags;
  }

  /// Removes links and hashtags from text to get clean text
  static String getCleanText(String text) {
    String cleanText = text;

    // Remove URLs (replace with single space to avoid joining words)
    cleanText = cleanText.replaceAll(_urlRegex, ' ');
    cleanText = cleanText.replaceAll(_wwwRegex, ' ');

    // Remove hashtags (replace with single space to avoid joining words)
    cleanText = cleanText.replaceAll(_hashtagRegex, ' ');

    // Clean up extra spaces but preserve line breaks
    // Replace multiple spaces/tabs with single space, but keep line breaks
    cleanText = cleanText.replaceAll(
      RegExp(r'[ \t]+'),
      ' ',
    ); // Replace multiple spaces/tabs with single space
    cleanText = cleanText.replaceAll(
      RegExp(r' *\n *'),
      '\n',
    ); // Clean spaces around line breaks
    cleanText = cleanText.replaceAll(
      RegExp(r'\n+'),
      '\n\n',
    ); // Normalize multiple line breaks to double
    cleanText = cleanText.trim();

    return cleanText;
  }

  /// Formats a URL to ensure it has a proper scheme
  static String formatUrl(String url) {
    if (url.startsWith('www.')) {
      return 'https://$url';
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }
}
