/*
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';

class CallLogScreen extends StatefulWidget {
  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  Map<String, List<CallLogEntry>> groupedCallLogs = {};
  List<CallLogEntry> allCallLogs = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    try {
      Iterable<CallLogEntry> entries = await CallLog.get();
      List<CallLogEntry> callLogs = entries.toList();

      Map<String, List<CallLogEntry>> groupedLogs = {};
      for (var log in callLogs) {
        String date = DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0));

        if (!groupedLogs.containsKey(date)) {
          groupedLogs[date] = [];
        }
        groupedLogs[date]?.add(log);
      }

      setState(() {
        allCallLogs = callLogs;
        groupedCallLogs = groupedLogs;
      });
    } catch (e) {
      print('Failed to get call logs: $e');
    }
  }

  Future<void> _uploadCallLogs() async {
    String apiUrl =
        "https://yourserver.com/api/uploadCallLogs"; // Replace with your API endpoint

    List<Map<String, dynamic>> callLogsData = allCallLogs.map((log) {
      return {
        "name": log.name ?? "Unknown",
        "number": log.number ?? "Unknown",
        "formattedNumber": log.formattedNumber ?? "Unknown",
        "callType": log.callType.toString(),
        "duration": log.duration ?? 0,
        "timestamp": log.timestamp ?? 0,
        "simDisplayName": log.simDisplayName ?? "Unknown",
      };
    }).toList();

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"callLogs": callLogsData}),
      );

      if (response.statusCode == 200) {
        print("Call logs uploaded successfully");
      } else {
        print("Failed to upload call logs");
      }
    } catch (e) {
      print("Error uploading call logs: $e");
    }
  }

  List<CallLogEntry> _searchLogs(String query) {
    if (query.isEmpty) {
      return allCallLogs;
    }
    return allCallLogs.where((log) {
      return (log.name?.toLowerCase() ?? "").contains(query.toLowerCase()) ||
          (log.number ?? "").contains(query);
    }).toList();
  }

  Icon _getCallTypeIcon(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return Icon(Icons.call_received, color: Colors.green);
      case CallType.outgoing:
        return Icon(Icons.call_made, color: Colors.blue);
      case CallType.missed:
        return Icon(Icons.call_missed, color: Colors.red);
      case CallType.rejected:
        return Icon(Icons.call_end, color: Colors.orange);
      case CallType.blocked:
        return Icon(Icons.block, color: Colors.black);
      default:
        return Icon(Icons.call, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CallLogEntry> filteredLogs = _searchLogs(searchQuery);
    Map<String, List<CallLogEntry>> groupedLogs = {};

    for (var log in filteredLogs) {
      DateTime logDateTime =
          DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0);
      String dateLabel = DateFormat('dd/MM/yyyy').format(logDateTime);

      if (!groupedLogs.containsKey(dateLabel)) {
        groupedLogs[dateLabel] = [];
      }
      groupedLogs[dateLabel]?.add(log);
    }

    List<String> sortedKeys = groupedLogs.keys.toList()
      ..sort((a, b) => DateFormat('dd/MM/yyyy')
          .parse(b)
          .compareTo(DateFormat('dd/MM/yyyy').parse(a)));

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Call Log',
              style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorWhite,
              ),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              }),
          actions: [
            IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: _uploadCallLogs,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by Name or Number",
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedKeys.length,
                itemBuilder: (context, index) {
                  String date = sortedKeys[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          date,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      ...groupedLogs[date].map((callLog) {
                        DateTime callDateTime =
                            DateTime.fromMillisecondsSinceEpoch(
                                callLog.timestamp ?? 0);
                        return Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: _getCallTypeIcon(
                                callLog.callType ?? CallType.unknown),
                            title: Text(
                                callLog.name != null
                                    ? "${callLog.name} (${callLog.number})"
                                    : callLog.number ?? "Unknown",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "Duration: ${callLog.duration} sec | Time: ${DateFormat('HH:mm').format(callDateTime)}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

}
*/
