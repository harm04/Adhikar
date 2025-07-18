import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/views/confirm_phone.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExpertDetails extends ConsumerStatefulWidget {
  final UserModel expertUserModel;
  const ExpertDetails({super.key, required this.expertUserModel});

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
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Book an Expert',
          style: TextStyle(color: context.textPrimaryColor),
        ),
        centerTitle: true,
        backgroundColor: context.surfaceColor,
        iconTheme: IconThemeData(color: context.iconPrimaryColor),
      ),
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
                      title: Text(
                        'How does the meeting work?',
                        style: TextStyle(color: context.textPrimaryColor),
                      ),
                      content: const Text(
                        'Once you book a call with an expert and complete the payment, '
                        'the expert will reach out to you via phone call within 36 hours from the time of payment.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
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
                          child: const Text('Book a Call'),
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
                  color: context.cardColor,
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '${widget.expertUserModel.firstName} ${widget.expertUserModel.lastName}',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: SvgPicture.asset(
                      'assets/svg/verified.svg',
                      height: 40,
                      colorFilter: ColorFilter.mode(
                        context.secondaryColor,
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
                      context.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${widget.expertUserModel.state}, ${widget.expertUserModel.city}',
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                children: [
                  Chip(
                    label: Text(
                      'Cases won : ${widget.expertUserModel.casesWon}',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Chip(
                    label: Text(
                      '${widget.expertUserModel.experience} years of experience',
                      style: TextStyle(
                        color: context.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Text(
                'About ${widget.expertUserModel.firstName}',
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                widget.expertUserModel.description,
                style: TextStyle(
                  fontSize: 18,
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Sector of Practice',
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 17),

              if (widget.expertUserModel.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: widget.expertUserModel.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: TextStyle(
                              color: context.textPrimaryColor,
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
