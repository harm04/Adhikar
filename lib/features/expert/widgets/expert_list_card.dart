import 'package:adhikar/features/expert/views/expert_details.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            SizedBox(height: 2),
            //name and description
            Text(
              '${widget.expertModel.firstName} ${widget.expertModel.lastName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(
              widget.expertModel.description,
              maxLines: widget.expertModel.tags.isEmpty ? 6 : 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            // Display tags
            if (widget.expertModel.tags.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      children: [
                        ...widget.expertModel.tags
                            .take(3)
                            .map((tag) => Chip(label: Text(tag))),
                        if (widget.expertModel.tags.length > 3)
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, top: 6),
                            child: Text(
                              '...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 5),
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
