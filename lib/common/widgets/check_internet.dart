import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CheckInternet extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onTryAgain;
  const CheckInternet({super.key, required this.child, this.onTryAgain});

  @override
  State<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange
        .listen((event) {
          setState(() {
            isConnectedToInternet = event == InternetStatus.connected;
          });
        });
    // Initial check
    InternetConnection().hasInternetAccess.then((value) {
      setState(() {
        isConnectedToInternet = value;
      });
    });
  }

  Future<void> _tryAgain() async {
    if (widget.onTryAgain != null) {
      await widget.onTryAgain!();
    }
    final hasInternet = await InternetConnection().hasInternetAccess;
    setState(() {
      isConnectedToInternet = hasInternet;
    });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isConnectedToInternet) {
      return widget.child;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: _tryAgain,
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
