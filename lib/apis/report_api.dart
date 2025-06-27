import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/models/report_modal.dart';
import 'package:adhikar/providers/provider.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final reportAPIProvider = Provider((ref) {
  return ReportAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IReportAPI {
  FutureEither<Document> report(ReportModal reportModal);
  Future<List<Document>> getReports();
}

class ReportAPI implements IReportAPI {
  final Databases _db;

  ReportAPI({required Databases db}) : _db = db;

  @override
  FutureEither<Document> report(ReportModal reportModal) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.reportCollectionID,
        documentId: ID.unique(),
        data: reportModal.toMap(),
      );
      return right(document);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getReports() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.reportCollectionID,
    );

    return documents.documents;
  }

}
