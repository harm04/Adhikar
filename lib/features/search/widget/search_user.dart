import 'package:adhikar/features/search/controller/search_controller.dart';
import 'package:adhikar/features/search/widget/search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUser extends ConsumerWidget {
  final String query;
  SearchUser({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(searchUserProvider(query))
        .when(
          data: (users) => users.isEmpty
              ? Center(child: Text('No users found'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return SearchCard(user: user);
                  },
                ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        );
  }
}
