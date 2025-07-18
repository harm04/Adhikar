import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/views/confirm_phone.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExpertDetails extends ConsumerStatefulWidget {
  final UserModel expertUserModel;
  ExpertDetails({super.key, required this.expertUserModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpertDetailsState();
}

class _ExpertDetailsState extends ConsumerState<ExpertDetails> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Book an Expert'), centerTitle: true),
      bottomNavigationBar: currentUser.userType == 'Expert'
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18,
                bottom: 60,
                top: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('How does the meeting work?'),
                      content: Text(
                        'Once you book a call with an expert and complete the payment, '
                        'the expert will reach out to you via phone call within 36 hours from the time of payment.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmPhone(
                                  expertUserModel: widget.expertUserModel,
                                ),
                              ),
                            );
                          },
                          child: Text('Book a Call'),
                        ),
                      ],
                    ),
                  );
                },
                child: CustomButton(text: 'Book a Call'),
              ),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 310,
                child: Card(
                  color: Colors.grey[200],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: ImageTheme.defaultAdhikarLogo,
                      image: widget.expertUserModel.profileImage,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          ImageTheme.defaultAdhikarLogo,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '${widget.expertUserModel.firstName} ${widget.expertUserModel.lastName}',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: SvgPicture.asset(
                      'assets/svg/verified.svg',
                      height: 40,
                      colorFilter: ColorFilter.mode(
                        Pallete.secondaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svg/location.svg',
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      Pallete.greyColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${widget.expertUserModel.state}, ${widget.expertUserModel.city}',
                    style: TextStyle(color: Pallete.greyColor, fontSize: 17),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Wrap(
                children: [
                  Chip(
                    label: Text(
                      'Cases won : ${widget.expertUserModel.casesWon}',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Chip(
                    label: Text(
                      '${widget.expertUserModel.experience} years of experience',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),
              Text(
                'About ${widget.expertUserModel.firstName}',
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 17),
              Text(
                widget.expertUserModel.description,
                style: TextStyle(fontSize: 18, color: Pallete.greyColor),
              ),
              SizedBox(height: 30),
              Text(
                'Sector of Practice',
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 17),

              if (widget.expertUserModel.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: widget.expertUserModel.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
