import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ref
        .watch(getPostProvider)
        .when(
          data: (posts) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10), 
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(postmodel: post);
              },
            );
          },
          error: (err, st) {
            return ErrorText(error: err.toString());
          },
          loading: () {
            return Loader();
          },
        );
  }
}
