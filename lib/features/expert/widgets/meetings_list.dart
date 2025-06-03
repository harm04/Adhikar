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
    return ref
        .watch(getUserMeetingsProvider(currentUser))
        .when(
          data: (meetings) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Meetings'),
                centerTitle: true,
              ),
              body: meetings.isEmpty
                  ? Center(
                      child: Text(
                        'No meeting with an expert found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(18),
                      itemCount: meetings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final meeting = meetings[index];
                        return MeetingsListCard(meetings: meeting);
                      },
                    ),
            );
          },
          error: (err, st) => ErrorPage(error: err.toString()),
          loading: () => LoadingPage(),
        );
  }
}
