import 'dart:convert';

import 'package:adhikar/features/admin/services/get_server_key.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingAPI({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    String url =
        'https://fcm.googleapis.com/v1/projects/adhikarnotification/messages:send';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': ' Bearer $serverKey',
    };

    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data,
      },
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("notification sent successfully");
    } else {
      print("Failed to send notification: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to send notification');
    }
  }

  
  //send notification to a topic
  static Future<void> sendNotificationToTopic({
    required String topic,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    String url =
        'https://fcm.googleapis.com/v1/projects/adhikarnotification/messages:send';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': ' Bearer $serverKey',
    };

    Map<String, dynamic> message = {
      "message": {
        "topic": topic,
        "notification": {"body": body, "title": title},
        "data": data,
      },
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
}
