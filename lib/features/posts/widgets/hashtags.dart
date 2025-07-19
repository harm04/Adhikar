import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class HashTags extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  const HashTags({super.key, required this.text, this.maxLines, this.overflow});

  Future<void> _launchUrl(String url) async {
    try {
      // Ensure URL has proper scheme
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final uri = Uri.parse(formattedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            // You can add gesture recognizer here for hashtag functionality
          ),
        );
      } else if (element.startsWith('https://') ||
          element.startsWith('http://') ||
          element.startsWith('www.')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(element),
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(color: Pallete.whiteColor, fontSize: 18),
          ),
        );
      }
    });
    return RichText(
      text: TextSpan(children: textspans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
