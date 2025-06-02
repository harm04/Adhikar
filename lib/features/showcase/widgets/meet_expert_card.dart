import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetExpertCard extends ConsumerWidget {
  final UserModel user;
  const MeetExpertCard({super.key,required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Pallete.cardColor,
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImage == ''
                    ? AssetImage('assets/images/logo.png')
                    : NetworkImage(user.profileImage) as ImageProvider,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.firstName + ' ' + user.lastName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Pallete.whiteColor,
                      ),
                    ),
                    Text(
                      user.bio == '' ? 'Adhikar user' : user.bio,
                      style: TextStyle(fontSize: 16, color: Pallete.greyColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Pallete.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    child: Center(
                      child: Text(
                        'Follow',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
