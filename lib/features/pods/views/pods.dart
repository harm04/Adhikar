import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PodsView extends ConsumerStatefulWidget {
  final String podimage;
  final String podTitle;
  final String podDescription;
  final String podBanner;
  const PodsView(
      {super.key,
      required this.podimage,
      required this.podTitle,
      required this.podDescription,
      required this.podBanner});

  @override
  ConsumerState<PodsView> createState() => _PodsViewState();
}

class _PodsViewState extends ConsumerState<PodsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(widget.podBanner, fit: BoxFit.cover),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(1),
                              spreadRadius: 100,
                              blurRadius: 100,
                              blurStyle: BlurStyle.normal)
                        ]),
                      )),
                  Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundImage: AssetImage(
                                  widget.podimage,
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: Text(
                                  widget.podTitle,
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.whiteColor),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(widget.podDescription,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: 
                                 Pallete.greyColor,fontWeight: FontWeight.bold
                                )),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                ref.watch(getPodsPostProvider(widget.podTitle)).when(
                    data: (pod) {
                      return pod.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                  child: Text(
                                "No posts available in ${widget.podTitle}",
                                style: TextStyle(fontSize: 18,color: Pallete.greyColor,fontWeight: FontWeight.bold),
                              )),
                            )
                          : Column(
                              children: pod
                                  .map((post) => Consumer(
                                        builder: (context, ref, _) {
                                          final postStream =
                                              ref.watch(postStreamProvider(post.id));
                                          return postStream.when(
                                            data: (livePost) =>
                                                PostCard(postmodel: livePost),
                                            loading: () => PostCard(postmodel: post),
                                            error: (e, st) => PostCard(postmodel: post),
                                          );
                                        },
                                      ))
                                  .toList(),
                            );
                    },
                    error: (error, st) => ErrorText(error: error.toString()),
                    loading: () => Loader()),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}