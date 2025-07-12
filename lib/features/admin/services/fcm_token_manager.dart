import 'package:adhikar/apis/user_api.dart';
import 'package:adhikar/features/admin/services/notification_service.dart';
import 'package:adhikar/features/admin/services/send_notification_service.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCMTokenManager {
  static Future<void> validateAndRefreshUserToken({
    required String userId,
    required String currentToken,
    required WidgetRef ref,
  }) async {
    try {
      print("🔍 Validating FCM token for user: $userId");

      // Test if current token is valid
      final isValid = await SendNotificationService.testTokenValidity(
        token: currentToken,
      );

      if (!isValid) {
        print("❌ Token invalid, generating new token for user: $userId");

        // Generate new token
        final notificationService = NotificationService();
        final newToken = await notificationService.getToken();

        if (newToken != null &&
            newToken.isNotEmpty &&
            newToken != currentToken) {
          print("🔄 Updating user with new FCM token");

          // Update token in database
          final userAPI = ref.read(userAPIProvider);
          await userAPI.updateFCMToken(userId, newToken);

          print("✅ Successfully refreshed FCM token for user: $userId");

          // Invalidate user providers to refresh data
          ref.invalidate(currentUserDataProvider);
          ref.invalidate(allUsersProvider);

          return;
        }
      } else {
        print("✅ FCM token is valid for user: $userId");
      }
    } catch (e) {
      print("❌ Error during token validation/refresh: $e");
    }
  }

  // Bulk validation and cleanup for admin
  static Future<Map<String, bool>> validateAllTokens({
    required List<UserModel> users,
  }) async {
    final results = <String, bool>{};

    print("🔍 Starting bulk FCM token validation for ${users.length} users");

    for (final user in users) {
      if (user.fcmToken.isEmpty) continue;

      try {
        final isValid = await SendNotificationService.testTokenValidity(
          token: user.fcmToken,
        );
        results[user.uid] = isValid;

        if (isValid) {
          print("✅ Valid: ${user.firstName} ${user.lastName}");
        } else {
          print("❌ Invalid: ${user.firstName} ${user.lastName} (${user.uid})");
        }
      } catch (e) {
        results[user.uid] = false;
        print("❌ Error: ${user.firstName} ${user.lastName} - $e");
      }
    }

    final validCount = results.values.where((v) => v).length;
    final invalidCount = results.values.where((v) => !v).length;

    print("📊 Validation complete: $validCount valid, $invalidCount invalid");

    return results;
  }

  // Auto-cleanup invalid tokens
  static Future<int> cleanupInvalidTokens({
    required Map<String, bool> validationResults,
    required WidgetRef ref,
  }) async {
    final invalidUserIds = validationResults.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    if (invalidUserIds.isEmpty) {
      print("✅ No invalid tokens to clean up");
      return 0;
    }

    print("🧹 Cleaning up ${invalidUserIds.length} invalid FCM tokens");

    final userAPI = ref.read(userAPIProvider);
    int cleanedCount = 0;

    for (String userId in invalidUserIds) {
      try {
        await userAPI.clearFCMToken(userId);
        cleanedCount++;
        print("🧹 Cleared token for user: $userId");
      } catch (e) {
        print("❌ Failed to clear token for user $userId: $e");
      }
    }

    // Refresh providers
    ref.invalidate(allUsersProvider);

    print("✅ Cleaned up $cleanedCount invalid tokens");
    return cleanedCount;
  }

  // Generate and set new token for user
  static Future<String?> generateNewTokenForUser({
    required String userId,
    required WidgetRef ref,
  }) async {
    try {
      print("🔄 Generating new FCM token for user: $userId");

      final notificationService = NotificationService();
      final newToken = await notificationService.getToken();

      if (newToken != null && newToken.isNotEmpty) {
        final userAPI = ref.read(userAPIProvider);
        await userAPI.updateFCMToken(userId, newToken);

        print("✅ Generated and saved new token for user: $userId");
        return newToken;
      }

      print("❌ Failed to generate new token");
      return null;
    } catch (e) {
      print("❌ Error generating new token: $e");
      return null;
    }
  }
}
