// ignore_for_file: unused_result

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:adhikar/features/auth/controllers/auth_controller.dart';

class CheckInternet extends ConsumerStatefulWidget {
  final Widget child;
  final Future<void> Function()? onTryAgain;
  const CheckInternet({super.key, required this.child, this.onTryAgain});

  @override
  ConsumerState<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends ConsumerState<CheckInternet> {
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange
        .listen((event) async {
          final hasInternet = event == InternetStatus.connected;
          if (isConnectedToInternet != hasInternet) {
            setState(() {
              isConnectedToInternet = hasInternet;
            });

            if (hasInternet) {
              // Refresh providers only if the internet connection is restored
              ref.refresh(currentUserAccountProvider);
              ref.refresh(currentUserDataProvider);
            }
          }
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
    if (isConnectedToInternet != hasInternet) {
      setState(() {
        isConnectedToInternet = hasInternet;
      });

      if (hasInternet) {
        // ignore: unused_result
        ref.refresh(currentUserAccountProvider);
        ref.refresh(currentUserDataProvider);
      }
    }
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
