import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';

import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final UserModel user;
  const SearchCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProfileView(userModel: user);
            },
          ),
        );
      },
      // child: ListTile(
      //   leading: CircleAvatar(
      //     radius: 35,
      //     backgroundImage: user.profileImage == ''
      //         ? NetworkImage(
      //             'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
      //           )
      //         : NetworkImage(user.profileImage),
      //   ),
      //   title: Text(
      //     '${user.firstName} ${user.lastName}',
      //     style: TextStyle(
      //       color: Pallete.whiteColor,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   subtitle: Text(user.email, style: TextStyle(color: Pallete.greyColor)),
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 3),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.profileImage == ''
                      ?AssetImage(ImageTheme.defaultProfileImage)
                      : NetworkImage(user.profileImage),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.bio == '' ? 'Adhikar user' : user.bio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Pallete.greyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
          ],
        ),
      ),
    );
  }
}
