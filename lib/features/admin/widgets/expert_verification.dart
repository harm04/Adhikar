import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/expert/controller/expert_controller.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertVerification extends ConsumerStatefulWidget {
  final ExpertModel expert;
  const ExpertVerification({super.key, required this.expert});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpertVerificationState();
}

class _ExpertVerificationState extends ConsumerState<ExpertVerification> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(expertControllerProvider);

    return ref
        .watch(expertDataProvider(widget.expert.uid))
        .when(
          data: (expert) {
            return isLoading
                ? Loader()
                : Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Expert Verification - ${expert.firstName} ${expert.lastName}',
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: expert.approved == 'true'
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Approved',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    // Approve button
                                    GestureDetector(
                                      onTap: () => ref
                                          .read(
                                            expertControllerProvider.notifier,
                                          )
                                          .approveExpert(
                                            expert.uid,
                                            context,
                                            ref,
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Card(
                                          color: const Color.fromARGB(
                                            255,
                                            10,
                                            1,
                                            94,
                                          ),
                                          child: SizedBox(
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                'Approve',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    121,
                                                    106,
                                                    255,
                                                  ),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    // Reject button
                                    GestureDetector(
                                      onTap: () => ref
                                          .read(
                                            expertControllerProvider.notifier,
                                          )
                                          .rejectExpert(
                                            expert.uid,
                                            context,
                                            ref,
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Card(
                                          color: const Color.fromARGB(
                                            255,
                                            83,
                                            6,
                                            1,
                                          ),
                                          child: SizedBox(
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                'Reject',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    255,
                                                    17,
                                                    0,
                                                  ),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
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
                      ],
                    ),

                    body: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        children: [
                          Container(
                            width: 400,
                            height: double.infinity,

                            decoration: BoxDecoration(
                              color: Pallete.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 400,
                                      width: 400,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                            child: Image.network(
                                              expert.profImage,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 400,
                                            ),
                                          ),
                                          // Bottom-to-top gradient overlay for blur effect
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            height:
                                                100, // adjust for blur height
                                            child: IgnorePointer(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20),
                                                      ),
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black,
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),

                                    //expert uid
                                    Row(
                                      children: [
                                        Text(
                                          'Expert uid : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.uid,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert phone
                                    Row(
                                      children: [
                                        Text(
                                          'Phone : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.phone,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert email
                                    Row(
                                      children: [
                                        Text(
                                          'Email : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.email,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert DoB
                                    Row(
                                      children: [
                                        Text(
                                          'DOB : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.dob,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20), // Expert State
                                    Row(
                                      children: [
                                        Text(
                                          'State : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.state,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert city
                                    Row(
                                      children: [
                                        Text(
                                          'City : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.uid,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert address1
                                    Row(
                                      children: [
                                        Text(
                                          'Address 1 : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.address1,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert address 2
                                    Row(
                                      children: [
                                        Text(
                                          'Address 2 : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.address2,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert cases won
                                    Row(
                                      children: [
                                        Text(
                                          'Cases won : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.casesWon,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Expert experience
                                    Row(
                                      children: [
                                        Text(
                                          'Experience : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          expert.experience,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    if (expert.tags.isNotEmpty)
                                      Wrap(
                                        spacing: 6,
                                        children: expert.tags
                                            .map(
                                              (tag) => Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Chip(
                                                  backgroundColor:
                                                      Pallete.primaryColor,
                                                  label: Text(
                                                    tag,
                                                    style: TextStyle(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Right side: Documents and Description
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 40.0,
                                right: 40,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Uploaded Documents",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _DocumentPreview(
                                        url: expert.idDoc,
                                        label: "ID Document",
                                      ),
                                      SizedBox(width: 16),
                                      _DocumentPreview(
                                        url: expert.proofDoc,
                                        label: "Proof Document",
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  // Description below documents, with limited width
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          220 * 2 +
                                          16, // width of two documents + spacing
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Description',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          expert.description,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Pallete.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
          error: (err, st) => ErrorText(error: err.toString()),
          loading: () => Loader(),
        );
  }
}

class _DocumentPreview extends StatelessWidget {
  final String url;
  final String label;

  const _DocumentPreview({required this.url, required this.label});

  bool get isPdf {
    final path = Uri.parse(url).path.toLowerCase();
    return path.endsWith('.pdf');
  }

  bool get isImage {
    final path = Uri.parse(url).path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Cannot open document.")));
        }
      },
      child: Container(
        width: 220,
        height: 260,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: isPdf
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap to view/download",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              )
            : isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: 320,
                  height: 360,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/doc.svg',
                      width: 60,
                      height: 60,
                      colorFilter: ColorFilter.mode(
                        Pallete.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Pallete.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tap to view/download",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Pallete.greyColor),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
