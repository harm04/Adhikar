import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
// Remove: import 'package:adhikar/models/expert_model.dart';
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
  FutureEitherVoid updateExpertWithMeeting(
    UserModel userModel,
    String meetingId,
  );
  Future<bool> verifyAndCompleteMeeting(String meetingId, String enteredOtp);
  Future<List<Document>> getExpertMeetings(String expertUid);
  FutureEitherVoid updateUserWithMeeting(
    UserModel userModel,
    String meetingId,
  );
  Future<void> addCreditsToExpertEverywhere(
    String expertUid,
    int creditsToAdd,
  );
  Stream<List<Document>> getUserMeetingsStream(String userUid);
  Stream<List<Document>> getExpertMeetingsStream(String expertUid);
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

  //update user meetings[] with meetingId
  @override
  FutureEitherVoid updateUserWithMeeting(
    UserModel userModel,
    String meetingId,
  ) async {
    try {
      //update user with meetingId
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

  //update expert meeting[] with same meetingId
  @override
  FutureEitherVoid updateExpertWithMeeting(
    UserModel userModel,
    String meetingId,
  ) async {
    try {
      //update expert with meetingId
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: {'meetings': userModel.meetings},
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

  @override
  Future<List<Document>> getExpertMeetings(String expertUid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.meetingsCollectionID,
      queries: [Query.equal('expertUid', expertUid)],
    );
    return documents.documents;
  }

  @override
  Stream<List<Document>> getUserMeetingsStream(String userUid) {
    return _db
        .listDocuments(
          databaseId: AppwriteConstants.databaseID,
          collectionId: AppwriteConstants.meetingsCollectionID,
          queries: [Query.equal('clientUid', userUid)],
        )
        .asStream()
        .asyncMap((documents) => documents.documents);
  }

  @override
  Stream<List<Document>> getExpertMeetingsStream(String expertUid) {
    return _db
        .listDocuments(
          databaseId: AppwriteConstants.databaseID,
          collectionId: AppwriteConstants.meetingsCollectionID,
          queries: [Query.equal('expertUid', expertUid)],
        )
        .asStream()
        .asyncMap((documents) => documents.documents);
  }

  @override
  Future<bool> verifyAndCompleteMeeting(
    String meetingId,
    String enteredOtp,
  ) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.meetingsCollectionID,
      documentId: meetingId,
    );
    final meetingOtp = doc.data['otp'];
    if (meetingOtp == enteredOtp) {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.meetingsCollectionID,
        documentId: meetingId,
        data: {'meetingStatus': 'completed'},
      );
      return true;
    }
    return false;
  }

  @override
  Future<void> addCreditsToExpertEverywhere(
    String expertUid,
    int creditsToAdd,
  ) async {
    // Update in UserModel collection
    final userDoc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      documentId: expertUid,
    );
    final userCredits = userDoc.data['credits'] ?? 0;
    await _db.updateDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      documentId: expertUid,
      data: {'credits': userCredits + creditsToAdd},
    );
  }
}
