import 'package:adhikar/common/widgets/webview_page.dart';
import 'package:adhikar/common/widgets/theme_toggle.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/settings/widget/my_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    void signout() {
      ref.read(authControllerProvider.notifier).signout(context, ref);
    }

    Future<void> launchPrivacyPolicy() async {
      final Uri url = Uri.parse(
        'https://adhikarnotification.web.app/privacy-policy',
      );
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        // Show error if URL can't be launched
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Privacy Policy')),
          );
        }
      }
    }

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  signout(); // Proceed with logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Text(
              'Signed in using ${currentUser.email}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 14),
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
              // Theme Toggle Section
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioThemeToggle(),
                  ],
                ),
              ),

              // Divider
              Divider(color: Theme.of(context).dividerColor, thickness: 1),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return  MyAccount();
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
              GestureDetector(
                onTap: () => launchPrivacyPolicy(),
                child: customRow('assets/svg/lock.svg', 'Privacy Policy'),
              ),
              customRow('assets/svg/terms_of_service.svg', 'Terms of Service'),
              customRow('assets/svg/about.svg', 'About Adhikar'),
              customRow('assets/svg/share.svg', 'Share App'),
              GestureDetector(
                onTap: () => showLogoutDialog(),
                child: customRow('assets/svg/logout.svg', 'Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow(String svgPath, String title) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 17),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
