import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/message_modal.dart';
import 'package:adhikar/apis/messaging_api.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/features/admin/services/send_notification_service.dart';
import 'package:adhikar/providers/open_chat_provider.dart'; // Import the provider

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
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );
    await _api.sendMessage(message);

    final receiverUser = await ref.read(
      userDataByIdProvider(receiverId).future,
    );
    final senderUser = await ref.read(userDataByIdProvider(senderId).future);
    if (receiverUser != null &&
        receiverUser.fcmToken != null &&
        receiverUser.fcmToken.isNotEmpty) {
      await SendNotificationService.sendNotificationUsingAPI(
        token: receiverUser.fcmToken,
        title: '${senderUser!.firstName} sent a message',
        body: text,
        data: {
          "screen": "chat",
          "senderId": senderId,
          "receiverId": receiverId,
          "messageId": message.id,
        },
      );
    }
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

  Future<int> getUnseenChatsCount(String userId) {
    return _api.getUnseenChatsCount(userId);
  }

  Stream<int> getUnseenChatsCountStream(String userId) {
    return _api.getUnseenChatsCountStream(userId);
  }
}

final userDataByIdProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  // Use your existing logic to fetch user by ID
  return ref.read(authControllerProvider.notifier).getUserData(userId);
});

final unseenChatsCountProvider = StreamProvider.family<int, String>((
  ref,
  userId,
) {
  return ref
      .read(messagingControllerProvider)
      .getUnseenChatsCountStream(userId);
});
