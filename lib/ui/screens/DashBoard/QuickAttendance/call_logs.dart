/*
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';

class CallLogScreen extends StatefulWidget {
  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  List<CallLogEntry> callLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    try {
      Iterable<CallLogEntry> entries = await CallLog.get();
      setState(() {
        callLogs = entries.toList();
      });
    } catch (e) {
      print('Failed to get call logs: $e');
      // Handle error
    }
  }

  Icon _getCallTypeIcon(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return Icon(Icons.call_received, color: Colors.green);
      case CallType.outgoing:
        return Icon(Icons.call_made, color: Colors.blue);
      case CallType.missed:
        return Icon(Icons.call_missed, color: Colors.red);
      case CallType.voiceMail:
        return Icon(Icons.voicemail, color: Colors.grey);
      case CallType.rejected:
        return Icon(Icons.call_end, color: Colors.orange);
      case CallType.blocked:
        return Icon(Icons.block, color: Colors.black);
      case CallType.answeredExternally:
        return Icon(Icons.call_end, color: Colors.purple);
      case CallType.unknown:
      default:
        return Icon(Icons.call, color: Colors.grey);
    }
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        navigateTo(context, HomeScreen.routeName,
            clearAllStack: true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Call Log'),
          leading: InkWell(
              onTap: () {
                navigateTo(context, HomeScreen.routeName,
                    clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
        ),
        body: ListView.builder(
          itemCount: callLogs.length,
          itemBuilder: (context, index) {
            final callLog = callLogs[index];
            final callDateTime = DateTime.fromMillisecondsSinceEpoch(callLog.timestamp);
            return InkWell(
              onTap: (){
                return showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Name : ${callLog.name}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Number : ${callLog.number}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Formatted Number : ${callLog.formattedNumber}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('CallType : ${callLog.callType}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Duration : ${callLog.duration}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('TimeStamp : ${callLog.timestamp}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Cached Number Type : ${callLog.cachedNumberType}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Cached Number Label : ${callLog.cachedNumberLabel}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Cached Matched Number : ${callLog.cachedMatchedNumber}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Sim Display Name : ${callLog.simDisplayName}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Text('Phone Account Id : ${callLog.phoneAccountId}', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          ElevatedButton(onPressed: (){
                            Navigator.of(context).pop();},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Close"),
                              )),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _getCallTypeIcon(callLog.callType),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(callLog.name ?? callLog.number ?? 'Unknown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(callLog.number ?? 'Unknown', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                          Spacer(),
                          Text(_formatDate(callDateTime), style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Duration: ${callLog.duration} seconds', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}*/
