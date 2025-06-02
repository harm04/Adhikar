import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final expertApiProvider = Provider((ref) {
  return ExpertAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealTimeProvider),
  );
});

abstract class IUserAPI {
  Future<List<Document>> getExperts();
  FutureEitherVoid applyForExpert(UserModel userModel, ExpertModel lawyerModel);
}

class ExpertAPI implements IUserAPI {
  final Databases _db;
  // final Realtime _realtime;
  ExpertAPI({required Databases db, required Realtime realtime})
    : _db = db;
      // _realtime = realtime;

  @override
  FutureEitherVoid applyForExpert(
    UserModel userModel,
    ExpertModel lawyerModel,
  ) async {
    try {
      //update usertype in usermodel
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: {'userType': userModel.userType},
      );

      //create lawyermodel
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.expertCollectionID,
        documentId: userModel.uid,
        data: lawyerModel.toMap(),
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getExperts() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.expertCollectionID,
    );

    return documents.documents;
  }
}
