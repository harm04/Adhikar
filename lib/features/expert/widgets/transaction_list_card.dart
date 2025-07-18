import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/transaction_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TransactionListCard extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  TransactionListCard({super.key, required this.transaction});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionListCardState();
}

class _TransactionListCardState extends ConsumerState<TransactionListCard> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(userDataProvider(widget.transaction.expertUid))
        .when(
          data: (expertUser) {
            return Card(
              color: Pallete.cardColor,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 19),
                height: 140,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction.paymentStatus == 'Requested'
                                  ? "Your Payment will be transfered once verified."
                                  : widget.transaction.paymentStatus == 'Paid'
                                  ? 'Your Payment is successfully transfered.'
                                  : widget.transaction.paymentDescription,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.transaction.paymentStatus == 'Success'
                                  ? 'ID : ${widget.transaction.paymentID}'
                                  : widget.transaction.paymentStatus ==
                                        'Requested'
                                  ? 'ID : ${widget.transaction.paymentID}'
                                  : widget.transaction.paymentStatus == 'Paid'
                                  ? "Withdraw successfull"
                                  : 'Transaction failed',
                              style: TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            //created at
                            Text(
                              DateFormat(
                                'dd MMMM, yyyy',
                              ).format(widget.transaction.createdAt),
                              style: TextStyle(color: Pallete.whiteColor),
                            ),
                          ],
                        ),
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
                            //amount
                            Text(
                              '₹${widget.transaction.amount.toString()}',
                              style: TextStyle(
                                color:
                                    widget.transaction.paymentStatus ==
                                        'Success'
                                    ? Colors.green
                                    : widget.transaction.paymentStatus ==
                                          'Requested'
                                    ? Pallete.primaryColor
                                    : widget.transaction.paymentStatus == 'Paid'
                                    ? Colors.green
                                    : Pallete.redColor,
                                fontSize: 23,
                              ),
                            ),
                            SizedBox(height: 7),
                            SvgPicture.asset(
                              widget.transaction.paymentStatus == 'Success' ||
                                      widget.transaction.paymentStatus == 'Paid'
                                  ? 'assets/svg/payment_success.svg'
                                  : widget.transaction.paymentStatus ==
                                        'Requested'
                                  ? 'assets/svg/payment_success.svg'
                                  : 'assets/svg/failed_payement.svg',
                              width: 40,
                              height: 40,
                              colorFilter: ColorFilter.mode(
                                widget.transaction.paymentStatus == 'Success' ||
                                        widget.transaction.paymentStatus ==
                                            'Paid'
                                    ? Colors.green
                                    : widget.transaction.paymentStatus ==
                                          'Requested'
                                    ? Pallete.primaryColor
                                    : Pallete.redColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              widget.transaction.paymentStatus == 'Success'
                                  ? 'Successfull'
                                  : widget.transaction.paymentStatus ==
                                        'Requested'
                                  ? 'Requested'
                                  : widget.transaction.paymentStatus == 'Paid'
                                  ? 'Paid'
                                  : 'Failed',
                              style: TextStyle(
                                color:
                                    widget.transaction.paymentStatus ==
                                            'Success' ||
                                        widget.transaction.paymentStatus ==
                                            'Paid'
                                    ? Colors.green
                                    : widget.transaction.paymentStatus ==
                                          'Requested'
                                    ? Pallete.primaryColor
                                    : Pallete.redColor,
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
