import 'dart:io';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/providers/provider.dart';

import 'package:appwrite/appwrite.dart';

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
          file: InputFile.fromPath(path: file.path));
      imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }

  // Future<List<String>> uploadDocFiles(List<PlatformFile> files) async {
  //   List<String> imageLinks = [];
  //   for (final file in files) {
  //     final uploadedImage = await _storage.createFile(
  //         bucketId: AppwriteConstants.postStorageBucketID,
  //         fileId: ID.unique(),
  //         file: InputFile.fromPath(path: file.path!));
  //     imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
  //   }
  //   return imageLinks;
  // }
}