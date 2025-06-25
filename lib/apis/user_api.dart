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
}
