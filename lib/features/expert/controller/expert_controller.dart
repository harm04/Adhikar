import 'dart:io';

import 'package:adhikar/apis/expert_api.dart';
import 'package:adhikar/apis/storage_api.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/admin/graph/today_stats.dart';
import 'package:adhikar/features/expert/views/expert_verification.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expertControllerProvider = StateNotifierProvider<ExpertController, bool>((
  ref,
) {
  return ExpertController(
    expertAPI: ref.watch(expertApiProvider),
    storageApi: ref.watch(storageAPIProvider),
  );
});

final getExpertsProvider = FutureProvider.autoDispose((ref) async {
  final expertsController = ref.watch(expertControllerProvider.notifier);
  return expertsController.getExpertsList();
});

// //get experts by uid
// final expertDataProvider = FutureProvider.family<UserModel, String>((
//   ref,
//   uid,
// ) async {
//   final expertController = ref.watch(expertControllerProvider.notifier);
//   return expertController.getExpertData(uid);
// });

class ExpertController extends StateNotifier<bool> {
  final ExpertAPI _expertAPI;
  final StorageApi _storageApi;
  ExpertController({
    required ExpertAPI expertAPI,
    required StorageApi storageApi,
  }) : _expertAPI = expertAPI,
       _storageApi = storageApi,
       super(false);

  void applyForExpert({
    required UserModel userModel,
    required BuildContext context,
    required String phone,
    required String dob,
    required String countryState,
    required String city,
    required String address1,
    required String address2,
    required PlatformFile proofDoc,
    required PlatformFile idDoc,
    required String casesWon,
    required String experience,
    required String description,
    required File profImage,
    required List<String> tags,
  }) async {
    state = true;
    final proofDocUrl = await _storageApi.uploadDocFiles([proofDoc]);
    final idDocUrl = await _storageApi.uploadDocFiles([idDoc]);
    final profileImageurl = await _storageApi.uploadFiles([profImage]);

    final updatedUser = userModel.copyWith(
      userType: 'pending',
      phone: phone,
      dob: dob,
      state: countryState,
      city: city,
      address1: address1,
      address2: address2,
      proofDoc: proofDocUrl[0],
      idDoc: idDocUrl[0],
      casesWon: casesWon,
      experience: experience,
      description: description,
    profileImage:  profileImageurl[0],
      tags: tags,
      credits: 0.0,
      meetings: [],
    );

    final res = await _expertAPI.applyForExpert(updatedUser);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Your profile is sent for verification');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ExpertVerification()),
        (route) => false,
      );
    });
  }

  Future<List<UserModel>> getExpertsList() async {
    final expertsList = await _expertAPI.getExperts();
    return expertsList.map((doc) => UserModel.fromMap(doc.data)).toList();
  }

  
  //approve expert
  Future<void> approveExpert(
    String uid,
    BuildContext context,
    WidgetRef ref,
  ) async {
    state = true;
    final res = await _expertAPI.approveExpert(uid);
    res.fold((l) => showSnackbar(context, l.message), (r) async {
     

      showSnackbar(context, 'Expert approved successfully');
      ref.invalidate(getExpertsProvider);
      ref.invalidate(usersCountProvider);
      ref.invalidate(expertsCountProvider);
      ref.invalidate(todayStatsProvider);
     
    });
    state = false;
  }

  //reject expert
  Future<void> rejectExpert(
    String uid,
    BuildContext context,
    WidgetRef ref,
  ) async {
    state = true;
    final res = await _expertAPI.rejectExpert(uid);
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Expert rejected successfully');
      ref.invalidate(getExpertsProvider);
      ref.invalidate(usersCountProvider);
      ref.invalidate(expertsCountProvider);
      ref.invalidate(todayStatsProvider);
    });
    state = false;
  }
}
