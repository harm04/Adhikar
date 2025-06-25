import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/check_internet.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/splash_screnn.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/auth/views/signin.dart';
import 'package:adhikar/features/expert/views/expert_verification.dart';
import 'package:adhikar/features/admin/views/side_nav.dart';
import 'package:adhikar/firebase_options.dart';
import 'package:adhikar/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // PushNotificationController().initializeNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _showSplash = true;

  void _finishSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(onFinish: _finishSplash),
      );
    }
    return MaterialApp(
      title: 'Adhikar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: Scaffold(
        body: CheckInternet(
          child: ref
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
        ),
      ),
    );
  }
}
