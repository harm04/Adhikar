import 'package:adhikar/apis/transaction_api.dart';
import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/models/transaction_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, bool>((ref) {
      return TransactionController(
        transactionAPI: ref.watch(transactionAPIAPIProvider),
      );
    });

final getUserTransactionProvider = FutureProvider.family((
  ref,
  UserModel userModel,
) async {
  final transactionController = ref.watch(
    transactionControllerProvider.notifier,
  );
  return transactionController.getUserTransactionList(userModel);
});

class TransactionController extends StateNotifier<bool> {
  final TransactionAPI _transactionAPI;

  TransactionController({required TransactionAPI transactionAPI})
    : _transactionAPI = transactionAPI,
      super(false);

  //create transaction
  void createTransaction({
    required UserModel userModel,
    required UserModel expertUserModel, // Changed from ExpertModel to UserModel
    required String phone,
    required String paymentID,
    required BuildContext context,
    required String paymentStatus,
    required int amount,
  }) async {
    state = true;

    TransactionModel transactionModel = TransactionModel(
      id: '',
      createdAt: DateTime.now(),
      clientPhone: phone,
      amount: amount,
      clientUid: userModel.uid,
      paymentStatus: paymentStatus,
      expertUid: expertUserModel.uid,
      paymentID: paymentID,
      paymentDescription:
          'Payment for meeting with ${expertUserModel.firstName} ${expertUserModel.lastName}',
    );

    final res = await _transactionAPI.createTransaction(transactionModel);

    res.fold((l) => showSnackbar(context, l.message), (r) async {
      final transactionId = r.$id;

      final updatedUser = userModel.copyWith(
        transactions: [...userModel.transactions, transactionId],
      );

      final res1 = await _transactionAPI.updateUserWithTransaction(
        updatedUser,
        transactionId,
      );
      res1.fold((l) => showSnackbar(context, l.message), (r) async {
        final updatedExpert = expertUserModel.copyWith(
          transactions: [...expertUserModel.transactions, transactionId],
        );
        final res2 = await _transactionAPI.updateExpertWithTransaction(
          updatedExpert,
          transactionId,
        );
        state = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BottomNavBar();
            },
          ),
        );
        res2.fold((l) => showSnackbar(context, l.message), (r) {});
      });
    });
  }

  Future<List<TransactionModel>> getUserTransactionList(
    UserModel userModel,
  ) async {
    final meetingsList = await _transactionAPI.getUserTransaction(userModel);
    return meetingsList
        .map((meetings) => TransactionModel.fromMap(meetings.data))
        .toList();
  }
}
