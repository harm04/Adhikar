import 'package:flutter/material.dart';
import 'package:adhikar/theme/pallete_theme.dart';

class ExpandableHashtags extends StatefulWidget {
  final String text;
  final List<String> hashtags;

  const ExpandableHashtags({
    super.key,
    required this.text,
    this.hashtags = const [],
  });

  @override
  State<ExpandableHashtags> createState() => _ExpandableHashtagsState();
}

class _ExpandableHashtagsState extends State<ExpandableHashtags> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: widget.text,
          style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: 18,
            height: 1.4, // Line spacing
          ),
        );

        final tp = TextPainter(
          text: span,
          maxLines: 8,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);
        final doesOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clean text without links and hashtags
            Text(
              widget.text,
              style: TextStyle(
                
                fontSize: 18,
                height: 1.4, // Proper line spacing
              ),
              maxLines: expanded ? null : 8,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),

            if (!expanded && doesOverflow)
              GestureDetector(
                onTap: () => setState(() => expanded = true),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    ' ...show more',
                    style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Hashtags section
            if (widget.hashtags.isNotEmpty) ...[
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.hashtags.map((hashtag) {
                  return Text(
                    hashtag,
                    style: TextStyle(
                      color: Pallete.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
