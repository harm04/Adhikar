class PostDisplayHelper {
  /// Reconstructs display text from clean text, hashtags, and link
  static String getDisplayText(
    String cleanText,
    List<String> hashtags,
    String link,
  ) {
    String displayText = cleanText;

    // Add hashtags at the end
    if (hashtags.isNotEmpty) {
      displayText += ' ${hashtags.join(' ')}';
    }

    // Add link at the end if it exists
    if (link.isNotEmpty) {
      displayText += ' $link';
    }

    return displayText.trim();
  }

  /// Alternative: Get display text with hashtags and links in their original positions
  /// This would require more complex logic to remember original positions
  static String getFormattedDisplayText(
    String cleanText,
    List<String> hashtags,
    String link,
  ) {
    String displayText = cleanText;

    // For now, simply append hashtags and link
    // In a more sophisticated implementation, you could store position information
    if (hashtags.isNotEmpty) {
      displayText += '\n\n${hashtags.join(' ')}';
    }

    return displayText.trim();
  }
}
