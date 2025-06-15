import 'package:adhikar/common/widgets/webview_page.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/settings/widget/my_account.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    void signout() {
      ref.read(authControllerProvider.notifier).signout(context,ref);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      bottomNavigationBar: BottomAppBar(
        color: Pallete.backgroundColor,
        child: Column(
          children: [
            Text(
              'Signed in using ${currentUser.email}',
              style: TextStyle(color: Pallete.whiteColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Pallete.whiteColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyAccount();
                    },
                  ),
                ),
                child: customRow('assets/svg/profile.svg', 'My Account'),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      url: 'https://forms.gle/826x3NnDgAcVLRvp7',
                      appBarText: 'Feedback',
                    ),
                  ),
                ),
                child: customRow(
                  'assets/svg/feedback.svg',
                  'Feedback & Support',
                ),
              ),
              customRow('assets/svg/faq.svg', 'FAQs'),
              customRow('assets/svg/lock.svg', 'Privacy Policy'),
              customRow('assets/svg/terms_of_service.svg', 'Terms of Service'),
              customRow('assets/svg/about.svg', 'About Adhikar'),
              customRow('assets/svg/share.svg', 'Share App'),
              GestureDetector(
                onTap: () => signout(),
                child: customRow('assets/svg/logout.svg', 'Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow(String svgPath, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          SvgPicture.asset(
            svgPath,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
          ),
          SizedBox(width: 17),
          Text(
            title,
            style: TextStyle(color: Pallete.whiteColor, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
