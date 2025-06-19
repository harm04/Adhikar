// import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
// import 'package:adhikar/common/widgets/error.dart';
// import 'package:adhikar/common/widgets/loader.dart';
// import 'package:adhikar/features/auth/controllers/auth_controller.dart';
// import 'package:adhikar/features/auth/views/signin.dart';
// import 'package:adhikar/features/admin/views/side_nav.dart';
// import 'package:adhikar/models/user_model.dart';
// import 'package:adhikar/theme/app_theme.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// void main() {
//   runApp(ProviderScope(child: const MyApp()));
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Add a static flag to track dialog state
//     final ValueNotifier<bool> dialogShown = ValueNotifier(false);

//     return MaterialApp(
//       title: 'Adhikar',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.theme,
//       home: FutureBuilder(
//         future: SharedPreferences.getInstance(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Loader();
//           final prefs = snapshot.data as SharedPreferences;
//           return ref
//               .watch(currentUserAccountProvider)
//               .when(
//                 data: (user) {
//                   if (user != null) {
//                     final currentUserAsyncValue = ref.watch(
//                       currentUserDataProvider,
//                     );
//                     return currentUserAsyncValue.when(
//                       data: (currentUser) {
//                         if (currentUser != null) {
//                           if (currentUser.email == 'admin@gmail.com' &&
//                               currentUser.password == 'asdfghjkl') {
//                             return SideNav();
//                           }
//                           return BottomNavBar();
//                         } else {
//                           // No internet but session exists, try cached user
//                           final cachedUserStr = prefs.getString('cached_user');
//                           if (cachedUserStr != null) {
//                             if (!dialogShown.value) {
//                               dialogShown.value = true;
//                               WidgetsBinding.instance.addPostFrameCallback((_) {
//                                 showNoInternetDialog(context, () async {
//                                   final connectivityResult =
//                                       await Connectivity().checkConnectivity();
//                                   if (connectivityResult !=
//                                       ConnectivityResult.none) {
//                                     Navigator.of(context).pop();
//                                     dialogShown.value = false;
//                                     (context as Element).reassemble();
//                                   }
//                                   // If still no internet, dialog stays open
//                                 });
//                               });
//                             }
//                             final cachedUser = UserModel.fromMap(
//                               jsonDecode(cachedUserStr),
//                             );
//                             if (cachedUser.email == 'admin@gmail.com' &&
//                                 cachedUser.password == 'asdfghjkl') {
//                               return SideNav();
//                             }
//                             return BottomNavBar();
//                           }
//                           return SignInScreen();
//                         }
//                       },
//                       loading: () => Loader(),
//                       error: (err, st) {
//                         // No internet but session exists, try cached user
//                         final cachedUserStr = prefs.getString('cached_user');
//                         if (cachedUserStr != null) {
//                           if (!dialogShown.value) {
//                             dialogShown.value = true;
//                             WidgetsBinding.instance.addPostFrameCallback((_) {
//                               showNoInternetDialog(context, () async {
//                                 final connectivityResult = await Connectivity()
//                                     .checkConnectivity();
//                                 if (connectivityResult !=
//                                     ConnectivityResult.none) {
//                                   Navigator.of(context).pop();
//                                   dialogShown.value = false;
//                                   (context as Element).reassemble();
//                                 }
//                                 // If still no internet, dialog stays open
//                               });
//                             });
//                           }
//                           final cachedUser = UserModel.fromMap(
//                             jsonDecode(cachedUserStr),
//                           );
//                           if (cachedUser.email == 'admin@gmail.com' &&
//                               cachedUser.password == 'asdfghjkl') {
//                             return SideNav();
//                           }
//                           return BottomNavBar();
//                         }
//                         return SignInScreen();
//                       },
//                     );
//                   } else {
//                     // No session, check for cached user
//                     final cachedUserStr = prefs.getString('cached_user');
//                     if (cachedUserStr != null) {
//                       if (!dialogShown.value) {
//                         dialogShown.value = true;
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           showNoInternetDialog(context, () async {
//                             final connectivityResult = await Connectivity()
//                                 .checkConnectivity();
//                             if (connectivityResult != ConnectivityResult.none) {
//                               Navigator.of(context).pop();
//                               dialogShown.value = false;
//                               (context as Element).reassemble();
//                             }
//                             // If still no internet, dialog stays open
//                           });
//                         });
//                       }
//                       final cachedUser = UserModel.fromMap(
//                         jsonDecode(cachedUserStr),
//                       );
//                       if (cachedUser.email == 'admin@gmail.com' &&
//                           cachedUser.password == 'asdfghjkl') {
//                         return SideNav();
//                       }
//                       return BottomNavBar();
//                     }
//                     return SignInScreen();
//                   }
//                 },
//                 error: (err, st) => ErrorText(error: err.toString()),
//                 loading: () => Loader(),
//               );
//         },
//       ),
//     );
//   }
// }

// void showNoInternetDialog(
//   BuildContext context,
//   Future<void> Function() onTryAgain,
// ) {
// showDialog(
//   context: context,
//   barrierDismissible: false,
//   builder: (_) => AlertDialog(
//     title: Text('No Internet'),
//     content: Text('Please connect to the internet.'),
//     actions: [
//       TextButton(
//         onPressed: () async {
//           await onTryAgain();
//         },
//         child: Text('Try Again'),
//       ),
//     ],
//   ),
// );
// }

import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
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
                      if (currentUser.email == 't2@gmail.com' &&
                          currentUser.password == 'harshmali') {
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
