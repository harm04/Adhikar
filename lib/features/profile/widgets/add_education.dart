import 'package:adhikar/common/widgets/custom_textfield.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AddEducation extends ConsumerStatefulWidget {
  final UserModel currentUser;
  const AddEducation({super.key,required this.currentUser});

  @override
  ConsumerState<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends ConsumerState<AddEducation> {
  TextEditingController degreeController = TextEditingController();
  TextEditingController streamController = TextEditingController();
  TextEditingController universityController = TextEditingController();

@override
  void dispose() {
    super.dispose();
    degreeController.dispose();
    streamController.dispose();
    universityController.dispose();
  }

  @override
  void initState() {
   super.initState();
    degreeController.text = widget.currentUser.eduDegree;
    streamController.text = widget.currentUser.eduStream;
    universityController.text = widget.currentUser.eduUniversity;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Education'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: () {
                if (degreeController.text.isNotEmpty &&
                    streamController.text.isNotEmpty &&
                    universityController.text.isNotEmpty) {
                  ref
                      .read(authControllerProvider.notifier)
                      .updateUserEducation(
                        userModel: widget.currentUser,
                        context: context,
                        degree: degreeController.text,
                        stream: streamController.text,
                        university: universityController.text,
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
                  color: Pallete.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Add Degree',
                style: TextStyle(color: Pallete.whiteColor, fontSize: 17),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,

                controller: degreeController,
                hintText: 'Degree',
                obsecureText: false,
              ),
              SizedBox(height: 15),
              Text(
                'Add Stream',
                style: TextStyle(color: Pallete.whiteColor, fontSize: 17),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: streamController,
                hintText: 'Stream',
                obsecureText: false,
              ),
              SizedBox(height: 15),
              Text(
                'Add University',
                style: TextStyle(color: Pallete.whiteColor, fontSize: 17),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: universityController,
                hintText: 'University',
                obsecureText: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
