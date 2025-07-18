import 'package:adhikar/models/message_modal.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/features/message/views/messaging.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationsListScreen extends ConsumerWidget {
  final UserModel currentUser;
  ConversationsListScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages'), centerTitle: true),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ref
            .read(messagingControllerProvider)
            .getUserConversationsStream(currentUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final conversations = snapshot.data!;
          if (conversations.isEmpty) {
            return Center(child: Text('No conversations yet'));
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final peerId = conversations[index]['peerId'] as String;
              final lastMessage =
                  conversations[index]['message'] as MessageModel;

              return FutureBuilder<UserModel?>(
                future: ref.read(userDataByIdProvider(peerId).future),
                builder: (context, userSnap) {
                  if (!userSnap.hasData) {
                    return ListTile(
                      title: Center(child: Text('Loading...')),
                    );
                  }
                  final peerUser = userSnap.data!;
                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: peerUser.profileImage == ''
                              ? AssetImage(ImageTheme.defaultProfileImage)
                              : NetworkImage(peerUser.profileImage),
                        ),
                        if (lastMessage.senderId == peerId &&
                            lastMessage.isRead == false)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 117, 240, 121),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${peerUser.firstName} ${peerUser.lastName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${timeago.format(lastMessage.createdAt, locale: 'en_short')} ago',
                          style: TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      lastMessage.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Pallete.greyColor, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MessagingScreen(
                            currentUser: currentUser,
                            peerUser: peerUser,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
