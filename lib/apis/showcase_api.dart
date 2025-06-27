import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/provider.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final showcaseAPIProvider = Provider((ref) {
  return ShowcaseAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealTimeProvider),
  );
});
//showcase count
final showcasesCountProvider = FutureProvider<int>((ref) async {
  final showcaseAPI = ref.watch(showcaseAPIProvider);
  final showcases = await showcaseAPI.getShowcase();
  return showcases.length;
});

abstract class IShowcaseAPI {
  FutureEither<Document> shareShowcase(ShowcaseModel showcaseModel);
  Future<List<Document>> getShowcase();
  Stream<RealtimeMessage> getLatestShowcase();
  Stream<ShowcaseModel> getShowcaseStream(String showcaseId);
  FutureEither<Document> upvoteShowcase(ShowcaseModel showcaseModel);
  FutureEither<Document> bookmarkShowcase(UserModel userModel);
  Future<List<Document>> getComments(ShowcaseModel showcaseModel);
 
  FutureEither<Document> addCommentIdToShowcase(
    String showcaseId,
    List<String> commentIds,
  );
  Future<ShowcaseModel?> getShowcaseById(String showcaseId);
}

class ShowcaseAPI implements IShowcaseAPI {
  final Databases _db;
  final Realtime _realtime;
  ShowcaseAPI({required Databases db, required Realtime realtime})
    : _db = db,
      _realtime = realtime;

  @override
  FutureEither<Document> shareShowcase(ShowcaseModel showcaseModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.showcaseCollectionID,
        documentId: ID.unique(),
        data: showcaseModel.toMap(),
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getShowcase() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.showcaseCollectionID,
      queries: [
        Query.orderDesc('createdAt'),
        Query.notEqual('tagline', 'comment'), // Exclude comments
      ],
    );

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestShowcase() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.showcaseCollectionID}.documents',
    ]).stream;
  }

  @override
  FutureEither<Document> upvoteShowcase(ShowcaseModel showcaseModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.showcaseCollectionID,
        documentId: showcaseModel.id,
        data: {'upvotes': showcaseModel.upvotes},
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }


  

  //bookmark post
  @override
  FutureEither<Document> bookmarkShowcase(UserModel userModel) async {
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
  Future<List<Document>> getComments(ShowcaseModel showcaseModel) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.showcaseCollectionID,
      queries: [Query.equal('commentedTo', showcaseModel.id)],
    );

    return documents.documents;
  }

  

  @override
  FutureEither<Document> addCommentIdToShowcase(
    String showcaseId,
    List<String> commentIds,
  ) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.showcaseCollectionID,
        documentId: showcaseId,
        data: {'commentIds': commentIds},
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Stream<ShowcaseModel> getShowcaseStream(String showcaseId) {
    return _realtime
        .subscribe([
          'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.showcaseCollectionID}.documents.$showcaseId',
        ])
        .stream
        .map((event) {
          final data = event.payload;
          return ShowcaseModel.fromMap(data);
        });
  }

  @override
  Future<ShowcaseModel?> getShowcaseById(String showcaseId) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.showcaseCollectionID,
      documentId: showcaseId,
    );
    return ShowcaseModel.fromMap(doc.data);
  }

}
