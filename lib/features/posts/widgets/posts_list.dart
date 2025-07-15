import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:async';

class PostList extends ConsumerStatefulWidget {
  const PostList({super.key});

  @override
  ConsumerState<PostList> createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  List<PostModel>? _stablePosts;
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollEndTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_isScrolling) {
      setState(() {
        _isScrolling = true;
      });
    }

    _scrollEndTimer?.cancel();
    _scrollEndTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isScrolling = false;
          _stablePosts = null;
        });
      }
    });
  }

  Future<void> _refreshPosts() async {
    ref.invalidate(getPostProvider);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return _KeepAliveWrapper(
      child: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ref
            .watch(getPostProvider)
            .when(
              data: (posts) {
                return ref
                    .watch(getLatestPostProvider)
                    .when(
                      data: (data) {
                        if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.postCollectionID}.documents.*.create',
                        )) {
                          posts.insert(0, PostModel.fromMap(data.payload));
                        }

                        // Use stable list during scrolling to prevent reordering
                        List<PostModel> displayPosts;
                        if (_isScrolling && _stablePosts != null) {
                          // During scrolling, maintain order but update post data
                          displayPosts = _stablePosts!.map((stablePost) {
                            final updatedPost = posts.firstWhere(
                              (p) => p.id == stablePost.id,
                              orElse: () => stablePost,
                            );
                            return updatedPost;
                          }).toList();
                        } else {
                          // Not scrolling, use new list and save as stable
                          displayPosts = posts;
                          _stablePosts = List.from(posts);
                        }

                        return AnimationLimiter(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 10),
                            physics: const BouncingScrollPhysics(),
                            cacheExtent: 1000.0, // Increased cache extent
                            addAutomaticKeepAlives: true, // Keep widgets alive
                            addRepaintBoundaries:
                                true, // Add repaint boundaries
                            itemCount: displayPosts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final post = displayPosts[index];
                              if (post.pod == 'comment') {
                                return const SizedBox();
                              }
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 100),
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
                        );
                      },
                      error: (error, StackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => AnimationLimiter(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 10),
                          physics: const BouncingScrollPhysics(),
                          cacheExtent: 1000.0, // Increased cache extent
                          addAutomaticKeepAlives: true, // Keep widgets alive
                          addRepaintBoundaries: true, // Add repaint boundaries
                          itemCount: posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = posts[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 100),
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
              error: (err, st) {
                return ErrorText(error: err.toString());
              },
              loading: () {
                return const Loader();
              },
            ),
      ),
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
