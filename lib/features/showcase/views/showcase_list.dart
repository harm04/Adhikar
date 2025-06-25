import 'package:adhikar/common/widgets/check_internet.dart';
import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/showcase/controller/showcase_controller.dart';
import 'package:adhikar/features/showcase/views/create_showcase.dart';
import 'package:adhikar/features/showcase/widgets/showcase_list_card.dart';
import 'package:adhikar/models/showcase_model.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ShowcaseList extends ConsumerStatefulWidget {
  const ShowcaseList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowcaseState();
}

class _ShowcaseState extends ConsumerState<ShowcaseList> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    final isLoading = ref.watch(showcaseControllerProvider);
    return currentUser == null || isLoading
        ? LoadingPage()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Pallete.primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateShowcase();
                    },
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/svg/pencil.svg',
                height: 30,
                colorFilter: ColorFilter.mode(
                  Pallete.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text('Showcase'),
              leading: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(ImageTheme.defaultAdhikarLogo),
                ),
              ),
              centerTitle: true,
            ),
            body: CheckInternet(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      //image
                      Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage('assets/images/showcase.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      Consumer(
                        builder: (context, ref, _) {
                          final showcaseAsync = ref.watch(getShowcaseProvider);
                          return _KeepAliveWrapper(
                            child: ref
                                .watch(getShowcaseProvider)
                                .when(
                                  data: (showcases) {
                                    return ref
                                        .watch(getLatestShowcaseProvider)
                                        .when(
                                          data: (data) {
                                            if (data.events.contains(
                                              'databases.*.collections.${AppwriteConstants.showcaseCollectionID}.documents.*.create',
                                            )) {
                                              final newShowcase =
                                                  ShowcaseModel.fromMap(
                                                    data.payload,
                                                  );
                                              final alreadyExists = showcases
                                                  .any(
                                                    (s) =>
                                                        s.id == newShowcase.id,
                                                  );
                                              if (!alreadyExists) {
                                                showcases.insert(
                                                  0,
                                                  newShowcase,
                                                );
                                              }
                                            }
                                            //else write code to update the post
                                            return showcaseAsync.when(
                                              data: (showcases) {
                                                if (showcases.isEmpty) {
                                                  return Center(
                                                    child: Text(
                                                      'No showcases yet.',
                                                    ),
                                                  );
                                                }
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //showcase length
                                                    Text(
                                                      '${showcases.length} Entries',
                                                      style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    //showcase list
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          showcases.length,
                                                      itemBuilder: (context, index) {
                                                        final showcase =
                                                            showcases[index];
                                                        return ShowcaseListCard(
                                                          showcase: showcase,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                              loading: () => Loader(),
                                              error: (e, st) => Center(
                                                child: Text(
                                                  'Error loading showcases',
                                                ),
                                              ),
                                            );
                                          },
                                          error: (error, StackTrace) =>
                                              ErrorText(
                                                error: error.toString(),
                                              ),
                                          loading: () {
                                            return showcaseAsync.when(
                                              data: (showcases) {
                                                if (showcases.isEmpty) {
                                                  return Center(
                                                    child: Text(
                                                      'No showcases yet.',
                                                    ),
                                                  );
                                                }
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //showcase length
                                                    Text(
                                                      '${showcases.length} Entries',
                                                      style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    //showcase list
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          showcases.length,
                                                      itemBuilder: (context, index) {
                                                        final showcase =
                                                            showcases[index];
                                                        return ShowcaseListCard(
                                                          showcase: showcase,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                              loading: () => Loader(),
                                              error: (e, st) => Center(
                                                child: Text(
                                                  'Error loading showcases',
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                  },
                                  error: (err, st) {
                                    return ErrorText(error: err.toString());
                                  },
                                  loading: () => Loader(),
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
