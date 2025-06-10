import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/meetings_controller.dart';
import 'package:adhikar/features/expert/widgets/meetings_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetingsList extends ConsumerStatefulWidget {
  const MeetingsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetingsListState();
}

class _MeetingsListState extends ConsumerState<MeetingsList> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    final meetingsAsync = currentUser.userType == 'User'
        ? ref.watch(userMeetingsStreamProvider(currentUser.uid))
        : ref.watch(expertMeetingsStreamProvider(currentUser.uid));

    return Scaffold(
      appBar: AppBar(title: const Text('My Meetings'), centerTitle: true),
      body: meetingsAsync.when(
        data: (meetings) {
          if (meetings.isEmpty) {
            return Center(
              child: Text(
                currentUser.userType == 'User'
                    ? 'No meeting with an expert found.'
                    : 'No appointments with users found.',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
           
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              final meeting = meetings[index];
              return MeetingsListCard(meetingsModel: meeting);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
