import 'package:flutter/material.dart';
import 'package:adhikar/features/admin/services/get_server_key.dart';
import 'package:adhikar/features/admin/services/send_notification_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NotificationTestScreen());
  }
}

class NotificationTestScreen extends StatefulWidget {
  @override
  _NotificationTestScreenState createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  String _result = 'Ready to test...';
  bool _isLoading = false;

  Future<void> testServerKey() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing server key...';
    });

    try {
      final serverKey = await GetServerKey().getServerkeyToken();
      setState(() {
        _result =
            'Server key obtained successfully!\nLength: ${serverKey.length} characters\nFirst 50 chars: ${serverKey.substring(0, 50)}...';
      });
    } catch (e) {
      setState(() {
        _result = 'Server key test failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> testNotificationSend() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing notification to topic...';
    });

    try {
      await SendNotificationService.sendNotificationToTopic(
        topic: 'all_users',
        title: 'Test Notification',
        body: 'This is a test notification from admin panel',
        data: {'screen': 'home'},
        imageUrl: null,
      );
      setState(() {
        _result = 'Test notification sent successfully to all_users topic!';
      });
    } catch (e) {
      setState(() {
        _result = 'Test notification failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Debug')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : testServerKey,
              child: Text('Test Server Key'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : testNotificationSend,
              child: Text('Test Notification Send'),
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
