import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endpoint)
      .setProject(AppwriteConstants.projectID)
      .setSelfSigned(status: true);
});

final appwriteMessagingProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Messaging(client);
});

final appwriteFunctionsProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Functions(client);
});

final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final appwriteRealTimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
