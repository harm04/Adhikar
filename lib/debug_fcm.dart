// import 'package:adhikar/features/admin/services/send_notification_service.dart';

// // Debug function to test current FCM token
// Future<void> debugFCMToken() async {
//   // Replace with your current token from the logs
//   String currentToken =
//       "fetLYMrcRWybU0ScDbPx3g:APA91bGM3Toro-tDT_LCq5z2LcTdzTNBM1WB86jiVboRW2PRcs8AG-7CEUyFkTmzupob760EVWhb_V0vLC2_puGFx0-0UFCs01gU2nbdtE6Af6zgfVCJ8BQ";

//   print("🧪 Testing FCM token validity...");
//   bool isValid = await SendNotificationService.testTokenValidity(
//     token: currentToken,
//   );

//   if (isValid) {
//     print("✅ Token is valid! Sending test notification...");
//     try {
//       await SendNotificationService.sendNotificationUsingAPI(
//         token: currentToken,
//         title: "Test Notification",
//         body: "Your FCM token is working correctly!",
//         data: {"screen": "home"},
//       );
//       print("✅ Test notification sent successfully!");
//     } catch (e) {
//       print("❌ Failed to send test notification: $e");
//     }
//   } else {
//     print("❌ Token is invalid. User needs to re-login.");
//   }
// }
