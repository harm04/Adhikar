import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/admin/widgets/expert_verification.dart';
import 'package:adhikar/features/expert/controller/expert_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminExpertList extends ConsumerStatefulWidget {
  AdminExpertList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminExpertListState();
}

class _AdminExpertListState extends ConsumerState<AdminExpertList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref
          .watch(getExpertsProvider)
          .when(
            data: (experts) {
              final approvedCount = experts
                  .where((e) => e.userType == 'Expert')
                  .length;
              final pendingCount = experts
                  .where((e) => e.userType == 'pending')
                  .length;

              final applications = experts;

              final Map<String, double> dataMap = {
                "Approved": approvedCount.toDouble(),
                "Pending": pendingCount.toDouble(),
                "Total Applications": applications.length.toDouble(),
              };

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expert List
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 20),
                      itemCount: experts.length,
                      itemBuilder: (context, index) {
                        final expert = experts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ExpertVerification(
                                      expertUser: expert,
                                    );
                                  },
                                ),
                              );
                            },
                            contentPadding: EdgeInsets.all(20),
                            tileColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              '${expert.firstName} ${expert.lastName}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: expert.userType == 'Expert'
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Approved',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Verify Profile',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Pie Chart
                  Expanded(
                    flex: 2,
                    child: Card(
                      margin: EdgeInsets.all(24),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          right: 16,
                          bottom: 16,
                          left: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //expert Statistics
                            Text(
                              'Expert Statistics',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Numbers Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatNumber(
                                  label: "Total",
                                  value: applications.length,
                                  color: Colors.blue,
                                ),
                                _StatNumber(
                                  label: "Approved",
                                  value: approvedCount,
                                  color: Colors.green,
                                ),
                                _StatNumber(
                                  label: "Pending",
                                  value: pendingCount,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            PieChart(
                              dataMap: dataMap,
                              chartType: ChartType.disc,
                              colorList: [
                                Colors.green,
                                Colors.orange,
                                Colors.blue,
                              ],
                              chartRadius: 220,
                              legendOptions: LegendOptions(
                                showLegends: true,
                                legendPosition: LegendPosition.bottom,
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValuesInPercentage: false,
                                showChartValues: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => Loader(),
          ),
    );
  }
}

class _StatNumber extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatNumber({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}