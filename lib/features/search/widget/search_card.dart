import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 3),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.profileImage == ''
                      ? AssetImage(ImageTheme.defaultProfileImage)
                      : NetworkImage(user.profileImage),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              color: context.textPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          user.userType == 'Expert'
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: SvgPicture.asset(
                                    'assets/svg/verified.svg',
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      context.secondaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      Text(
                        user.bio == '' ? 'Adhikar user' : user.bio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.textHintColor,
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
