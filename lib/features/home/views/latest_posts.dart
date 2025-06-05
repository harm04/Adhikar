import 'package:adhikar/apis/posts_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';

class LatestPosts extends ConsumerWidget {
  const LatestPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestAsync = ref.watch(latestPostsProvider);

    Future<void> _refresh() async {
      ref.invalidate(latestPostsProvider);
    }

    return latestAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No latest posts found'));
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

// Provider for latest posts (sort by createdAt descending)
final latestPostsProvider = StreamProvider<List<PostModel>>((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getAllPostsStream().map(
    (posts) =>
        posts.where((post) => post.pod != 'comment').toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
  );
});
