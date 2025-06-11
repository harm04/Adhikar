import 'package:adhikar/common/widgets/webview_page.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class News extends ConsumerStatefulWidget {
  final dynamic item;
  final List<dynamic> allNews; // Pass all news items to this screen

  const News({super.key, required this.item, required this.allNews});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsState();
}

class _NewsState extends ConsumerState<News> {
  @override
  Widget build(BuildContext context) {
    // Filter out the current news item
    final List<dynamic> otherNews = widget.allNews
        .where((news) => news['url'] != widget.item['url'])
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
                  widget.item['image'] == null
                      ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
                      : Image.network(widget.item['image'], fit: BoxFit.cover),
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
                      widget.item['title'] ?? 'No title',
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
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Text(
                            widget.item['source'] ?? 'Unknown Source',
                            style: TextStyle(
                              fontSize: 16,
                              color: Pallete.greyColor,
                            ),
                          ),
                          SizedBox(width: 10),

                          Text(
                            widget.item['published_at'] != null
                                ? timeago.format(
                                    DateTime.parse(
                                      widget.item['published_at'],
                                    ).toLocal(),
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
                    GestureDetector(
                      onTap: () {
                        //navigate to the source URL
                        if (widget.item['url'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                url: widget.item['url'],
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
                    widget.item['description'] ?? 'No description',
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherNews.length,
                  itemBuilder: (context, index) {
                    final news = otherNews[index];
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
                                      '${news['source'] ?? 'Unknown Source'} ·  ${news['published_at'] != null ? timeago.format(DateTime.parse(news['published_at']).toLocal()) : ''}',

                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Pallete.greyColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      news['title'] ?? 'No title',
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
                              const SizedBox(width: 12),
                              // Image at right
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: news['image'] != null
                                      ? Image.network(
                                          news['image'],
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
