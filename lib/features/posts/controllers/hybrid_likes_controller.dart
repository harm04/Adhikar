import 'dart:async';
import 'dart:convert';
import 'package:adhikar/apis/posts_api.dart';
import 'package:adhikar/models/posts_model.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for the HybridLikesController
final hybridLikesControllerProvider =
    ChangeNotifierProvider<HybridLikesController>((ref) {
      return HybridLikesController(
        ref: ref,
        postAPI: ref.watch(postAPIProvider),
      );
    });

class HybridLikesController extends ChangeNotifier {
  final Ref _ref; // Keep for future use with notifications
  final PostAPI _postAPI;
  Timer? _syncTimer;
  bool _isSyncing = false;

  // Cache to store pending likes
  final Map<String, Set<String>> _pendingLikes = {};
  final Map<String, Set<String>> _pendingUnlikes = {};

  // Store the latest known state of posts' likes
  final Map<String, List<String>> _postsLikesCache = {};

  HybridLikesController({required Ref ref, required PostAPI postAPI})
    : _ref = ref,
      _postAPI = postAPI {
    _loadFromLocalStorage();
    _setupSyncTimer();
  }

  // Check if a post is liked by the user
  bool isLiked(String postId, String userId) {
    // Check local cache first
    if (_postsLikesCache.containsKey(postId)) {
      return _postsLikesCache[postId]!.contains(userId);
    }
    return false;
  }

  // Get the count of likes for a post
  int getLikeCount(String postId) {
    return _postsLikesCache[postId]?.length ?? 0;
  }

  // Initialize likes cache from a post model
  void initPostLikes(PostModel post) {
    if (!_postsLikesCache.containsKey(post.id)) {
      _postsLikesCache[post.id] = List<String>.from(post.likes);
    }
  }

  // Toggle like locally first, then queue for sync
  Future<bool> toggleLike(PostModel post, UserModel user) async {
    initPostLikes(post);
    final postId = post.id;
    final userId = user.uid;

    // Get current likes state
    final likes = _postsLikesCache[postId] ?? [];
    final isCurrentlyLiked = likes.contains(userId);

    // Toggle like in local cache
    if (isCurrentlyLiked) {
      _postsLikesCache[postId]!.remove(userId);
      // Add to pending unlikes
      _pendingUnlikes.putIfAbsent(postId, () => {}).add(userId);
      // Remove from pending likes if it was there
      _pendingLikes[postId]?.remove(userId);
    } else {
      _postsLikesCache[postId]!.add(userId);
      // Add to pending likes
      _pendingLikes.putIfAbsent(postId, () => {}).add(userId);
      // Remove from pending unlikes if it was there
      _pendingUnlikes[postId]?.remove(userId);
    }

    // Save changes to local storage
    await _saveToLocalStorage();

    // Notify listeners to update UI
    notifyListeners();

    // Return the new state (liked or not liked)
    return !isCurrentlyLiked;
  }

  // Setup timer for periodic syncing with the server
  void _setupSyncTimer() {
    // Sync every 30 seconds
    _syncTimer = Timer.periodic(Duration(seconds: 30), (_) => syncWithServer());
  }

  // Load cached likes from local storage
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load pending likes
      final pendingLikesJson = prefs.getString('pending_likes');
      if (pendingLikesJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(pendingLikesJson);
        decoded.forEach((postId, userIds) {
          _pendingLikes[postId] = Set<String>.from(userIds);
        });
      }

      // Load pending unlikes
      final pendingUnlikesJson = prefs.getString('pending_unlikes');
      if (pendingUnlikesJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(pendingUnlikesJson);
        decoded.forEach((postId, userIds) {
          _pendingUnlikes[postId] = Set<String>.from(userIds);
        });
      }

      // Load posts likes cache
      final postsLikesCacheJson = prefs.getString('posts_likes_cache');
      if (postsLikesCacheJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(postsLikesCacheJson);
        decoded.forEach((postId, userIds) {
          _postsLikesCache[postId] = List<String>.from(userIds);
        });
      }
    } catch (e) {
      debugPrint('Error loading likes from local storage: $e');
    }
  }

  // Save pending likes to local storage
  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert sets to lists for JSON serialization
      final Map<String, List<String>> pendingLikesMap = {};
      _pendingLikes.forEach((key, value) {
        pendingLikesMap[key] = value.toList();
      });

      final Map<String, List<String>> pendingUnlikesMap = {};
      _pendingUnlikes.forEach((key, value) {
        pendingUnlikesMap[key] = value.toList();
      });

      await prefs.setString('pending_likes', jsonEncode(pendingLikesMap));
      await prefs.setString('pending_unlikes', jsonEncode(pendingUnlikesMap));
      await prefs.setString('posts_likes_cache', jsonEncode(_postsLikesCache));
    } catch (e) {
      debugPrint('Error saving likes to local storage: $e');
    }
  }

  // Sync pending likes/unlikes with the server
  Future<void> syncWithServer() async {
    if (_isSyncing || (_pendingLikes.isEmpty && _pendingUnlikes.isEmpty)) {
      return;
    }

    _isSyncing = true;

    try {
      // Process each post with pending likes
      for (final postId in Set<String>.from(_pendingLikes.keys)) {
        if (_pendingLikes[postId]?.isNotEmpty ?? false) {
          await _syncPostLikes(postId);
        }
      }

      // Process each post with pending unlikes
      for (final postId in Set<String>.from(_pendingUnlikes.keys)) {
        if (_pendingUnlikes[postId]?.isNotEmpty ?? false) {
          await _syncPostLikes(postId);
        }
      }

      // Save the updated state to local storage
      await _saveToLocalStorage();
    } catch (e) {
      debugPrint('Error syncing likes with server: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // Sync likes for a specific post
  Future<void> _syncPostLikes(String postId) async {
    try {
      // Get the current post from the server
      final post = await _postAPI.getPostById(postId);

      if (post != null) {
        final serverLikes = Set<String>.from(post.likes);

        // Apply pending likes and unlikes
        final pendingLikesForPost = _pendingLikes[postId] ?? {};
        final pendingUnlikesForPost = _pendingUnlikes[postId] ?? {};

        // Update the server with our local changes
        final newLikes = List<String>.from(serverLikes);

        // Add pending likes
        for (final userId in pendingLikesForPost) {
          if (!newLikes.contains(userId)) {
            newLikes.add(userId);
          }
        }

        // Remove pending unlikes
        for (final userId in pendingUnlikesForPost) {
          newLikes.remove(userId);
        }

        // Update post on server
        final updatedPost = post.copyWith(likes: newLikes);
        await _postAPI.likePost(updatedPost);

        // Update local cache with server values
        _postsLikesCache[postId] = newLikes;

        // Clear pending operations for this post
        _pendingLikes.remove(postId);
        _pendingUnlikes.remove(postId);

        // Notify listeners to update UI if needed
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error syncing post $postId: $e');
      // Keep pending operations for retry in the next sync cycle
    }
  }

  // Force an immediate sync with the server
  Future<void> forceSyncWithServer() async {
    await syncWithServer();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
