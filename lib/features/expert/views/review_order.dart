import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/expert_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewOrder extends ConsumerStatefulWidget {
  final ExpertModel expertModel;
  final String phone;
  const ReviewOrder({
    super.key,
    required this.expertModel,
    required this.phone,
  });

  @override
  ConsumerState<ReviewOrder> createState() => _ReviewOrderState();

  static Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: '$title\n',
          style: const TextStyle(color: Colors.white, fontSize: 12),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewOrderState extends ConsumerState<ReviewOrder> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Review your order',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 18.0,
          right: 18,
          bottom: 60,
          top: 20,
        ),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(231, 209, 95, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Continue to Payment',
                style: const TextStyle(
                  color: Pallete.backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 580,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Pallete.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        widget.expertModel.profImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                    // Bottom-to-top gradient overlay for blur effect
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 100, // adjust for blur height
                      child: IgnorePointer(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Text(
                        '${widget.expertModel.firstName} ${widget.expertModel.lastName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 0,
                ),

                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '${currentUser.firstName} ${currentUser.lastName}',
                  style: const TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 0,
                ),

                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  currentUser.email,
                  style: const TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 0,
                ),

                child: Text(
                  'Contact Number',
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.phone,
                  style: const TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        color: Pallete.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹300',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(231, 209, 95, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
