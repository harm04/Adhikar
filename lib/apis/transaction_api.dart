import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/models/transaction_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final transactionAPIAPIProvider = Provider((ref) {
  return TransactionAPI(
    db: ref.watch(appwriteDatabaseProvider),
    // realtime: ref.watch(appwriteRealTimeProvider),
  );
});

abstract class IUserAPI {
  Future<List<Document>> getUserTransaction(UserModel userModel);
  Future<Either<Failure, Document>> createTransaction(
    TransactionModel transactionModel,
  );
  FutureEitherVoid updateExpertmodelWithTransaction(
    ExpertModel expertModel,
    String transactionId,
  );
  FutureEitherVoid updateUsermodelWithTransaction(
    UserModel userModel,
    String transactionId,
  );
}

class TransactionAPI implements IUserAPI {
  final Databases _db;
  // final Realtime _realtime;
  TransactionAPI({
    required Databases db,
    // required Realtime realtime
  }) : _db = db;
  // _realtime = realtime;

  @override
  Future<Either<Failure, Document>> createTransaction(
    TransactionModel transactionModel,
  ) async {
    try {
      final doc = await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.transactionCollectionID,
        documentId: ID.unique(),
        data: transactionModel.toMap(),
      );
      return right(doc); // Return the created document
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  //update usermodel transaction[] with transactionId
  @override
  FutureEitherVoid updateUsermodelWithTransaction(
    UserModel userModel,
    String transactionId,
  ) async {
    try {
      //update usermodel with transactionId
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: {'transactions': userModel.transactions},
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  //update expertmodel meeting[] with same meetingId
  @override
  FutureEitherVoid updateExpertmodelWithTransaction(
    ExpertModel expertModel,
    String transactionId,
  ) async {
    try {
      //update expertmodel with transactionId
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.expertCollectionID,
        documentId: expertModel.uid,
        data: {'transactions': expertModel.transactions},
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getUserTransaction(UserModel userModel) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.transactionCollectionID,
      queries: [Query.equal('clientUid', userModel.uid)],
    );

    return documents.documents;
  }
}
