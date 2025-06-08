import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/notification/controller/notification_controller.dart';
import 'package:adhikar/models/message_modal.dart';
import 'package:adhikar/apis/messaging_api.dart';
import 'package:adhikar/models/notification_modal.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as ref;

final messagingControllerProvider = Provider((ref) {
  return MessagingController(ref.watch(messagingAPIProvider));
});

class MessagingController {
  final MessagingAPI _api;
  MessagingController(this._api);

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
     required WidgetRef ref,
  }) async {
    final message = MessageModel(
      id: '', // Let Appwrite generate the ID
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );
    await _api.sendMessage(message);
final notification = NotificationModel(
    id: '',
    userId: receiverId,
    senderId: senderId,
    type: 'message',
    messageId: message.id,
    title: 'New Message',
    body: 'You have received a new message.',
    createdAt: DateTime.now(),
    isRead: false,
    extraData: {'text': text},
  );
  await ref.read(notificationControllerProvider.notifier).createNotification(notification);

  }

  Stream<List<MessageModel>> getMessages(String userId, String peerId) {
    return _api.getMessages(userId, peerId);
  }

  Future<List<Map<String, dynamic>>> getUserConversations(String userId) {
    return _api.getUserConversations(userId);
  }

  Stream<List<Map<String, dynamic>>> getUserConversationsStream(String userId) {
    return _api.getUserConversationsStream(userId);
  }

  Future<void> markMessagesAsRead(String currentUserId, String peerId) async {
    await _api.markMessagesAsRead(currentUserId, peerId);
  }
}

final userDataByIdProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  // Use your existing logic to fetch user by ID
  return ref.read(authControllerProvider.notifier).getUserData(userId);
});
