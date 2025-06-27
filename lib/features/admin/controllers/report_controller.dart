import 'package:adhikar/apis/report_api.dart';
import 'package:adhikar/common/widgets/snackbar.dart';

import 'package:adhikar/models/report_modal.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/features/posts/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider
final reportControllerProvider = StateNotifierProvider<ReportController, bool>((
  ref,
) {
  return ReportController(reportAPI: ref.watch(reportAPIProvider));
});

final getReportsProvider = FutureProvider.autoDispose((ref) async {
  final reportController = ref.watch(reportControllerProvider.notifier);
  return reportController.getReports();
});

class ReportController extends StateNotifier<bool> {
  final ReportAPI _reportAPI;

  ReportController({required ReportAPI reportAPI})
    : _reportAPI = reportAPI,

      super(false);

  void report({
   
    required String postId,
    required UserModel currentUser,
    required String reason,
    required UserModel reportedUser,
    required BuildContext context,
  }) async {
    state = true;
    ReportModal reportModal = ReportModal(
      postId: postId,
      reason: reason,
      reporterUid: currentUser.uid,
      id: '',
      reportedUserUid: reportedUser.uid,
      
      createdAt: DateTime.now(),
    );
    final res = await _reportAPI.report(reportModal);

    res.fold((l) => showSnackbar(context, l.message), (r) {
      state = false;
      Navigator.pop(context);
      showSnackbar(context, 'Post reported successfully');
    });
  }

  Future<List<ReportModal>> getReports() async {
    final reportLists = await _reportAPI.getReports();
    return reportLists
        .map((reports) => ReportModal.fromMap(reports.data))
        .toList();
  }

  void deletePostByAdmin({
    required String postId,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ref
        .read(postControllerProvider.notifier)
        .markPostAsDeletedByAdmin(postId, context);
  }
}
