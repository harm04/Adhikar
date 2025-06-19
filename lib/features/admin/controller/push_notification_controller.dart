// // import 'dart:convert';

// // import 'package:adhikar/constants/appwrite_constants.dart';
// // import 'package:adhikar/providers/provider.dart';
// // import 'package:appwrite/appwrite.dart';
// // import 'package:appwrite/enums.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // final pushNotificationProvider =
// //     StateNotifierProvider<PushNotificationController, bool>((ref) {
// //       return PushNotificationController(ref.watch(appwriteFunctionsProvider));
// //     });

// // class PushNotificationController extends StateNotifier<bool> {
// //   final Functions _functions;

// //   PushNotificationController(this._functions) : super(false);

// //   void sendNotification() async {
// //     try {
// //       final token = await FirebaseMessaging.instance.getToken();
// //       print(token);
// //       if (token == null) {
// //         print('FCM token is null');
// //         return;
// //       }
// //       final Map<String, dynamic> requestBody = {
        
// //         'deviceToken': token,
// //         'message': {'title': 'Notification Title', 'body': 'Notification Body'},
// //       };
// //       final result = await _functions.createExecution(
// //         functionId: AppwriteConstants.functionId,
// //         body: jsonEncode(requestBody),
// //         path: '/',
// //         method: ExecutionMethod.pOST,
// //         headers: {'Content-Type': 'application/json'},
// //       );
// //     } catch (e) {
// //       print(e);
// //     }
// //   }

// //   Future<void> requestAndCheckNotificationPermissions() async {
// //     state = true;

// //     // Request permission
// //     NotificationSettings settings = await FirebaseMessaging.instance
// //         .requestPermission(alert: true, badge: true, sound: true);

// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print('User granted permission');
// //       // Continue with your notification logic
// //     } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
// //       print('User denied permission');
// //       // Handle denied case
// //     } else if (settings.authorizationStatus ==
// //         AuthorizationStatus.provisional) {
// //       print('User granted provisional permission');
// //       // Handle provisional permission
// //     } else if (settings.authorizationStatus ==
// //         AuthorizationStatus.notDetermined) {
// //       print('Permission not determined yet');
// //     }

// //     state = false;
// //   }

// //   void openAppSettings() {
// //     // For Android/iOS, use appropriate packages
// //     // For web, show instructions to the user
// //     print('Please enable notifications in your browser settings');
// //   }
// // }


// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('Handling background message: ${message.messageId}');
// }

// class PushNotificationController {
//   static final PushNotificationController _instance = PushNotificationController._internal();

//   factory PushNotificationController() {
//     return _instance;
//   }

//   late final FlutterLocalNotificationsPlugin _localNotifications;
//   late final FirebaseMessaging _firebaseMessaging;

//   PushNotificationController._internal() {
//     _localNotifications = FlutterLocalNotificationsPlugin();
//     _firebaseMessaging = FirebaseMessaging.instance;
//     initializeNotifications();
//   }

//   Future<void> initializeNotifications() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

//     // Initialize local notifications
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );

//     await _localNotifications.initialize(
//       const InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       ),
//       onDidReceiveNotificationResponse: _handleNotificationTap,
//     );

//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTapBackground);
//   }

//   void _handleNotificationTap(NotificationResponse response) {
//     debugPrint('Notification tapped: ${response.payload}');
//   }

//   void _handleNotificationTapBackground(RemoteMessage message) {
//     debugPrint('Background notification tapped: ${message.messageId}');
//   }

//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     debugPrint('Received foreground message: ${message.messageId}');

//     await _showLocalNotification(
//       title: message.notification?.title ?? 'New Message',
//       body: message.notification?.body ?? '',
//       payload: message.data.toString(),
//     );
//   }

//   Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default Channel',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     await _localNotifications.show(
//       DateTime.now().millisecond,
//       title,
//       body,
//       const NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       ),
//       payload: payload,
//     );
//   }

//   Future<String?> getFCMToken() async {
//     return await _firebaseMessaging.getToken();
//   }
// }