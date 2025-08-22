import 'dart:io';
import 'dart:convert';
import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';
import 'package:adhikar/features/message/views/messaging.dart';
import 'package:adhikar/features/news/widget/news_list.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/features/showcase/views/showcase.dart';
import 'package:adhikar/providers/open_chat_provider.dart';
import 'package:adhikar/main.dart' as main; // Import for navigator key
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:adhikar/features/home/views/home.dart';
import 'package:adhikar/features/notification/views/notifications.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Flag to track if notifications are initialized
  static bool _isInitialized = false;

  //request notification permission from user
  static void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      Future.delayed(Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  //get the token for the device
  static Future<String?> getToken() async {
    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );
    String? token = await messaging.getToken();
    print("token=> $token");
    return token!;
  }

  //firebase init
  static void firebaseInit(BuildContext context, WidgetRef ref) {
    print("🔧 Initializing Firebase messaging listeners");

    // Set foreground notification presentation options for iOS
    if (Platform.isIOS) {
      iosForgroundNotification();
    }

    FirebaseMessaging.onMessage.listen((message) {
      print("📨 Received foreground message: ${message.notification?.title}");
      final openChatUserId = ref.read(openChatUserIdProvider);
      final senderId = message.data['senderId'];

      // Suppress notification if user is viewing this chat
      if (message.data['screen'] == 'chat' && openChatUserId == senderId) {
        print("🚫 Suppressing notification - user is viewing this chat");
        return;
      }

      RemoteNotification? notification = message.notification;
      if (kDebugMode) {
        print("notification title: ${notification!.title}");
        print("notification body: ${notification.body}");
        print("notification data: ${message.data}");
      }

      // Always show our custom notification for foreground messages
      print("📱 Processing foreground notification");
      showNotification(message);
    });
  }

  // Initialize notifications with tap handler
  static Future<void> _initializeNotifications() async {
    if (_isInitialized) return;

    var androidInitSettings = const AndroidInitializationSettings(
      'logo_transaprent',
    );
    var iosInitSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    // Set up the callback for notification taps
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Parse the payload to get navigation data
        if (response.payload != null) {
          _handleNotificationTap(response.payload!);
        }
      },
    );
    _isInitialized = true;
    print("📱 Initialized local notifications with tap handler");
  }

  // Global method to handle notification tap
  static void _handleNotificationTap(String payload) {
    print("🔔 Notification tapped with payload: $payload");

    // Parse the JSON payload to get screen navigation data
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final String? screen = data['screen'];

      print("🎯 Parsed screen from payload: $screen");
      print("📊 Full data: $data");

      // Use the global navigator key to navigate
      _navigateToScreenWithGlobalKey(screen, data);
    } catch (e) {
      print("❌ Error parsing notification payload: $e");
      print("📝 Raw payload was: $payload");
    }
  }

  // Navigate to screen using global navigator key
  static void _navigateToScreenWithGlobalKey(
    String? screen,
    Map<String, dynamic> data,
  ) {
    print("🧭 Navigating to screen: $screen with data: $data");

    // Get the current context from the global navigator key
    final BuildContext? context = main.navigatorKey.currentState?.context;

    if (context == null) {
      print("❌ No context available for navigation");
      print("🔍 Navigator key state: ${main.navigatorKey.currentState}");
      return;
    }

    print("✅ Context available, proceeding with navigation");

    // Navigate based on screen type
    switch (screen) {
      case 'notification':
        print("📱 Navigating to Notifications screen");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notifications()),
        );
        break;
      case 'home':
        print("🏠 Navigating to Home screen");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
        break;
      case 'news':
        print("📰 Navigating to News screen");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsList()),
        );
        break;
      default:
        print("🏠 Default navigation to Home screen");
        // Default to home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
        break;
    }
  }

  // Method to display notification with proper icon and navigation
  static Future<void> showNotification(RemoteMessage message) async {
    print(
      "📱 showNotification called with message: ${message.notification?.title}",
    );

    // Ensure initialization
    if (!_isInitialized) {
      await _initializeNotifications();
    }

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'adhikar_channel', // Use consistent channel ID
      'Adhikar Notifications', // Channel name
      description: 'High importance notifications for Adhikar app',
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      showBadge: true,
      enableVibration: true,
    );

    // Create the notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    String? imageUrl =
        message.notification?.android?.imageUrl ?? message.data['image'];

    AndroidNotificationDetails androidNotificationDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Download the image to a local file
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/notification_image.jpg';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final bigPicture = BigPictureStyleInformation(
        FilePathAndroidBitmap(filePath),
        contentTitle: message.notification!.title,
        summaryText: message.notification!.body,
      );
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: channel.description.toString(),
        styleInformation: bigPicture,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: channel.sound,
        icon: 'logo_transaprent',
      );
    } else {
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: channel.description.toString(),
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: channel.sound,
        icon: 'logo_transaprent',
      );
    }

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      print(
        "📱 Attempting to show notification: ${message.notification?.title}",
      );
      print("📊 Message data: ${message.data}");

      // Create payload with navigation data
      final payload = jsonEncode(message.data);
      print("🎯 Created payload: $payload");

      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: payload, // Add the payload here
      );
      print("📱 Notification show request completed with payload: $payload");
    });
  }

  //background notification
  static Future<void> backgroundNotification(
    BuildContext context,
    WidgetRef ref,
  ) async {
    //background message handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message, ref); // Pass ref here
    });
    //terminated message handler
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message, ref); // Pass ref here
      }
    });
  }

  //handle message
  static Future<void> handleMessage(
    BuildContext context,
    RemoteMessage message,
    WidgetRef ref, // <-- Add this
  ) async {
    if (message.data['screen'] == 'notification') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Notifications()),
      );
    } else if (message.data['screen'] == 'home') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (message.data['screen'] == 'Showcase' &&
        message.data['showcaseId'] != null) {
      final showcaseId = message.data['showcaseId'];
      final showcaseModel = await ref.read(
        singleShowcaseProvider(showcaseId).future,
      );

      if (showcaseModel != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Showcase(showcaseModel: showcaseModel),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Showcase not found')));
      }
    } else if (message.data['screen'] == 'Post' &&
        message.data['PostId'] != null) {
      final postId = message.data['postId'];
      final postModal = await ref.read(singlePostProvider(postId).future);

      if (postModal != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCard(postmodel: postModal),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post not found')));
      }
    } else if (message.data['screen'] == 'chat') {
      final senderId = message.data['senderId'];

      final currentUserId = ref.read(currentUserDataProvider).value?.uid;

      final currentUserFuture = ref.read(
        userDataByIdProvider(currentUserId!).future,
      );
      final peerUserFuture = ref.read(userDataByIdProvider(senderId).future);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      Future.wait([currentUserFuture, peerUserFuture]).then((users) {
        Navigator.pop(context);

        final currentUser = users[0];
        final peerUser = users[1];

        if (currentUser != null && peerUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MessagingScreen(currentUser: currentUser, peerUser: peerUser),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User not found')));
        }
      });
    } else if (message.data['screen'] == 'news') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsList()),
      );
    } else {
      // Handle other screens or default action
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    }
  }

  //ios foreground notification
  static Future iosForgroundNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
