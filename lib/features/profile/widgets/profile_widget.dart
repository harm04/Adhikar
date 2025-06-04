import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/profile/views/edit_profile.dart';
import 'package:adhikar/features/profile/widgets/add_education.dart';
import 'package:adhikar/features/profile/widgets/add_experience.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  final UserModel userModel;
  const ProfileWidget({super.key, required this.userModel});

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

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider);
    bool isLoading = ref.watch(authControllerProvider);
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
                      backgroundColor: Pallete.primaryColor,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: widget.userModel.profileImage == ''
                            ? NetworkImage(
                                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                              )
                            : NetworkImage(widget.userModel.profileImage),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userModel.firstName +
                                ' ' +
                                widget.userModel.lastName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
              widget.userModel.uid == currentUser.value!.uid
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileView(userModel: widget.userModel),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/pencil.svg',
                        colorFilter: ColorFilter.mode(
                          Pallete.whiteColor,
                          BlendMode.srcIn,
                        ),
                        height: 25,
                      ),
                    )
                  : SizedBox(),
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
                  Pallete.greyColor,
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
                  style: TextStyle(color: Pallete.greyColor),
                ),
              ),
              SizedBox(width: 20),
              SvgPicture.asset(
                'assets/svg/meetings.svg',
                colorFilter: ColorFilter.mode(
                  Pallete.greyColor,
                  BlendMode.srcIn,
                ),
                height: 25,
              ),
              SizedBox(width: 5),
              Text(
                'Joined on ${widget.userModel.createdAt}',
                style: TextStyle(color: Pallete.greyColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Image.asset(
                widget.userModel.linkedin == ''
                    ? 'assets/icons/ic_linkedin_grey.png'
                    : 'assets/icons/ic_linkedin.png',
                height: 40,
              ),
              SizedBox(width: 9),
              Image.asset(
                widget.userModel.instagram == ''
                    ? 'assets/icons/ic_instagram_grey.png'
                    : 'assets/icons/ic_instagram.png',
                height: 40,
              ),
              SizedBox(width: 9),
              Image.asset(
                widget.userModel.twitter == ''
                    ? 'assets/icons/ic_x_grey.png'
                    : 'assets/icons/ic_x.png',
                height: 40,
              ),
              SizedBox(width: 9),
              Image.asset(
                widget.userModel.facebook == ''
                    ? 'assets/icons/ic_facebook_grey.png'
                    : 'assets/icons/ic_facebook.png',
                height: 40,
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
                    widget.userModel.uid != currentUser.value!.uid
                        ? ref
                              .read(authControllerProvider.notifier)
                              .followUser(
                                userModel: widget.userModel,
                                currentUser: currentUser.value!,
                                context: context,
                              )
                        : SizedBox();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Pallete.primaryColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: isLoading
                            ? Loader()
                            : Text(
                                widget.userModel.uid == currentUser.value!.uid
                                    ? '${widget.userModel.followers.length} Followers'
                                    : currentUser.value!.following.contains(
                                        widget.userModel.uid,
                                      )
                                    ? 'Unfollow'
                                    : 'Follow',
                                style: TextStyle(
                                  color: Pallete.whiteColor,
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Pallete.whiteColor),
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
                              Pallete.whiteColor,
                              BlendMode.srcIn,
                            ),
                            height: 25,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Messages',
                            style: TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
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
          indicatorColor: Pallete.secondaryColor,
          labelColor: Pallete.secondaryColor,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      widget.userModel.summary == ''
                          ? 'Adhikar user'
                          : widget.userModel.summary,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Experience',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.userModel.uid == currentUser.value!.uid
                            ? GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddExperience(),
                                  ),
                                ),
                                child: widget.userModel.experienceTitle == ''
                                    ? SvgPicture.asset(
                                        'assets/svg/add.svg',
                                        colorFilter: ColorFilter.mode(
                                          Pallete.whiteColor,
                                          BlendMode.srcIn,
                                        ),
                                        height: 25,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svg/pencil.svg',
                                        colorFilter: ColorFilter.mode(
                                          Pallete.whiteColor,
                                          BlendMode.srcIn,
                                        ),
                                        height: 25,
                                      ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Education',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.userModel.uid == currentUser.value!.uid
                            ? GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEducation(),
                                  ),
                                ),
                                child: widget.userModel.eduDegree == ''
                                    ? SvgPicture.asset(
                                        'assets/svg/add.svg',
                                        colorFilter: ColorFilter.mode(
                                          Pallete.whiteColor,
                                          BlendMode.srcIn,
                                        ),
                                        height: 25,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svg/pencil.svg',
                                        colorFilter: ColorFilter.mode(
                                          Pallete.whiteColor,
                                          BlendMode.srcIn,
                                        ),
                                        height: 25,
                                      ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
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
