import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/meetings_controller.dart';
import 'package:adhikar/models/meetings_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class MeetingsListCard extends ConsumerStatefulWidget {
  final MeetingsModel meetingsModel;
  const MeetingsListCard({super.key, required this.meetingsModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MeetingsListCardState();
}

class _MeetingsListCardState extends ConsumerState<MeetingsListCard> {
  late String meetingStatus;
  final TextEditingController otpController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    super.initState();
    meetingStatus = widget.meetingsModel.meetingStatus;
  }

  @override
  void didUpdateWidget(covariant MeetingsListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.meetingsModel.meetingStatus != meetingStatus) {
      setState(() {
        meetingStatus = widget.meetingsModel.meetingStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    // USER VIEW
    if (currentUser.userType == 'User') {
      return ref
          .watch(userDataProvider(widget.meetingsModel.expertUid))
          .when(
            data: (expertdata) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Pallete.cardColor,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Pallete.secondaryColor),
                    ),
                    height: 180,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              expertdata.profileImage.isNotEmpty
                                  ? expertdata.profileImage
                                  : ImageTheme.defaultProfileImage,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${expertdata.firstName} ${expertdata.lastName}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svg/verified.svg',
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          Pallete.secondaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/location.svg',
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                        Pallete.secondaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text(
                                      expertdata.state,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Pallete.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Text('Booked: '),
                                    SizedBox(width: 5),
                                    Text(
                                      timeago.format(
                                        widget.meetingsModel.createdAt,
                                      ),
                                    ),
                                  ],
                                ),
                                // Show OTP if meeting is pending
                                if (meetingStatus == 'pending') ...[
                                  SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        27,
                                        45,
                                        68,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/lock.svg',
                                          height: 20,
                                          colorFilter: ColorFilter.mode(
                                            Pallete.whiteColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'OTP: ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          widget.meetingsModel.otp,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Pallete.secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(height: 7),
                                if (meetingStatus == 'completed')
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      color: Colors.green.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Completed',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
    }

    // EXPERT VIEW
    return ref
        .watch(userDataProvider(widget.meetingsModel.clientUid))
        .when(
          data: (clientData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Pallete.cardColor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Pallete.secondaryColor),
                  ),
                  height: 180,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            clientData.profileImage.isNotEmpty
                                ? clientData.profileImage
                                : ImageTheme.defaultProfileImage,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${clientData.firstName} ${clientData.lastName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/call.svg',
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      Pallete.secondaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    clientData.phone,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Pallete.secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Text('Booked: '),
                                  const SizedBox(width: 5),
                                  Text(
                                    timeago.format(
                                      widget.meetingsModel.createdAt,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (meetingStatus == 'pending')
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        String? localError;
                                        final dialogOtpController =
                                            TextEditingController();
                                        return StatefulBuilder(
                                          builder: (context, setStateDialog) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Enter OTP to Complete Meeting',
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Ask client for OTP to mark this meeting as completed.\n\nClient can find the meeting OTP in the meetings tab.',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        dialogOtpController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 6,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Enter OTP from client',
                                                      errorText: localError,
                                                      border:
                                                          const OutlineInputBorder(),
                                                      counterText: '',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final enteredOtp =
                                                        dialogOtpController.text
                                                            .trim();
                                                    if (enteredOtp.isEmpty) {
                                                      setStateDialog(() {
                                                        localError =
                                                            'Please enter OTP';
                                                      });
                                                      return;
                                                    }
                                                    final isValid = await ref
                                                        .read(
                                                          meetingsControllerProvider
                                                              .notifier,
                                                        )
                                                        .verifyAndCompleteMeeting(
                                                          widget
                                                              .meetingsModel
                                                              .id,
                                                          enteredOtp,
                                                          widget
                                                              .meetingsModel
                                                              .expertUid,
                                                        );
                                                    if (isValid) {
                                                      setState(() {
                                                        meetingStatus =
                                                            'completed';
                                                        errorText = null;
                                                      });
                                                      dialogOtpController
                                                          .clear();
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      showSnackbar(
                                                        context,
                                                        'Meeting marked as completed',
                                                      );
                                                      ref.invalidate(
                                                        getExpertMeetingsProvider,
                                                      );
                                                    } else {
                                                      setStateDialog(() {
                                                        localError =
                                                            'Invalid OTP. Please try again.';
                                                      });
                                                    }
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Click to enter OTP',
                                    style: TextStyle(
                                      color: Pallete.secondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (meetingStatus == 'completed')
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),)
              );
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
  }
}
