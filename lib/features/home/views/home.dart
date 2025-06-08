import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/bookmarks/bookmarks.dart';
import 'package:adhikar/features/expert/views/apply_for_expert.dart';
import 'package:adhikar/features/home/widgets/following_posts.dart';
import 'package:adhikar/features/home/widgets/latest_posts.dart';
import 'package:adhikar/features/home/widgets/trending_posts.dart';
import 'package:adhikar/features/kyr/widget/kyr_list.dart';
import 'package:adhikar/features/message/views/conversations.dart';
import 'package:adhikar/features/news/widget/news_list.dart';
import 'package:adhikar/features/notification/views/notifications.dart';
import 'package:adhikar/features/pods/widgets/pods_list.dart';
import 'package:adhikar/features/posts/views/create_post.dart';
import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/features/settings/views/settings.dart';
import 'package:adhikar/features/showcase/views/showcase_list.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void signout() {
    ref.read(authControllerProvider.notifier).signout(context);
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(currentUserDataProvider)
        .when(
          data: (currentUser) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                key: scaffoldKey,
                //drawer
                drawer: Drawer(
                  width: MediaQuery.of(context).size.width * 0.86,
                  backgroundColor: Pallete.backgroundColor,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                //profile section
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ProfileView(
                                          userModel: currentUser,
                                        );
                                      },
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            currentUser!.profileImage == ''
                                            ? AssetImage(
                                                ImageTheme.defaultProfileImage,
                                              )
                                            : NetworkImage(
                                                currentUser.profileImage,
                                              ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${currentUser.firstName} ${currentUser.lastName}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              currentUser.bio == ''
                                                  ? 'Adhikar user'
                                                  : currentUser.bio,

                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),

                                Divider(color: Pallete.primaryColor),
                                //drawer Items
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const PodsListView();
                                      },
                                    ),
                                  ),
                                  child: drawerItems(
                                    'Pods',
                                    'assets/svg/pods.svg',
                                  ),
                                ),
                                //bookmarks
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BookmarksScreen();
                                      },
                                    ),
                                  ),
                                  child: drawerItems(
                                    'Bookmarks',
                                    'assets/svg/bookmark_outline.svg',
                                  ),
                                ),

                                currentUser.userType == 'Expert'
                                    ? SizedBox()
                                    : GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const ApplyForExpert();
                                            },
                                          ),
                                        ),
                                        child: drawerItems(
                                          'Apply for Lawyer',
                                          'assets/svg/apply_for_lawyer.svg',
                                        ),
                                      ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const NewsList();
                                      },
                                    ),
                                  ),
                                  child: drawerItems(
                                    'News',
                                    'assets/svg/news.svg',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const ShowcaseList();
                                      },
                                    ),
                                  ),
                                  child: drawerItems(
                                    'Showcase',
                                    'assets/svg/showcase.svg',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const KYRListView();
                                      },
                                    ),
                                  ),
                                  child: drawerItems(
                                    'KYR',
                                    'assets/svg/kyr.svg',
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const Settings();
                                    },
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    drawerItems(
                                      'Settings',
                                      'assets/svg/settings.svg',
                                    ),
                                    GestureDetector(
                                      onTap: () => signout(),
                                      child: drawerItems(
                                        'Logout',
                                        'assets/svg/logout.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                backgroundColor: Pallete.backgroundColor,
                //flotting action button
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Pallete.primaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CreatePostScreen();
                        },
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/pencil.svg',
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      backgroundColor: Pallete.backgroundColor,
                      floating: true,
                      snap: true,
                      pinned: false,
                      title: const Text('Adhikar'),
                      centerTitle: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: currentUser.profileImage == ''
                                ? AssetImage(ImageTheme.defaultProfileImage)
                                : NetworkImage(currentUser.profileImage),
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: Row(
                            children: [
                              //notification icon
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const Notifications();
                                    },
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  'assets/svg/notification.svg',
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  height: 30,
                                ),
                              ),

                              const SizedBox(width: 22),
                              //chat icon
                              GestureDetector(
                                onTap: () {
                                  final currentUser = ref
                                      .watch(currentUserDataProvider)
                                      .value!;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ConversationsListScreen(
                                        currentUser: currentUser,
                                      ),
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/chat.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      //tabs
                      bottom: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Pallete.secondaryColor,
                        labelColor: Pallete.secondaryColor,
                        labelStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: 'Trendings'),
                          Tab(text: 'Latest'),
                          Tab(text: 'Following'),
                        ],
                      ),
                    ),
                  ],
                  body: const TabBarView(
                    children: [
                      TrendingPosts(),
                      // PostList(),
                      LatestPosts(),
                      FollowingPosts(),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (err, st) => ErrorText(error: err.toString()),
          loading: () => LoadingPage(),
        );
  }
}

//drawer DrawerItems
Widget drawerItems(String title, String iconPath) {
  return ListTile(
    // onTap: () {
    //   Navigator.pushNamed(context, '/profile');
    // },
    title: Text(
      title,
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    ),
    leading: SvgPicture.asset(
      iconPath,
      height: 30,
      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ),
  );
}

class ListTabContent extends StatelessWidget {
  final String title;
  const ListTabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 25,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '$title item ${index + 1}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
