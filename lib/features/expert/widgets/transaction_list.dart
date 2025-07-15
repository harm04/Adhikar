import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/transaction_controller.dart';
import 'package:adhikar/features/expert/widgets/transaction_list_card.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetingsListState();
}

class _MeetingsListState extends ConsumerState<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return ref
        .watch(getUserTransactionProvider(currentUser))
        .when(
          data: (transaction) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Transactions '),
                centerTitle: true,
              ),
              body: transaction.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions found.',
                        style: TextStyle(fontSize: 18, color: context.textSecondaryColor),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(getUserTransactionProvider(currentUser));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(18),
                        itemCount: transaction.length,
                        itemBuilder: (BuildContext context, int index) {
                          final transactions = transaction[transaction.length - 1 - index];
                          return TransactionListCard(transaction: transactions);
                        },
                      ),
                    ),
            );
          },
          error: (err, st) => ErrorPage(error: err.toString()),
          loading: () => LoadingPage(),
        );
  }
}
