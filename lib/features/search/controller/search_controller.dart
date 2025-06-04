
import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/models/user_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchUserControllerProvider = StateNotifierProvider((ref) {
  return SearchController(userAPI: ref.watch(userAPIProvider));
});

// User search
final searchUserProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  query,
) async {
  final userAPI = ref.watch(userAPIProvider);
  final docs = await userAPI.searchUser(query);
  return docs.map((doc) => UserModel.fromMap(doc.data)).toList();
});

// Post search
final searchPostsProvider = FutureProvider.family<List<PostModel>, String>((
  ref,
  query,
) async {
  final postAPI = ref.watch(postAPIProvider);
  final docs = await postAPI.searchPosts(query);
  return docs.map((doc) => PostModel.fromMap(doc.data)).toList();
});

class SearchController extends StateNotifier<bool> {
  final UserAPI _userAPI;

  SearchController({required UserAPI userAPI})
    : _userAPI = userAPI,
      super(false);

  Future<List<UserModel>> searchUSer(String name) async {
    final users = await _userAPI.searchUser(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }

}
