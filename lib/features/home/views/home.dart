import 'package:adhikar/features/posts/views/create_post.dart';
import 'package:adhikar/features/posts/widgets/posts_list.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                          // onTap: () => Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return ProfileView(userModel: currentuser);
                          //     },
                          //   ),
                          // ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Harsh Mali',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      'Adhikar user',

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
                        drawerItems('Pods', 'assets/svg/pods.svg'),
                        drawerItems(
                          'Apply for Lawyer',
                          'assets/svg/apply_for_lawyer.svg',
                        ),
                        drawerItems('News', 'assets/svg/news.svg'),
                        drawerItems('Showcase', 'assets/svg/showcase.svg'),
                        drawerItems('KYR', 'assets/svg/kyr.svg'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          drawerItems('Settings', 'assets/svg/settings.svg'),
                          drawerItems('Logout', 'assets/svg/logout.svg'),
                        ],
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
            colorFilter: ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
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
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Row(
                    children: [
                      //notification icon
                      SvgPicture.asset(
                        'assets/svg/notification.svg',
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        height: 30,
                      ),

                      const SizedBox(width: 22),
                      //chat icon
                      SvgPicture.asset(
                        'assets/svg/chat.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        height: 30,
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
              // Replace with content widgets
              PostList(),
              ListTabContent(title: "Rights"),
              ListTabContent(title: "Awareness"),
            ],
          ),
        ),
      ),
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
