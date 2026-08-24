import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soleoserp/main.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

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

  // Timer to trigger the location fetch and send data every 10 seconds
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final permission = await Geolocator.checkPermission();
        final isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();

        if (!isLocationServiceEnabled ||
            permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await BackgroundService().sendLocationLogData();
        } else if (permission == LocationPermission.always) {
          final Position position = await Geolocator.getCurrentPosition();
          service.invoke('on_location_changed', position.toJson());

          await BackgroundService().sendLocationData(
            position.latitude.toString(),
            position.longitude.toString(),
          );
        }
      }
    }
  });
}

class BackgroundService {
  final FlutterBackgroundService flutterBackgroundService =
      FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;

  Future<void> initializeService() async {
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );

    await flutterBackgroundService.startService();
  }

  void setServiceAsForeground() async {
    flutterBackgroundService.invoke("setAsForeground");
  }

  void stopService() {
    flutterBackgroundService.invoke("stop_service");
  }

  Future<void> sendLocationData(String latitude, String longitude) async {
    final deviceName = await getDeviceName();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String formattedDate = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString().padLeft(2, '0') +
        "-" +
        DateTime.now().day.toString().padLeft(2, '0') +
        " " +
        DateTime.now().hour.toString().padLeft(2, '0') +
        ":" +
        DateTime.now().minute.toString().padLeft(2, '0') +
        ":" +
        DateTime.now().second.toString().padLeft(2, '0');

    print('Sending location data at: ${DateTime.now()}');

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = json.encode([
      {
        "Latitude": latitude,
        "Longitude": longitude,
        "LogDateTime": formattedDate,
        "DeviceName": deviceName,
        "EmployeeID": preferences.getString('EmployeeId'),
        "LoginUserID": preferences.getString('LoginUserID'),
        "CompanyId": preferences.getString('CompanyId'),
      }
    ]);

    try {
      final response = await http
          .post(
            Uri.parse(
                '${preferences.getString('ApiKey')}/EmployeeTracking/Add'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        print('Location data sent successfully');
      } else {
        print('Failed to send location data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending location data: $e');
    }
  }

  Future<void> sendLocationLogData() async {
    final deviceName = await getDeviceName();
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String formattedDate = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString().padLeft(2, '0') +
        "-" +
        DateTime.now().day.toString().padLeft(2, '0') +
        " " +
        DateTime.now().hour.toString().padLeft(2, '0') +
        ":" +
        DateTime.now().minute.toString().padLeft(2, '0') +
        ":" +
        DateTime.now().second.toString().padLeft(2, '0');

    print('Sending location data at: ${DateTime.now()}');

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = json.encode([
      {
        "LogDateTime": formattedDate,
        "LocationOff": formattedDate,
        "InternetOff": formattedDate,
        "Message": "Location Is Disable",
        "DeviceName": deviceName,
        "EmployeeID": preferences.getString('EmployeeId'),
        "LoginUserID": preferences.getString('LoginUserID'),
        "CompanyId": preferences.getString('CompanyId'),
      }
    ]);

    try {
      final response = await http
          .post(
            Uri.parse(
                '${preferences.getString('ApiKey')}/EmployeeTrackingLog/Add'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        print('Log data sent successfully');
      } else {
        print('Failed to send location data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending location data: $e');
    }
  }
}
