import 'package:adhikar/apis/transaction_api.dart';
import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/models/transaction_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, bool>((ref) {
      return TransactionController(
        transactionAPI: ref.watch(transactionAPIAPIProvider),
        ref: ref,
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
  final Ref ref;

  TransactionController({
    required TransactionAPI transactionAPI,
    required this.ref,
  }) : _transactionAPI = transactionAPI,
       super(false);

  // Create transaction
  Future<Either<Failure, Document>> createTransaction({
    required UserModel userModel,
    required UserModel expertUserModel,
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

    

    final r = res.getOrElse((_) => throw Exception('Unexpected error'));
    final transactionId = r.$id;

    // Update user with transaction
    final updatedUser = userModel.copyWith(
      transactions: [...userModel.transactions, transactionId],
    );
    final res1 = await _transactionAPI.updateUserWithTransaction(
      updatedUser,
      transactionId,
    );
   

    // Update expert with transaction
    final updatedExpert = expertUserModel.copyWith(
      transactions: [...expertUserModel.transactions, transactionId],
    );
    final res2 = await _transactionAPI.updateExpertWithTransaction(
      updatedExpert,
      transactionId,
    );
    state = false;
    

    // Navigate to BottomNavBar after successful transaction
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
      (route) => false,
    );

    showSnackbar(context, 'Transaction completed successfully');
    return res;
  }

  Future<List<TransactionModel>> getUserTransactionList(
    UserModel userModel,
  ) async {
    final meetingsList = await _transactionAPI.getUserTransaction(userModel);
    return meetingsList
        .map((meetings) => TransactionModel.fromMap(meetings.data))
        .toList();
  }

  // Update transaction status
  Future<void> updateTransactionStatus({
    required String paymentId,
    required String status,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _transactionAPI.updateTransactionStatus(
      paymentId,
      status,
    );
    state = false;
    res.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) {
        showSnackbar(context, 'Transaction status updated successfully');
      },
    );
  }
}
