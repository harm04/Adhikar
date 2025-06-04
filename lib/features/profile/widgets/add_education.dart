import 'package:adhikar/common/widgets/custom_textfield.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';

class AddEducation extends StatefulWidget {
  const AddEducation({super.key});

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  TextEditingController degreeController = TextEditingController();
  TextEditingController streamController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Education'),
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
              Text(
                'Basic info',
                style: TextStyle(
                  color: Pallete.backgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Add Degree',
                style: TextStyle(color: Pallete.backgroundColor, fontSize: 17),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,

                controller: degreeController,
                hintText: 'Degree',
                obsecureText: false,
              ),
              SizedBox(height: 15),
              Text(
                'Add Stream',
                style: TextStyle(color: Pallete.backgroundColor, fontSize: 17),
              ),
              SizedBox(height: 5),
              CustomTextfield(
                keyboardType: TextInputType.text,
                controller: streamController,
                hintText: 'Stream',
                obsecureText: false,
              ),
              SizedBox(height: 15),
              Text(
                'Add University',
                style: TextStyle(color: Pallete.backgroundColor, fontSize: 17),
              ),
              SizedBox(height: 5),
              TextField(
                maxLines: 5,
                controller: universityController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'University',
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
