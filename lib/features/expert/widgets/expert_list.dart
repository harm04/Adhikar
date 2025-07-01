import 'package:adhikar/common/widgets/check_internet.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/expert_controller.dart';
import 'package:adhikar/features/expert/widgets/expert_list_card.dart';
import 'package:adhikar/features/expert/widgets/meetings_list.dart';
import 'package:adhikar/features/expert/widgets/transaction_list.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExpertList extends ConsumerStatefulWidget {
  const ExpertList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpertListState();
}

class _ExpertListState extends ConsumerState<ExpertList> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(ImageTheme.defaultAdhikarLogo),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MeetingsList();
                        },
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/meetings.svg',
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 18),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TransactionList();
                        },
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/transaction.svg',
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      Pallete.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        title: const Text('Book an Expert'),
        centerTitle: true,
      ),
      body: CheckInternet(
        child: ref
            .watch(getExpertsProvider)
            .when(
              data: (experts) {
                if (experts.isEmpty) {
                  return const Center(child: Text('No experts available'));
                }

                return GridView.builder(
                 
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.49,
                  ),
                  itemCount: experts.length,
                  itemBuilder: (context, index) {
                    final expert = experts[index];
                    return ExpertListCard(expertUserModel: expert);
                  },
                );
              },
              loading: () => Loader(),
              error: (err, st) => Center(child: Text('Error: $err')),
            ),
      ),
    );
  }
}
