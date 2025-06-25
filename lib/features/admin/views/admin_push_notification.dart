import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/features/admin/services/send_notification_service.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPushNotification extends ConsumerStatefulWidget {
  const AdminPushNotification({super.key});

  @override
  ConsumerState<AdminPushNotification> createState() =>
      _AdminPushNotificationState();
}

class _AdminPushNotificationState extends ConsumerState<AdminPushNotification> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  UserModel? selectedUser;
  UserModel? selectedExpert;
  bool sendToAllUsers = false;
  bool sendToAllExperts = false;

  bool isLoading = false; // Loading state

  void sendNotification(BuildContext context) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    try {
      if (sendToAllUsers) {
        await SendNotificationService.sendNotificationToTopic(
          topic: 'all_users',
          title: titleController.text,
          body: bodyController.text,
          data: {"screen": "home"},
        );
      } else if (sendToAllExperts) {
        await SendNotificationService.sendNotificationToTopic(
          topic: 'all_experts',
          title: titleController.text,
          body: bodyController.text,
          data: {"screen": "home"},
        );
      } else if (selectedUser != null) {
        await SendNotificationService.sendNotificationUsingAPI(
          token: selectedUser!.fcmToken,
          title: titleController.text,
          body: bodyController.text,
          data: {"screen": "home"},
        );
      } else if (selectedExpert != null) {
        await SendNotificationService.sendNotificationUsingAPI(
          token: selectedExpert!.fcmToken,
          title: titleController.text,
          body: bodyController.text,
          data: {"screen": "home"},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a target audience')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return isLoading
        ? LoadingPage()
        : Scaffold(
            body: usersAsync.when(
              data: (users) {
                final experts = users
                    .where((u) => u.userType == 'Expert')
                    .toList();
                final normalUsers = users
                    .where((u) => u.userType == 'User')
                    .toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Send Notification',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 25),
                        Text('Target Audience', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: sendToAllUsers,
                                  onChanged: (val) {
                                    setState(() {
                                      sendToAllUsers = val ?? false;
                                      if (sendToAllUsers) {
                                        sendToAllExperts = false;
                                        selectedUser = null;
                                        selectedExpert = null;
                                      }
                                    });
                                  },
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(
                                  'All Users',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(width: 70),
                            Row(
                              children: [
                                Checkbox(
                                  value: sendToAllExperts,
                                  onChanged: (val) {
                                    setState(() {
                                      sendToAllExperts = val ?? false;
                                      if (sendToAllExperts) {
                                        sendToAllUsers = false;
                                        selectedUser = null;
                                        selectedExpert = null;
                                      }
                                    });
                                  },
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(
                                  'All Experts',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Text('Specific User', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 20),
                        // Select user
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButtonFormField<UserModel>(
                            value: selectedUser,
                            hint: Text('Select User'),
                            items: normalUsers.map<DropdownMenuItem<UserModel>>(
                              (user) {
                                return DropdownMenuItem<UserModel>(
                                  value: user,
                                  child: Text(
                                    '${user.firstName} ${user.lastName}',
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: sendToAllUsers || sendToAllExperts
                                ? null
                                : (user) {
                                    setState(() {
                                      selectedUser = user;
                                      selectedExpert = null;
                                    });
                                  },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'User',
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text('Specific Expert', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 20),
                        // Select expert
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButtonFormField<UserModel>(
                            value: selectedExpert,
                            hint: Text('Select Expert'),
                            items: experts.map<DropdownMenuItem<UserModel>>((
                              expert,
                            ) {
                              return DropdownMenuItem<UserModel>(
                                value: expert,
                                child: Text(
                                  '${expert.firstName} ${expert.lastName}',
                                ),
                              );
                            }).toList(),
                            onChanged: sendToAllUsers || sendToAllExperts
                                ? null
                                : (expert) {
                                    setState(() {
                                      selectedExpert = expert;
                                      selectedUser = null;
                                    });
                                  },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expert',
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text('Title', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text('Body', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            controller: bodyController,
                            decoration: InputDecoration(
                              labelText: 'Body',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () => sendNotification(context),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  'Send Notification',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading users')),
            ),
          );
  }
}
