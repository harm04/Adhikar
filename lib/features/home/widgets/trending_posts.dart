import 'package:adhikar/apis/posts_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/common/widgets/check_internet.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:async';

class TrendingPosts extends ConsumerStatefulWidget {
  const TrendingPosts({super.key});

  @override
  ConsumerState<TrendingPosts> createState() => _TrendingPostsState();
}

class _TrendingPostsState extends ConsumerState<TrendingPosts> {
  bool _isScrolling = false;
  List<PostModel>? _stablePostList;
  Timer? _scrollEndTimer;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    // Listen to the primary scroll controller when available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollController = PrimaryScrollController.of(context);
        _scrollController?.addListener(_onScroll);
      }
    });
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _scrollEndTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_isScrolling) {
      setState(() {
        _isScrolling = true;
      });
    }

    // Cancel previous timer
    _scrollEndTimer?.cancel();

    // Set new timer to detect scroll end
    _scrollEndTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isScrolling = false;
          _stablePostList = null; // Allow reordering after scroll ends
        });
      }
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(trendingPostsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final trendingAsync = ref.watch(trendingPostsProvider);

    return CheckInternet(
      onTryAgain: _refresh,
      child: trendingAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No trending posts found'));
          }

          // Use stable list during scrolling to prevent reordering
          List<PostModel> displayPosts;
          if (_isScrolling && _stablePostList != null) {
            // During scrolling, use the stable list but update individual post data
            displayPosts = _stablePostList!.map((stablePost) {
              // Find updated post data but maintain position
              final updatedPost = posts.firstWhere(
                (p) => p.id == stablePost.id,
                orElse: () => stablePost,
              );
              return updatedPost;
            }).toList();
          } else {
            // Not scrolling, use the new sorted list and save it as stable
            displayPosts = posts;
            _stablePostList = List.from(posts);
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: AnimationLimiter(
              child: ListView.builder(
                primary:
                    true, // Use primary scroll controller for NestedScrollView
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10.0),
                cacheExtent:
                    1000.0, // Increased cache extent for better image preloading
                addAutomaticKeepAlives:
                    true, // Keep widgets alive for smoother scrolling
                addRepaintBoundaries:
                    true, // Add repaint boundaries automatically
                itemCount: displayPosts.length,
                itemBuilder: (context, index) {
                  final post = displayPosts[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(
                      milliseconds: 100,
                    ), // Further reduced duration for smoother scroll
                    child: SlideAnimation(
                      verticalOffset: 5.0, // Further reduced offset
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
        loading: () => const Loader(),
        error: (err, st) => ErrorText(error: err.toString()),
      ),
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
