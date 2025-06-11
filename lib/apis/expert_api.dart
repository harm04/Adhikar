import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
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

//experts count
final expertsCountProvider = FutureProvider<int>((ref) async {
  final expertAPI = ref.watch(expertApiProvider);
  final experts = await expertAPI.getExperts();
  return experts.length;
});

abstract class IUserAPI {
  Future<List<Document>> getExperts();
  FutureEitherVoid applyForExpert(UserModel userModel);
  // Future<Document> getExpertData(String uid);
  FutureEitherVoid approveExpert(String uid);
}

class ExpertAPI implements IUserAPI {
  final Databases _db;
  // final Realtime _realtime;
  ExpertAPI({required Databases db, required Realtime realtime}) : _db = db;
  // _realtime = realtime;

  @override
  FutureEitherVoid applyForExpert(UserModel userModel) async {
    try {
      //update usertype in usermodel
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

  @override
  Future<List<Document>> getExperts() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      queries: [
        Query.equal('userType', ['Expert', 'pending']),
      ],
    );
    return documents.documents;
  }

  // @override
  // Future<Document> getExpertData(String uid) {
  //   return _db.getDocument(
  //     databaseId: AppwriteConstants.databaseID,
  //     collectionId: AppwriteConstants.expertCollectionID,
  //     documentId: uid,
  //   );
  // }

  //approv expert
  FutureEitherVoid approveExpert(String uid) async {
    try {
      //update usertype in usermodel
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: uid,
        data: {'userType': 'Expert'},
      );

      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  //reject expert
  FutureEitherVoid rejectExpert(String uid) async {
    try {
      //update usertype in usermodel
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: uid,
        data: {'userType': 'User'},
      );

      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  Future<void> updateUserProfileImage(
    String uid,
    String profileImageUrl,
  ) async {
    await _db.updateDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      documentId: uid,
      data: {'profileImage': profileImageUrl},
    );
  }
}
