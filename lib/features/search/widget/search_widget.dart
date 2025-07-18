import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/search/controller/search_controller.dart';
import 'package:adhikar/features/search/widget/search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  SearchWidget({super.key, required this.searchController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchWidget> {
  bool isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    widget.searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref
          .watch(searchUserProvider(widget.searchController.text))
          .when(
            data: (searchUser) {
              return ListView.builder(
                itemCount: searchUser.length,
                itemBuilder: (context, index) {
                  return SearchCard(user: searchUser[index]);
                },
              );
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => LoadingPage(),
          ),
    );
  }
}
