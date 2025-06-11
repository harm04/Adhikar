import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/apis/showcase_api.dart';
import 'package:intl/intl.dart';

final todayStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final userAPI = ref.watch(userAPIProvider);
  final postAPI = ref.watch(postAPIProvider);
  final showcaseAPI = ref.watch(showcaseAPIProvider);

  final users = await userAPI.getUsers();
  final posts = await postAPI.getPosts();
  final showcases = await showcaseAPI.getShowcase();

  int countToday(List docs, String field) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    return docs.where((doc) {
      final raw = doc.data[field];
      DateTime? createdAt;
      if (raw is int) {
        createdAt = DateTime.fromMillisecondsSinceEpoch(raw);
      } else if (raw is String) {
        createdAt = DateTime.tryParse(raw);
        if (createdAt == null && int.tryParse(raw) != null) {
          createdAt = DateTime.fromMillisecondsSinceEpoch(int.parse(raw));
        }
        // Try parsing "Jun 11" format
        if (createdAt == null && raw.length == 6) {
          try {
            createdAt = DateFormat('MMM dd').parse(raw);
            // Set year to current year
            createdAt = DateTime(now.year, createdAt.month, createdAt.day);
          } catch (_) {}
        }
      }
      return createdAt != null && !createdAt.isBefore(startOfToday);
    }).length;
  }

  int usersToday = countToday(users, 'createdAt');
  int postsToday = countToday(posts, 'createdAt');
  int showcasesToday = countToday(showcases, 'createdAt');

  return {
    'users': usersToday,
    'posts': postsToday,
    'showcases': showcasesToday,
    // 'experts': expertsToday, // <-- Remove or comment out this line
  };
});
