import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/models/meetings_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final meetingsAPIProvider = Provider((ref) {
  return MeetingsAPI(
    db: ref.watch(appwriteDatabaseProvider),
    // realtime: ref.watch(appwriteRealTimeProvider),
  );
});

abstract class IUserAPI {
  Future<List<Document>> getUserMeetings(UserModel userModel);
  Future<Either<Failure, Document>> createMeeting(MeetingsModel meetingsModel);
  FutureEitherVoid updateExpertmodelWithMeeting(
    ExpertModel expertModel,
    String meetingId,
  );
  FutureEitherVoid updateUsermodelWithMeeting(
    UserModel userModel,
    String meetingId,
  );
}

class MeetingsAPI implements IUserAPI {
  final Databases _db;
  // final Realtime _realtime;
  MeetingsAPI({
    required Databases db,
    // required Realtime realtime
  }) : _db = db;
  // _realtime = realtime;

  @override
  Future<Either<Failure, Document>> createMeeting(
    MeetingsModel meetingsModel,
  ) async {
    try {
      final doc = await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.meetingsCollectionID,
        documentId: ID.unique(),
        data: meetingsModel.toMap(),
      );
      return right(doc); // Return the created document
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  //update usermodel meetings[] with meetingId
  @override
  FutureEitherVoid updateUsermodelWithMeeting(
    UserModel userModel,
    String meetingId,
  ) async {
    try {
      //update usermodel with meetingId
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: {'meetings': userModel.meetings, 'phone': userModel.phone},
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  //update expertmodel meeting[] with same meetingId
  @override
  FutureEitherVoid updateExpertmodelWithMeeting(
    ExpertModel expertModel,
    String meetingId,
  ) async {
    try {
      //update expertmodel with meetingId
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.expertCollectionID,
        documentId: expertModel.uid,
        data: {'meetings': expertModel.meetings},
      );
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getUserMeetings(UserModel userModel) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.meetingsCollectionID,
      queries: [Query.equal('clientUid', userModel.uid)],
    );

    return documents.documents;
  }
}
