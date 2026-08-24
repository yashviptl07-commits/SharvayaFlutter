import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      await service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) async {
      await service.setAsBackgroundService();
    });
  }

  service.on("stop_service").listen((event) async {
    await service.stopSelf();
  });

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance && await service.isForegroundService()) {
      final reminders = await BackgroundService().fetchTaskReminderList();

      if (reminders.isNotEmpty) {
        for (var reminder in reminders) {
          final startDate = DateTime.tryParse(reminder['StartDate']);
          if (startDate != null) {
            final now = DateTime.now();
            final timeDifference = startDate.difference(now).inMinutes;

            if (timeDifference > 0 && timeDifference <= 10) {
              // Send notifications for task types
              await BackgroundService().scheduleNotification(
                flutterLocalNotificationsPlugin,
                reminder,
                timeDifference,
              );
            }
          }
        }
      }
    }
  });
}

class BackgroundService {
  final FlutterBackgroundService flutterBackgroundService = FlutterBackgroundService();

  Future<void> initializeService() async {
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
    await flutterBackgroundService.startService();
  }

  Future<List<Map<String, dynamic>>> fetchTaskReminderList() async {
    const apiUrl = 'http://192.168.1.10:130/Dashboard/TaskReminderList';

    try {
      final prefs = await SharedPreferences.getInstance();
      final loginUserId = prefs.getString('LoginUserID') ?? 'admin';
      final companyId = prefs.getString('CompanyId') ?? '4132';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"LoginUserID": loginUserId, "CompanyId": companyId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['Data']['details'] as List).map((detail) {
          return {
            'pkId': detail['pkId'],
            'title': detail['ModuleName'],
            'body': detail['Description'],
            'StartDate': detail['CreatedDate'],
            'tokens': [
              detail['CreatedByToken'] ?? '',
              detail['AssignedByToken'] ?? '',
            ],
            'ReminderType': detail['ReminderType'],
          };
        }).toList();
      } else {
        print("Failed to fetch reminders. Status Code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in fetchTaskReminderList: $e");
      return [];
    }
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Map<String, dynamic> reminder,
      int timeDifference,
      ) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'task_reminder_channel',
      'Task Reminders',
      channelDescription: 'Task Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    try {
      // Send local notification
      await flutterLocalNotificationsPlugin.show(
        reminder['pkId'],
        reminder['title'],
        reminder['body'],
        notificationDetails,
      );

      // Send Firebase notification
      await sendFirebaseNotification(
        reminder['title'],
        reminder['body'],
        reminder['tokens'],
      );

      print("Scheduled notification for: ${reminder['title']}");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  Future<void> sendFirebaseNotification(
      String title,
      String body,
      List<String> tokens,
      ) async {
    const firebaseUrl = 'https://fcm.googleapis.com/fcm/send';
    const serverKey = 'YOUR_FIREBASE_SERVER_KEY'; // Replace with actual key

    final payload = {
      "registration_ids": tokens,
      "notification": {
        "title": title,
        "body": body,
      },
      "priority": "high",
    };

    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print("Firebase notification sent: $title");
      } else {
        print("Failed to send Firebase notification. Response: ${response.body}");
      }
    } catch (e) {
      print("Error sending Firebase notification: $e");
    }
  }
}
