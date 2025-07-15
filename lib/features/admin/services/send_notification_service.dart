import 'dart:convert';

import 'package:adhikar/features/admin/services/get_server_key.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:appwrite/appwrite.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingAPI({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
    String? imageUrl,
    String? userId, // Add userId parameter for token cleanup
  }) async {
    // Skip if token is null or empty
    if (token == null || token.isEmpty) {
      print("❌ Skipping notification: FCM token is null or empty");
      return;
    }

    String serverKey = await GetServerKey().getServerKeyToken();
    String url =
        'https://fcm.googleapis.com/v1/projects/adhikarnotification/messages:send';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': ' Bearer $serverKey',
    };

    Map<String, dynamic> notification = {
      "body": body,
      "title": title,
      if (imageUrl != null && imageUrl.isNotEmpty) "image": imageUrl,
    };

    Map<String, dynamic> message = {
      "message": {"token": token, "notification": notification, "data": data},
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print(
        "✅ Notification sent successfully to token: ${token.substring(0, 20)}...",
      );
    } else {
      print("❌ Failed to send notification: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Check if token is unregistered and clean it up
      if (response.body.contains("UNREGISTERED") && userId != null) {
        print("🧹 Cleaning up unregistered FCM token for user: $userId");
        await _cleanupInvalidToken(userId);
      }

      throw Exception('Failed to send notification');
    }
  }

  // Helper method to clean up invalid FCM tokens
  static Future<void> _cleanupInvalidToken(String userId) async {
    try {
      print("⚠️ Invalid FCM token detected for user: $userId");

      // Create Appwrite client with proper configuration
      final client = Client()
        ..setEndpoint('https://cloud.appwrite.io/v1')
        ..setProject('adhikarnotification');

      final UserAPI userAPI = UserAPI(
        db: Databases(client),
        realtime: Realtime(client),
      );

      await userAPI.clearFCMToken(userId);
      print("✅ Successfully cleared invalid FCM token for user: $userId");
      print("💡 User will get a fresh token on next app launch");
    } catch (e) {
      print("❌ Failed to cleanup invalid token for user $userId: $e");
    }
  }

  //send notification to a topic
  static Future<void> sendNotificationToTopic({
    required String topic,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    String url =
        'https://fcm.googleapis.com/v1/projects/adhikarnotification/messages:send';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': ' Bearer $serverKey',
    };

    Map<String, dynamic> notification = {
      "body": body,
      "title": title,
      if (imageUrl != null && imageUrl.isNotEmpty) "image": imageUrl,
    };

    Map<String, dynamic> message = {
      "message": {"topic": topic, "notification": notification, "data": data},
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("notification sent to topic successfully");
    } else {
      print("Failed to send notification to topic: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to send notification to topic');
    }
  }

  // Debug method to test FCM token validity
  static Future<bool> testTokenValidity({required String token}) async {
    try {
      String serverKey = await GetServerKey().getServerKeyToken();
      String url =
          'https://fcm.googleapis.com/v1/projects/adhikarnotification/messages:send';
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': ' Bearer $serverKey',
      };

      // Send a minimal test message
      Map<String, dynamic> message = {
        "message": {
          "token": token,
          "data": {"test": "validation"},
        },
      };

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("FCM Token is valid: ${token.substring(0, 20)}...");
        return true;
      } else {
        print("FCM Token is invalid: ${response.statusCode}");
        print("Response: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error testing FCM token: $e");
      return false;
    }
  }
}
