import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/common/widgets/check_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FollowingPosts extends ConsumerWidget {
  const FollowingPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) return Loader();

    final followingAsync = ref.watch(
      followingPostsProvider(currentUser.following),
    );

    Future<void> _refresh() async {
      ref.invalidate(followingPostsProvider(currentUser.following));
    }

    return CheckInternet(
      onTryAgain: _refresh,
      child: followingAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(child: Text('No posts from following users'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: AnimationLimiter(
              child: ListView.builder(
                primary:
                    true, // Use primary scroll controller for NestedScrollView
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10.0),
                cacheExtent: 1000.0, // Increased cache for smooth scrolling
                addAutomaticKeepAlives: true, // Keep widgets alive
                addRepaintBoundaries: true, // Add repaint boundaries
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(
                      milliseconds: 100,
                    ), // Reduced for smoother scroll
                    child: SlideAnimation(
                      verticalOffset: 5.0, // Reduced offset
                      child: FadeInAnimation(
                        child: RepaintBoundary(
                          key: ValueKey(post.id),
                          child: PostCard(postmodel: post),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => Loader(),
        error: (err, st) => ErrorText(error: err.toString()),
      ),
    );
  }
}

// Provider for following posts
final followingPostsProvider =
    StreamProvider.family<List<PostModel>, List<String>>((ref, followingUids) {
      final postAPI = ref.watch(postAPIProvider);
      return postAPI.getAllPostsStream().map(
        (posts) => posts
            .where(
              (post) =>
                  followingUids.contains(post.uid) &&
                  post.isAnonymous == false &&
                  post.pod != 'comment',
            )
            .toList(),
      );
    });
