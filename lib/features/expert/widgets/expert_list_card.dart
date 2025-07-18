import 'package:adhikar/features/expert/views/expert_details.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExpertListCard extends ConsumerStatefulWidget {
  final UserModel expertUserModel;
  ExpertListCard({super.key, required this.expertUserModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpertListCardState();
}

class _ExpertListCardState extends ConsumerState<ExpertListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Pallete.cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Let content dictate height
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio:
                          1.2, // Keeps image proportional on all screens
                      child: Card(
                        color: Pallete.cardColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3.0),
                          child: Image.network(
                            widget.expertUserModel.profileImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${widget.expertUserModel.firstName} ${widget.expertUserModel.lastName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7.0, right: 7),
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
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/location.svg',
                          width: 18,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            Pallete.greyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.expertUserModel.state,
                            style: TextStyle(color: Pallete.greyColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        widget.expertUserModel.description,
                        maxLines: widget.expertUserModel.tags.isEmpty ? 4 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (widget.expertUserModel.tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: [
                          Chip(label: Text(widget.expertUserModel.tags.first)),
                        ],
                      ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Pallete.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ExpertDetails(
                            expertUserModel: widget.expertUserModel,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
