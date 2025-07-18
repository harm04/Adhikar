import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/common/widgets/custom_textfield.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/auth/views/signup.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerStatefulWidget {
  SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: emailController.text,
          ref: ref,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return isLoading
        ? LoadingPage()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            color: Pallete.whiteColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'It\'s great to see you again',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Email',
                          style: TextStyle(
                            color: Pallete.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        CustomTextfield(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          textCapitalization: TextCapitalization.none,
                          obsecureText: false,
                          hintText: 'email',
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Password',
                          style: TextStyle(
                            color: Pallete.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        CustomTextfield(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          textCapitalization: TextCapitalization.none,
                          obsecureText: true,
                          hintText: 'password',
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Reset password',
                                style: TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            onLogin();
                          },
                          child: CustomButton(text: 'Login'),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SignUpScreen();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

// import 'package:adhikar/common/widgets/custom_button.dart';
// import 'package:adhikar/features/auth/controllers/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SignInScreen extends ConsumerStatefulWidget {
//   SignInScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends ConsumerState<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () {
//               ref
//                   .read(authControllerProvider.notifier)
//                   .googleSignIn(context: context, ref: ref);
//             },
//             child: CustomButton(text: 'Login with Google'),
//           ),
//           SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Login with Email',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
