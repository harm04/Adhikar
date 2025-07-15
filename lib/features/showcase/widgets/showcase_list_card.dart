import 'package:adhikar/common/widgets/fullscreen_image_viewer.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/features/showcase/views/showcase.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

class ShowcaseListCard extends ConsumerStatefulWidget {
  final ShowcaseModel showcase;
  const ShowcaseListCard({super.key, required this.showcase});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowcaseListCardState();
}

class _ShowcaseListCardState extends ConsumerState<ShowcaseListCard> {
  String _buildDisplayText() {
    // Return only the clean title text, no hashtags or links for list view
    return widget.showcase.title;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Showcase(showcaseModel: widget.showcase);
            },
          ),
        );
        // Refresh the showcases list after returning from detail
        final _ = ref.refresh(getShowcaseProvider);
      },
      child: Card(
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 19),
          height: 110,
          child: Row(
            children: [
              // Left section: Image and text
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: FullscreenImageViewer(
                        imageUrl: widget.showcase.logoImage.isEmpty
                            ? null
                            : widget.showcase.logoImage,
                        child: widget.showcase.logoImage == ''
                            ? Image.asset(
                                'assets/images/logo.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage.assetNetwork(
                                placeholder: ImageTheme.defaultAdhikarLogo,
                                image: widget.showcase.logoImage,
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                      return Image.asset(
                                        ImageTheme.defaultProfileImage,
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                      );
                                    },
                              ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _buildDisplayText(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.showcase.tagline.isEmpty
                                ? 'No tagline provided'
                                : widget.showcase.tagline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              color: context.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right section: Divider and LikeButton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 19.0,
                      right: 19,
                      top: 19,
                      bottom: 19,
                    ),
                    child: Container(width: 1.2, color: context.borderColor),
                  ),
                  LikeButton(
                    size: 26,
                    onTap: (isLiked) async {
                      ref
                          .read(showcaseControllerProvider.notifier)
                          .upvoteShowcase(widget.showcase, currentUser);
                      return !isLiked;
                    },
                    isLiked: widget.showcase.upvotes.contains(currentUser!.uid),
                    likeBuilder: (isLiked) {
                      return SvgPicture.asset(
                        isLiked
                            ? 'assets/svg/upvote_filled.svg'
                            : 'assets/svg/upvote_outline.svg',
                        colorFilter: ColorFilter.mode(
                          isLiked
                              ? context.secondaryColor
                              : context.iconSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      );
                    },
                    likeCount: widget.showcase.upvotes.length,
                    countBuilder: (likeCount, isLiked, text) => Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isLiked
                              ? context.secondaryColor
                              : context.textSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
