import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/views/confirm_phone.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExpertDetails extends ConsumerStatefulWidget {
  final ExpertModel expertModel;
  const ExpertDetails({super.key, required this.expertModel});

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
      appBar: AppBar(title: const Text('Book an Expert'), centerTitle: true),
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
                      title: const Text('How does the meeting work?'),
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
                                  expertModel: widget.expertModel,
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
                  color: Colors.grey[200],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    // child: Image.network(
                    //   widget.expertModel.profImage,
                    //   fit: BoxFit.cover,
                    // ),
                    child: FadeInImage.assetNetwork(
                      placeholder: ImageTheme.defaultAdhikarLogo,
                      image: widget.expertModel.profImage,
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
                    '${widget.expertModel.firstName} ${widget.expertModel.lastName}',
                    style: const TextStyle(
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
                    '${widget.expertModel.state}, ${widget.expertModel.city}',
                    style: TextStyle(color: Pallete.greyColor, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                children: [
                  Chip(
                    label: Text(
                      'Cases won : ${widget.expertModel.casesWon}',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Chip(
                    label: Text(
                      '${widget.expertModel.experience} years of experience',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Text(
                'About ${widget.expertModel.firstName}',
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                widget.expertModel.description,
                style: const TextStyle(fontSize: 18, color: Pallete.greyColor),
              ),
              const SizedBox(height: 30),
              Text(
                'Sector of Practice',
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 17),

              if (widget.expertModel.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: widget.expertModel.tags
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
