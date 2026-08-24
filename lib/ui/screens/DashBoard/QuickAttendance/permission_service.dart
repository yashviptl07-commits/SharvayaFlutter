import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PermissionService {
  static const _channel = MethodChannel('com.sharvayainfotech.eofficedesk/permissions');

  Future<void> requestPermissions() async {
    try {
      await _channel.invokeMethod('requestPermissions');
    } on PlatformException catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> startRecording() async {
    try {
      await _channel.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      await _channel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<List<FileSystemEntity>> getRecordedFiles() async {
    //Directory directory = await getExternalStorageDirectory();
    String recordingsPath = '/sdcard/Recordings/Call/Call recording Konik Sharvaya_240801_180955.m4a';
    Directory recordingsDir = Directory(recordingsPath);

    if (await recordingsDir.exists()) {
      return recordingsDir.listSync();
    } else {
      return [];
    }
  }
}