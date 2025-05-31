import 'package:flutter/material.dart';
import 'hashtags.dart';
import 'package:adhikar/theme/pallete_theme.dart';

class ExpandableHashtags extends StatefulWidget {
  final String text;
  const ExpandableHashtags({super.key, required this.text});

  @override
  State<ExpandableHashtags> createState() => _ExpandableHashtagsState();
}

class _ExpandableHashtagsState extends State<ExpandableHashtags> {
  bool expanded = false;

  List<TextSpan> buildTextSpans(String text) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(TextSpan(
          text: '$element ',
          style: TextStyle(color: Pallete.blueColor, fontSize: 18),
        ));
      } else if (element.startsWith('https://') ||
          element.startsWith('http') ||
          element.startsWith('www')) {
        textspans.add(TextSpan(
          text: '$element ',
          style: TextStyle(color: Pallete.blueColor, fontSize: 18),
        ));
      } else {
        textspans.add(TextSpan(
          text: '$element ',
          style: TextStyle(color: Pallete.whiteColor, fontSize: 18),
        ));
      }
    });
    return textspans;
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = HashTags(
      text: widget.text,
      maxLines: expanded ? null : 8,
      overflow: expanded ? TextOverflow.visible : TextOverflow.clip,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(children: buildTextSpans(widget.text));
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
            textWidget,
            if (!expanded && doesOverflow)
              GestureDetector(
                onTap: () => setState(() => expanded = true),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    ' ...show more',
                    style: TextStyle(
                      color: Pallete.secondaryColor,fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}