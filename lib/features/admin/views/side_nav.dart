import 'package:adhikar/features/admin/views/admin_expert_list.dart';
import 'package:adhikar/features/admin/views/admin_home.dart';
import 'package:adhikar/features/admin/views/admin_push_notification.dart';
import 'package:adhikar/features/admin/views/admin_withdraw_list.dart';
import 'package:adhikar/features/admin/views/token_management.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  int selectedIndex = 0; // Add this to track selected menu

  // Example pages for demonstration
  final List<Widget> pages = [
    AdminHome(),
    AdminExpertList(),
    AdminWithdrawList(),
    Center(child: Text('Meetings Page', style: TextStyle(fontSize: 32))),
    AdminPushNotification(),
    TokenManagement(), // Add token management page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 2, 38, 68),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30, // Reduced from 40
                                  backgroundImage: AssetImage(
                                    'assets/images/logo.png',
                                  ),
                                ),
                                const SizedBox(width: 8), // Reduced from 10
                                Flexible(
                                  // Added Flexible to prevent overflow
                                  child: Text(
                                    'Adhikar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24, // Reduced from 30
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Main Menu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildListTile('Home', 'assets/svg/home.svg', 0),
                      buildListTile('Expert', 'assets/svg/gavel.svg', 1),
                      buildListTile(
                        'Payment',
                        'assets/svg/payment_success.svg',
                        2,
                      ),
                      buildListTile('Meetings', 'assets/svg/meetings.svg', 3),
                      buildListTile(
                        'Notifications',
                        'assets/svg/notification.svg',
                        4,
                      ),
                      buildListTile(
                        'Token Management',
                        'assets/svg/gavel.svg', // You can use a different icon
                        5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                child: pages[selectedIndex], // Show selected page
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(String title, String asset, int index) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: selectedIndex == index
            ? Pallete.primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: ListTile(
          visualDensity: VisualDensity(vertical: -4),
          dense: true,
          leading: SvgPicture.asset(
            asset,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          selected: selectedIndex == index,
          selectedTileColor: Colors.white24,
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
