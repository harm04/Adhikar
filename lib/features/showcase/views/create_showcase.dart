import 'dart:io';

import 'package:adhikar/common/pick_image.dart';
import 'package:adhikar/common/widgets/custom_textfield.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateShowcase extends ConsumerStatefulWidget {
  CreateShowcase({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateShowcaseState();
}

class _CreateShowcaseState extends ConsumerState<CreateShowcase> {
  TextEditingController titleController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<File> images = [];
  File? bannerImage;
  File? logoImage;

  @override
  void initState() {
    super.initState();
    titleController.addListener(_onTextChanged);
    descriptionController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    titleController.removeListener(_onTextChanged);
    descriptionController.removeListener(_onTextChanged);
    titleController.dispose();
    taglineController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onPickeImages() async {
    images = await pickImages();
    setState(() {});
  }

  void onPickebannerImage() async {
    final picked = await pickImage();
    if (picked != null) {
      bannerImage = picked;
      setState(() {});
    }
  }

  void onPickelogoImages() async {
    final picked = await pickImage();
    if (picked != null) {
      logoImage = picked;
      setState(() {});
    }
  }

  void shareShowcase() {
    ref
        .read(showcaseControllerProvider.notifier)
        .shareShowcase(
          tagline: taglineController.text,
          title: titleController.text,
          description: descriptionController.text,
          bannerImage: bannerImage,
          logoImage: logoImage,
          images: images,
          commentedTo: '',
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    final isLoading = ref.watch(showcaseControllerProvider);
    return currentUser == null || isLoading
        ? LoadingPage()
        : Scaffold(
            appBar: AppBar(title: Text('Case Showcase'), centerTitle: true),
            //bottom bar
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: context.dividerColor, width: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () => onPickeImages(),
                      child: SvgPicture.asset(
                        'assets/svg/gallery.svg',
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          context.secondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0, top: 10),
                    child: GestureDetector(
                      onTap: () => shareShowcase(),
                      child: Row(
                        children: [
                          Text(
                            'Upload',
                            style: TextStyle(
                              color:
                                  titleController.text.trim().length >= 5 &&
                                      descriptionController.text
                                              .trim()
                                              .length >=
                                          100
                                  ? context.successColor
                                  : context.textSecondaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/svg/tick.svg',
                            height: 39,
                            colorFilter: ColorFilter.mode(
                              titleController.text.trim().length >= 5 &&
                                      descriptionController.text
                                              .trim()
                                              .length >=
                                          100
                                  ? context.successColor
                                  : context.textSecondaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    //a sqare curved container for logo
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.borderColor,
                            width: 2,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onPickelogoImages();
                          },
                          child: logoImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/add_image.svg',
                                      colorFilter: ColorFilter.mode(
                                        context.iconPrimaryColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 39,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Add Logo',
                                      style: TextStyle(
                                        color: context.textPrimaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    logoImage!,
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    buildTextField(
                      controller: titleController,
                      hintText: 'Min. 5 Characters',
                      label: 'Title',
                      isRequired: true,
                      maxLength: 20,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      controller: taglineController,
                      hintText: 'Min. 20 Characters',
                      label: 'Tagline',
                      isRequired: false,
                      maxLength: 50,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          backgroundColor: context.surfaceColor,
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
                                          color: context.textPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      guidelineItem(
                                        'Showcase only real cases you have personally worked on, participated in, or have explicit permission to discuss. Avoid sharing fabricated or misleading case details, as authenticity is crucial for community trust.',
                                        '1',
                                      ),
                                      guidelineItem(
                                        'Respect client confidentiality at all times. Do not disclose names, contact details, or any identifying information about clients, witnesses, or other parties unless you have obtained their explicit, written consent.',
                                        '2',
                                      ),
                                      guidelineItem(
                                        'Focus on the legal aspects, unique challenges, and learning outcomes of the case. Share your strategies, legal reasoning, and the impact of the case on your professional growth or the legal community.',
                                        '3',
                                      ),
                                      guidelineItem(
                                        'Avoid personal attacks, defamatory statements, or negative commentary about individuals, organizations, or opposing counsel. Maintain a professional and respectful tone in all your posts and comments.',
                                        '4',
                                      ),
                                      guidelineItem(
                                        'Ensure your showcase is educational, insightful, or inspiring for other legal professionals and students. Share lessons learned, innovative approaches, or landmark judgments that can benefit the community.',
                                        '5',
                                      ),
                                      guidelineItem(
                                        'Do not use the Showcase for blatant self-promotion, advertising, or solicitation of clients. Subtle mentions of your firm or practice are acceptable if relevant to the case, but avoid overt marketing language.',
                                        '6',
                                      ),
                                      guidelineItem(
                                        'Do not share any content that violates laws, bar council rules, or ethical standards for legal professionals. This includes, but is not limited to, sub judice matters, contempt of court, or privileged communications.',
                                        '7',
                                      ),
                                      guidelineItem(
                                        'Keep your language professional and courteous. Avoid profanity, slang, or any language that could be considered disrespectful or inappropriate in a professional setting.',
                                        '8',
                                      ),
                                      guidelineItem(
                                        'If you are sharing documents, images, or media related to a case, ensure that all sensitive information is redacted and that you have the right to share such materials.',
                                        '9',
                                      ),
                                      guidelineItem(
                                        'Engage constructively with comments and questions on your showcase. Be open to feedback, differing perspectives, and healthy debate, but always respond with professionalism and respect.',
                                        '10',
                                      ),
                                      guidelineItem(
                                        'Repeated violations of these guidelines may result in moderation actions, including removal of posts, temporary suspension, or permanent banning from the platform.',
                                        '11',
                                      ),
                                      SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                context.primaryColor,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Got it!',
                                            style: TextStyle(
                                              color: context.secondaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
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
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Read community guidelines before posting!',
                            style: TextStyle(
                              color: context.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      controller: descriptionController,
                      hintText: 'Min. 100 Characters',
                      label: 'Description',
                      isRequired: true,
                      maxLength: 2000,
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: context.borderColor,
                          width: 2,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          onPickebannerImage();
                        },
                        child: bannerImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/add_image.svg',
                                    colorFilter: ColorFilter.mode(
                                      context.iconPrimaryColor,
                                      BlendMode.srcIn,
                                    ),
                                    height: 39,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Add Banner',
                                    style: TextStyle(
                                      color: context.textPrimaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  bannerImage!,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 40),
                    if (images.isNotEmpty) ...[
                      Text(
                        'Images',
                        style: TextStyle(
                          color: context.textPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  ],
                ),
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
              style: TextStyle(color: context.textPrimaryColor, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  //textfield
  Widget buildTextField({
    required String hintText,
    required String label,
    required bool isRequired,
    required int maxLength,

    required TextEditingController controller,
    int? maxLines,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              isRequired ? '(Required)' : '',
              style: TextStyle(color: context.textSecondaryColor, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 10),
        CustomTextfield(
          controller: controller,
          maxLines: maxLines ?? 1,
          textCapitalization: TextCapitalization.sentences,
          maxLength: maxLength,
          hintText: hintText,
          obsecureText: false,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
