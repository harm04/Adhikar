import 'dart:io';

import 'package:adhikar/apis/auth_api.dart';
import 'package:adhikar/apis/storage_api.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/views/signin.dart';
import 'package:adhikar/features/notification/controller/notification_controller.dart';
import 'package:adhikar/models/notification_modal.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    storageApi: ref.watch(storageAPIProvider),
  );
});

final currentUserDataProvider = FutureProvider((ref) async {
  final currentUserId = ref.watch(currentUserAccountProvider).value?.$id;
  if (currentUserId == null) return null;
  final userData = await ref.watch(userDataProvider(currentUserId).future);
  return userData;
});

final userDataProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

final getlatestUserDataProvider = StreamProvider((ref) {
  final userApi = ref.watch(userAPIProvider);
  return userApi.getLatestUserProfileData();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  final StorageApi _storageAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
    required StorageApi storageApi,
  }) : _authAPI = authAPI,
       _storageAPI = storageApi,
       _userAPI = userAPI,

       super(false);
  //signup
  void signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) async {
      UserModel userModel = UserModel(
        firstName: firstName,
        lastName: lastName,
        phone: '',
        email: email,
        credits: 0.0,
        meetings: [],
        transactions: [],
        password: password,
        profileImage: '',
        bio: '',
        createdAt: DateFormat("MMM dd").format(DateTime.now()),
        summary: '',
        following: [],
        followers: [],
        bookmarked: [],
        isVerified: false,
        uid: r.$id,
        location: '',
        linkedin: '',
        twitter: '',
        instagram: '',
        facebook: '',
        experienceTitle: '',
        experienceSummary: '',
        experienceOrganization: '',
        eduStream: '',
        eduDegree: '',
        eduUniversity: '',
        userType: 'User',
      );

      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackbar(context, l.message), (r) {
        // Only navigate after user data is saved
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
        showSnackbar(
          context,
          'Welcome ${userModel.email}. Please login to continue',
        );
      });
    });
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signIn(email: email, password: password);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
      showSnackbar(context, 'Welcome $email. You are successfully logged in');
    });
  }

  Future<models.User?> currentUser() => _authAPI.currentUserAccount();

  void signout(BuildContext context) async {
    state = true;
    final res = await _authAPI.signout();
    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message), // Show error if signout fails
      (r) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SignInScreen();
            },
          ),
          (Route) => false,
        );
      },
    );
  }

  //user count
  final usersCountProvider = FutureProvider<int>((ref) async {
    final userAPI = ref.watch(userAPIProvider);
    final users = await userAPI.getUsers();
    return users.length;
  });

  //follow user
  void followUser({
    required UserModel userModel,
    required UserModel currentUser,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = true;
    bool isFollow = false;
    if (currentUser.following.contains(userModel.uid)) {
      currentUser.following.remove(userModel.uid);
      userModel.followers.remove(currentUser.uid);
    } else {
      currentUser.following.add(userModel.uid);
      userModel.followers.add(currentUser.uid);
      isFollow = true;
    }
    userModel = userModel.copyWith(followers: userModel.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);
    final res = await _userAPI.addToFollowers(userModel);

    res.fold((l) => showSnackbar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackbar(context, l.message), (r) {
        // Send notification only if followed (not unfollowed) and not self
        if (isFollow && userModel.uid != currentUser.uid) {
          final notification = NotificationModel(
            id: '',
            userId: userModel.uid, // The user being followed
            senderId: currentUser.uid,
            type: 'follow',
            title: 'New Follower',
            body: '${currentUser.firstName} started following you.',
            isRead: false,
            createdAt: DateTime.now(),
          );
          ref
              .read(notificationControllerProvider.notifier)
              .createNotification(notification);
        }
      });
      null;
    });
    state = false;
  }

  //update user data
  void updateUser({
    required UserModel userModel,
    required BuildContext context,
    required File? profileImage,
    required String firstName,
    required String lastName,
    required String bio,
    required String location,
    required String linkedin,
    required String twitter,
    required String instagram,
    required String facebook,
    required String summary,
  }) async {
    state = true;

    // Always start with the latest userModel
    var updatedUserModel = userModel;

    if (profileImage != null) {
      final profileUrl = await _storageAPI.uploadFiles([profileImage]);
      updatedUserModel = updatedUserModel.copyWith(profileImage: profileUrl[0]);
    }
    if (firstName != updatedUserModel.firstName) {
      updatedUserModel = updatedUserModel.copyWith(firstName: firstName);
    }
    if (lastName != updatedUserModel.lastName) {
      updatedUserModel = updatedUserModel.copyWith(lastName: lastName);
    }
    if (bio.isNotEmpty &&
        bio != 'Adhikar user' &&
        bio != updatedUserModel.bio) {
      updatedUserModel = updatedUserModel.copyWith(bio: bio);
    }
    if (location.isNotEmpty && location != updatedUserModel.location) {
      updatedUserModel = updatedUserModel.copyWith(location: location);
    }
    if (linkedin.isNotEmpty && linkedin != updatedUserModel.linkedin) {
      updatedUserModel = updatedUserModel.copyWith(linkedin: linkedin);
    }
    if (twitter.isNotEmpty && twitter != updatedUserModel.twitter) {
      updatedUserModel = updatedUserModel.copyWith(twitter: twitter);
    }
    if (instagram.isNotEmpty && instagram != updatedUserModel.instagram) {
      updatedUserModel = updatedUserModel.copyWith(instagram: instagram);
    }
    if (facebook.isNotEmpty && facebook != updatedUserModel.facebook) {
      updatedUserModel = updatedUserModel.copyWith(facebook: facebook);
    }
    if (summary.isNotEmpty &&
        summary != 'Adhikar user' &&
        summary != updatedUserModel.summary) {
      updatedUserModel = updatedUserModel.copyWith(summary: summary);
    }

    final res = await _userAPI.updateUser(updatedUserModel);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Profile updated successfully');
      // Invalidate the currentUserDataProvider so all listeners get fresh data

      Navigator.pop(context);
    });
  }

  //update user experience
  void updateUserExperience({
    required UserModel userModel,
    required BuildContext context,

    required String title,
    required String firmOrOrganization,
    required String summary,
  }) async {
    state = true;

    // Always start with the latest userModel
    var updatedUserModel = userModel;

    if (title != updatedUserModel.experienceTitle) {
      updatedUserModel = updatedUserModel.copyWith(experienceTitle: title);
    }
    if (firmOrOrganization != updatedUserModel.experienceOrganization) {
      updatedUserModel = updatedUserModel.copyWith(
        experienceOrganization: firmOrOrganization,
      );
    }
    if (summary != updatedUserModel.experienceSummary) {
      updatedUserModel = updatedUserModel.copyWith(experienceSummary: summary);
    }

    final res = await _userAPI.updateUser(updatedUserModel);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Experience updated successfully');
      // Invalidate the currentUserDataProvider so all listeners get fresh data

      Navigator.pop(context);
    });
  }

  //update user education
  void updateUserEducation({
    required UserModel userModel,
    required BuildContext context,

    required String degree,
    required String stream,
    required String university,
  }) async {
    state = true;

    // Always start with the latest userModel
    var updatedUserModel = userModel;

    if (degree != updatedUserModel.eduDegree) {
      updatedUserModel = updatedUserModel.copyWith(eduDegree: degree);
    }
    if (stream != updatedUserModel.eduStream) {
      updatedUserModel = updatedUserModel.copyWith(eduStream: stream);
    }
    if (university != updatedUserModel.eduUniversity) {
      updatedUserModel = updatedUserModel.copyWith(eduUniversity: university);
    }

    final res = await _userAPI.updateUser(updatedUserModel);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Education updated successfully');
      // Invalidate the currentUserDataProvider so all listeners get fresh data

      Navigator.pop(context);
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
