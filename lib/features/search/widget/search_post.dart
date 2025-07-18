import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/search/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPost extends ConsumerWidget {
  final String query;
  SearchPost({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(searchPostsProvider(query))
        .when(
          data: (posts) {
            // Filter out comments
            final mainPosts = posts
                .where((post) => post.pod != 'comment')
                .toList();
            if (mainPosts.isEmpty) {
              return Center(child: Text('No posts found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: mainPosts.length,
              itemBuilder: (context, index) {
                final post = mainPosts[index];
                return PostCard(postmodel: post);
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        );
  }
}
