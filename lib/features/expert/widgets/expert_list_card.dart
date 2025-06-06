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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Pallete.cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Let content dictate height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2, // Keeps image proportional on all screens
              child: Card(
                color: Pallete.cardColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: Image.network(
                    widget.expertModel.profImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '${widget.expertModel.firstName} ${widget.expertModel.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
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
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.expertModel.state,
                    style: TextStyle(color: Pallete.greyColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                widget.expertModel.description,
                maxLines: widget.expertModel.tags.isEmpty ? 4 : 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            if (widget.expertModel.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                children: [Chip(label: Text(widget.expertModel.tags.first))],
              ),
            const SizedBox(height: 8),
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
                        return ExpertDetails(expertModel: widget.expertModel);
                      },
                    ),
                  );
                },
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontSize: 16,
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
