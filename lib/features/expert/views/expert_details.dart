import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/features/expert/views/confirm_phone.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpertDetails extends ConsumerStatefulWidget {
  final ExpertModel expertModel;
  const ExpertDetails({super.key, required this.expertModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpertDetailsState();
}

class _ExpertDetailsState extends ConsumerState<ExpertDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book an Expert'), centerTitle: true),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 18.0,
          right: 18,
          bottom: 60,
          top: 20,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ConfirmPhone(expertModel: widget.expertModel);
                },
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
                    child: Image.network(
                      widget.expertModel.profImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.expertModel.firstName} ${widget.expertModel.lastName}',
                style: const TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
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
