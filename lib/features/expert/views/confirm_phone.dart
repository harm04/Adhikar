import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/views/review_order.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmPhone extends ConsumerStatefulWidget {
  final UserModel expertUserModel; // Changed type to UserModel
  const ConfirmPhone({super.key, required this.expertUserModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmPhoneState();
}

class _ConfirmPhoneState extends ConsumerState<ConfirmPhone> {
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(currentUserDataProvider).value;
    phoneController = TextEditingController(text: currentUser?.phone ?? '');
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Phone number'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              //phone number textfield with country code and india flag
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // India flag emoji
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                        child: const Text(
                          '🇮🇳',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Country code
                      const Text(
                        '+91',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    String digits = newValue.text.replaceAll('-', '');
                    String formatted = '';
                    for (int i = 0; i < digits.length && i < 10; i++) {
                      if (i == 3 || i == 6) formatted += '-';
                      formatted += digits[i];
                    }
                    return TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  final phone = phoneController.text.trim();
                  final phoneDigits = phone.replaceAll('-', '');
                  if (phoneDigits.length != 10 ||
                      int.tryParse(phoneDigits) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Phone number must be in 000-000-0000 format',
                        ),
                      ),
                    );
                    return;
                  }
                  // Proceed with booking logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ReviewOrder(
                          expertUserModel: widget.expertUserModel, // Now UserModel
                          phone: phoneDigits,
                        );
                      },
                    ),
                  );
                },
                child: CustomButton(text: 'Book a Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
