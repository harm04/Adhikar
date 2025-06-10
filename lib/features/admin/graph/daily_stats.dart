import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/apis/showcase_api.dart';
import 'package:adhikar/apis/expert_api.dart';

final todayStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final userAPI = ref.watch(userAPIProvider);
  final postAPI = ref.watch(postAPIProvider);
  final showcaseAPI = ref.watch(showcaseAPIProvider);
  final expertAPI = ref.watch(expertApiProvider);

  final users = await userAPI.getUsers();
  final posts = await postAPI.getPosts();
  final showcases = await showcaseAPI.getShowcase();
  final experts = await expertAPI.getExperts();

  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);

  int countToday(List docs, String field) {
    return docs.where((doc) {
      final createdAt =
          DateTime.tryParse(doc.data[field]?.toString() ?? '') ??
          (doc.data[field] is int
              ? DateTime.fromMillisecondsSinceEpoch(doc.data[field])
              : null);
      return createdAt != null && createdAt.isAfter(startOfToday);
    }).length;
  }

  int usersToday = countToday(users, 'createdAt');
  int postsToday = countToday(posts, 'createdAt');
  int showcasesToday = countToday(showcases, 'createdAt');
  int expertsToday = experts.where((doc) {
    final createdAt =
        DateTime.tryParse(doc.data['createdAt']?.toString() ?? '') ??
        (doc.data['createdAt'] is int
            ? DateTime.fromMillisecondsSinceEpoch(doc.data['createdAt'])
            : null);
    return createdAt != null && createdAt.isAfter(startOfToday);
  }).length;

  return {
    'users': usersToday,
    'posts': postsToday,
    'showcases': showcasesToday,
    // 'experts': expertsToday, // <-- Remove or comment out this line
  };
});
