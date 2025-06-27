import 'dart:math';
import 'package:adhikar/apis/meetings_api.dart';
import 'package:adhikar/common/failure.dart';
import 'package:adhikar/features/admin/services/send_notification_service.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';
import 'package:adhikar/models/meetings_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final meetingsControllerProvider =
    StateNotifierProvider<MeetingsController, bool>((ref) {
      return MeetingsController(
        meethingsAPI: ref.watch(meetingsAPIProvider),
        ref: ref,
      );
    });

final getUserMeetingsProvider = FutureProvider.family((
  ref,
  UserModel userModel,
) async {
  final meetingsController = ref.watch(meetingsControllerProvider.notifier);
  return meetingsController.getUserMeetingsList(userModel);
});

final getExpertMeetingsProvider =
    FutureProvider.family<List<MeetingsModel>, String>((ref, expertUid) async {
      final meetingsController = ref.watch(meetingsControllerProvider.notifier);
      return meetingsController.getExpertMeetingsList(expertUid);
    });

final userMeetingsStreamProvider =
    StreamProvider.family<List<MeetingsModel>, String>((ref, userUid) {
      final meetingsAPI = ref.watch(meetingsAPIProvider);
      return meetingsAPI
          .getUserMeetingsStream(userUid)
          .map(
            (docs) =>
                docs.map((doc) => MeetingsModel.fromMap(doc.data)).toList(),
          );
    });

final expertMeetingsStreamProvider =
    StreamProvider.family<List<MeetingsModel>, String>((ref, expertUid) {
      final meetingsAPI = ref.watch(meetingsAPIProvider);
      return meetingsAPI
          .getExpertMeetingsStream(expertUid)
          .map(
            (docs) =>
                docs.map((doc) => MeetingsModel.fromMap(doc.data)).toList(),
          );
    });

class MeetingsController extends StateNotifier<bool> {
  final MeetingsAPI _meetingsAPI;
  final Ref ref;

  MeetingsController({required MeetingsAPI meethingsAPI, required this.ref})
    : _meetingsAPI = meethingsAPI,
      super(false);

  //create meeting
  Future<Either<Failure, Document>> createMeeting({
    required UserModel userModel,
    required UserModel expertUserModel,
    required String phone,
    required String transactionID,
    required BuildContext context,
  }) async {
    state = true;

    // Generate 6-digit OTP
    final otp = (Random().nextInt(900000) + 100000).toString();

    MeetingsModel meetingsModel = MeetingsModel(
      id: '',
      createdAt: DateTime.now(),
      clientPhone: phone,
      clientUid: userModel.uid,
      expertUid: expertUserModel.uid,
      transactionID: transactionID,
      meetingStatus: 'pending',
      otp: otp,
    );

    final res = await _meetingsAPI.createMeeting(meetingsModel);
    //send push notification to ser and expert when meeting is created

    // Update user's phone in UserModel after meeting creation
    if (userModel.phone != phone) {
      final updatedUser = userModel.copyWith(phone: phone);
      ref
          .read(authControllerProvider.notifier)
          .updateUser(
            userModel: updatedUser,
            context: context,
            profileImage: null,
            firstName: updatedUser.firstName,
            lastName: updatedUser.lastName,
            bio: updatedUser.bio,
            location: updatedUser.location,
            linkedin: updatedUser.linkedin,
            twitter: updatedUser.twitter,
            instagram: updatedUser.instagram,
            facebook: updatedUser.facebook,
            summary: updatedUser.summary,
          );
    }

    // Fetch latest user and expert models to get their FCM tokens
    final user = await ref.read(userDataByIdProvider(userModel.uid).future);
    final expert = await ref.read(
      userDataByIdProvider(expertUserModel.uid).future,
    );

    if (user != null && user.fcmToken.isNotEmpty) {
      await SendNotificationService.sendNotificationUsingAPI(
        token: user.fcmToken,
        title: 'Meeting Created',
        body:
            'Your meeting with ${expertUserModel.firstName} is scheduled. The Expert will contact you within 36hrs.',
        data: {
          "screen": "Meetings",
          "meetingId": res.fold((l) => '', (r) => r.$id),
          "role": "user",
        },
      );
    }

    if (expert != null && expert.fcmToken.isNotEmpty) {
      await SendNotificationService.sendNotificationUsingAPI(
        token: expert.fcmToken,
        title: 'New Meeting Request',
        body:
            'You have a new meeting request from ${userModel.firstName}. Please contact them within 24hrs.',
        data: {
          "screen": "Meetings",
          "meetingId": res.fold((l) => '', (r) => r.$id),
          "role": "expert",
        },
      );
    }

    state = false;
    return res;
  }

  //get meetings of a user
  Future<List<MeetingsModel>> getUserMeetingsList(UserModel userModel) async {
    final meetingsList = await _meetingsAPI.getUserMeetings(userModel);
    return meetingsList
        .map((meetings) => MeetingsModel.fromMap(meetings.data))
        .toList();
  }

  Future<List<MeetingsModel>> getExpertMeetingsList(String expertUid) async {
    final meetingsList = await _meetingsAPI.getExpertMeetings(expertUid);
    return meetingsList
        .map((meetings) => MeetingsModel.fromMap(meetings.data))
        .toList();
  }

  Future<bool> verifyAndCompleteMeeting(
    String meetingId,
    String enteredOtp,
    String expertUid,
  ) async {
    state = true;
    final result = await _meetingsAPI.verifyAndCompleteMeeting(
      meetingId,
      enteredOtp,
    );
    if (result) {
      await _meetingsAPI.addCreditsToExpertEverywhere(expertUid, 130);
    }
    state = false;
    return result;
  }
}
