import 'package:adhikar/models/message_modal.dart';
import 'package:adhikar/features/message/controller/messaging_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/features/nyaysahayak/widget/chat_bubble.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/providers/open_chat_provider.dart'; // Import the provider

class MessagingScreen extends ConsumerStatefulWidget {
  final UserModel currentUser;
  final UserModel peerUser;
  MessagingScreen({
    super.key,
    required this.currentUser,
    required this.peerUser,
  });

  @override
  ConsumerState<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends ConsumerState<MessagingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clear the open chat user ID
    ref.read(openChatUserIdProvider.notifier).state = null;
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messagingControllerProvider)
          .markMessagesAsRead(widget.currentUser.uid, widget.peerUser.uid);
      // Set the open chat user ID
      ref.read(openChatUserIdProvider.notifier).state = widget.peerUser.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    final peerUser = widget.peerUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: peerUser.profileImage == ''
                  ? AssetImage(ImageTheme.defaultProfileImage)
                  : NetworkImage(peerUser.profileImage),
            ),
            SizedBox(width: 10),
            Text('${peerUser.firstName} ${peerUser.lastName}'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: ref
                  .read(messagingControllerProvider)
                  .getMessages(currentUser.uid, peerUser.uid),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUser.uid;
                    return ChatBubble(
                      direction: isMe ? Direction.right : Direction.left,
                      message: msg.text,
                      photoUrl: isMe
                          ? currentUser.profileImage == ''
                                ? null
                                : currentUser.profileImage
                          : peerUser.profileImage == ''
                          ? null
                          : peerUser.profileImage,
                      type: BubbleType.alone,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Pallete.searchBarColor,
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    final isNotEmpty = value.text.trim().isNotEmpty;
                    return IconButton(
                      icon: Icon(Icons.send, color: Pallete.whiteColor),
                      onPressed: isNotEmpty
                          ? () async {
                              final text = _controller.text.trim();
                              _controller.clear(); // Clear before sending
                              await ref
                                  .read(messagingControllerProvider)
                                  .sendMessage(
                                    senderId: widget.currentUser.uid,
                                    receiverId: widget.peerUser.uid,
                                    text: text,
                                    ref: ref,
                                  );
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
