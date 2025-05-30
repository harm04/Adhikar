import 'dart:io';
import 'package:adhikar/common/pick_image.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _AddPostViewState();
}

class _AddPostViewState extends ConsumerState<CreatePostScreen> {
  String dropDownValue = 'General';
  bool isAnonymous = false;
  TextEditingController postController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  void onPickeImages() async {
    images = await pickImages();
    setState(() {});
  }

  void sharePost() {
    ref
        .read(postControllerProvider.notifier)
        .sharePost(
          text: postController.text,
          isAnonymous: isAnonymous,
          pod: dropDownValue,
          images: images,
          commentedTo: '',
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return currentUser == null || isLoading
        ? LoadingPage()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text('Create Post'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAnonymous = !isAnonymous;
                            });
                          },
                          child: CircleAvatar(
                            radius: 45,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Pallete.whiteColor,
                                  radius: 45,
                                  backgroundImage: !isAnonymous
                                      ? currentUser.profileImage != ''
                                            ? NetworkImage(
                                                currentUser.profileImage,
                                              )
                                            : NetworkImage(
                                                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
                                              )
                                      : AssetImage(
                                          'assets/icons/anonymous.png',
                                        ),
                                ),
                                Center(
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/replace.png',
                                        height: 35,
                                        color: Pallete.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentUser.firstName} ${currentUser.lastName}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Click on your profile picture to toggle between user and anonymous posting',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Pallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    //pods
                    Container(
                      // width: 260,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Pallete.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Pallete.whiteColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropDownValue,
                          borderRadius: BorderRadius.circular(10),
                          icon: SvgPicture.asset(
                            'assets/svg/drop_down_arrow.svg',
                            colorFilter: ColorFilter.mode(
                              Pallete.whiteColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          style: TextStyle(
                            color: Pallete.whiteColor,
                            fontSize: 16,
                          ),
                          items: [
                            dropdownMenuItem(
                              'Freelance & Legal Services',
                              'assets/icons/ic_freelance_services.png',
                              'Freelance & Legal Services',
                            ),
                            dropdownMenuItem(
                              'Criminal & Civil Law',
                              'assets/icons/ic_criminal_law.png',
                              'Criminal & Civil Law',
                            ),
                            dropdownMenuItem(
                              'Corporate & Business Law',
                              'assets/icons/ic_businees_law.png',
                              'Corporate & Business Law',
                            ),
                            dropdownMenuItem(
                              'Moot Court & Bar Exam Prep',
                              'assets/icons/ic_exam_prep.png',
                              'Moot Court & Bar Exam Prep',
                            ),
                            dropdownMenuItem(
                              'Internships & Job Opportunities',
                              'assets/icons/ic_internship_and_job.png',
                              'Internships & Job Opportunities',
                            ),
                            dropdownMenuItem(
                              'Legal Tech & AI',
                              'assets/icons/ic_legal_tech_and_ai.png',
                              'Legal Tech & AI',
                            ),
                            dropdownMenuItem(
                              'Case Discussions',
                              'assets/icons/ic_case_discussion.png',
                              'Case Discussions',
                            ),
                            dropdownMenuItem(
                              'Legal News & Updates',
                              'assets/icons/ic_legal_news_and_updates.png',
                              'Legal News & Updates',
                            ),
                            dropdownMenuItem(
                              'General',
                              'assets/icons/ic_general.png',
                              'General',
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              dropDownValue = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //community guidelines
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          backgroundColor: Pallete.backgroundColor,
                          isScrollControlled: true,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.5,
                              minChildSize: 0.3,
                              maxChildSize: 0.9,
                              builder: (context, scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Community Guidelines',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Pallete.whiteColor,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      guidelineItem(
                                        'Do not use profanity. Your post/comments will be moderated and can even lead to banning accounts. Casual use in a running sentence is okay. For example- FML. Dafuq. Sheeet. These words are okay. Pure slangs with the intention of being rude or to hurt someone will not be acceptable on Adhikar.',
                                        '1',
                                      ),
                                      guidelineItem(
                                        'Do not leak private data of a individual or a company.',
                                        '2',
                                      ),
                                      guidelineItem(
                                        'DO not berate or defame anyone you personally know. Personal vendetta against individual wont\'t be tolerated.',
                                        '3',
                                      ),
                                      guidelineItem(
                                        'Do not share personal or sensitive data.',
                                        '4',
                                      ),
                                      guidelineItem(
                                        'Blatant self-promotion isn\'t allowed. Please avoid or else these posts will be moderated. You can let people know abot your firm subtly.',
                                        '5',
                                      ),
                                      guidelineItem(
                                        'Selling courses is banned. Don\'t do in feed or DM\'s. If this gets reported it might lead to a banned.',
                                        '6',
                                      ),
                                      SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Pallete.primaryColor,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Got it!',
                                            style: TextStyle(
                                              color: Pallete.secondaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Pallete.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Read community guidelines before posting!',
                            style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //textfiel
                    TextField(
                      controller: postController,
                      maxLength: 1000,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your post here...',
                      ),
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((file) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.file(file),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            //icons and post button
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Pallete.greyColor, width: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () => onPickeImages(),
                          child: SvgPicture.asset(
                            'assets/svg/gallery.svg',
                            height: 30,
                            colorFilter: ColorFilter.mode(Pallete.secondaryColor,  BlendMode.srcIn,),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          'assets/svg/emoji.svg',
                          height: 30,
                          colorFilter: ColorFilter.mode(Pallete.secondaryColor,  BlendMode.srcIn,),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0, top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.primaryColor,
                      ),
                      onPressed: sharePost,
                      child: Text(
                        'Post',
                        style: TextStyle(color: Pallete.whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // bottomsheet
  Widget guidelineItem(String text, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$number. ' + text,
              style: TextStyle(color: Pallete.whiteColor, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  //pod widget
  DropdownMenuItem dropdownMenuItem(String value, String imgPath, String text) {
    {
      return DropdownMenuItem(
        value: value,
        child: Row(
          children: [
            CircleAvatar(radius: 15, backgroundImage: AssetImage(imgPath)),
            SizedBox(width: 7),
            Text(text),
          ],
        ),
      );
    }
  }
}
