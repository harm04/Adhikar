import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/profile/widgets/profile_widget.dart';
import 'package:adhikar/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  final UserModel userModel;
  const ProfileView({super.key, required this.userModel});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    UserModel copyOfUserModel = widget.userModel;
    return Scaffold(
      appBar: AppBar(title: Text('Profile on Adhikar'), centerTitle: true),
      body: ref
          .watch(getlatestUserDataProvider)
          .when(
            data: (user) {
              if (user.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollectionID}.documents.${copyOfUserModel.uid}.update',
              )) {
                copyOfUserModel = UserModel.fromMap(user.payload);
              }
              return ProfileWidget(userModel: copyOfUserModel);
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => ProfileWidget(userModel: copyOfUserModel),
          ),
      //
    );
  }
}
