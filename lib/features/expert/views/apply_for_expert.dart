import 'dart:io';

import 'package:adhikar/common/pick_image.dart';
import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/expert_controller.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyForExpert extends ConsumerStatefulWidget {
  const ApplyForExpert({super.key});

  @override
  ConsumerState<ApplyForExpert> createState() => _ApplyForLawyerScreenState();
}

class _ApplyForLawyerScreenState extends ConsumerState<ApplyForExpert> {
  TextEditingController statecontroller = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController casesWonController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;
  final List<String> _tags = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(currentUserDataProvider).value;
      if (user != null) {
        emailController.text = user.email;
        firstNameController.text = user.firstName;
        lastNameController.text = user.lastName;
        // set other controllers if needed
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    statecontroller.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    casesWonController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
  }

  PlatformFile? proofFile;
  PlatformFile? idFile;
  File? profileImage;
  // Uint8List? profImage;

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
      });
    }
    _controller.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future selectFileForProof() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        proofFile = result.files.first;
      });
      print(proofFile!.name);
    } else {
      showSnackbar(context, 'File not selected');
    }
  }

  Future selectFileForId() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        idFile = result.files.first;
      });
      print(idFile!.name);
    } else {
      showSnackbar(context, 'File not selected');
    }
  }

  void pickProfileImage() async {
    final profImage = await pickImage();
    if (profImage != null) {
      setState(() {
        profileImage = profImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> states = [
      "Andhra Pradesh",
      "Arunachal Pradesh",
      "Assam",
      "Bihar",
      "Chhattisgarh",
      "Goa",
      "Gujarat",
      "Haryana",
      "Himachal Pradesh",
      "Jharkhand",
      "Karnataka",
      "Kerala",
      "Madhya Pradesh",
      "Maharashtra",
      "Manipur",
      "Meghalaya",
      "Mizoram",
      "Nagaland",
      "Odisha",
      "Punjab",
      "Rajasthan",
      "Sikkim",
      "Tamil Nadu",
      "Telangana",
      "Tripura",
      "Uttar Pradesh",
      "Uttarakhand",
      "West Bengal",
      "Andaman and Nicobar Islands",
      "Chandigarh",
      "Dadra and Nagar Haveli and Daman and Diu",
      "Lakshadweep",
      "Delhi (National Capital Territory)",
      "Puducherry",
      "Ladakh",
      "Jammu and Kashmir",
    ];
    final currentUser = ref.watch(currentUserDataProvider).value;

    bool isLoading = ref.watch(expertControllerProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: context.primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: context.iconPrimaryColor),
        title: Text(
          'Apply for Adhikar Expert',
          style: TextStyle(color: context.textPrimaryColor),
        ),
      ),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          profileImage != null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundColor: context.surfaceColor,
                                  child: CircleAvatar(
                                    radius: 66,
                                    backgroundColor: context.textPrimaryColor,
                                    backgroundImage: FileImage(profileImage!),
                                  ),
                                )
                              : currentUser!.profileImage != ''
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundColor: context.textPrimaryColor,
                                  child: CircleAvatar(
                                    radius: 66,
                                    backgroundColor: context.surfaceColor,
                                    backgroundImage: NetworkImage(
                                      currentUser.profileImage,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundColor: context.primaryColor,
                                  child: CircleAvatar(
                                    radius: 66,
                                    backgroundColor: context.surfaceColor,
                                    backgroundImage: AssetImage(
                                      ImageTheme.defaultProfileImage,
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: -0,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                pickProfileImage();
                              },
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: context.textPrimaryColor,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: context.backgroundColor,
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: context.iconSecondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        'Required',
                        style: TextStyle(
                          color: context.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'First name',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: firstNameController,
                      hinttext: 'Jhon Doe',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Last name',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: lastNameController,
                      hinttext: 'Jhon Doe',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: emailController,
                      hinttext: 'adhikar@gmail.com',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Phone',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: phoneController,
                      hinttext: '9999999999',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Date of birth',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: dobController,
                      hinttext: '04/03/2004',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Address line 1',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: address1Controller,
                      hinttext: 'Flat no / Building',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Address line 2',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: address2Controller,
                      hinttext: 'Area / Street',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'City',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: cityController,
                      hinttext: 'City',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Choose your State',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropDownField(
                            enabled: true,
                            textStyle: TextStyle(
                              color: context.textPrimaryColor,
                              fontSize: 16,
                            ),
                            controller: statecontroller,
                            hintText: 'Select your State',
                            hintStyle: TextStyle(
                              color: context.textHintColor,
                              fontSize: 17,
                            ),
                            items: states,
                            itemsVisibleInDropdown: 5,
                            onValueChanged: (value) {
                              setState(() {
                                statecontroller.text = value!;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text("*", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Write Tags for your expertise (Criminal, Civil, Family, etc.)',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.borderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ..._tags.map(
                            (tag) => Chip(
                              label: Text(tag),
                              onDeleted: () => _removeTag(tag),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              controller: _controller,
                              onSubmitted: _addTag,
                              decoration: InputDecoration(
                                hintText: 'Add tags',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Upload proof of beign Lawyer',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        selectFileForProof();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: proofFile != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      proofFile!.extension == 'pdf'
                                          ? 'assets/icons/ic_pdf.png'
                                          : 'assets/icons/ic_image.png',
                                      height: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        proofFile!.name,
                                        style: TextStyle(
                                          color: context.textPrimaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: context.textPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Upload identity proof',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        selectFileForId();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: idFile != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      idFile!.extension == 'pdf'
                                          ? 'assets/icons/ic_pdf.png'
                                          : 'assets/icons/ic_image.png',
                                      height: 35,
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        idFile!.name,
                                        style: TextStyle(
                                          color: context.textPrimaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: context.textPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cases won',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: casesWonController,
                      hinttext: 'Cases won',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Experience (in years)',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      controller: experienceController,
                      hinttext: '10+',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Add description about yourself',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: descriptionController,
                        maxLength: 1000,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixText: '*',
                          suffixStyle: const TextStyle(
                            color: Colors.red,
                            letterSpacing: 10,
                          ),
                          hintText: 'Describe yourself within 1000 letters',
                          hintStyle: TextStyle(
                            color: context.textHintColor,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        if (emailController.text.isNotEmpty &&
                            firstNameController.text.isNotEmpty &&
                            lastNameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            dobController.text.isNotEmpty &&
                            statecontroller.text.isNotEmpty &&
                            cityController.text.isNotEmpty &&
                            address1Controller.text.isNotEmpty &&
                            address2Controller.text.isNotEmpty &&
                            casesWonController.text.isNotEmpty &&
                            experienceController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            profileImage != null &&
                            idFile != null &&
                            proofFile != null) {
                          ref
                              .read(expertControllerProvider.notifier)
                              .applyForExpert(
                                userModel: currentUser!,
                                context: context,
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                dob: dobController.text,
                                countryState: statecontroller.text,
                                city: cityController.text,
                                address1: address1Controller.text,
                                address2: address2Controller.text,
                                proofDoc: proofFile!,
                                idDoc: idFile!,
                                casesWon: casesWonController.text,
                                experience: experienceController.text,
                                description: descriptionController.text,

                                profImage: profileImage!,
                                tags: _tags, // <-- Add this line
                              );
                          ref.invalidate(
                            currentUserDataProvider,
                          ); // This will refresh user data
                        } else {
                          showSnackbar(context, 'Please fill all the fields');
                        }
                      },
                      child: const CustomButton(
                        text: 'Submit for verification',
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String hinttext,
    required TextInputType keyboardType,
    bool obsecureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: obsecureText,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixText: '*',
          suffixStyle: const TextStyle(color: Colors.red, letterSpacing: 10),
          hintText: hinttext,
          hintStyle: TextStyle(color: context.textHintColor, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

}
