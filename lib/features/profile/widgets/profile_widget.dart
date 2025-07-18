import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/common/widgets/webview_page.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/message/views/conversations.dart';
import 'package:adhikar/features/message/views/messaging.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';

import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/expandable_hashtags.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/profile/views/edit_profile.dart';
import 'package:adhikar/features/profile/widgets/add_education.dart';
import 'package:adhikar/features/profile/widgets/add_experience.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  final UserModel userModel;
  ProfileWidget({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSocialLink(BuildContext context, String url, String platform) {
    if (url.isEmpty ||
        !(url.startsWith('http://') || url.startsWith('https://'))) {
      showSnackbar(context, '$platform link is invalid');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url, appBarText: 'Adhikar'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    bool isLoading = ref.watch(authControllerProvider);
    if (currentUser == null) {
      return Loader(); // or any loading widget
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: widget.userModel.profileImage == ''
                            ? AssetImage(ImageTheme.defaultProfileImage)
                            : NetworkImage(widget.userModel.profileImage)
                                  as ImageProvider,
                      ),
                    ),

                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.userModel.firstName} ${widget.userModel.lastName}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.userModel.userType == 'Expert'
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 7.0),
                                      child: SvgPicture.asset(
                                        'assets/svg/verified.svg',
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            widget.userModel.bio == ''
                                ? 'Adhikar user'
                                : widget.userModel.bio,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.userModel.uid == currentUser.uid
                      ? GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileView(
                                  userModel: widget.userModel,
                                ),
                              ),
                            );
                            if (result == true) {
                              ref.invalidate(
                                currentUserDataProvider,
                              ); // Refetch user data
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/svg/pencil.svg',
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onBackground,
                              BlendMode.srcIn,
                            ),
                            height: 25,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 15),

                  widget.userModel.uid == currentUser.uid &&
                          widget.userModel.userType == 'Expert'
                      ? GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                widget.userModel.credits.toString(),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onBackground,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10),
                              SvgPicture.asset(
                                'assets/svg/wallet.svg',
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.secondary,
                                  BlendMode.srcIn,
                                ),
                                height: 25,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svg/location.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).hintColor,
                  BlendMode.srcIn,
                ),
                height: 25,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.userModel.location == ''
                      ? 'India, India'
                      : widget.userModel.location,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
              SizedBox(width: 20),
              SvgPicture.asset(
                'assets/svg/meetings.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).hintColor,
                  BlendMode.srcIn,
                ),
                height: 25,
              ),
              SizedBox(width: 5),
              Text(
                'Joined on ${widget.userModel.createdAt}',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _openSocialLink(
                  context,
                  widget.userModel.linkedin,
                  'Linkedin',
                ),
                child: Image.asset(
                  widget.userModel.linkedin == ''
                      ? 'assets/icons/ic_linkedin_grey.png'
                      : 'assets/icons/ic_linkedin.png',
                  height: 40,
                ),
              ),
              SizedBox(width: 9),
              GestureDetector(
                onTap: () => _openSocialLink(
                  context,
                  widget.userModel.instagram,
                  'Instagram',
                ),
                child: Image.asset(
                  widget.userModel.instagram == ''
                      ? 'assets/icons/ic_instagram_grey.png'
                      : 'assets/icons/ic_instagram.png',
                  height: 40,
                ),
              ),
              SizedBox(width: 9),
              GestureDetector(
                onTap: () =>
                    _openSocialLink(context, widget.userModel.twitter, 'X'),
                child: Image.asset(
                  widget.userModel.twitter == ''
                      ? 'assets/icons/ic_x_grey.png'
                      : 'assets/icons/ic_x.png',
                  height: 40,
                ),
              ),
              SizedBox(width: 9),
              GestureDetector(
                onTap: () => _openSocialLink(
                  context,
                  widget.userModel.facebook,
                  'Facebook',
                ),
                child: Image.asset(
                  widget.userModel.facebook == ''
                      ? 'assets/icons/ic_facebook_grey.png'
                      : 'assets/icons/ic_facebook.png',
                  height: 40,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.userModel.uid != currentUser.uid
                        ? ref
                              .read(authControllerProvider.notifier)
                              .followUser(
                                userModel: widget.userModel,
                                currentUser: currentUser,
                                context: context,
                                ref: ref,
                              )
                        : SizedBox();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.userModel.uid == currentUser.uid
                                    ? '${widget.userModel.followers.length} Followers'
                                    : currentUser.following.contains(
                                        widget.userModel.uid,
                                      )
                                    ? 'Unfollow'
                                    : 'Follow',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final currentUser = ref
                        .watch(currentUserDataProvider)
                        .value!;
                    final peerUser = widget.userModel;
                    if (currentUser.uid == peerUser.uid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ConversationsListScreen(
                              currentUser: currentUser,
                            );
                          },
                        ),
                      );
                      return;
                    }

                    // If current user is Expert, allow messaging anyone
                    if (currentUser.userType == 'Expert') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagingScreen(
                            currentUser: currentUser,
                            peerUser: peerUser,
                          ),
                        ),
                      );
                      return;
                    }

                    // If both are Users, allow messaging
                    if (currentUser.userType == 'User' &&
                        peerUser.userType == 'User') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagingScreen(
                            currentUser: currentUser,
                            peerUser: peerUser,
                          ),
                        ),
                      );
                      return;
                    }

                    // If current user is User and peer is Expert
                    if (currentUser.userType == 'User' &&
                        peerUser.userType == 'Expert') {
                      // Check if conversation exists
                      final conversations = await ref
                          .read(messagingControllerProvider)
                          .getUserConversations(currentUser.uid);

                      final exists = conversations.any(
                        (conv) => conv['peerId'] == peerUser.uid,
                      );

                      if (exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagingScreen(
                              currentUser: currentUser,
                              peerUser: peerUser,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You cannot message an expert."),
                          ),
                        );
                      }
                      return;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/chat.svg',
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).iconTheme.color ??
                                    Theme.of(context).colorScheme.onSurface,
                                BlendMode.srcIn,
                              ),
                              height: 25,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Messages',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelColor: Theme.of(context).colorScheme.secondary,
          labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          tabs: [
            Tab(child: Text('About', style: TextStyle(fontSize: 17))),
            Tab(child: Text('Posts', style: TextStyle(fontSize: 17))),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      widget.userModel.summary != ''
                          ? ExpandableHashtags(text: widget.userModel.summary)
                          : Text(
                              'Adhikar user',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                      SizedBox(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          widget.userModel.uid == currentUser.uid
                              ? GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddExperience(
                                        currentUser: widget.userModel,
                                      ),
                                    ),
                                  ),
                                  child: widget.userModel.experienceTitle == ''
                                      ? SvgPicture.asset(
                                          'assets/svg/add.svg',
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).iconTheme.color ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            BlendMode.srcIn,
                                          ),
                                          height: 25,
                                        )
                                      : SvgPicture.asset(
                                          'assets/svg/pencil.svg',
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).iconTheme.color ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            BlendMode.srcIn,
                                          ),
                                          height: 25,
                                        ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(height: 7),
                      widget.userModel.experienceTitle != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userModel.experienceTitle,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),

                                Text(
                                  widget.userModel.experienceOrganization,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                SizedBox(height: 7),
                                ExpandableHashtags(
                                  text: widget.userModel.experienceSummary,
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Education',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          widget.userModel.uid == currentUser.uid
                              ? GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEducation(
                                        currentUser: widget.userModel,
                                      ),
                                    ),
                                  ),
                                  child: widget.userModel.eduDegree == ''
                                      ? SvgPicture.asset(
                                          'assets/svg/add.svg',
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).iconTheme.color ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            BlendMode.srcIn,
                                          ),
                                          height: 25,
                                        )
                                      : SvgPicture.asset(
                                          'assets/svg/pencil.svg',
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).iconTheme.color ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            BlendMode.srcIn,
                                          ),
                                          height: 25,
                                        ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(height: 7),
                      widget.userModel.eduDegree != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userModel.eduDegree,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),

                                Text(
                                  widget.userModel.eduUniversity,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  widget.userModel.eduStream,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 7),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
              //posts tab
              ref
                  .watch(getUsersPostProvider(widget.userModel.uid))
                  .when(
                    data: (posts) {
                      // Filter out posts where pod == 'comment'
                      final mainPosts = posts
                          .where((post) => post.pod != 'comment')
                          .toList();
                      if (mainPosts.isEmpty) {
                        return Center(child: Text("No posts available"));
                      }
                      return ListView.builder(
                        itemCount: mainPosts.length,
                        itemBuilder: (context, index) {
                          final post = mainPosts[index];
                          return Consumer(
                            builder: (context, ref, _) {
                              final postStream = ref.watch(
                                postStreamProvider(post.id),
                              );
                              return postStream.when(
                                data: (livePost) =>
                                    PostCard(postmodel: livePost),
                                loading: () => PostCard(postmodel: post),
                                error: (e, st) => PostCard(postmodel: post),
                              );
                            },
                          );
                        },
                      );
                    },
                    error: (error, st) => ErrorText(error: error.toString()),
                    loading: () => LoadingPage(),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
