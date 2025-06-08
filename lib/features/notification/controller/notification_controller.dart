import 'package:adhikar/apis/notification_api.dart';
import 'package:adhikar/models/notification_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
      return NotificationController(
        notificationAPI: ref.watch(notificationAPIProvider),

      );
    });

final getUserNotificationsProvider =
    FutureProvider.family<List<NotificationModel>, String>((ref, userId) async {
      return ref
          .watch(notificationControllerProvider.notifier)
          .getUserNotifications(userId);
    });

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;

  NotificationController({
    required NotificationAPI notificationAPI,
  
  }) : _notificationAPI = notificationAPI,
  
       super(false);

  Future<void> createNotification(NotificationModel notification) async {
    state = true;
    await _notificationAPI.createNotification(notification);
    state = false;
  }

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    return await _notificationAPI.getUserNotifications(userId);
  }

}
