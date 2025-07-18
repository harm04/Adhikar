import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsListCard extends ConsumerStatefulWidget {
  final dynamic item;
  NewsListCard({super.key, required this.item});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsListCardState();
}

class _NewsListCardState extends ConsumerState<NewsListCard> {
  @override
  Widget build(BuildContext context) {
    // Use thread if available, else fallback to top-level
    final thread = widget.item['thread'] ?? {};
    final title = thread['title'] ?? widget.item['title'] ?? 'No title';
    final image = thread['main_image'] ?? widget.item['image'];
    final publishedAt = thread['published'] ?? widget.item['published_at'];
    final siteDomain = thread['site'] ?? widget.item['source'] ?? '';

    // Favicon URL using Google S2 API
    final faviconUrl = siteDomain.isNotEmpty
        ? 'https://www.google.com/s2/favicons?sz=32&domain=$siteDomain'
        : null;

    final rawdDescription =
        widget.item['highlightText'] ??
        widget.item['highlightTitle'] ??
        'No description';
    final description = rawdDescription.replaceAll(RegExp(r'</?em>'), '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            if (faviconUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  faviconUrl,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) =>
                      SizedBox(width: 20),
                ),
              ),
            Text(
              siteDomain,
              style: TextStyle(fontSize: 16, color: Pallete.greyColor),
            ),
            SizedBox(width: 10),
            Text(
              publishedAt != null
                  ? timeago.format(DateTime.parse(publishedAt).toLocal())
                  : '',
              style: TextStyle(fontSize: 16, color: Pallete.greyColor),
            ),
          ],
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: image != null
              ? Image.network(
                  image,
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
          description,
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
