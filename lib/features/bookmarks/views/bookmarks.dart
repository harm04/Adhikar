import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/showcase/widgets/showcase_list_card.dart';

class BookmarksScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(bookmarkedPostsProvider);
    final showcasesAsync = ref.watch(bookmarkedShowcasesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
          centerTitle: true,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: context.secondaryColor,
            labelColor: context.secondaryColor,
            unselectedLabelColor: context.textSecondaryColor,
            labelStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Showcases'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Posts Tab
            postsAsync.when(
              data: (posts) => posts.isEmpty
                  ? Center(
                      child: Text(
                        'No bookmarked posts',
                        style: TextStyle(
                          color: context.textSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 15),
                      itemCount: posts.length,
                      itemBuilder: (context, index) =>
                          PostCard(postmodel: posts[index]),
                    ),
              loading: () => Loader(),
              error: (e, st) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: context.errorColor),
                ),
              ),
            ),
            // Showcases Tab
            showcasesAsync.when(
              data: (showcases) => showcases.isEmpty
                  ? Center(
                      child: Text(
                        'No bookmarked showcases',
                        style: TextStyle(
                          color: context.textSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 15),
                      itemCount: showcases.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: ShowcaseListCard(showcase: showcases[index]),
                      ),
                    ),
              loading: () => Loader(),
              error: (e, st) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: context.errorColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
