import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostList extends ConsumerStatefulWidget {
  const PostList({super.key});

  @override
  ConsumerState<PostList> createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
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
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = posts[index];
                            return post.pod == 'comment'
                                ? const SizedBox()
                                : PostCard(postmodel: post);
                          },
                        );
                      },
                      error: (error, StackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
                          return PostCard(postmodel: post);
                        },
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
