import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';

import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/pods/widgets/pods_list.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/carousel.dart';
import 'package:adhikar/features/posts/widgets/expandable_hashtags.dart';
import 'package:adhikar/features/posts/widgets/hashtags.dart';
import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class Comment extends ConsumerStatefulWidget {
  final PostModel postModel;
  final String podImage;

  const Comment({super.key, required this.postModel, required this.podImage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<Comment> {
  bool isAnonymous = false;
  TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    // final commentsAsyncValue = ref.watch(getCommentsProvider(widget.postModel));
    return ref
        .watch(userDataProvider(widget.postModel.uid))
        .when(
          data: (user) {
            return Scaffold(
              resizeToAvoidBottomInset: true,

              appBar: AppBar(title: Text('Comments')),
              //bottom nav bar
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Pallete.greyColor, width: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAnonymous = !isAnonymous;
                            });
                          },
                          child: CircleAvatar(
                            radius: 20,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Pallete.whiteColor,
                                  backgroundImage: !isAnonymous
                                      ? NetworkImage(
                                          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                                        )
                                      : AssetImage(
                                          'assets/icons/anonymous.png',
                                        ),
                                ),
                                Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/replace.png',
                                        height: 35,
                                        color: Pallete.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Enter your reply here...',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              autofocus: true, // Auto-focus when tapping
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0, top: 10),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: commentController,
                            builder: (context, value, child) {
                              final isNotEmpty = value.text.trim().isNotEmpty;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isNotEmpty
                                      ? Pallete.primaryColor
                                      : Pallete.greyColor,
                                ),
                                onPressed: isNotEmpty
                                    ? () async {
                                        ref
                                            .read(
                                              postControllerProvider.notifier,
                                            )
                                            .shareComment(
                                              text: commentController.text,
                                              isAnonymous: isAnonymous,

                                              pod: 'comment',
                                              context: context,
                                              commentedTo: widget.postModel.id,
                                            );
                                        commentController.clear();
                                        ref.invalidate(
                                          getCommentsProvider(widget.postModel),
                                        );
                                      }
                                    : null, // disables the button if empty
                                child: Text(
                                  'Post',
                                  style: TextStyle(color: Pallete.whiteColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //profile image
                            GestureDetector(
                              onTap: () => widget.postModel.isAnonymous
                                  ? SizedBox()
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileView(userModel: user);
                                        },
                                      ),
                                    ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Pallete.whiteColor,
                                backgroundImage: widget.postModel.isAnonymous
                                    ? AssetImage('assets/icons/anonymous.png')
                                    : (user.profileImage == ''
                                          ? NetworkImage(
                                              'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                                            )
                                          : NetworkImage(user.profileImage)),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      //username
                                      GestureDetector(
                                        onTap: () =>
                                            widget.postModel.isAnonymous
                                            ? SizedBox()
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ProfileView(
                                                      userModel: user,
                                                    );
                                                  },
                                                ),
                                              ),
                                        child: Text(
                                          widget.postModel.isAnonymous
                                              ? 'Anonymous'
                                              : '${user.firstName} ${user.lastName}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      //time
                                      Text(
                                        ' . ${timeago.format(widget.postModel.createdAt, locale: 'en_short')}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //bio
                                  Text(
                                    widget.postModel.isAnonymous
                                        ? 'Anonymous User'
                                        : user.bio == ''
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
                            //pod
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PodsListView();
                                  },
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage(widget.podImage),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        //text content
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              width: double.infinity,
                              child: ExpandableHashtags(
                                text: widget.postModel.text,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 5),

                        //image
                        if (widget.postModel.type == PostType.image)
                          widget.postModel.images.length <= 4
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 10,
                                  ),
                                  child: GridView.builder(
                                    padding: const EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.postModel.images.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              widget.postModel.images.length ==
                                                  1
                                              ? 1
                                              : widget
                                                        .postModel
                                                        .images
                                                        .length ==
                                                    2
                                              ? 2
                                              : 2,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 1,
                                        ),
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          widget.postModel.images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : CarouselImage(
                                  imageLinks: widget.postModel.images,
                                ),
                        if (widget.postModel.link.isNotEmpty) ...[
                          SizedBox(height: 4),

                          //link preview
                          AnyLinkPreview(
                            link: widget.postModel.link.toString().replaceAll(
                              RegExp(r'[\[\]]'),
                              '',
                            ),
                            displayDirection: UIDirection.uiDirectionHorizontal,
                          ),
                        ],
                        SizedBox(height: 20),
                        //date and time
                        Row(
                          children: [
                            Text(
                              DateFormat(
                                'hh:mm a',
                              ).format(widget.postModel.createdAt),
                              style: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //am,pm
                            Text(
                              ' . ',
                              style: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'MMM dd, yy',
                              ).format(widget.postModel.createdAt),
                              style: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: const Color.fromARGB(255, 49, 48, 48),
                          thickness: 0,
                        ),

                        //like,comment,share,more
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer(
                              builder: (context, ref, _) {
                                final postStream = ref.watch(
                                  postStreamProvider(widget.postModel.id),
                                );
                                return postStream.when(
                                  data: (livePost) => Text(
                                    '${livePost.likes.length} likes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.greyColor,
                                    ),
                                  ),
                                  loading: () => Text(
                                    '${widget.postModel.likes.length} likes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.greyColor,
                                    ),
                                  ),
                                  error: (e, st) => Text(
                                    '${widget.postModel.likes.length} likes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.greyColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                LikeButton(
                                  isLiked:
                                      ref
                                          .watch(currentUserDataProvider)
                                          .value
                                          ?.bookmarked
                                          .contains(widget.postModel.id) ??
                                      false,
                                  size: 32,
                                  onTap: (isLiked) async {
                                    ref
                                        .read(postControllerProvider.notifier)
                                        .bookmarkPost(
                                          widget.postModel,
                                          ref
                                              .read(currentUserDataProvider)
                                              .value!,
                                        );
                                    ref.invalidate(currentUserDataProvider);
                                    return !isLiked;
                                  },
                                  likeBuilder: (isLiked) {
                                    return isLiked
                                        ? SvgPicture.asset(
                                            'assets/svg/bookmark_filled.svg',
                                            colorFilter: ColorFilter.mode(
                                              Pallete.secondaryColor,
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            'assets/svg/bookmark_outline.svg',
                                            colorFilter: ColorFilter.mode(
                                              Pallete.greyColor,
                                              BlendMode.srcIn,
                                            ),
                                          );
                                  },
                                ),
                                SizedBox(width: 25),

                                LikeButton(
                                  isLiked: widget.postModel.likes.contains(
                                    currentUser.uid,
                                  ),
                                  size: 32,
                                  onTap: (isLiked) async {
                                    ref
                                        .read(postControllerProvider.notifier)
                                        .likePost(
                                          widget.postModel,
                                          currentUser,
                                        );
                                    return !isLiked;
                                  },
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
                                ),
                                SizedBox(width: 25),
                                SvgPicture.asset(
                                  'assets/svg/more_outline.svg',
                                  colorFilter: ColorFilter.mode(
                                    Pallete.greyColor,
                                    BlendMode.srcIn,
                                  ),
                                  height: 22,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 49, 48, 48),
                          thickness: 0,
                        ),

                        //replies
                        SizedBox(height: 15),
                        ref
                            .watch(getCommentsProvider(widget.postModel))
                            .when(
                              data: (comments) => Text(
                                '${comments.length} Replies',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              loading: () => Text(
                                'Loading replies...',

                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              error: (e, st) => Text(
                                'Error loading replies',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        SizedBox(height: 15),
                        ref
                            .watch(getCommentsProvider(widget.postModel))
                            .when(
                              data: (comments) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final commentPost = comments[index];

                                    return ref
                                        .watch(
                                          userDataProvider(commentPost.uid),
                                        )
                                        .when(
                                          data: (user) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //profile image
                                                    GestureDetector(
                                                      onTap: () =>
                                                          commentPost
                                                              .isAnonymous
                                                          ? SizedBox()
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) {
                                                                  return ProfileView(
                                                                    userModel:
                                                                        user,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            Pallete.whiteColor,
                                                        backgroundImage:
                                                            commentPost
                                                                .isAnonymous
                                                            ? AssetImage(
                                                                'assets/icons/anonymous.png',
                                                              )
                                                            : user.profileImage ==
                                                                  ''
                                                            ? NetworkImage(
                                                                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                                                              )
                                                            : NetworkImage(
                                                                user.profileImage,
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              //username
                                                              GestureDetector(
                                                                onTap: () =>
                                                                    commentPost
                                                                        .isAnonymous
                                                                    ? SizedBox()
                                                                    : Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder:
                                                                              (
                                                                                context,
                                                                              ) {
                                                                                return ProfileView(
                                                                                  userModel: user,
                                                                                );
                                                                              },
                                                                        ),
                                                                      ),
                                                                child: Text(
                                                                  commentPost
                                                                          .isAnonymous
                                                                      ? 'Anonymous'
                                                                      : '${user.firstName} ${user.lastName}',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              //time
                                                              Text(
                                                                ' . ${timeago.format(commentPost.createdAt, locale: 'en_short')}',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Pallete
                                                                      .greyColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          //bio
                                                          Text(
                                                            commentPost
                                                                    .isAnonymous
                                                                ? 'Anonymous Post'
                                                                : user.bio == ''
                                                                ? 'Adhikar user'
                                                                : '${user.bio}',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Pallete
                                                                  .greyColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //hashtags
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: HashTags(
                                                            text: commentPost
                                                                .text,
                                                          ),
                                                        ),
                                                        LikeButton(
                                                          size: 26,
                                                          onTap: (isLiked) async {
                                                            ref
                                                                .read(
                                                                  postControllerProvider
                                                                      .notifier,
                                                                )
                                                                .likePost(
                                                                  commentPost,
                                                                  currentUser,
                                                                );
                                                            return !isLiked;
                                                          },
                                                          isLiked: commentPost
                                                              .likes
                                                              .contains(
                                                                currentUser.uid,
                                                              ),
                                                          likeBuilder: (isLiked) {
                                                            return isLiked
                                                                ? SvgPicture.asset(
                                                                    'assets/svg/like_filled.svg',
                                                                    colorFilter: ColorFilter.mode(
                                                                      Pallete
                                                                          .secondaryColor,
                                                                      BlendMode
                                                                          .srcIn,
                                                                    ),
                                                                  )
                                                                : SvgPicture.asset(
                                                                    'assets/svg/like_outline.svg',
                                                                    colorFilter: ColorFilter.mode(
                                                                      Pallete
                                                                          .greyColor,
                                                                      BlendMode
                                                                          .srcIn,
                                                                    ),
                                                                  );
                                                          },
                                                          likeCount: commentPost
                                                              .likes
                                                              .length,
                                                          countBuilder:
                                                              (
                                                                likeCount,
                                                                isLiked,
                                                                text,
                                                              ) => Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 3.0,
                                                                    ),
                                                                child: Text(
                                                                  text,
                                                                  style: TextStyle(
                                                                    color:
                                                                        isLiked
                                                                        ? Pallete
                                                                              .secondaryColor
                                                                        : Pallete
                                                                              .greyColor,
                                                                    fontSize:
                                                                        16,
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
                                              ErrorText(
                                                error: error.toString(),
                                              ),
                                          loading: () => SizedBox(),
                                        );
                                  },
                                );
                              },
                              loading: () => Loader(),
                              error: (e, st) => ErrorText(error: e.toString()),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, StackTrace) => ErrorText(error: error.toString()),
          loading: () => SizedBox(),
        );
  }
}
