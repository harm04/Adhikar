import 'dart:io';

import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/profile/widgets/edit_profile_widget.dart';
import 'package:adhikar/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EditProfileView extends ConsumerStatefulWidget {
  final UserModel userModel;
  const EditProfileView({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? profileImage;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    summaryController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    linkedinController.dispose();
    locationController.dispose();
  }

  //pick profile image
  // void pickProfileImage() async {
  //   final profImage = await pickImage();
  //   if (profImage != null) {
  //     setState(() {
  //       profileImage = profImage;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.userModel.firstName;
    lastNameController.text = widget.userModel.lastName;
    bioController.text = widget.userModel.bio == ''
        ? 'Adhikar user'
        : widget.userModel.bio;
    summaryController.text = widget.userModel.summary == ''
        ? 'Adhikar user'
        : widget.userModel.summary;
    instagramController.text = widget.userModel.instagram;
    facebookController.text = widget.userModel.facebook;
    twitterController.text = widget.userModel.twitter;
    linkedinController.text = widget.userModel.linkedin;
    locationController.text = widget.userModel.location == ''
        ? locationController.text
        : widget.userModel.location;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    UserModel copyOfUserModel = widget.userModel;

    return isLoading
        ? LoadingPage()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: GestureDetector(
                    onTap: () {
                      if (firstNameController.text.isNotEmpty &&
                          lastNameController.text.isNotEmpty) {
                        // Create a new UserModel with all updated fields
                        final updatedUserModel = widget.userModel.copyWith(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          bio: bioController.text,
                          location: locationController.text,
                          linkedin: linkedinController.text,
                          twitter: twitterController.text,
                          instagram: instagramController.text,
                          facebook: facebookController.text,
                          summary: summaryController.text,
                          // Add other fields if needed
                        );

                        ref
                            .read(authControllerProvider.notifier)
                            .updateUser(
                              userModel: updatedUserModel,
                              context: context,
                              profileImage: profileImage,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              bio: bioController.text,
                              location: locationController.text,
                              linkedin: linkedinController.text,
                              twitter: twitterController.text,
                              instagram: instagramController.text,
                              facebook: facebookController.text,
                              summary: summaryController.text,
                            );
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/svg/tick.svg',
                      colorFilter: ColorFilter.mode(
                        Colors.green,
                        BlendMode.srcIn,
                      ),
                      height: 45,
                    ),
                  ),
                ),
              ],
            ),
            body: ref
                .watch(getlatestUserDataProvider)
                .when(
                  data: (user) {
                    if (user.events.contains(
                      'databases.*.collections.${AppwriteConstants.usersCollectionID}.documents.${copyOfUserModel.uid}.update',
                    )) {
                      copyOfUserModel = UserModel.fromMap(user.payload);
                    }
                    return EditProfileWidget(
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      bioController: bioController,
                      summaryController: summaryController,
                      locationController: locationController,
                      instagramController: instagramController,
                      facebookController: facebookController,
                      linkedinController: linkedinController,
                      twitterController: twitterController,
                      copyOfUserModel: copyOfUserModel,
                    );
                  },
                  error: (error, st) => ErrorText(error: error.toString()),
                  loading: () => EditProfileWidget(
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    bioController: bioController,
                    summaryController: summaryController,
                    locationController: locationController,
                    instagramController: instagramController,
                    facebookController: facebookController,
                    linkedinController: linkedinController,
                    twitterController: twitterController,
                    copyOfUserModel: copyOfUserModel,
                  ),
                ),
          );
  }
}
