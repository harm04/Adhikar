import 'package:adhikar/features/expert/widgets/expert_list.dart';
import 'package:adhikar/features/home/views/home.dart';
import 'package:adhikar/features/nyaysahayak/views/nyaysahayak.dart';
import 'package:adhikar/features/search/views/search.dart';
import 'package:adhikar/features/showcase/views/showcase_list.dart';

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
     HomePage(),
     ExpertList(),
     Nyaysahayak(),
     Search(),
    ShowcaseList(),
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Responsive sizing
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 400;
    final baseHeight = isSmallScreen ? 70.0 : 80.0;

    final iconSize = isSmallScreen ? 22.0 : (isLargeScreen ? 28.0 : 26.0);
    final fontSize = isSmallScreen ? 9.0 : (isLargeScreen ? 12.0 : 10.0);

    return PopScope(
      canPop: _page == 0, // Only allow popping if on home page
      onPopInvoked: (didPop) {
        if (!didPop && _page != 0) {
          // If pop was prevented and we're not on home page, navigate to home
          navigationTapped(0);
        }
      },
      child: Scaffold(
        // Allow content to resize when keyboard appears, but nav bar stays fixed
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            // Main content area that will resize with keyboard
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: onPageChanged,
                children: pageList,
              ),
            ),
            // Fixed bottom navigation bar that never moves
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                top: 8,
                bottom: MediaQuery.of(context).viewPadding.bottom + 16,
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                height: baseHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      0,
                      'assets/svg/home.svg',
                      'Home',
                      iconSize,
                      fontSize,
                    ),
                    _buildNavItem(
                      1,
                      'assets/svg/gavel.svg',
                      'Expert',
                      iconSize,
                      fontSize,
                    ),
                    _buildNavItem(
                      2,
                      'assets/svg/ai.svg',
                      'AI',
                      iconSize,
                      fontSize,
                    ),
                    _buildNavItem(
                      3,
                      'assets/svg/search.svg',
                      'Search',
                      iconSize,
                      fontSize,
                    ),
                    _buildNavItem(
                      4,
                      'assets/svg/showcase.svg',
                      'Showcase',
                      iconSize,
                      fontSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String iconPath,
    String label,
    double iconSize,
    double fontSize,
  ) {
    final isSelected = _page == index;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDarkMode ? Colors.white : Theme.of(context).primaryColor;
    final inactiveColor = Colors.grey;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigationTapped(index),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      isSelected ? activeColor : inactiveColor,
                      BlendMode.srcIn,
                    ),
                    height: iconSize,
                  ),
                ),
                const SizedBox(height: 3),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? activeColor : inactiveColor,
                      fontSize: fontSize,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
