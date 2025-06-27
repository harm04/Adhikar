import 'dart:io';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';
import 'package:adhikar/features/message/views/messaging.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/features/showcase/views/showcase.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/open_chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:adhikar/features/home/views/home.dart';
import 'package:adhikar/features/notification/views/notifications.dart';
import 'package:adhikar/features/showcase/views/showcase_list.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //request notification permission from user
  void requestNotificationPermission() async {
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
  Future<String?> getToken() async {
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

  //init firebase messaging
  void initLocalNotification(
    BuildContext context,
    RemoteMessage message,
    WidgetRef ref,
  ) async {
    var androidInitSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosInitSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message, ref); // Now ref is available here!
      },
    );
  }

  //firebase init
  void firebaseInit(BuildContext context, WidgetRef ref) {
    FirebaseMessaging.onMessage.listen((message) {
      final openChatUserId = ref.read(openChatUserIdProvider);
      final senderId = message.data['senderId'];

      // Suppress notification if user is viewing this chat
      if (message.data['screen'] == 'chat' && openChatUserId == senderId) {
        return;
      }

      RemoteNotification? notification = message.notification;
      if (kDebugMode) {
        print("notification title: ${notification!.title}");
        print("notification body: ${notification.body}");
      }
      if (Platform.isIOS) {
        iosForgroundNotification();
      }
      if (Platform.isAndroid) {
        initLocalNotification(context, message, ref);
        showNotification(message);
      }
    });
  }

  //function to show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      showBadge: true,
      enableVibration: true,
      
    );

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
        icon: 'logo_transaprent',
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: channel.description.toString(),
        styleInformation: bigPicture,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: channel.sound,
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
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  //background notification
  Future<void> backgroundNotification(
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
  Future<void> handleMessage(
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
        ).showSnackBar(const SnackBar(content: Text('Showcase not found')));
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
    } else {
      // Handle other screens or default action
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  //ios foreground notification
  Future iosForgroundNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
