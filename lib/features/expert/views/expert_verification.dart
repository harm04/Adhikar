import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpertVerification extends StatefulWidget {
  const ExpertVerification({super.key});

  @override
  State<ExpertVerification> createState() => _ExpertVerificationState();
}

class _ExpertVerificationState extends State<ExpertVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verification pending '),automaticallyImplyLeading: false,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/verify.svg', height: 95),
SizedBox(height: 20,),
              Text(
                'Your request for verification has been sent. Please wait while our team verifies your documents. It usually takes 24 hrs.',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 190),
            ],
          ),
        ),
      ),
    );
  }
}
