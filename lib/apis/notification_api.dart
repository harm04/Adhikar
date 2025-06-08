import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/notification_modal.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealTimeProvider),
  );
});

class NotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationAPI({required Databases db, required Realtime realtime})
    : _db = db,
      _realtime = realtime;

  Future<void> createNotification(NotificationModel notification) async {
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.notificationCollectionID,
      documentId: ID.unique(),
      data: notification.toMap(),
    );
  }

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    final docs = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.notificationCollectionID,
      queries: [Query.equal('userId', userId), Query.orderDesc('createdAt')],
    );
    return docs.documents
        .map((doc) => NotificationModel.fromMap(doc.data))
        .toList();
  }

  Stream<RealtimeMessage> getLatestNotifications(String userId) {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.notificationCollectionID}.documents',
    ]).stream;
  }
}
