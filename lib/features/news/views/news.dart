import 'package:adhikar/common/widgets/webview_page.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class News extends ConsumerStatefulWidget {
  final dynamic item;
  final List<dynamic> allNews; // Pass all news items to this screen

  News({super.key, required this.item, required this.allNews});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsState();
}

class _NewsState extends ConsumerState<News> {
  @override
  Widget build(BuildContext context) {
    final thread = widget.item['thread'] ?? {};
    final title = thread['title'] ?? widget.item['title'] ?? 'No title';
    final image = thread['main_image'] ?? 'assets/images/logo.png';
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
    final url = thread['url'] ?? widget.item['url'];

    // Filter out the current news item
    final List<dynamic> otherNews = widget.allNews
        .where((news) => (news['url'] ?? news['thread']?['url']) != url)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  image == ''
                      ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
                      : Image.network(image, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            spreadRadius: 100,
                            blurRadius: 100,
                            blurStyle: BlurStyle.normal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
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
                            Flexible(
                              child: Text(
                                siteDomain,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Pallete.greyColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              publishedAt != null
                                  ? timeago.format(
                                      DateTime.parse(publishedAt).toLocal(),
                                    )
                                  : '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Pallete.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //navigate to the source URL
                        if (url != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                url: url,
                                appBarText: 'News Source',
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Pallete.secondaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22.0,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Read more',
                                  style: TextStyle(
                                    color: Pallete.backgroundColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SvgPicture.asset(
                                  'assets/svg/right_arrow.svg',
                                  height: 20,
                                  width: 20,
                                  color: Pallete.backgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Pallete.whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    'More like this',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0.0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: otherNews.length,
                  itemBuilder: (context, index) {
                    final news = otherNews[index];
                    final newsThread = news['thread'] ?? {};
                    final newsTitle =
                        newsThread['title'] ?? news['title'] ?? 'No title';
                    final newsImage = newsThread['main_image'] ?? news['image'];
                    final newsPublishedAt =
                        newsThread['published'] ?? news['published_at'];
                    final newsSource =
                        newsThread['site'] ??
                        news['source'] ??
                        'Unknown Source';

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              News(item: news, allNews: widget.allNews),
                        ),
                      ),
                      child: Card(
                        color: Pallete.backgroundColor,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$newsSource ·  ${newsPublishedAt != null ? timeago.format(DateTime.parse(newsPublishedAt).toLocal()) : ''}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Pallete.greyColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      newsTitle,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Pallete.whiteColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              // Image at right
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: newsImage != null
                                      ? Image.network(
                                          newsImage,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    'assets/images/logo.png',
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                        )
                                      : Image.asset(
                                          'assets/images/logo.png',
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
