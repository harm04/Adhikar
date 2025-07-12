import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

//
final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealTimeProvider),
  );
});

//user count
final usersCountProvider = FutureProvider<int>((ref) async {
  final userAPI = ref.watch(userAPIProvider);
  final users = await userAPI.getUsers();
  print("📊 usersCountProvider: Fetched ${users.length} users for count");
  return users.length;
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid addToFollowing(UserModel userModel);
  FutureEitherVoid addToFollowers(UserModel userModel);
  FutureEitherVoid updateUser(UserModel userModel);
  Future<Document> getUserData(String uid);
  Future<List<Document>> getUsers();
  Future<List<Document>> searchUser(String name);
  Future<void> updateUserCredits(String uid, double credits);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({required Databases db, required Realtime realtime})
    : _db = db,
      _realtime = realtime;

  //getUsers
  Future<List<Document>> getUsers() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      queries: [
        Query.limit(999), // Increase limit to fetch all users
        Query.orderDesc('\$createdAt'), // Order by creation date (newest first)
      ],
    );
    print(
      "📄 UserAPI.getUsers(): Fetched ${documents.documents.length} users from Appwrite",
    );
    return documents.documents;
  }

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      documentId: uid,
    );
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.usersCollectionID}.documents',
    ]).stream;
  }

  //updateUser
  @override
  FutureEitherVoid updateUser(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  //search user
  @override
  Future<List<Document>> searchUser(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      queries: [
        Query.search('firstName', name),
        // Query.search('lastName', name),
      ],
    );

    return documents.documents;
  }

  //follow user

  @override
  FutureEitherVoid addToFollowers(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(), // <-- send all fields!
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid addToFollowing(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(), // <-- send all fields!
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  Future<void> updateUserCredits(String uid, double credits) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: uid,
        data: {'credits': credits},
      );
    } catch (e) {
      throw Failure(e.toString(), StackTrace.current);
    }
  }

  // New method: Clear invalid FCM token from user document
  Future<void> clearFCMToken(String uid) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: uid,
        data: {'fcmToken': ''},
      );
      print("🧹 Cleared FCM token for user: $uid");
    } catch (e) {
      print("❌ Failed to clear FCM token for user $uid: $e");
      throw Failure(e.toString(), StackTrace.current);
    }
  }

  // New method: Update user's FCM token
  Future<void> updateFCMToken(String uid, String newToken) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: uid,
        data: {'fcmToken': newToken},
      );
      print("🔄 Updated FCM token for user: $uid");
    } catch (e) {
      print("❌ Failed to update FCM token for user $uid: $e");
      throw Failure(e.toString(), StackTrace.current);
    }
  }

  // New method: Get users with valid FCM tokens only
  Future<List<Document>> getUsersWithValidTokens() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      queries: [
        Query.limit(999),
        Query.orderDesc('\$createdAt'),
        Query.isNotNull('fcmToken'),
        Query.notEqual('fcmToken', ''),
      ],
    );
    print(
      "📱 UserAPI.getUsersWithValidTokens(): Found ${documents.documents.length} users with FCM tokens",
    );
    return documents.documents;
  }
}
