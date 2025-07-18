import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/fullscreen_image_viewer.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/posts/widgets/carousel.dart';
import 'package:adhikar/features/posts/widgets/expandable_hashtags.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/features/showcase/widgets/comment_textfield.dart';
import 'package:adhikar/features/showcase/widgets/comments_list.dart';
import 'package:adhikar/features/showcase/widgets/meet_expert_card.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

class Showcase extends ConsumerStatefulWidget {
  final ShowcaseModel showcaseModel;
  Showcase({super.key, required this.showcaseModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowcaseState();
}

class _ShowcaseState extends ConsumerState<Showcase> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      bottomNavigationBar: CommentTextfield(
        showcaseModel: widget.showcaseModel,
        currentUser: currentUser,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 290.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.showcaseModel.bannerImage == ''
                      ? FullscreenImageViewer(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : FullscreenImageViewer(
                          imageUrl: widget.showcaseModel.bannerImage,
                          child: Image.network(
                            widget.showcaseModel.bannerImage,
                            fit: BoxFit.cover,
                          ),
                        ),

                  //back arrow
                  Positioned(
                    top: 55,
                    left: 10,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: SvgPicture.asset(
                          height: 30,
                          'assets/svg/left_arrow.svg',
                          colorFilter: ColorFilter.mode(
                            Pallete.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 10,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: LikeButton(
                            isLiked:
                                ref
                                    .watch(currentUserDataProvider)
                                    .value
                                    ?.bookmarked
                                    .contains(widget.showcaseModel.id) ??
                                false,
                            size: 28,
                            onTap: (isLiked) async {
                              ref
                                  .read(showcaseControllerProvider.notifier)
                                  .bookmarkPost(
                                    widget.showcaseModel,
                                    ref.read(currentUserDataProvider).value!,
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
                                        Pallete.whiteColor,
                                        BlendMode.srcIn,
                                      ),
                                    );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        //share
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Coming Soon'),
                                  content: Text(
                                    'Sharing feature is coming soon.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: SvgPicture.asset(
                              height: 30,
                              'assets/svg/share.svg',
                              colorFilter: ColorFilter.mode(
                                Pallete.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //blurred background
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            spreadRadius: 200,
                            blurRadius: 200,
                            blurStyle: BlurStyle.normal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //logo and text
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: FullscreenImageViewer(
                                imageUrl: widget.showcaseModel.logoImage.isEmpty
                                    ? null
                                    : widget.showcaseModel.logoImage,
                                child: widget.showcaseModel.logoImage == ''
                                    ? Image.asset(
                                        'assets/images/logo.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        widget.showcaseModel.logoImage,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(width: 18),
                            // Showcase title and tagline
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.showcaseModel.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.whiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      widget.showcaseModel.tagline == ''
                                          ? 'No tagline provided'
                                          : widget.showcaseModel.tagline,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Pallete.whiteColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  //
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        height: 22,
                                        'assets/svg/upvote_outline.svg',
                                        colorFilter: ColorFilter.mode(
                                          Pallete.whiteColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        widget.showcaseModel.upvotes.length
                                            .toString(),
                                        style: TextStyle(
                                          color: Pallete.whiteColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 25),
                                      SvgPicture.asset(
                                        'assets/svg/comment.svg',
                                        colorFilter: ColorFilter.mode(
                                          Pallete.whiteColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        widget.showcaseModel.commentIds.length
                                            .toString(),
                                        style: TextStyle(
                                          color: Pallete.whiteColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Upvote
                  GestureDetector(
                    onTap: () async {
                      ref
                          .read(showcaseControllerProvider.notifier)
                          .upvoteShowcase(widget.showcaseModel, currentUser);
                      setState(() {}); // To update UI after upvote
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            widget.showcaseModel.upvotes.contains(
                              currentUser.uid,
                            )
                            ? Pallete.secondaryColor
                            : Pallete.cardColor,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 9.0,
                            horizontal: 20,
                          ),
                          child: Text(
                            widget.showcaseModel.upvotes.contains(
                                  currentUser.uid,
                                )
                                ? 'Upvoted'
                                : 'Upvote',
                            style: TextStyle(
                              color:
                                  widget.showcaseModel.upvotes.contains(
                                    currentUser.uid,
                                  )
                                  ? Pallete.primaryColor
                                  : Pallete.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  ExpandableHashtags(text: widget.showcaseModel.description),
                  SizedBox(height: 20),
                  //image
                  if (widget.showcaseModel.type == PostType.image)
                    widget.showcaseModel.images.length <= 4
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 10,
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.showcaseModel.images.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        widget.showcaseModel.images.length == 1
                                        ? 1
                                        : widget.showcaseModel.images.length ==
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
                                  child: FullscreenImageViewer(
                                    imageUrl:
                                        widget.showcaseModel.images[index],
                                    child: Image.network(
                                      widget.showcaseModel.images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : CarouselImage(
                            imageLinks: widget.showcaseModel.images,
                          ),
                  if (widget.showcaseModel.link.isNotEmpty) ...[
                    SizedBox(height: 4),

                    //link preview
                    AnyLinkPreview(
                      link: widget.showcaseModel.link.toString().replaceAll(
                        RegExp(r'[\[\]]'),
                        '',
                      ),
                      displayDirection: UIDirection.uiDirectionHorizontal,
                    ),
                    SizedBox(height: 10),
                  ],
                  //Meet the Expert
                  Text(
                    'Meet the Expert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  Consumer(
                    builder: (context, ref, _) {
                      return ref
                          .watch(userDataProvider(widget.showcaseModel.uid))
                          .when(
                            data: (user) {
                              return MeetExpertCard(user: user);
                            },
                            error: (err, st) =>
                                ErrorText(error: err.toString()),
                            loading: () => Loader(),
                          );
                    },
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Discussion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),

                  //comments
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 10),

                  CommentsList(
                    showcaseModel: widget.showcaseModel,
                    currentUser: currentUser,
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
