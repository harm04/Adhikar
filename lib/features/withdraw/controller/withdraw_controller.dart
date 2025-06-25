import 'package:adhikar/apis/withdraw_api.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/transaction_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/models/withdraw_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider
final withdrawControllerProvider =
    StateNotifierProvider<WithdrawController, bool>((ref) {
      return WithdrawController(
        ref: ref,
        withdrawAPI: ref.watch(withdrawAPIProvider),
      );
    });

final getWithdrawProvider = FutureProvider.autoDispose((ref) async {
  final withdrawController = ref.watch(withdrawControllerProvider.notifier);
  return withdrawController.getWithdraw();
});

class WithdrawController extends StateNotifier<bool> {
  final Ref _ref;
  final WithdrawAPI _withdrawAPI;

  WithdrawController({required Ref ref, required WithdrawAPI withdrawAPI})
    : _ref = ref,
      _withdrawAPI = withdrawAPI,

      super(false);

  void withdrawRequest({
    required String amount,
    required String upiId,
    required UserModel currentUser,
    required BuildContext context,
  }) async {
    state = true;
    WithdrawModal withdrawModal = WithdrawModal(
      amount: amount,
      upiId: upiId,
      uid: currentUser.uid,
      status: 'Pending',
      id: '',
      createdAt: DateTime.now(),
    );
    final res = await _withdrawAPI.requestWithdraw(withdrawModal);

    res.fold((l) => showSnackbar(context, l.message), (r) {
      _ref
          .read(transactionControllerProvider.notifier)
          .createTransaction(
            userModel: currentUser,
            expertUserModel: currentUser,
            amount: double.parse(amount).toInt(),
            paymentStatus: 'Requested',
            phone: currentUser.phone,
            paymentID: r.$id,
            context: context,
          );
      state = false;
      Navigator.pop(context);
      showSnackbar(context, 'Withdraw request sent successfully');
    });
  }

  Future<List<WithdrawModal>> getWithdraw() async {
    final withdrawList = await _withdrawAPI.getWithdraw();
    return withdrawList
        .map((withdraw) => WithdrawModal.fromMap(withdraw.data))
        .toList();
  }

  //accept withdraw request
  void acceptWithdrawRequest({
    required WithdrawModal withdrawModal,
    required UserModel currentUser,
    required BuildContext context,
  }) async {
    state = true;
    WithdrawModal updatedWithdraw = withdrawModal.copyWith(
      status: 'Paid',
      id: withdrawModal.id,
    );

    final res = await _withdrawAPI.updateWithdrawStatus(
      withdrawModal.id,
      updatedWithdraw.status,
    );

    res.fold((l) => showSnackbar(context, l.message), (r) {
      _ref
          .read(transactionControllerProvider.notifier)
          .updateTransactionStatus(
            paymentId: withdrawModal.id,
            status: 'Paid',
            context: context,
          );
      // Update user's credits
      final updatedCredits =
          currentUser.credits - double.parse(withdrawModal.amount);
      _ref
          .read(authControllerProvider.notifier)
          .updateUserCredits(uid: currentUser.uid, credits: updatedCredits);

      state = false;
      Navigator.pop(context);
      showSnackbar(context, 'Withdraw request accepted successfully');
    });
  }

  //reject withdraw request
  void rejectWithdrawRequest({
    required WithdrawModal withdrawModal,
    required BuildContext context,
  }) async {
    state = true;
    WithdrawModal updatedWithdraw = withdrawModal.copyWith(
      status: 'Rejected',
      id: withdrawModal.id,
    );
    final res = await _withdrawAPI.updateWithdrawStatus(
      withdrawModal.id,
      updatedWithdraw.status,
    );
    res.fold((l) => showSnackbar(context, l.message), (r) {
      //update transaction status
      _ref
          .read(transactionControllerProvider.notifier)
          .updateTransactionStatus(
            paymentId: withdrawModal.id,
            status: 'Rejected',
            context: context,
          );
      state = false;
      Navigator.pop(context);
      showSnackbar(context, 'Withdraw request rejected successfully');
    });
  }
}
