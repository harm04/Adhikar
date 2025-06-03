import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/expert/controller/expert_controller.dart';
import 'package:adhikar/models/meetings_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class MeetingsListCard extends ConsumerStatefulWidget {
  final MeetingsModel meetings;
  const MeetingsListCard({super.key, required this.meetings});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowcaseListCardState();
}

class _ShowcaseListCardState extends ConsumerState<MeetingsListCard> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(expertDataProvider(widget.meetings.expertUid))
        .when(
          data: (expertData) {
            return Card(
              color: Pallete.cardColor,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 19),
                height: 110,
                child: Row(
                  children: [
                    // Left section: Image and text
                    Expanded(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              expertData.profImage,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${expertData.firstName} ${expertData.lastName}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/location.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                        Pallete.greyColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      expertData.state,
                                      style: TextStyle(
                                        color: Pallete.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Booked ${timeago.format(widget.meetings.createdAt, locale: 'en_short')} ago',
                                  style: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right section: Divider and status icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 19.0,
                            right: 19,
                            top: 19,
                            bottom: 19,
                          ),
                          child: Container(width: 1.2, color: Colors.grey[400]),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              widget.meetings.meetingStatus == 'pending'
                                  ? 'assets/svg/pending_meeting.svg'
                                  : 'assets/svg/completed_meeting.svg',
                              width: 40,
                              height: 40,
                              colorFilter: ColorFilter.mode(
                                widget.meetings.meetingStatus == 'pending'
                                    ? Pallete.redColor
                                    : Colors.green,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.meetings.meetingStatus == 'pending'
                                  ? 'Pending'
                                  : 'Completed',
                              style: TextStyle(
                                color:
                                    widget.meetings.meetingStatus == 'pending'
                                    ? Pallete.redColor
                                    : Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          error: (err, st) => ErrorText(error: err.toString()),
          loading: () => SizedBox(),
        );
  }
}
