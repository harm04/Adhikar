import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/posts/widgets/carousel.dart';
import 'package:adhikar/features/posts/widgets/hashtags.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final PostModel postmodel;
  const PostCard({super.key, required this.postmodel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: postmodel.isAnonymous
                            ? AssetImage('assets/icons/anonymous.png')
                            : user.profileImage == ''
                            ? NetworkImage(
                                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                              )
                            : NetworkImage(user.profileImage),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              user.firstName + ' ' + user.lastName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user.bio == ''
                                        ? 'Adhikar user defc dddddd eeeeeeee eee wwwwww wwww w'
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

                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Pallete.secondaryColor,

                        backgroundImage: AssetImage(getPod(postmodel.pod)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  HashTags(text: postmodel.text),
                  SizedBox(height: 5),
                  if (postmodel.type == PostType.image)
                    postmodel.images.length <= 4
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0,bottom: 10),
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
                                  child: Image.network(
                                    postmodel.images[index],
                                    fit: BoxFit.cover,
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
                          Text(
                            '${postmodel.commentIds.length.toString()} replies',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Pallete.secondaryColor,
                            ),
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
                          SvgPicture.asset(
                            'assets/svg/bookmark_outline.svg',
                            colorFilter: ColorFilter.mode(
                              Pallete.greyColor,
                              BlendMode.srcIn,
                            ),
                            height: 28,
                          ),
                          SizedBox(width: 20),
                          SvgPicture.asset(
                            'assets/svg/like_outline.svg',
                            colorFilter: ColorFilter.mode(
                              Pallete.greyColor,
                              BlendMode.srcIn,
                            ),
                            height: 32,
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
