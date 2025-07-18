import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/notification/widgets/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Notifications extends ConsumerStatefulWidget {
  Notifications({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<Notifications> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) return Loader();
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), centerTitle: true),
      body: NotificationsList(userId: currentUser.uid),
    );
  }
}
