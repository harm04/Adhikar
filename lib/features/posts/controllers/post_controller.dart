import 'dart:io';

import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/apis/storage_api.dart';
import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider
final postControllerProvider = StateNotifierProvider<PostController, bool>((
  ref,
) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageApi: ref.watch(storageAPIProvider),
  );
});

final getPostProvider = FutureProvider.autoDispose((ref) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPost();
});
final getCommentsProvider = FutureProvider.family((
  ref,
  PostModel postModel,
) async {
  final commentsController = ref.watch(postControllerProvider.notifier);
  return commentsController.getComments(postModel);
});

final getUsersPostProvider = FutureProvider.family((
  ref,
  UserModel userModel,
) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getUsersPost(userModel);
});

final getPodsPostProvider = FutureProvider.family((ref, String podName) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPodsPost(podName);
});

final getLatestPostProvider = StreamProvider.autoDispose((ref) {
  ref.keepAlive();
  final postAPI = ref.watch(postAPIProvider);

  return postAPI.getLatestPosts();
});
final postStreamProvider = StreamProvider.family.autoDispose<PostModel, String>((ref, postId) {
  final postAPI = ref.watch(postAPIProvider);
  // Listen to realtime updates for this post
  return postAPI.getPostStream(postId);
});

class PostController extends StateNotifier<bool> {
  final Ref _ref;
  final PostAPI _postAPI;
  final StorageApi _storageApi;
  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageApi storageApi,
  }) : _ref = ref,
       _postAPI = postAPI,
       _storageApi = storageApi,
       super(false);

  //sharing post main function
  void sharePost({
    required String text,
    required bool isAnonymous,
    required String pod,
    required List<File> images,
    required String commentedTo,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackbar(context, 'Please write something');
      return;
    }

    if (images.isNotEmpty) {
      _shareImagePost(
        text: text,
        images: images,
        commentedTo: commentedTo,
        context: context,
        isAnonymous: isAnonymous,
        pod: pod,
      );
    } else {
      _shareTextPost(
        text: text,
        context: context,
        isAnonymous: isAnonymous,
        pod: pod,
        commentedTo: commentedTo,
      );
    }
  }

  //sharing image post
  void _shareImagePost({
    required String text,
    required List<File> images,
    required String commentedTo,
    required bool isAnonymous,
    required String pod,
    required BuildContext context,
  }) async {
    state = true;
    String link = _linkInTheText(text);
    final hashtags = _hashtagInText(text);
    final user = _ref.watch(currentUserDataProvider).value!;
    final imageUrls = await _storageApi.uploadFiles(images);
    PostModel postModel = PostModel(
      text: text,
      link: link,
      hashtags: hashtags,
      uid: user.uid,
      id: '',
      pod: pod,
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
      images: imageUrls,
      likes: [],
      commentIds: [],
      type: PostType.image,
      commentedTo: commentedTo,
    );
    final res = await _postAPI.sharePost(postModel);
    state = false;
    Navigator.pop(context);
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Post uploaded successfully'),
    );
  }

  //sharing text post
  void _shareTextPost({
    required String text,
    required String commentedTo,
    required BuildContext context,
    required bool isAnonymous,
    required String pod,
  }) async {
    state = true;
    String link = _linkInTheText(text);
    final hashtags = _hashtagInText(text);
    final user = _ref.watch(currentUserDataProvider).value!;

    PostModel postModel = PostModel(
      text: text,
      link: link,
      hashtags: hashtags,
      uid: user.uid,
      id: '',
      pod: pod,
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
      images: [],
      likes: [],
      commentIds: [],
      type: PostType.text,
      commentedTo: commentedTo,
    );
    final res = await _postAPI.sharePost(postModel);
    state = false;
    Navigator.pop(context);
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Post uploaded successfully'),
    );
  }

  Future shareComment({
    required String text,
    required String commentedTo,
    required BuildContext context,
    required bool isAnonymous,
    required String pod,
  }) async {
    state = true;
    String link = _linkInTheText(text);
    final hashtags = _hashtagInText(text);
    final user = _ref.watch(currentUserDataProvider).value!;

    PostModel postModel = PostModel(
      text: text,
      link: link,
      hashtags: hashtags,
      uid: user.uid,
      id: '',
      pod: pod,
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
      images: [],
      likes: [],
      commentIds: [],
      type: PostType.text,
      commentedTo: commentedTo,
    );
    final res = await _postAPI.sharePost(postModel);
    res.fold((l) => showSnackbar(context, l.message), (r) async {
      // Fetch parent post to get current commentIds
      final parentPosts = await _postAPI.getPosts();
      final parentPostDoc = parentPosts.firstWhere(
        (doc) => doc.$id == commentedTo,
      );
      final parentPost = PostModel.fromMap(parentPostDoc.data);
      final updatedCommentIds = List<String>.from(parentPost.commentIds)
        ..add(r.$id);
      final res2 = await _postAPI.addCommentIdToPost(
        commentedTo,
        updatedCommentIds,
      );
      state = false;
      Navigator.pop(context);
      res2.fold(
        (l) => showSnackbar(context, l.message),
        (r) => showSnackbar(context, 'Post uploaded successfully'),
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

  Future<List<PostModel>> getPost() async {
    final postsList = await _postAPI.getPosts();
    return postsList
        .map((post) => PostModel.fromMap(post.data))
        .where((post) => post.pod != 'comment')
        .toList();
  }

  Future<List<PostModel>> getComments(PostModel postModel) async {
    final commentsList = await _postAPI.getComments(postModel);
    return commentsList.map((post) => PostModel.fromMap(post.data)).toList();
  }

  Future<List<PostModel>> getUsersPost(UserModel userModel) async {
    final postList = await _postAPI.getUsersPost(userModel);
    return postList.map((post) => PostModel.fromMap(post.data)).toList();
  }

  Future<List<PostModel>> getPodsPost(String podName) async {
    final postList = await _postAPI.getPodsPost(podName);
    return postList.map((post) => PostModel.fromMap(post.data)).toList();
  }

  //like post
  void likePost(PostModel postModel, UserModel userModel) async {
    List<String> likes = postModel.likes;
    if (likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      likes.add(userModel.uid);
    }
    postModel = postModel.copyWith(likes: likes);
    await _postAPI.likePost(postModel);
  }
  

  //bookmark post

  void bookmarkPost(PostModel postModel, UserModel userModel) async {
    List<String> bookmarks = userModel.bookmarked;
    if (bookmarks.contains(postModel.id)) {
      bookmarks.remove(postModel.id);
    } else {
      bookmarks.add(postModel.id);
    }
    userModel = userModel.copyWith(bookmarked: bookmarks);
    await _postAPI.bookmarkPost(userModel);
  }

  
}
