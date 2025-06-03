import 'package:adhikar/features/expert/views/expert_details.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExpertListCard extends ConsumerStatefulWidget {
  final ExpertModel expertModel;
  const ExpertListCard({super.key, required this.expertModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpertListCardState();
}

class _ExpertListCardState extends ConsumerState<ExpertListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //take width of the gridview box
              width: double.infinity,
              height: 170,
              child: Card(
                color: Pallete.cardColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.expertModel.profImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            //name and description
            Text(
              '${widget.expertModel.firstName} ${widget.expertModel.lastName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
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
                  widget.expertModel.state,
                  style: TextStyle(color: Pallete.greyColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.expertModel.description,
              maxLines: widget.expertModel.tags.isEmpty ? 6 : 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            // Display tags
            if (widget.expertModel.tags.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      children: [
                        ...widget.expertModel.tags
                            .take(2)
                            .map((tag) => Chip(label: Text(tag))),
                      ],
                    ),
                  ),
                ],
              ),

            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Pallete.primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExpertDetails(expertModel: widget.expertModel);
                      },
                    ),
                  );
                },
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
