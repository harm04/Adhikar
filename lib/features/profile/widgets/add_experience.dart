import 'package:adhikar/common/widgets/custom_textfield.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AddExperience extends ConsumerStatefulWidget {
  final UserModel currentUser;
  AddExperience({super.key, required this.currentUser});

  @override
  ConsumerState<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends ConsumerState<AddExperience> {
  TextEditingController titleController = TextEditingController();
  TextEditingController firmOrOrganisationController = TextEditingController();
  TextEditingController summaryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    firmOrOrganisationController.dispose();
    summaryController.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.currentUser.experienceTitle;
    firmOrOrganisationController.text =
        widget.currentUser.experienceOrganization;
    summaryController.text = widget.currentUser.experienceSummary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Experience'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: () {
                if (titleController.text.isNotEmpty &&
                    firmOrOrganisationController.text.isNotEmpty &&
                    summaryController.text.isNotEmpty) {
                  ref
                      .read(authControllerProvider.notifier)
                      .updateUserExperience(
                        userModel: widget.currentUser,
                        context: context,
                        title: titleController.text,
                        firmOrOrganization: firmOrOrganisationController.text,
                        summary: summaryController.text,
                      );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: SvgPicture.asset(
                'assets/svg/tick.svg',
                colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                height: 45,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic info',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Add Title',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: titleController,
                hintText: 'Title',
                obsecureText: false,
              ),
              SizedBox(height: 15),
              Text(
                'Add Law firm / Organisation',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: firmOrOrganisationController,
                hintText: 'Law firm / Organisation',
                obsecureText: false,
              ),
              SizedBox(height: 15),
              Text(
                'Add Summary',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                maxLength: 1000,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                controller: summaryController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Tell us about your experience',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
