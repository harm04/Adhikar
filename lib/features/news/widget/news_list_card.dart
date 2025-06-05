import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsListCard extends ConsumerStatefulWidget {
  final dynamic item;
  const NewsListCard({super.key, required this.item});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsListCardState();
}

class _NewsListCardState extends ConsumerState<NewsListCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          widget.item['title'] ?? 'No title',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              widget.item['source'] ?? 'Unknown Source',
              style: TextStyle(fontSize: 16, color: Pallete.greyColor),
            ),
            SizedBox(width: 10),

            Text(
              widget.item['published_at'] != null
                  ? timeago.format(
                      DateTime.parse(widget.item['published_at']).toLocal(),
                    )
                  : '',
              style: TextStyle(fontSize: 16, color: Pallete.greyColor),
            ),
          ],
        ),
        SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.item['image'] != null
              ? Image.network(
                  widget.item['image'],

                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                )
              : Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
        ),
        SizedBox(height: 10),
        Text(
          widget.item['description'] ?? 'No description',
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        Divider(),
      ],
    );
  }
}
