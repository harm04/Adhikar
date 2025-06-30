import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/message_modal.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingAPIProvider = Provider((ref) {
  return MessagingAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealTimeProvider),
  );
});

class MessagingAPI {
  final Databases _db;
  final Realtime _realtime;
  MessagingAPI({required Databases db, required Realtime realtime})
    : _db = db,
      _realtime = realtime;

  Future<void> sendMessage(MessageModel message) async {
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.messagesCollectionID,
      documentId: ID.unique(),
      data: message.toMap(),
    );
  }

  Stream<List<MessageModel>> getMessages(String userId, String peerId) async* {
    final channel =
        'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.messagesCollectionID}.documents';

    // Helper to fetch messages
    Future<List<MessageModel>> fetchMessages() async {
      final docs = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.messagesCollectionID,
        queries: [
          Query.or([
            Query.and([
              Query.equal('senderId', userId),
              Query.equal('receiverId', peerId),
            ]),
            Query.and([
              Query.equal('senderId', peerId),
              Query.equal('receiverId', userId),
            ]),
          ]),
          Query.orderDesc('createdAt'),
        ],
      );
      return docs.documents
          .map((doc) => MessageModel.fromMap(doc.data, doc.$id))
          .toList();
    }

    // Initial fetch
    yield await fetchMessages();

    // Listen for realtime updates and re-fetch
    await for (final event in _realtime.subscribe([channel]).stream) {
      // Only react to create/update/delete events
      if (event.events.any(
        (e) =>
            e.contains('databases.*.collections.*.documents.*.create') ||
            e.contains('databases.*.collections.*.documents.*.update') ||
            e.contains('databases.*.collections.*.documents.*.delete'),
      )) {
        yield await fetchMessages();
      }
    }
  }

  Future<List<Map<String, dynamic>>> getUserConversations(String userId) async {
    // Fetch all messages where user is sender or receiver
    final docs = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.messagesCollectionID,
      queries: [
        Query.or([
          Query.equal('senderId', userId),
          Query.equal('receiverId', userId),
        ]),
        Query.orderDesc('createdAt'),
      ],
    );

    // Map to store latest message per peer
    final Map<String, MessageModel> latestMessages = {};

    for (final doc in docs.documents) {
      final msg = MessageModel.fromMap(doc.data, doc.$id);
      final peerId = msg.senderId == userId ? msg.receiverId : msg.senderId;
      if (!latestMessages.containsKey(peerId) ||
          msg.createdAt.isAfter(latestMessages[peerId]!.createdAt)) {
        latestMessages[peerId] = msg;
      }
    }

    // Return list of {peerId, message}
    return latestMessages.entries
        .map((e) => {'peerId': e.key, 'message': e.value})
        .toList();
  }

  Stream<List<Map<String, dynamic>>> getUserConversationsStream(
    String userId,
  ) async* {
    final channel =
        'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.messagesCollectionID}.documents';

    Future<List<Map<String, dynamic>>> fetchConversations() async {
      final docs = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.messagesCollectionID,
        queries: [
          Query.or([
            Query.equal('senderId', userId),
            Query.equal('receiverId', userId),
          ]),
          Query.orderDesc('createdAt'),
        ],
      );

      final Map<String, MessageModel> latestMessages = {};
      for (final doc in docs.documents) {
        final msg = MessageModel.fromMap(doc.data, doc.$id);
        final peerId = msg.senderId == userId ? msg.receiverId : msg.senderId;
        if (!latestMessages.containsKey(peerId) ||
            msg.createdAt.isAfter(latestMessages[peerId]!.createdAt)) {
          latestMessages[peerId] = msg;
        }
      }
      return latestMessages.entries
          .map((e) => {'peerId': e.key, 'message': e.value})
          .toList();
    }

    yield await fetchConversations();

    await for (final event in _realtime.subscribe([channel]).stream) {
      if (event.events.any(
        (e) =>
            e.contains('databases.*.collections.*.documents.*.create') ||
            e.contains('databases.*.collections.*.documents.*.update') ||
            e.contains('databases.*.collections.*.documents.*.delete'),
      )) {
        yield await fetchConversations();
      }
    }
  }

  Future<void> markMessagesAsRead(String currentUserId, String peerId) async {
    final docs = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.messagesCollectionID,
      queries: [
        Query.equal('senderId', peerId),
        Query.equal('receiverId', currentUserId),
        Query.equal('isRead', false),
      ],
    );
    for (final doc in docs.documents) {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.messagesCollectionID,
        documentId: doc.$id,
        data: {'isRead': true},
      );
    }
  }

  // Get count of unseen chats (conversations with unread messages from others)
  Future<int> getUnseenChatsCount(String userId) async {
    final docs = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.messagesCollectionID,
      queries: [
        Query.equal('receiverId', userId), // Messages received by the user
        Query.equal('isRead', false), // Only unread messages
        Query.orderDesc('createdAt'),
      ],
    );

    // Group by senderId to count unique conversations with unread messages
    final Set<String> unseenSenders = {};
    for (final doc in docs.documents) {
      final msg = MessageModel.fromMap(doc.data, doc.$id);
      unseenSenders.add(msg.senderId);
    }

    return unseenSenders.length;
  }

  // Stream for unseen chats count
  Stream<int> getUnseenChatsCountStream(String userId) async* {
    final channel =
        'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.messagesCollectionID}.documents';

    Future<int> fetchUnseenCount() async {
      return await getUnseenChatsCount(userId);
    }

    // Initial fetch
    yield await fetchUnseenCount();

    // Listen for realtime updates
    await for (final event in _realtime.subscribe([channel]).stream) {
      if (event.events.any(
        (e) =>
            e.contains('databases.*.collections.*.documents.*.create') ||
            e.contains('databases.*.collections.*.documents.*.update') ||
            e.contains('databases.*.collections.*.documents.*.delete'),
      )) {
        yield await fetchUnseenCount();
      }
    }
  }
}
