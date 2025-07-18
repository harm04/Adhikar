import 'package:adhikar/features/expert/widgets/expert_list.dart';
import 'package:adhikar/features/home/views/home.dart';
import 'package:adhikar/features/nyaysahayak/views/nyaysahayak.dart';
import 'package:adhikar/features/search/views/search.dart';
import 'package:adhikar/features/showcase/views/showcase_list.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  int _page = 0;
  late PageController pageController;
  late AnimationController _animationController;
  bool _isBottomNavVisible = true;

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

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _animationController.dispose();
  }

  void _hideBottomNav() {
    if (_isBottomNavVisible) {
      setState(() {
        _isBottomNavVisible = false;
      });
      _animationController.forward();
    }
  }

  void _showBottomNav() {
    if (!_isBottomNavVisible) {
      setState(() {
        _isBottomNavVisible = true;
      });
      _animationController.reverse();
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    // Show bottom nav when switching pages
    _showBottomNav();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    // Show bottom nav when user taps navigation
    _showBottomNav();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bottomPadding = mediaQuery.padding.bottom;

    // Check if we have system navigation buttons (3-button mode)
    final hasSystemNavigation = bottomPadding > 0;

    // Responsive sizing
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 400;
    final baseHeight = isSmallScreen ? 70.0 : 80.0;

    final iconSize = isSmallScreen ? 22.0 : (isLargeScreen ? 28.0 : 26.0);
    final fontSize = isSmallScreen ? 9.0 : (isLargeScreen ? 12.0 : 10.0);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            final scrollDelta = scrollInfo.scrollDelta ?? 0.0;

            // Only react to significant scroll movements
            if (scrollDelta.abs() > 3.0) {
              if (scrollDelta > 0 && _isBottomNavVisible) {
                // Scrolling down - hide bottom nav
                _hideBottomNav();
              } else if (scrollDelta < 0 && !_isBottomNavVisible) {
                // Scrolling up - show bottom nav
                _showBottomNav();
              }
            }
          }
          return false;
        },
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: pageList,
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isBottomNavVisible ? null : 0,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animationController.value * 100),
              child: Container(
                decoration: BoxDecoration(
                  color: Pallete.backgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: Pallete.greyColor.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Container(
                    height: baseHeight,
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: hasSystemNavigation ? 8 : 16,
                    ),
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
              ),
            );
          },
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

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigationTapped(index),
          borderRadius: BorderRadius.circular(12),
          splashColor: Pallete.whiteColor.withOpacity(0.1),
          highlightColor: Pallete.whiteColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Pallete.whiteColor : Pallete.greyColor,
                    BlendMode.srcIn,
                  ),
                  height: iconSize,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Pallete.whiteColor : Pallete.greyColor,
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
