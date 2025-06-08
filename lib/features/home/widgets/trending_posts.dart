import 'package:adhikar/apis/posts_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';

class TrendingPosts extends ConsumerWidget {
  const TrendingPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingPostsProvider);

    Future<void> _refresh() async {
      ref.invalidate(trendingPostsProvider);
    }

    return trendingAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No trending posts found'));
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(postmodel: post);
            },
          ),
        );
      },
      loading: () => const Loader(),
      error: (err, st) => ErrorText(error: err.toString()),
    );
  }
}

// Provider for trending posts (sort by likes count)
final trendingPostsProvider = StreamProvider<List<PostModel>>((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getAllPostsStream().map(
    (posts) =>
        posts.where((post) => post.pod != 'comment').toList()
          ..sort((a, b) => b.likes.length.compareTo(a.likes.length)),
  );
});
