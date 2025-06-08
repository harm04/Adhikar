import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/pods/widgets/pods_list.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/carousel.dart';
import 'package:adhikar/features/posts/views/comment.dart';
import 'package:adhikar/features/posts/widgets/expandable_hashtags.dart';
import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final PostModel postmodel;
  const PostCard({super.key, required this.postmodel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      // You can show a loader, placeholder, or SizedBox.shrink()
      return const SizedBox.shrink();
    }
    String getPod(String text) {
      Map<String, String> podImageMap = {
        'General': 'assets/icons/ic_general.png',
        'Freelance & Legal Services': 'assets/icons/ic_freelance_services.png',
        'Criminal & Civil Law': 'assets/icons/ic_criminal_law.png',
        'Corporate & Business Law': 'assets/icons/ic_businees_law.png',
        'Moot Court & Bar Exam Prep': 'assets/icons/ic_exam_prep.png',
        'Internships & Job Opportunities':
            'assets/icons/ic_internship_and_job.png',
        'Legal Tech & AI': 'assets/icons/ic_legal_tech_and_ai.png',
        'Case Discussions': 'assets/icons/ic_case_discussion.png',
        'Legal News & Updates': 'assets/icons/ic_legal_news_and_updates.png',
      };

      for (var keyword in podImageMap.keys) {
        if (text.contains(keyword)) {
          return podImageMap[keyword]!;
        }
      }

      return 'assets/icons/ic_general.png';
    }

    return ref
        .watch(userDataProvider(postmodel.uid))
        .when(
          data: (user) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => postmodel.isAnonymous
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
                          radius: 28,
                          backgroundColor: Pallete.whiteColor,
                          backgroundImage: postmodel.isAnonymous
                              ? AssetImage('assets/icons/anonymous.png')
                              : user.profileImage == ''
                              ? AssetImage(ImageTheme.defaultProfileImage)
                              : NetworkImage(user.profileImage),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => postmodel.isAnonymous
                                  ? SizedBox()
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileView(userModel: user);
                                        },
                                      ),
                                    ),
                              child: Text(
                                postmodel.isAnonymous
                                    ? 'Anonymous'
                                    : user.firstName + ' ' + user.lastName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    postmodel.isAnonymous
                                        ? 'Anonymous User'
                                        : user.bio == ''
                                        ? 'Adhikar user'
                                        : user.bio,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Pallete.greyColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  timeago.format(
                                    postmodel.createdAt,
                                    locale: 'en_short',
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 18),

                      //pod
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PodsListView(),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Pallete.secondaryColor,

                          backgroundImage: AssetImage(getPod(postmodel.pod)),
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
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Comment(
                                postModel: postmodel,
                                podImage: getPod(postmodel.pod),
                              ),
                            ),
                          ),
                          child: ExpandableHashtags(text: postmodel.text),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 5),
                  //image
                  if (postmodel.type == PostType.image)
                    postmodel.images.length <= 4
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 10,
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: postmodel.images.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: postmodel.images.length == 1
                                        ? 1
                                        : postmodel.images.length == 2
                                        ? 2
                                        : 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: ImageTheme
                                        .defaultAdhikarLogo, 
                                    image: postmodel.images[index],
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                          return Image.asset(
                                            ImageTheme.defaultAdhikarLogo,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                  ),
                                );
                              },
                            ),
                          )
                        : CarouselImage(imageLinks: postmodel.images),
                  if (postmodel.link.isNotEmpty) ...[
                    SizedBox(height: 4),

                    //link preview
                    AnyLinkPreview(
                      link: postmodel.link.toString().replaceAll(
                        RegExp(r'[\[\]]'),
                        '',
                      ),
                      displayDirection: UIDirection.uiDirectionHorizontal,
                    ),
                    SizedBox(height: 10),
                  ],
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              final postStream = ref.watch(
                                postStreamProvider(postmodel.id),
                              );
                              return postStream.when(
                                data: (livePost) => Text(
                                  '${livePost.commentIds.length} replies',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.secondaryColor,
                                  ),
                                ),
                                loading: () => Text(
                                  '${postmodel.commentIds.length} replies',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.secondaryColor,
                                  ),
                                ),
                                error: (e, st) => Text(
                                  '${postmodel.commentIds.length} replies',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.secondaryColor,
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(
                            '. ${postmodel.likes.length} likes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Pallete.greyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          LikeButton(
                            isLiked:
                                ref
                                    .watch(currentUserDataProvider)
                                    .value
                                    ?.bookmarked
                                    .contains(postmodel.id) ??
                                false,
                            size: 32,
                            onTap: (isLiked) async {
                              ref
                                  .read(postControllerProvider.notifier)
                                  .bookmarkPost(
                                    postmodel,
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
                                        Pallete.greyColor,
                                        BlendMode.srcIn,
                                      ),
                                    );
                            },
                          ),

                          SizedBox(width: 20),
                          LikeButton(
                            isLiked: postmodel.likes.contains(currentUser.uid),
                            size: 32,
                            onTap: (isLiked) async {
                              ref
                                  .read(postControllerProvider.notifier)
                                  .likePost(postmodel, currentUser);
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
                          SizedBox(width: 20),
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
                  SizedBox(height: 10),
                  Divider(
                    color: const Color.fromARGB(255, 49, 48, 48),
                    thickness: 0,
                  ),
                ],
              ),
            );
          },
          error: (err, st) {
            return ErrorText(error: err.toString());
          },
          loading: () {
            return SizedBox.shrink();
          },
        );
  }
}
