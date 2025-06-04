
import 'package:adhikar/common/widgets/custom_textfield.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({super.key});

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  TextEditingController titleController = TextEditingController();
  TextEditingController organisationController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Experience'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset(
              'assets/icons/ic_correct.png',
              height: 25,
              color: Colors.green,
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
              Text('Basic info',
                  style: TextStyle(
                      color: Pallete.backgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              Text('Add Title',
                  style: TextStyle(
                    color: Pallete.backgroundColor,
                    fontSize: 17,
                  )),
              SizedBox(height: 5),
              CustomTextfield(
                  keyboardType: TextInputType.text,
                  controller: titleController,
                  hintText: 'Title',
                  obsecureText: false),
              SizedBox(
                height: 15,
              ),
              Text('Add Organisation',
                  style: TextStyle(
                    color: Pallete.backgroundColor,
                    fontSize: 17,
                  )),
              SizedBox(height: 5),
              CustomTextfield(
                  keyboardType: TextInputType.text,
                  controller: organisationController,
                  hintText: 'Organisation',
                  obsecureText: false),
              SizedBox(
                height: 15,
              ),
              Text('Add Summary',
                  style: TextStyle(
                    color: Pallete.backgroundColor,
                    fontSize: 17,
                  )),
              SizedBox(height: 5),
              TextField(
                maxLines: 5,
                controller: summaryController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Summary',
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