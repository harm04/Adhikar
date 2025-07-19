import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetExpertCard extends ConsumerWidget {
  final UserModel user;
   MeetExpertCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Card(
      color: context.cardColor,
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileView(userModel: user);
                    },
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: user.profileImage == ''
                      ? AssetImage(ImageTheme.defaultProfileImage)
                      : NetworkImage(user.profileImage) as ImageProvider,
                ),
              ),
              SizedBox(width: 15),
              // Wrap the text column in Expanded
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileView(userModel: user);
                          },
                        ),
                      ),
                      child: Row(
                        children: [
                          // Wrap name in Flexible to avoid overflow
                          Flexible(
                            child: Text(
                              '${user.firstName} ${user.lastName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimaryColor,
                              ),
                            ),
                          ),
                          if (user.userType == 'Expert')
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 7.0,
                                right: 6,
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/verified.svg',
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  context.secondaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Wrap bio in Flexible to avoid overflow
                    Flexible(
                      child: Text(
                        user.bio == '' ? 'Adhikar user' : user.bio,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.textSecondaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Button
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 110,
                  ), // Limit button width
                  child: GestureDetector(
                    onTap: () async {
                      if (user.uid != currentUser.uid) {
                        ref
                            .read(authControllerProvider.notifier)
                            .followUser(
                              userModel: user,
                              currentUser: currentUser,
                              context: context,
                              ref: ref,
                            );
                        ref.invalidate(currentUserDataProvider);
                      }
                      if(user.uid == currentUser.uid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfileView(userModel: user);
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: context.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Center(
                          child: Text(
                            user.uid == currentUser.uid
                                ? 'View Profile'
                                : currentUser.following.contains(user.uid)
                                ? 'Unfollow'
                                : 'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
