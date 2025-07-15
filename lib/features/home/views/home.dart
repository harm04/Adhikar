import 'package:adhikar/common/widgets/badge_icon.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/admin/services/notification_service.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/bookmarks/views/bookmarks.dart';
import 'package:adhikar/features/expert/views/apply_for_expert.dart';
import 'package:adhikar/features/home/widgets/following_posts.dart';
import 'package:adhikar/features/home/widgets/latest_posts.dart';
import 'package:adhikar/features/home/widgets/trending_posts.dart';
import 'package:adhikar/features/kyr/widget/kyr_list.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';
import 'package:adhikar/features/message/views/conversations.dart';
import 'package:adhikar/features/news/widget/news_list.dart';
import 'package:adhikar/features/notification/views/notifications.dart';
import 'package:adhikar/features/pods/widgets/pods_list.dart';
import 'package:adhikar/features/posts/views/create_post.dart';
import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/features/settings/views/settings.dart';
import 'package:adhikar/features/withdraw/views/withdraw_request.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';
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
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getToken();
    notificationService.firebaseInit(context, ref);
    notificationService.backgroundNotification(context, ref);
  }

  void signout() {
    ref.read(authControllerProvider.notifier).signout(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(currentUserDataProvider)
        .when(
          data: (currentUser) {
            if (currentUser == null) {
              return const LoadingPage();
            }
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                key: scaffoldKey,
                //drawer
                drawer: Drawer(
                  width: MediaQuery.of(context).size.width * 0.86,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                  onTap: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileView(
                                            userModel: currentUser,
                                          );
                                        },
                                      ),
                                    );

                                    if (updated == true) {
                                      ref.invalidate(currentUserDataProvider);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        key: ValueKey(currentUser.profileImage),
                                        radius: 50,
                                        backgroundImage:
                                            currentUser.profileImage == ''
                                            ? AssetImage(
                                                ImageTheme.defaultProfileImage,
                                              )
                                            : NetworkImage(
                                                    "${currentUser.profileImage}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                                                  )
                                                  as ImageProvider,
                                        onBackgroundImageError:
                                            (exception, stackTrace) {
                                              // Handle image loading errors
                                            },
                                        child: currentUser.profileImage != ''
                                            ? FutureBuilder<void>(
                                                future: precacheImage(
                                                  NetworkImage(
                                                    "${currentUser.profileImage}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                                                  ),
                                                  context,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage: AssetImage(
                                                        ImageTheme
                                                            .loadingPlaceholder,
                                                      ),
                                                    );
                                                  }
                                                  return SizedBox.shrink();
                                                },
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${currentUser.firstName} ${currentUser.lastName}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                currentUser.userType == 'Expert'
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 7.0,
                                                            ),
                                                        child: SvgPicture.asset(
                                                          'assets/svg/verified.svg',
                                                          height: 20,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                context
                                                                    .secondaryColor,
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

                                Divider(color: Theme.of(context).dividerColor),
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
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const WithdrawRequest();
                                              },
                                            ),
                                          );
                                        },
                                        child: drawerItems(
                                          'Withdraw',
                                          'assets/svg/wallet.svg',
                                        ),
                                      )
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //flotting action button
                floatingActionButton: FloatingActionButton(
                  backgroundColor: context.primaryColor,
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
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      floating: true,
                      snap: true,
                      pinned: false,
                      expandedHeight: 0,
                      forceElevated: innerBoxIsScrolled,
                      title: const Text('Adhikar'),
                      centerTitle: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: CircleAvatar(
                            key: ValueKey(currentUser.profileImage),
                            radius: 20,
                            backgroundImage: currentUser.profileImage == ''
                                ? AssetImage(ImageTheme.defaultProfileImage)
                                : NetworkImage(
                                    "${currentUser.profileImage}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                                  ),
                            onBackgroundImageError: (exception, stackTrace) {},
                            child: currentUser.profileImage != ''
                                ? FutureBuilder<void>(
                                    future: precacheImage(
                                      NetworkImage(
                                        "${currentUser.profileImage}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                                      ),
                                      context,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(
                                            ImageTheme.loadingPlaceholder,
                                          ),
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  )
                                : null,
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
                                    context.iconPrimaryColor,
                                    BlendMode.srcIn,
                                  ),
                                  height: 30,
                                ),
                              ),

                              const SizedBox(width: 22),
                              //chat icon with badge
                              Consumer(
                                builder: (context, ref, child) {
                                  final currentUser = ref
                                      .watch(currentUserDataProvider)
                                      .value;
                                  if (currentUser == null) {
                                    return SvgPicture.asset(
                                      'assets/svg/chat.svg',
                                      color: Theme.of(
                                        context,
                                      ).appBarTheme.iconTheme?.color,
                                      height: 30,
                                    );
                                  }

                                  final unseenChatsAsync = ref.watch(
                                    unseenChatsCountProvider(currentUser.uid),
                                  );

                                  return unseenChatsAsync.when(
                                    data: (unseenCount) => BadgeIcon(
                                      iconPath: 'assets/svg/chat.svg',
                                      badgeCount: unseenCount,
                                      iconHeight: 30,
                                      iconColor:
                                          Theme.of(
                                            context,
                                          ).appBarTheme.foregroundColor ??
                                          Colors.white,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ConversationsListScreen(
                                                  currentUser: currentUser,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    loading: () => SvgPicture.asset(
                                      'assets/svg/chat.svg',
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(
                                              context,
                                            ).appBarTheme.foregroundColor ??
                                            Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      height: 30,
                                    ),
                                    error: (_, __) => SvgPicture.asset(
                                      'assets/svg/chat.svg',
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(
                                              context,
                                            ).appBarTheme.foregroundColor ??
                                            Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      height: 30,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      //tabs
                      bottom: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: context.secondaryColor,
                        labelColor: context.secondaryColor,
                        labelStyle: const TextStyle(
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
  return Builder(
    builder: (context) => ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      leading: SvgPicture.asset(
        iconPath,
        height: 30,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color ?? Theme.of(context).primaryColor,
          BlendMode.srcIn,
        ),
      ),
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
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
