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
      );
});

abstract class IUserAPI { 
  
  FutureEitherVoid saveUserData(UserModel userModel);
  
  Future<Document> getUserData(String uid);

}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db, })
      : _db = db; 
  
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseID,
          collectionId: AppwriteConstants.usersCollectionID,
          documentId: userModel.uid,
          data: userModel.toMap());
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
        documentId: uid);
  }


}