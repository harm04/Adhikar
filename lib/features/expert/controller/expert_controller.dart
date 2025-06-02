import 'dart:io';

import 'package:adhikar/apis/expert_api.dart';
import 'package:adhikar/apis/storage_api.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/expert/views/expert_verification.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expertControllerProvider =
    StateNotifierProvider<ExpertController, bool>((ref) {
  return ExpertController(
    expertAPI: ref.watch(expertApiProvider),
    storageApi: ref.watch(storageAPIProvider),
  );
});

final getExpertsProvider = FutureProvider.autoDispose((ref) async {
  final expertsController = ref.watch(expertControllerProvider.notifier);
  return expertsController.getExpertsList();
});



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
    required String approved,
    required File profImage,
    required List<String> tags, // <-- Add this
  }) async {
    state = true;
    //controller to update usertype in usermodel
    userModel = userModel.copyWith(userType: 'pending');
    //controller to create a lawyer model
    final proofDocUrl = await _storageApi.uploadDocFiles([proofDoc]);
    final idDocUrl = await _storageApi.uploadDocFiles([idDoc]);
    final profileImageurl = await _storageApi.uploadFiles([profImage]);
    ExpertModel expertModel = ExpertModel(
      email: userModel.email,
      credits: 50.0,
      meetings: [],
      password: userModel.password,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      phone: phone,
      uid: userModel.uid,
      transactions: [],
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
      approved: approved,
      profImage: profileImageurl[0],
      tags: tags, // <-- Add this
    );

    final res = await _expertAPI.applyForExpert(userModel, expertModel);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      
     showSnackbar(context, 'Your profile is sent for verification');
     Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) =>ExpertVerification()), // or your root widget
  (route) => false,
);
    });
  }

  Future<List<ExpertModel>> getExpertsList() async {
    final lawyersList = await _expertAPI.getExperts();
    return lawyersList
        .map((lawyers) => ExpertModel.fromMap(lawyers.data))
        .toList();
  }
}
