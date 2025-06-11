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
  TextEditingController casesWonController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  List<String> tags = [];
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
    casesWonController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    phoneController.dispose();
    tagsController.dispose();
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
    casesWonController.text = widget.userModel.casesWon;
    experienceController.text = widget.userModel.experience;
    descriptionController.text = widget.userModel.description;
    address1Controller.text = widget.userModel.address1;
    address2Controller.text = widget.userModel.address2;
    cityController.text = widget.userModel.city;
    stateController.text = widget.userModel.state;
    phoneController.text = widget.userModel.phone;
    tags = List<String>.from(widget.userModel.tags);
  }

  void _onProfileImageChanged(File? image) {
    setState(() {
      profileImage = image;
    });
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
                        ref
                            .read(authControllerProvider.notifier)
                            .updateUser(
                              userModel: widget.userModel,
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
                             
                              casesWon: casesWonController.text,
                              experience: experienceController.text,
                              description: descriptionController.text,
                              address1: address1Controller.text,
                              address2: address2Controller.text,
                              city: cityController.text,
                              userState: stateController.text,
                              phone: phoneController.text,
                              tags: tags,
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
                      profileImage: profileImage,
                      facebookController: facebookController,
                      linkedinController: linkedinController,
                      twitterController: twitterController,
                      casesWonController: casesWonController,
                      experienceController: experienceController,
                      descriptionController: descriptionController,
                      address1Controller: address1Controller,
                      address2Controller: address2Controller,
                      cityController: cityController,
                      stateController: stateController,
                      phoneController: phoneController,
                      tagsController: tagsController,
                      tags: tags,
                      onTagsChanged: (newTags) =>
                          setState(() => tags = newTags),
                      copyOfUserModel: copyOfUserModel,
                      onProfileImageChanged: _onProfileImageChanged,
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
                    profileImage: profileImage,
                    facebookController: facebookController,
                    linkedinController: linkedinController,
                    twitterController: twitterController,
                    casesWonController: casesWonController,
                    experienceController: experienceController,
                    descriptionController: descriptionController,
                    address1Controller: address1Controller,
                    address2Controller: address2Controller,
                    cityController: cityController,
                    stateController: stateController,
                    phoneController: phoneController,
                    tagsController: tagsController,
                    tags: tags,
                    onTagsChanged: (newTags) => setState(() => tags = newTags),
                    copyOfUserModel: copyOfUserModel,
                    onProfileImageChanged: _onProfileImageChanged,
                  ),
                ),
          );
  }
}
