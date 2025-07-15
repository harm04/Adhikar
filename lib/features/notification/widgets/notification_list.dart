import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/notification/controller/notification_controller.dart';
import 'package:adhikar/features/profile/views/profile.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/features/posts/widgets/post_card.dart';
import 'package:adhikar/features/showcase/widgets/showcase_list_card.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsList extends ConsumerWidget {
  final String userId;
  const NotificationsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(getUserNotificationsProvider(userId));
    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Center(
            child: Text(
              'No notifications yet.',
              style: TextStyle(color: context.textSecondaryColor),
            ),
          );
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ref
                .watch(userDataProvider(notification.senderId))
                .when(
                  data: (sender) {
                    Widget? relatedCard;
                    if (notification.postId != null &&
                        notification.postId!.isNotEmpty) {
                      relatedCard = Consumer(
                        builder: (context, ref, _) {
                          final postAsync = ref.watch(
                            singlePostProvider(notification.postId!),
                          );
                          return postAsync.when(
                            data: (post) => post != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 5,
                                    ),
                                    child: PostCard(
                                      postmodel: post,
                                      isReadOnly: true,
                                    ),
                                  )
                                : SizedBox(),
                            loading: () => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: LinearProgressIndicator(
                                color: context.secondaryColor,
                              ),
                            ),
                            error: (e, st) => SizedBox(),
                          );
                        },
                      );
                    } else if (notification.showcaseId != null &&
                        notification.showcaseId!.isNotEmpty) {
                      relatedCard = Consumer(
                        builder: (context, ref, _) {
                          final showcaseAsync = ref.watch(
                            singleShowcaseProvider(notification.showcaseId!),
                          );
                          return showcaseAsync.when(
                            data: (showcase) => showcase != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 5,
                                    ),
                                    child: ShowcaseListCard(showcase: showcase),
                                  )
                                : SizedBox(),
                            loading: () => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: LinearProgressIndicator(
                                color: context.secondaryColor,
                              ),
                            ),
                            error: (e, st) => SizedBox(),
                          );
                        },
                      );
                    }

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(userModel: sender),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: sender.profileImage == ''
                                  ? AssetImage(ImageTheme.defaultProfileImage)
                                  : NetworkImage(sender.profileImage)
                                        as ImageProvider,
                            ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: context.secondaryColor,
                              ),
                            ),
                            subtitle: Text(
                              notification.body,
                              style: TextStyle(
                                fontSize: 17,
                                color: context.textPrimaryColor,
                              ),
                            ),
                            trailing: Text(
                              '~ ${timeago.format(notification.createdAt)}',
                              style: TextStyle(
                                fontSize: 15,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ),
                          if (relatedCard != null) relatedCard,
                          Divider(color: context.dividerColor),
                        ],
                      ),
                    );
                  },
                  error: (error, st) => ErrorText(error: error.toString()),
                  loading: () => SizedBox(),
                );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: context.secondaryColor),
      ),
      error: (e, st) => Center(
        child: Text('Error: $e', style: TextStyle(color: context.errorColor)),
      ),
    );
  }
}
