import 'package:adhikar/apis/meetings_api.dart';
import 'package:adhikar/common/failure.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/models/meetings_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final meetingsControllerProvider =
    StateNotifierProvider<MeetingsController, bool>((ref) {
      return MeetingsController(meethingsAPI: ref.watch(meetingsAPIProvider));
    });

final getUserMeetingsProvider = FutureProvider.family((
  ref,
  UserModel userModel,
) async {
  final meetingsController = ref.watch(meetingsControllerProvider.notifier);
  return meetingsController.getUserMeetingsList(userModel);
});

class MeetingsController extends StateNotifier<bool> {
  final MeetingsAPI _meetingsAPI;

  MeetingsController({required MeetingsAPI meethingsAPI})
    : _meetingsAPI = meethingsAPI,

      super(false);

  //create meeting
  Future<Either<Failure, Document>> createMeeting({
    required UserModel userModel,
    required ExpertModel expertModel,
    required String phone,
    required String transactionID,
    required BuildContext context,
  }) async {
    state = true;

    MeetingsModel meetingsModel = MeetingsModel(
      id: '',
      createdAt: DateTime.now(),
      clientPhone: phone,
      clientUid: userModel.uid,
      expertUid: expertModel.uid,
      transactionID: transactionID,
      meetingStatus: 'pending',
    );

    final res = await _meetingsAPI.createMeeting(meetingsModel);
    state = false;

    return res; // This will be used to get the meeting ID
  }

  //get meetings of a user

  Future<List<MeetingsModel>> getUserMeetingsList(UserModel userModel) async {
    final meetingsList = await _meetingsAPI.getUserMeetings(userModel);
    return meetingsList
        .map((meetings) => MeetingsModel.fromMap(meetings.data))
        .toList();
  }
}
