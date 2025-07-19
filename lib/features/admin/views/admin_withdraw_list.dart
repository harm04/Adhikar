import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/withdraw/controller/withdraw_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminWithdrawList extends ConsumerStatefulWidget {
  AdminWithdrawList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminWithdrawListState();
}

class _AdminWithdrawListState extends ConsumerState<AdminWithdrawList> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(withdrawControllerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            body: ref
                .watch(getWithdrawProvider)
                .when(
                  data: (withdrawRequests) {
                    if (withdrawRequests.isEmpty) {
                      return const Center(
                        child: Text('No withdraw requests found.'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: withdrawRequests.length,
                      itemBuilder: (context, index) {
                        final withdrawRequest = withdrawRequests[index];
                        final expertAsync = ref.watch(
                          userDataProvider(withdrawRequest.uid),
                        );

                        if (expertAsync.isLoading) {
                          return const Loader(); // Show loader while expert data is loading
                        }

                        if (expertAsync.hasError) {
                          return ErrorText(
                            error: expertAsync.error.toString(),
                          ); // Handle error
                        }

                        final expert = expertAsync.value;
                        if (expert == null) {
                          return const SizedBox.shrink(); // Prevent rendering null values
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${expert.firstName} ${expert.lastName}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(' | '),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Available balance : ₹${expert.credits.toString()}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text('Phone: ${expert.phone}'),
                                          Text(
                                            'UPI ID: ${withdrawRequest.upiId}',
                                          ),
                                          Text(
                                            'Amount: ₹${withdrawRequest.amount}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    withdrawRequest.status == 'Rejected' ||
                                            withdrawRequest.status == 'Paid'
                                        ? Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  withdrawRequest.status ==
                                                      'Paid'
                                                  ? Colors.green.withOpacity(
                                                      0.2,
                                                    )
                                                  : Colors.orange.withOpacity(
                                                      0.2,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  withdrawRequest.status ==
                                                          'Paid'
                                                      ? 'Paid'
                                                      : 'Rejected',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        withdrawRequest
                                                                .status ==
                                                            'Paid'
                                                        ? Colors.green
                                                        : Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        withdrawControllerProvider
                                                            .notifier,
                                                      )
                                                      .acceptWithdrawRequest(
                                                        withdrawModal:
                                                            withdrawRequest,
                                                        currentUser: expert,
                                                        context: context,
                                                      );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Center(
                                                      child: Text(
                                                        'Accept',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        withdrawControllerProvider
                                                            .notifier,
                                                      )
                                                      .rejectWithdrawRequest(
                                                        withdrawModal:
                                                            withdrawRequest,
                                                        context: context,
                                                      );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: const Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, st) => ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
          );
  }
}
