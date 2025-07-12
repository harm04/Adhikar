import 'package:adhikar/features/posts/controllers/hybrid_likes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage hybrid likes system initialization
final hybridLikesProvider = Provider<void>((ref) {
  // Access the controller to initialize it
  final hybridLikesController = ref.watch(hybridLikesControllerProvider);

  // Set up a listener to force sync on app pause/resume
  WidgetsBinding.instance.addObserver(
    _AppLifecycleObserver(hybridLikesController),
  );

  return;
});

/// Observer to sync likes when app goes to background or resumes
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final HybridLikesController _controller;

  _AppLifecycleObserver(this._controller);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // App going to background, try to sync immediately
      _controller.forceSyncWithServer();
    } else if (state == AppLifecycleState.resumed) {
      // App coming to foreground, sync again to get latest data
      _controller.forceSyncWithServer();
    }
  }
}
