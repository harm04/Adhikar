import 'package:adhikar/apis/user_api.dart' as user_api;
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/admin/services/fcm_token_manager.dart';
import 'package:adhikar/features/admin/services/send_notification_service.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for token validation results
final tokenValidationProvider = StateProvider<Map<String, bool>>((ref) => {});

class TokenManagement extends ConsumerStatefulWidget {
  TokenManagement({super.key});

  @override
  ConsumerState<TokenManagement> createState() => _TokenManagementState();
}

class _TokenManagementState extends ConsumerState<TokenManagement> {
  bool isValidating = false;
  bool isCleaningUp = false;
  int validTokens = 0;
  int invalidTokens = 0;
  int totalTokens = 0;

  Future<void> validateAllTokens() async {
    setState(() {
      isValidating = true;
      validTokens = 0;
      invalidTokens = 0;
      totalTokens = 0;
    });

    try {
      // Wait for users data to be available
      final usersAsync = ref.read(allUsersProvider);
      if (!usersAsync.hasValue) {
        throw Exception('Users data not available yet');
      }

      final users = usersAsync.value!;
      final usersWithTokens = users.where((userModel) {
        return userModel.fcmToken.isNotEmpty;
      }).toList();

      totalTokens = usersWithTokens.length;

      print("🔍 Starting validation of $totalTokens FCM tokens...");

      // Use the new FCM Token Manager for bulk validation
      final validationResults = await FCMTokenManager.validateAllTokens(
        users: usersWithTokens,
      );

      // Count valid/invalid tokens
      validTokens = validationResults.values.where((v) => v).length;
      invalidTokens = validationResults.values.where((v) => !v).length;

      ref.read(tokenValidationProvider.notifier).state = validationResults;

      print("📊 Token validation complete:");
      print("   Total tokens: $totalTokens");
      print("   Valid tokens: $validTokens");
      print("   Invalid tokens: $invalidTokens");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error validating tokens: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isValidating = false;
        });
      }
    }
  }

  Future<void> cleanupInvalidTokens() async {
    if (mounted) {
      setState(() {
        isCleaningUp = true;
      });
    }

    try {
      final validationResults = ref.read(tokenValidationProvider);

      if (validationResults.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Run validation first')));
        return;
      }

      // Use the new FCM Token Manager for cleanup
      final cleanedCount = await FCMTokenManager.cleanupInvalidTokens(
        validationResults: validationResults,
        ref: ref,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cleaned up $cleanedCount invalid tokens')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error cleaning up tokens: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isCleaningUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Token Management'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: usersAsync.when(
        data: (users) {
          final usersWithTokens = users.where((userModel) {
            return userModel.fcmToken.isNotEmpty;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Token Statistics',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 10),
                        Text('Total users: ${users.length}'),
                        Text(
                          'Users with FCM tokens: ${usersWithTokens.length}',
                        ),
                        if (totalTokens > 0) ...[
                          Text('Valid tokens: $validTokens'),
                          Text('Invalid tokens: $invalidTokens'),
                          LinearProgressIndicator(
                            value: totalTokens > 0
                                ? validTokens / totalTokens
                                : 0,
                            backgroundColor: Colors.red[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: isValidating ? null : validateAllTokens,
                      icon: isValidating
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.security),
                      label: Text(
                        isValidating ? 'Validating...' : 'Validate All Tokens',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),

                    if (invalidTokens > 0)
                      ElevatedButton.icon(
                        onPressed: isCleaningUp ? null : cleanupInvalidTokens,
                        icon: isCleaningUp
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.cleaning_services),
                        label: Text(
                          isCleaningUp ? 'Cleaning...' : 'Clean Invalid Tokens',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 20),

                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Users with FCM Tokens',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: usersWithTokens.length,
                            itemBuilder: (context, index) {
                              final userModel = usersWithTokens[index];
                              final validationResults = ref.watch(
                                tokenValidationProvider,
                              );
                              final isValid = validationResults[userModel.uid];

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isValid == null
                                      ? Colors.grey
                                      : isValid
                                      ? Colors.green
                                      : Colors.red,
                                  child: Icon(
                                    isValid == null
                                        ? Icons.help
                                        : isValid
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  '${userModel.firstName} ${userModel.lastName}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Type: ${userModel.userType}'),
                                    Text(
                                      'Token: ${userModel.fcmToken.substring(0, 20)}...',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: isValid == false
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.refresh,
                                              color: Colors.blue,
                                            ),
                                            tooltip: 'Generate New Token',
                                            onPressed: () async {
                                              try {
                                                final newToken =
                                                    await FCMTokenManager.generateNewTokenForUser(
                                                      userId: userModel.uid,
                                                      ref: ref,
                                                    );

                                                if (newToken != null) {
                                                  ref.invalidate(
                                                    allUsersProvider,
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Generated new token for ${userModel.firstName}',
                                                      ),
                                                    ),
                                                  );

                                                  // Clear validation results to force re-validation
                                                  ref
                                                          .read(
                                                            tokenValidationProvider
                                                                .notifier,
                                                          )
                                                          .state =
                                                      {};
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to generate new token',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            tooltip: 'Clear Token',
                                            onPressed: () async {
                                              try {
                                                final userAPI = ref.read(
                                                  user_api.userAPIProvider,
                                                );
                                                await userAPI.clearFCMToken(
                                                  userModel.uid,
                                                );
                                                ref.invalidate(
                                                  allUsersProvider,
                                                );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Cleared token for ${userModel.firstName}',
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    : isValid == true
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Loader(),
        error: (error, stack) =>
            Center(child: Text('Error loading users: $error')),
      ),
    );
  }
}
