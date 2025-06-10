import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/auth/views/signin.dart';
import 'package:adhikar/features/expert/views/expert_verification.dart';
import 'package:adhikar/features/admin/views/side_nav.dart';
import 'package:adhikar/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Adhikar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: ref
          .watch(currentUserAccountProvider)
          .when(
            data: (user) {
              if (user != null) {
                final currentUserAsyncValue = ref.watch(
                  currentUserDataProvider,
                );
                return currentUserAsyncValue.when(
                  data: (currentUser) {
                    if (currentUser != null) {
                      
                      if (currentUser.email == 'admin@gmail.com' &&
                          currentUser.password == 'asdfghjkl') {
                        return SideNav();
                      }
                      return currentUser.userType == 'User' ||
                              currentUser.userType == 'Expert'
                          ? BottomNavBar()
                          : ExpertVerification();
                    } else {
                      return SignInScreen();
                    }
                  },
                  loading: () => Loader(),
                  error: (err, st) => ErrorText(error: err.toString()),
                );
              } else {
                return const SignInScreen();
              }
            },
            error: (err, st) {
              return ErrorText(error: err.toString());
            },
            loading: () {
              return Loader();
            },
          ),
    );
  }
}
