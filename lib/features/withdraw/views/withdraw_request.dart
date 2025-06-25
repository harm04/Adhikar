import 'package:adhikar/common/widgets/custom_button.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/withdraw/controller/withdraw_controller.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WithdrawRequest extends ConsumerStatefulWidget {
  const WithdrawRequest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WithdrawRequestState();
}

class _WithdrawRequestState extends ConsumerState<WithdrawRequest> {
  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController upiIdController = TextEditingController();

    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    void requestWithdraw() {
      ref
          .read(withdrawControllerProvider.notifier)
          .withdrawRequest(
            currentUser: currentUser,
            amount: amountController.text,
            upiId: upiIdController.text,
            context: context,
          );
    }

    final isLoading = ref.watch(withdrawControllerProvider);
    return currentUser == null || isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Withdraw Request'),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    '${currentUser.credits}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Pallete.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                              labelText: 'Enter Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => amountController.text = currentUser
                              .credits
                              .toString(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Pallete.primaryColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(13.0),
                              child: Center(
                                child: Text(
                                  'Withdraw all',
                                  style: TextStyle(
                                    color: Pallete.whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'UPI ID',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: upiIdController,
                      decoration: InputDecoration(
                        labelText: 'Enter UPI ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 42, 3, 0),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 19, 3),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Note: Please enter your UPI ID carefully. If you enter the wrong UPI ID, we will not be able to refund your money.',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (upiIdController.text.isEmpty ||
                            amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }

                        // Convert amountController.text to double for comparison
                        final enteredAmount = double.tryParse(
                          amountController.text,
                        );
                        if (enteredAmount == null ||
                            enteredAmount > currentUser.credits) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Insufficient credits'),
                            ),
                          );
                          return;
                        }

                        requestWithdraw();
                      },
                      child: const CustomButton(text: 'Request withdraw'),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
