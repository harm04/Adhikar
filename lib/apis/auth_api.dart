import 'package:adhikar/common/failure.dart';
import 'package:adhikar/common/type_def.dart';
import 'package:adhikar/providers/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authAPIProvider = Provider((ref) {
  return AuthAPI(
    account: ref.watch(appwriteAccountProvider),
    messaging: ref.watch(appwriteMessagingProvider),
  );
});

abstract class IAuthApi {
  Future<User?> currentUserAccount();
  FutureEither<User> signUp({required String email, required String password});
  FutureEither<Session> signIn({
    required String email,
    required String password,
  });
  FutureEitherVoid signout();
}

class AuthAPI implements IAuthApi {
  final Account _account;
  // ignore: unused_field
  final Messaging _messaging;

  AuthAPI({required Account account, required Messaging messaging})
    : _account = account,
      _messaging = messaging;

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    //   final targetId = ID.unique();
    //   final fcmToken = await FirebaseMessaging.instance.getToken();
      
    //  await _account.createPushTarget(
    //     identifier: fcmToken!,
    //     targetId: targetId,
    //     providerId: AppwriteConstants.providerId,
    //   );

    //   final mess =await  _messaging.createSubscriber(
    //     topicId: '6853cb17001ea135b5e6',
    //     targetId: targetId,
    //     subscriberId: ID.unique(),
    //   );
    //   print(mess);

      return right(session);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } catch (err) {
      return null;
    }
  }

  @override
  FutureEitherVoid signout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } catch (err, stackTrace) {
      return left(Failure(err.toString(), stackTrace));
    }
  }
}
