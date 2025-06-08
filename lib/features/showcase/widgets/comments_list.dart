import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/posts/widgets/hashtags.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsList extends ConsumerStatefulWidget {
  final ShowcaseModel showcaseModel;
  final UserModel currentUser;
  const CommentsList({
    super.key,
    required this.showcaseModel,
    required this.currentUser,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsListState();
}

class _CommentsListState extends ConsumerState<CommentsList> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getCommentsProvider(widget.showcaseModel))
        .when(
          data: (comments) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                final commentPost = comments[index];

                return ref
                    .watch(userDataProvider(commentPost.uid))
                    .when(
                      data: (user) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //profile image
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: user.profileImage == ''
                                      ? AssetImage(ImageTheme.defaultProfileImage)
                                      : NetworkImage(user.profileImage),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          //username
                                          Text(
                                            '${user.firstName} ${user.lastName}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          //time
                                          Text(
                                            ' . ${timeago.format(commentPost.createdAt, locale: 'en_short')}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Pallete.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      //bio
                                      Text(
                                        user.bio == ''
                                            ? 'Adhikar user'
                                            : '${user.bio}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //hashtags
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: HashTags(text: commentPost.title),
                                    ),
                                    LikeButton(
                                      size: 26,
                                      onTap: (isLiked) async {
                                        ref
                                            .read(
                                              showcaseControllerProvider
                                                  .notifier,
                                            )
                                            .upvoteShowcase(
                                              commentPost,
                                              widget.currentUser,
                                            );
                                        return !isLiked;
                                      },
                                      isLiked: commentPost.upvotes.contains(
                                        widget.currentUser.uid,
                                      ),
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                'assets/svg/like_filled.svg',
                                                colorFilter: ColorFilter.mode(
                                                  Pallete.secondaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                'assets/svg/like_outline.svg',
                                                colorFilter: ColorFilter.mode(
                                                  Pallete.greyColor,
                                                  BlendMode.srcIn,
                                                ),
                                              );
                                      },
                                      likeCount: commentPost.upvotes.length,
                                      countBuilder:
                                          (likeCount, isLiked, text) => Padding(
                                            padding: const EdgeInsets.only(
                                              left: 3.0,
                                            ),
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                color: isLiked
                                                    ? Pallete.secondaryColor
                                                    : Pallete.greyColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                              ],
                            ),

                            Divider(),
                          ],
                        );
                      },
                      error: (error, StackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => SizedBox(),
                    );
              },
            );
          },
          loading: () => Loader(),
          error: (e, st) => ErrorText(error: e.toString()),
        );
  }
}
