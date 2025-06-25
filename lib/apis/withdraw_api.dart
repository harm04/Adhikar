import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/withdraw_modal.dart';
import 'package:adhikar/providers/provider.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final withdrawAPIProvider = Provider((ref) {
  return WithdrawAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IWithdrawAPI {
  FutureEither<Document> requestWithdraw(WithdrawModal withdrawModal);
  Future<List<Document>> getWithdraw();
  FutureEitherVoid updateWithdrawStatus(String id, String status);
}

class WithdrawAPI implements IWithdrawAPI {
  final Databases _db;

  WithdrawAPI({required Databases db}) : _db = db;

  @override
  FutureEither<Document> requestWithdraw(WithdrawModal withdrawModal) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.withdrawCollectionID,
        documentId: ID.unique(),
        data: withdrawModal.toMap(),
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getWithdraw() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.withdrawCollectionID,
    );

    return documents.documents;
  }

  //update status of withdraw request
  FutureEitherVoid updateWithdrawStatus(String id, String status) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.withdrawCollectionID,
        documentId: id,
        data: {'status': status},
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
