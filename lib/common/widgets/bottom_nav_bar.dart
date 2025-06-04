import 'package:adhikar/features/expert/widgets/expert_list.dart';
import 'package:adhikar/features/home/views/home.dart';
import 'package:adhikar/features/search/views/search.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  late PageController pageController;

  List<Widget> pageList = [
    const HomePage(),
    const ExpertList(),
    const Center(child: Text(" AI")),
    const Search(),
    const Center(child: Text("Jobs")),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pageList,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: CupertinoTabBar(
          activeColor: Colors.white,
          backgroundColor: Pallete.backgroundColor,
          currentIndex: _page,
          onTap: navigationTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/home.svg',
                    colorFilter: ColorFilter.mode(
                      _page != 0 ? Pallete.greyColor : Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                    height: 26,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: 'Expert',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/gavel.svg',
                    colorFilter: ColorFilter.mode(
                      _page != 1 ? Pallete.greyColor : Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: 'AI',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/ai.svg',
                    colorFilter: ColorFilter.mode(
                      _page != 2 ? Pallete.greyColor : Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/search.svg',
                    colorFilter: ColorFilter.mode(
                      _page != 3 ? Pallete.greyColor : Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: 'Jobs',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/job.svg',
                    colorFilter: ColorFilter.mode(
                      _page != 4 ? Pallete.greyColor : Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
