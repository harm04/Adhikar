import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/provider.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealTimeProvider),
  );
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(PostModel postModel);
  Future<List<Document>> getPosts();
  Stream<RealtimeMessage> getLatestPosts();
  Stream<PostModel> getPostStream(String postId);
  FutureEither<Document> likePost(PostModel postModel);
  FutureEither<Document> bookmarkPost(UserModel userModel);
  Future<List<Document>> getComments(PostModel postModel);
  Future<List<Document>> getUsersPost(UserModel userModel);

  Future<List<Document>> getPodsPost(String podName);
  FutureEither<Document> addCommentIdToPost(
    String postId,
    List<String> commentIds,
  );
}

class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;
  PostAPI({required Databases db, required Realtime realtime})
    : _db = db,
      _realtime = realtime;
  @override
  FutureEither<Document> sharePost(PostModel postModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.postCollectionID,
        documentId: ID.unique(),
        data: postModel.toMap(),
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getPosts() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.postCollectionID,
      queries: [Query.orderDesc('createdAt')],
    );

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPosts() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.postCollectionID}.documents',
    ]).stream;
  }

  @override
  FutureEither<Document> likePost(PostModel postModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.postCollectionID,
        documentId: postModel.id,
        data: {'likes': postModel.likes},
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  //bookmark post
  @override
  FutureEither<Document> bookmarkPost(UserModel userModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: {'bookmarked': userModel.bookmarked},
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getComments(PostModel postModel) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.postCollectionID,
      queries: [Query.equal('commentedTo', postModel.id)],
    );

    return documents.documents;
  }

  @override
  Future<List<Document>> getUsersPost(UserModel userModel) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.postCollectionID,
      queries: [Query.equal('uid', userModel.uid)],
    );

    return documents.documents;
  }

  @override
  Future<List<Document>> getPodsPost(String podName) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.postCollectionID,
      queries: [Query.equal('pod', podName)],
    );

    return documents.documents;
  }

  @override
  FutureEither<Document> addCommentIdToPost(
    String postId,
    List<String> commentIds,
  ) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.postCollectionID,
        documentId: postId,
        data: {'commentIds': commentIds},
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<PostModel> getPostStream(String postId) {
    return _realtime
        .subscribe([
          'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.postCollectionID}.documents.$postId',
        ])
        .stream
        .map((event) {
          final data = event.payload;
          return PostModel.fromMap(data);
        });
  }
}
