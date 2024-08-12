// import 'dart:io';
// import 'dart:math';

// import 'package:app_settings/app_settings.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
//       FlutterLocalNotificationsPlugin();

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User Permission Granted');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       AppSettings.openAppSettings();
//     }
//   }

//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     print(token);
//     return token!;
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (Platform.isAndroid) {
//         initLocalNotification(context, message);
//         showNotification(message);
//       }
//     });
//   }

//   void initLocalNotification(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//     await _flutterLocalNotificationPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (payload) {});
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//         DateTime.now().toIso8601String(), 'Tracker Edge',
//         importance: Importance.max);
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'Loads are transferred to History section',
//             importance: Importance.high,
//             ticker: 'Ticker');
//     DarwinNotificationDetails darwinNotificationDetails =
//         const DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationPlugin.show(
//           0,
//           message.notification!.title.toString(),
//           message.notification!.body.toString(),
//           notificationDetails);
//     });
//   }

//   Future<void> showLocalNotification(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(DateTime.now().toString(), 'Trucker Edge',
//             channelDescription: 'Your Expanse will be transfer soon',
//             importance: Importance.high,
//             priority: Priority.high,
//             ticker: 'ticker');
//     DarwinNotificationDetails darwinNotificationDetails =
//         const DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//     await _flutterLocalNotificationPlugin.show(
//         0, title, body, notificationDetails);
//   }
// }
