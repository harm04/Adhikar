import 'dart:io' show Platform;
import 'package:adhikar/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/check_internet.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/splash_screnn.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/auth/views/signin.dart';
import 'package:adhikar/features/expert/views/expert_verification.dart';
import 'package:adhikar/features/admin/views/side_nav.dart';
import 'package:adhikar/theme/app_theme.dart';
import 'package:adhikar/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/features/admin/services/notification_service.dart';

// Global navigator key for handling navigation from notifications
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('🔔 Background message received: ${message.notification?.title}');
  print('📊 Background message data: ${message.data}');

  // Show notification directly using static method with proper navigation payload
  await NotificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _showSplash = true;
  static bool _fcmTokenUpdated =
      false; // Static flag to prevent multiple updates across rebuilds

  void _finishSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // Check if app was launched from a notification
    _checkForInitialMessage();

    // Listen for notification taps (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 App opened from notification: ${message.data}");
      NotificationService.handleMessage(context, message, ref);
    });

    // Initialize notification service
    Future.delayed(Duration(seconds: 1), () {
      NotificationService.requestNotificationPermission();
      NotificationService.firebaseInit(context, ref);
    });
  }

  // Check if app was launched from a notification
  void _checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      print("🚀 App launched from notification: ${initialMessage.data}");
      // Handle the initial message after app is fully loaded
      Future.delayed(Duration(seconds: 2), () {
        NotificationService.handleMessage(context, initialMessage, ref);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(onFinish: _finishSplash),
      );
    }
    return MaterialApp(
      title: 'Adhikar',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Add this line
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
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
                          // --- FCM topic subscription logic ---
                          if (!kIsWeb &&
                              (Platform.isAndroid || Platform.isIOS)) {
                            if (currentUser.userType == 'Expert') {
                              FirebaseMessaging.instance.subscribeToTopic(
                                'all_experts',
                              );
                            } else if (currentUser.userType == 'User') {
                              FirebaseMessaging.instance.subscribeToTopic(
                                'all_users',
                              );
                              FirebaseMessaging.instance.unsubscribeFromTopic(
                                'all_experts',
                              );
                            }
                            // Update FCM token only once per app session
                            if (!_fcmTokenUpdated) {
                              _fcmTokenUpdated = true;
                              Future.delayed(Duration(seconds: 2), () {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .updateFCMToken(currentUser.uid);
                              });
                            }
                          }
                          // --- End FCM topic subscription logic ---

                          if (currentUser.email == 'admin@gmail.com' &&
                              currentUser.password == 'asdfghjkl') {
                            return const SideNav();
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
                    return SignInScreen();
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
