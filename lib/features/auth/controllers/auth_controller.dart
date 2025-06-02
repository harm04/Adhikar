import 'package:adhikar/apis/auth_api.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/views/signin.dart';
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

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
    : _authAPI = authAPI,
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
        credits: 50.0,
        meetings: [],
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
      res2.fold(
        (l) => showSnackbar(context, l.message),
        (r) {
          // Only navigate after user data is saved
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
          showSnackbar(context, 'Welcome ${userModel.email}. Please login to continue');
        },
      );
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

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
