import 'dart:io';

import 'package:adhikar/apis/showcase_api.dart';
import 'package:adhikar/apis/storage_api.dart';
import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider
final showcaseControllerProvider =
    StateNotifierProvider<ShowcaseController, bool>((ref) {
      return ShowcaseController(
        ref: ref,
        showcaseAPI: ref.watch(showcaseAPIProvider),
        storageApi: ref.watch(storageAPIProvider),
      );
    });

final getShowcaseProvider = FutureProvider.autoDispose((ref) async {
  final showcaseController = ref.watch(showcaseControllerProvider.notifier);
  return showcaseController.getShowcase();
});

final getCommentsProvider = FutureProvider.family((
  ref,
  ShowcaseModel showcaseModel,
) async {
  final commentsController = ref.watch(showcaseControllerProvider.notifier);
  return commentsController.getComments(showcaseModel);
});

// final getUsersPostProvider = FutureProvider.family((
//   ref,
//   UserModel userModel,
// ) async {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.getUsersPost(userModel);
// });

// final getPodsPostProvider = FutureProvider.family((ref, String podName) async {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.getPodsPost(podName);
// });

final getLatestShowcaseProvider = StreamProvider.autoDispose((ref) {
  ref.keepAlive();
  final showcaseAPI = ref.watch(showcaseAPIProvider);

  return showcaseAPI.getLatestShowcase();
});

final showcaseStreamProvider = StreamProvider.family
    .autoDispose<ShowcaseModel, String>((ref, showcaseId) {
      final showcaseAPI = ref.watch(showcaseAPIProvider);
      // Listen to realtime updates for this post
      return showcaseAPI.getShowcaseStream(showcaseId);
    });

class ShowcaseController extends StateNotifier<bool> {
  final Ref _ref;
  final ShowcaseAPI _showcaseAPI;
  final StorageApi _storageApi;
  ShowcaseController({
    required Ref ref,
    required ShowcaseAPI showcaseAPI,
    required StorageApi storageApi,
  }) : _ref = ref,
       _showcaseAPI = showcaseAPI,
       _storageApi = storageApi,
       super(false);

  //sharing post main function
  void shareShowcase({
    required String title,
    required String tagline,
    required String description,
    required File? bannerImage,
    required File? logoImage,
    required List<File> images,
    required String commentedTo,
    required BuildContext context,
  }) {
    if (title.isEmpty) {
      showSnackbar(context, 'Please write Title');
      return;
    }
    if (description.isEmpty) {
      showSnackbar(context, 'Please write Description');
      return;
    }

    if (images.isNotEmpty) {
      _shareImagePost(
        title: title,
        images: images,
        bannerImage: bannerImage,
        logoImage: logoImage,
        commentedTo: commentedTo,
        context: context,
        tagline: tagline,
        description: description,
      );
    } else {
      _shareTextPost(
        title: title,
        bannerImage: bannerImage,
        logoImage: logoImage,
        commentedTo: commentedTo,
        context: context,
        tagline: tagline,
        description: description,
      );
    }
  }

  //sharing image post
  void _shareImagePost({
    required String title,
    required List<File> images,
    required String commentedTo,
    required String tagline,
    required String description,
    required File? bannerImage,
    required File? logoImage,
    required BuildContext context,
  }) async {
    state = true;
    String link = _linkInTheText(description);
    final hashtags = _hashtagInText(description);
    final user = _ref.watch(currentUserDataProvider).value!;
    String bannerImageUrl = '';
    if (bannerImage != null) {
      bannerImageUrl = await _storageApi.uploadShowcaseFile(bannerImage);
    }

    String logoImageUrl = '';
    if (logoImage != null) {
      logoImageUrl = await _storageApi.uploadShowcaseFile(logoImage);
    }

    final imageUrls = await _storageApi.uploadShowcaseFiles(images);
    ShowcaseModel showcaseModel = ShowcaseModel(
      title: title,
      tagline: tagline,
      link: link,
      hashtags: hashtags,
      uid: user.uid,
      description: description,
      id: '',
      bannerImage: bannerImageUrl,
      logoImage: logoImageUrl,
      createdAt: DateTime.now(),
      images: imageUrls,
      upvotes: [],
      commentIds: [],
      type: PostType.image,
      commentedTo: commentedTo,
    );

    final res = await _showcaseAPI.shareShowcase(showcaseModel);
    state = false;
    Navigator.pop(context);
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Showcased successfully'),
    );
  }

  //sharing text post
  void _shareTextPost({
    required String title,
    required String commentedTo,
    required BuildContext context,
    required String tagline,
    required String description,
    File? bannerImage,
    File? logoImage,
  }) async {
    state = true;
    String link = _linkInTheText(description);
    final hashtags = _hashtagInText(description);
    final user = _ref.watch(currentUserDataProvider).value!;

    String bannerImageUrl = '';
    if (bannerImage != null) {
      bannerImageUrl = await _storageApi.uploadShowcaseFile(bannerImage);
    }

    String logoImageUrl = '';
    if (logoImage != null) {
      logoImageUrl = await _storageApi.uploadShowcaseFile(logoImage);
    }

    ShowcaseModel showcaseModel = ShowcaseModel(
      title: title,
      tagline: tagline,
      link: link,
      hashtags: hashtags,
      uid: user.uid,
      description: description,
      id: '',
      bannerImage: bannerImageUrl,
      logoImage: logoImageUrl,
      createdAt: DateTime.now(),
      images: [],
      upvotes: [],
      commentIds: [],
      type: PostType.text,
      commentedTo: commentedTo,
    );

    final res = await _showcaseAPI.shareShowcase(showcaseModel);
    state = false;
    Navigator.pop(context);
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Showcased successfully'),
    );
  }

  Future shareComment({
    required String text,
    required String commentedTo,
    required String tagline,
    required BuildContext context,
  }) async {
    state = true;
    String link = _linkInTheText(text);
    final hashtags = _hashtagInText(text);
    final user = _ref.watch(currentUserDataProvider).value!;
    ShowcaseModel showcaseModel = ShowcaseModel(
      title: text,
      tagline: tagline,
      link: link,
      hashtags: hashtags,
      uid: user.uid,
      description: '',
      id: '',
      bannerImage: '',
      logoImage: '',
      createdAt: DateTime.now(),
      images: [],
      upvotes: [],
      commentIds: [],
      type: PostType.text,
      commentedTo: commentedTo,
    );

    final res = await _showcaseAPI.shareShowcase(showcaseModel);
    res.fold((l) => showSnackbar(context, l.message), (r) async {
      // Fetch parent post to get current commentIds
      final parentShowcase = await _showcaseAPI.getShowcase();
      final parentShowcaseDoc = parentShowcase.firstWhere(
        (doc) => doc.$id == commentedTo,
      );
      final parentShowcases = ShowcaseModel.fromMap(parentShowcaseDoc.data);
      final updatedCommentIds = List<String>.from(parentShowcases.commentIds)
        ..add(r.$id);
      final res2 = await _showcaseAPI.addCommentIdToShowcase(
        commentedTo,
        updatedCommentIds,
      );
      state = false;
      Navigator.pop(context);
      res2.fold(
        (l) => showSnackbar(context, l.message),
        (r) => showSnackbar(context, 'Comment posted successfully'),
      );
    });
  }

  //identifying link in the text
  String _linkInTheText(String text) {
    String link = '';
    final List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('http') ||
          word.startsWith('https') ||
          word.startsWith('www')) {
        link = word;
      }
    }
    return link;
  }

  //identifying hashtag in the text
  List<String> _hashtagInText(String text) {
    List<String> hashtags = [];
    final List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<List<ShowcaseModel>> getShowcase() async {
    final showcaseList = await _showcaseAPI.getShowcase();
    return showcaseList
        .map((showcase) => ShowcaseModel.fromMap(showcase.data))
        .where((showcase) => showcase.tagline != 'comment')
        .toList();
  }

  Future<List<ShowcaseModel>> getComments(ShowcaseModel showcaseModel) async {
    final commentsList = await _showcaseAPI.getComments(showcaseModel);
    return commentsList
        .map((showcase) => ShowcaseModel.fromMap(showcase.data))
        .toList();
  }

  // Future<List<PostModel>> getUsersPost(UserModel userModel) async {
  //   final postList = await _postAPI.getUsersPost(userModel);
  //   return postList.map((post) => PostModel.fromMap(post.data)).toList();
  // }

  // Future<List<PostModel>> getPodsPost(String podName) async {
  //   final postList = await _postAPI.getPodsPost(podName);
  //   return postList.map((post) => PostModel.fromMap(post.data)).toList();
  // }

  //upvote showcase
  void upvoteShowcase(ShowcaseModel showcaseModel, UserModel userModel) async {
    List<String> upvotes = showcaseModel.upvotes;
    if (upvotes.contains(userModel.uid)) {
      upvotes.remove(userModel.uid);
    } else {
      upvotes.add(userModel.uid);
    }
    showcaseModel = showcaseModel.copyWith(upvotes: upvotes);
    await _showcaseAPI.upvoteShowcase(showcaseModel);
  }

  //bookmark showcase

  void bookmarkPost(ShowcaseModel showcaseModel, UserModel userModel) async {
    List<String> bookmarks = userModel.bookmarked;
    if (bookmarks.contains(showcaseModel.id)) {
      bookmarks.remove(showcaseModel.id);
    } else {
      bookmarks.add(showcaseModel.id);
    }
    userModel = userModel.copyWith(bookmarked: bookmarks);
    await _showcaseAPI.bookmarkShowcase(userModel);
  }
}
