import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAccount extends ConsumerWidget {
  MyAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(title: Text('My Account'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            //name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${currentUser.firstName} ${currentUser.lastName}',
                    style: TextStyle(
                      color: Pallete.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            //email
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    currentUser.email,
                    style: TextStyle(
                      color: Pallete.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            //phone number
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    currentUser.phone == '' ? 'N/A' : currentUser.phone,
                    style: TextStyle(
                      color: Pallete.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
