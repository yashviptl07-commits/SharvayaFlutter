import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

@pragma('vm:entry-point')
void onTodoStart(ServiceInstance service) async {
  // Ensure Dart plugins are initialized
  DartPluginRegistrant.ensureInitialized();

  // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Android notification initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  // Platform-specific initialization settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize notifications
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Handle foreground and background service transitions for Android
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      print("Setting service as foreground...");
      await service.setAsForegroundService();
      print("Service is now running in foreground.");
    });

    service.on('setAsBackground').listen((event) async {
      print("Setting service as background...");
      await service.setAsBackgroundService();
      print("Service is now running in background.");
    });
  }

  // Handle stop service event
  service.on("stop_service").listen((event) async {
    print("Stopping service...");
    await service.stopSelf();
    print("Service stopped.");
  });

  Timer.periodic(const Duration(minutes: 20), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        print("Service is running in foreground.");

        final reminders =
            await BackgroundServiceForTodo().fetchTaskReminderList();

        if (reminders.isNotEmpty) {
          print(
              "Reminders fetched: ${reminders.length}. Sending notifications...");
          print(reminders);
        } else {
          print("No reminders found.");
        }

        for (var reminder in reminders) {
          print("Sending local notification: ${reminder['title']}");
          await BackgroundServiceForTodo().sendNotification(
            flutterLocalNotificationsPlugin,
            reminder['title'],
            reminder['body'],
          );

          print("Sending Firebase notification: ${reminder['title']}");
          await BackgroundServiceForTodo().sendFirebaseNotification(
            reminder['title'],
            reminder['body'],
            reminder['tokens'],
          );
        }
      } else {
        print("Service is not running in foreground.");
      }
    }
  });
}

class BackgroundServiceForTodo {
  final FlutterBackgroundService flutterBackgroundService =
      FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;

  Future<void> initializeServiceTodo() async {
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onTodoStart,
        autoStart: false,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onTodoStart,
      ),
    );

    await flutterBackgroundService.startService();
  }

  void setServiceAsForeground() async {
    print("Start background service.");
    flutterBackgroundService.invoke("setAsForeground");
  }

  void stopService() {
    print("Stopping background service.");
    flutterBackgroundService.invoke("stop_service");
  }

  Future<List<Map<String, dynamic>>> fetchTaskReminderList() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String loginUserId = prefs.getString('LoginUserID') ?? 'admin';
      final String companyId = prefs.getString('CompanyId') ?? '4132';
      final String apiKey =
          prefs.getString('ApiKey') ?? 'http://192.168.1.10:130/';

      final String apiUrl = '$apiKey/Dashboard/TaskReminderList';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"LoginUserID": loginUserId, "CompanyId": companyId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> details = data['Data']['details'];

        print("API response: ${response.body}");
        return details.map((detail) {
          return {
            'title': detail['ModuleName'],
            'body': detail['Description'],
            'tokens': List<String>.from([
              detail['CreatedByToken'] ?? '',
              detail['AssignedByToken'] ?? ''
            ]),
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

  Future<void> sendNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'task_reminder_channel',
      'Task Reminders',
      channelDescription: 'Channel for task reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
      );
      print("Local notification sent: $title");
    } catch (e) {
      print("Error sending local notification: $e");
    }
  }

  Future<void> sendFirebaseNotification(
    String title,
    String body,
    List<String> tokens,
  ) async {
    const String firebaseUrl =
        'https://fcm.googleapis.com/v1/projects/e-office-desk-flutter/messages:send';
    final String serverKey = await getAccessToken();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    final Map<String, dynamic> payload = {
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
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print("Firebase notification sent: $title");
      } else {
        print(
            "Failed to send Firebase notification. Response: ${response.body}");
      }
    } catch (e) {
      print("Error sending Firebase notification: $e");
    }
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "e-office-desk-flutter",
      "private_key_id": "dee49b88aa4fda701ba25636836d5cb4a6bf7fd8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCkch6ADZ5bnHGF\nxerUqS4SSo7O79XBztHqJv89POOS3ZZFJallYVjN/2coiyj7CUGH7btoyTijRoCn\nz+X2sEf0kK9gdbq7mQ0tM6ka0nr7uYZIYpLLDJfLtvzPIaKwGUIvjQ/Jmd8kKuau\no7iziv0TH2nwtuZKslued7nanisd343zNnNS22nXnKS/QR/blSesOp5ohPYegufk\nJlIQByXjF+TnRQNbOD3erERIG6U1BBm6ybZdWZCum5q9+nVr2TxaLphOTeBaVsac\n2s5cvSinw47bfpRZ0aVGAatK0/lRBstmlXD/p7D/Uy+8kHivB2EtBMugPT1WBUoE\n+iXGqjk/AgMBAAECggEAH45GjAwQ90NuBV2VUnmkfZ4RCWS8gBRP877H+9hTUzty\nOpKfjvS/Nchs4zrRAlskWBEmhVUXqT0+MvWSC2SIakXZYYk17AnSnXnsWVlKgEN5\noSpJQO2Js23J1XV+4ov2R2mqPeVpDGevHJQOPWXOanz8t1RhnLPdIOuYnnr7ix+s\nJn/FfuItz8tulpfxhOXX6U4hguJmZRTM8VWNx0OXm01JNdrRc01kE94XRIY2sclU\nEWkq0nmRbR0lY5+PY9heuuxgz7dfUyyhk5nxR/wNGsE9WRIMAIk0UtWDhq8kpHge\nCkgUuGKmlvpwcKAwvrMZa//KXkSUxa+SfQKT7KI4AQKBgQDXhCCol60o7zZUFt3G\nCB5X3H8YlfEmAqN9olruJ/HdSvV3Mj83qn3u3+UYUOFdHNhGOMk/N73i0NifhwX2\nUNEFPGCTRqfbQFZw2j6BkgeRM/70WviUHZLKHsh6RO+bjqtGVELupr0l1/ZEpkMu\n9HylK2WQkQ6RT6nbkzN3mzuIIQKBgQDDVhbZvaFK9t40mzolx0NqiUIkauzdos9q\nIdM5oWDecEytevdQ8JaoNhpS/xiBlJaJWvlgb8c+V0bWuHuZvmAaD+Y1UBzre3fF\nJRAmUe3VhbcVu3zHL2/wFCHv9eDg8VMAIyJTb+QM6XWFPlmi/jWPusHzceQGXEDi\nIy3ofGgVXwKBgQCTgeO4gNgMBG5y75OrTzM1f72d3kLHeVbdTppeFwj8JaoMg1+x\nggffz27GTdVyHaQJrCRSGJzm+XrK9WenR3lI1CJlqx6IemivpTDTDlgPkj8WkI1D\nE1q87ITa6wP0vJmN8W4+WfFsTXxJUGL7aGtHwYQqhp4p5xSjLQU1ABKnAQKBgEoZ\ndU+iNPZ4EbEJFZTRM0zNxs6D1Vj6cw5CyJr7EgEvvpasp/cHXU9wPqovZP96+2Qd\no64mmQGYICJCF3kqE9CvKVgeDOpziuq5dZfjyoIOWHahCeORpjf/myQpNOaABUlv\nCo12S59uTIuALIa9QlpEsWCFWsfi5SYjzD1+PAmnAoGBAL/na3HFfrrp2vvsRo+w\nCe0sH3Kfiugut41wtbl1cog370HCaRVeHucSmMxg97mNPScN7/KFBwpvkQqq0g9G\nJCKwK8EfWlM/dDFfCIJcXgQcj3+1cnvHzyiJ5EdUadDKsCnNk4chk9Xn4NKKB/94\ni2eaHQ6MAdCxLFeSjL+SIjwe\n-----END PRIVATE KEY-----\n",
      "client_email": "e-office-desk-flutter@appspot.gserviceaccount.com",
      "client_id": "100799278322772767315",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/e-office-desk-flutter%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }
}
