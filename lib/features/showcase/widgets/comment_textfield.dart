import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentTextfield extends ConsumerStatefulWidget {
  final ShowcaseModel showcaseModel;
  final UserModel currentUser;
   CommentTextfield({
    super.key,
    required this.showcaseModel,
    required this.currentUser,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentTextfieldState();
}

class _CommentTextfieldState extends ConsumerState<CommentTextfield> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Pallete.greyColor, width: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Pallete.primaryColor,
                  backgroundImage: widget.currentUser.profileImage != ''
                      ? NetworkImage(widget.currentUser.profileImage)
                      : AssetImage(ImageTheme.defaultProfileImage),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Enter your reply here...',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    autofocus: true, // Auto-focus when tapping
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 10),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: commentController,
                  builder: (context, value, child) {
                    final isNotEmpty = value.text.trim().isNotEmpty;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isNotEmpty
                            ? Pallete.primaryColor
                            : Pallete.greyColor,
                      ),
                      onPressed: isNotEmpty
                          ? () async {
                              ref
                                  .read(showcaseControllerProvider.notifier)
                                  .shareComment(
                                    text: commentController.text,
                                    tagline: 'comment',
                                    context: context,
                                    commentedTo: widget.showcaseModel.id,
                                  );
                              commentController.clear();
                              ref.invalidate(
                                getCommentsProvider(widget.showcaseModel),
                              );
                            }
                          : null, // disables the button if empty
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Pallete.whiteColor),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
