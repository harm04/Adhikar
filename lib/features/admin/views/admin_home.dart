import 'package:adhikar/apis/expert_api.dart';
import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/apis/showcase_api.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/common/widgets/loader.dart';

import 'package:adhikar/features/admin/graph/today_stats.dart';
import 'package:adhikar/features/admin/graph/user_activity_graph.dart';

import 'package:adhikar/features/search/widget/search_user.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminHome extends ConsumerStatefulWidget {
  AdminHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //total stats
              Text(
                "Total Stats",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Users
                  Expanded(
                    child: _AdminStatCard(
                      asset: 'assets/svg/profile.svg',
                      color: Color(0xFFE3F2FD),
                      title: "Users",
                      countAsync: ref.watch(usersCountProvider),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Experts
                  Expanded(
                    child: _AdminStatCard(
                      asset: 'assets/svg/apply_for_lawyer.svg',
                      color: Color(0xFFFFF9C4),
                      title: "Experts",
                      countAsync: ref.watch(expertsCountProvider),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Showcases
                  Expanded(
                    child: _AdminStatCard(
                      asset: 'assets/svg/showcase.svg',
                      color: Color(0xFFE1BEE7),
                      title: "Showcases",
                      countAsync: ref.watch(showcasesCountProvider),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Posts
                  Expanded(
                    child: _AdminStatCard(
                      asset: 'assets/svg/posts.svg',
                      color: Color(0xFFC8E6C9),
                      title: "Posts",
                      countAsync: ref.watch(postsCountProvider),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Search field and results
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search users...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                        if (searchController.text.isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                setState(() {});
                              },
                            ),
                          ),
                        SizedBox(height: 10),
                        if (searchController.text.trim().isNotEmpty)
                          // Show search results in the gap below the TextField
                          Container(
                            height: 300, // Adjust as needed
                            child: SearchUser(query: searchController.text),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Insights",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: context.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 380,
                          child: ref
                              .watch(todayStatsProvider)
                              .when(
                                data: (data) => UsersDailyActivityGraph(
                                  users: data['users']!,
                                  posts: data['posts']!,
                                  showcases: data['showcases']!,
                                ),
                                loading: () => Loader(),
                                error: (e, st) => Icon(Icons.error),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final Color color;
  final String asset;
  final String title;
  final AsyncValue<int> countAsync;

  const _AdminStatCard({
    required this.color,
    required this.asset,
    required this.title,
    required this.countAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: countAsync.when(
        data: (count) => Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    asset,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      context.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
        ),
        loading: () => Loader(),
        error: (e, st) => Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
