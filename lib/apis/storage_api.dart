import 'dart:io';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/providers/provider.dart';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageAPIProvider = Provider((ref) {
  return StorageApi(storage: ref.watch(appwriteStorageProvider));
});

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadFiles(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.postStorageBucketID,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(AppwriteConstants.postImageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }

  Future<List<String>> uploadShowcaseFiles(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.showcaseStorageBucketID,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(AppwriteConstants.showcaseImageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }

  Future<String> uploadShowcaseFile(File file) async {
    final uploadedImage = await _storage.createFile(
      bucketId: AppwriteConstants.showcaseStorageBucketID,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path),
    );
    return AppwriteConstants.showcaseImageUrl(uploadedImage.$id);
  }

  Future<List<String>> uploadDocFiles(List<PlatformFile> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.expertStorageBucketID,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path!),
      );
      imageLinks.add(AppwriteConstants.expertImageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
