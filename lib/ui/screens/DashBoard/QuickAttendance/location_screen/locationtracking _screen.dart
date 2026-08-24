import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/locationList_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/dashBoard_locationList_reponse.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/location_screen/LocatioLogScreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class LocationListMainScreen extends BaseStatefulWidget {
  static const routeName = '/LocationListMainScreen';

  @override
  _LocationListMainScreenState createState() => _LocationListMainScreenState();
}

class _LocationListMainScreenState extends BaseState<LocationListMainScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  List<Map<String, dynamic>> logs = [];
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  DashboardLocationListResponse _listResponse;
  int _pageNo = 0;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  bool isDeleteVisible = true;
  bool isExpand = false;

  final TextEditingController edt_assignTo = TextEditingController();
  final TextEditingController edt_assignToId = TextEditingController();
  final TextEditingController edt_SlipDate = TextEditingController();
  final TextEditingController edt_Reverse_SlipDate = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];

  DateTime selectedDate = DateTime.now();

  /// Auto refresh timer to re-call the API every 30s while screen active
  Timer _autoRefreshTimer;

  /// Flag to avoid multiple simultaneous API calls
  bool _isCallingLocationApi = false;

  /// Permissions / map readiness
  bool _hasLocationPermission = false;
  bool _isRequestingLocationPermission = false;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _mainBloc = MainBloc(baseBloc);

    isExpand = false;
    edt_SlipDate.text =
        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    edt_Reverse_SlipDate.text =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

    isDeleteVisible = viewvisiblitiyAsperClient(
      SerailsKey: _offlineLoggedInData.details[0].serialKey,
      RoleCode: _offlineLoggedInData.details[0].roleCode,
    );

    // Screen-scoped permission check (Android 13+ safe) + speeds up first map render.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLocationPermission();
    });
  }

  @override
  void dispose() {
    _cancelAutoRefreshTimer();
    edt_assignTo.dispose();
    edt_assignToId.dispose();
    edt_SlipDate.dispose();
    edt_Reverse_SlipDate.dispose();
    try {
      _mainBloc?.close();
    } catch (e) {}
    super.dispose();
  }

  /// Cancel timer helper
  void _cancelAutoRefreshTimer() {
    if (_autoRefreshTimer != null && _autoRefreshTimer.isActive) {
      _autoRefreshTimer.cancel();
      _autoRefreshTimer = null;
    }
  }

  /// Start auto refresh timer (30s) if not already started
  void _startAutoRefreshTimer() {
    _cancelAutoRefreshTimer();
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (edt_assignToId.text.isNotEmpty &&
          edt_Reverse_SlipDate.text.isNotEmpty) {
        _callLocationAPI();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is LocationListResponseState) {
            _onMaterialOutwardListResponseSuccess(state);
          }
          if (state is ALL_EmployeeNameListResponseState) {
            _onAssignToResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LocationListResponseState) return true;
          if (currentState is ALL_EmployeeNameListResponseState) return true;
          return false;
        },
      ),
    );
  }

  void _callLocationAPI() {
    if (edt_assignToId.text.isEmpty || edt_Reverse_SlipDate.text.isEmpty) {
      return;
    }

    if (_isCallingLocationApi) return;
    _isCallingLocationApi = true;

    _mainBloc.add(LocationListCallEvent(
      DashboardLocationListRequest(
        pkID: "0",
        LoginUserID: LoginUserID,
        EmployeeID: edt_assignToId.text,
        LogDate: edt_Reverse_SlipDate.text,
        CompanyId: CompanyID,
      ),
    ));

    Future.delayed(Duration(seconds: 20), () {
      _isCallingLocationApi = false;
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Colors.indigo.shade700,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          title: const Text(
            'Live Tracking',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
            onPressed: () {
              navigateTo(context, HomeScreen.routeName, clearAllStack: true);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.event_note, color: Colors.white, size: 28),
              onPressed: () {
                navigateTo(context, LocationLogListMainScreen.routeName,
                    clearAllStack: true);
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 30),
              onPressed: () => _callLocationAPI(),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AssignTo(
                  "Employee Selection",
                  enable1: false,
                  title: "Employee",
                  hintTextvalue: "--- Select ---",
                  controllerForLeft: edt_assignTo,
                  controllerpkID: edt_assignToId,
                  Custom_values1: arr_ALL_Name_ID_For_AssignTo,
                ),
                SlipDate(),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    GoogleMap(
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer()),
                        Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer()),
                        Factory<ScaleGestureRecognizer>(
                            () => ScaleGestureRecognizer()),
                        Factory<TapGestureRecognizer>(
                            () => TapGestureRecognizer()),
                        Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer()),
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(23.092458, 72.555963),
                        zoom: 14.0,
                      ),
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_mapController.isCompleted) {
                          _mapController.complete(controller);
                        }
                        if (mounted) {
                          setState(() {
                            _isMapReady = true;
                          });
                        }
                      },
                      buildingsEnabled: false,
                      myLocationEnabled: _hasLocationPermission,
                      myLocationButtonEnabled: _hasLocationPermission,
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                    ),

                    // Lightweight placeholder while map is initializing
                    if (!_isMapReady)
                      Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(strokeWidth: 2),
                            SizedBox(height: 10),
                            Text('Loading map...'),
                          ],
                        ),
                      ),

                    // Small legend + enable permission CTA
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  _LegendRow(color: Colors.red, text: 'Latest'),
                                  SizedBox(height: 4),
                                  _LegendRow(
                                      color: Colors.orange, text: 'Recent'),
                                  SizedBox(height: 4),
                                  _LegendRow(color: Colors.blue, text: 'Older'),
                                ],
                              ),
                            ),
                          ),
                          if (!_hasLocationPermission)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo.shade700,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _ensureLocationPermission,
                                child: const Text(
                                  'Enable location',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Request location permission safely for Android 11/13+.
  /// This keeps the map functional even if permission is denied (only disables "my location").
  Future<void> _ensureLocationPermission() async {
    if (!mounted) return;
    if (_isRequestingLocationPermission) return;
    _isRequestingLocationPermission = true;

    try {
      // 1) Check current
      var status = await Permission.locationWhenInUse.status;

      // Some Android setups only return Permission.location
      if (status.isDenied) {
        final fallback = await Permission.location.status;
        if (!fallback.isDenied) {
          status = fallback;
        }
      }

      if (status.isGranted) {
        if (mounted) {
          setState(() {
            _hasLocationPermission = true;
          });
        }
        return;
      }

      // 2) Request
      PermissionStatus req = await Permission.locationWhenInUse.request();
      if (!req.isGranted) {
        // try fallback
        req = await Permission.location.request();
      }

      if (!mounted) return;

      if (req.isGranted) {
        setState(() {
          _hasLocationPermission = true;
        });
      } else {
        setState(() {
          _hasLocationPermission = false;
        });

        if (req.isPermanentlyDenied) {
          _showLocationPermissionDialog();
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasLocationPermission = false;
        });
      }
    } finally {
      _isRequestingLocationPermission = false;
    }
  }

  Future<void> _showLocationPermissionDialog() async {
    if (!mounted) return;
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Enable Location Permission'),
          content: const Text(
            'To show your current location on the map, please allow Location permission in Settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await openAppSettings();
              },
              child: const Text('OPEN SETTINGS'),
            ),
          ],
        );
      },
    );
  }

  /// Format a raw ISO-like string into "dd-MM-yyyy   HH:mm:ss"
  String formatDateTime(String rawDateTime) {
    if (rawDateTime == null || rawDateTime.trim().isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(rawDateTime);
      return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year}   "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}:"
          "${dt.second.toString().padLeft(2, '0')}";
    } catch (e) {
      // fallback if parse fails
      return rawDateTime;
    }
  }

  /// Build info text used for InfoWindow snippet
  String buildInfo(Map<String, dynamic> log) {
    final String device = (log['device_name'] ?? '').toString();
    final String displayTime = (log['display_time'] ??
            log['log_date_time'] ??
            log['raw_log_date_time'] ??
            '')
        .toString();
    final String lat = (log['latitude'] ?? '').toString();
    final String lng = (log['longitude'] ?? '').toString();

    final lines = <String>[];
    if (displayTime.trim().isNotEmpty) lines.add('Time: $displayTime');
    if (device.trim().isNotEmpty) lines.add('Device: $device');
    if (lat.trim().isNotEmpty && lng.trim().isNotEmpty) {
      lines.add('Lat: $lat, Lng: $lng');
    }

    return lines.join('\n');
  }

  /// Core: update markers with latest-highlighting + overlap handling + camera move
  void _updateMarkers(List<Map<String, dynamic>> logs) async {
    if (!mounted) return;

    if (logs == null || logs.isEmpty) {
      setState(() {
        _markers.clear();
      });
      return;
    }

    logs.sort((a, b) {
      final aRaw = a['raw_log_date_time'] ?? '';
      final bRaw = b['raw_log_date_time'] ?? '';
      DateTime aDt, bDt;
      try {
        aDt = DateTime.parse(aRaw);
      } catch (_) {
        aDt = DateTime.tryParse(aRaw) ?? DateTime.fromMillisecondsSinceEpoch(0);
      }
      try {
        bDt = DateTime.parse(bRaw);
      } catch (_) {
        bDt = DateTime.tryParse(bRaw) ?? DateTime.fromMillisecondsSinceEpoch(0);
      }
      return bDt.compareTo(aDt);
    });

    final List<Map<String, dynamic>> latestLogs = logs.take(3).toList();
    final List<Map<String, dynamic>> olderLogs = logs.skip(3).toList();

    final Map<String, int> overlapCount = {};

    LatLng adjustPosition(double lat, double lng) {
      final String key = "${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}";
      overlapCount[key] = (overlapCount[key] ?? 0) + 1;
      final int count = overlapCount[key];
      final double delta = 0.00002 * count; // small shift
      return LatLng(lat + delta, lng + delta);
    }

    final Set<Marker> newMarkers = {};

    // hues for latest three (distinct)
    final List<double> latestHues = [
      BitmapDescriptor.hueRed,
      BitmapDescriptor.hueOrange,
      BitmapDescriptor.hueYellow,
    ];

    // Add latest markers
    for (int i = 0; i < latestLogs.length; i++) {
      final log = latestLogs[i];
      final lat = (log['latitude'] is double)
          ? log['latitude']
          : double.tryParse(log['latitude'].toString()) ?? 0.0;
      final lng = (log['longitude'] is double)
          ? log['longitude']
          : double.tryParse(log['longitude'].toString()) ?? 0.0;

      final pos = adjustPosition(lat, lng);

      newMarkers.add(Marker(
        markerId: MarkerId("latest_${i}_${pos.latitude}_${pos.longitude}"),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(latestHues[i]),
        zIndex: 1000 - i.toDouble(),
        infoWindow: InfoWindow(
          title: i == 0
              ? "LIVE — Latest Location"
              : (i == 1 ? "2nd Latest" : "3rd Latest"),
          snippet: buildInfo(log),
        ),
      ));
    }

    // Add older markers as subtle blue markers
    for (var log in olderLogs) {
      final lat = (log['latitude'] is double)
          ? log['latitude']
          : double.tryParse(log['latitude'].toString()) ?? 0.0;
      final lng = (log['longitude'] is double)
          ? log['longitude']
          : double.tryParse(log['longitude'].toString()) ?? 0.0;

      final pos = adjustPosition(lat, lng);

      // Use API id if available else fallback to index
      final String idStr =
          log.containsKey('id') ? log['id'].toString() : pos.toString();

      newMarkers.add(Marker(
        markerId: MarkerId("old_${idStr}_${pos.latitude}_${pos.longitude}"),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        zIndex: 1,
        infoWindow: InfoWindow(
          title: "Previous Location",
          snippet: buildInfo(log),
        ),
      ));
    }

    // commit markers to state
    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }

    // Move camera to the latest position (if map ready)
    try {
      if (_mapController.isCompleted && latestLogs.isNotEmpty) {
        final GoogleMapController controller = await _mapController.future;
        final latest = latestLogs.first;
        final targetLat = (latest['latitude'] is double)
            ? latest['latitude']
            : double.tryParse(latest['latitude'].toString()) ?? 0.0;
        final targetLng = (latest['longitude'] is double)
            ? latest['longitude']
            : double.tryParse(latest['longitude'].toString()) ?? 0.0;

        final target = LatLng(targetLat, targetLng);

        await controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 15.5),
        ));
      }
    } catch (e) {
      // silent fail for camera issues
      print("Map camera animate error: $e");
    }
  }

  void _onMaterialOutwardListResponseSuccess(LocationListResponseState state) {
    // Release API call lock
    _isCallingLocationApi = false;

    logs.clear();
    _listResponse = state.all_employeeList_Response;

    if (_listResponse == null || _listResponse.details == null) {
      _updateMarkers(logs);
      return;
    }

    for (int i = 0; i < _listResponse.details.length; i++) {
      final detail = _listResponse.details[i];

      final String rawDateTime = detail.logDateTime ?? "";

      final String displayTime =
          rawDateTime.isNotEmpty ? formatDateTime(rawDateTime) : "";

      String latitude = detail.latitude ?? "0";
      String longitude = detail.longitude ?? "0";
      String deviceName =
          detail.deviceName ?? detail.employeeName ?? "Unknown Device";

      logs.add({
        'id': detail.pkID ?? i,
        'latitude': double.tryParse(latitude) ?? 0.0,
        'longitude': double.tryParse(longitude) ?? 0.0,
        'device_name': deviceName,
        'raw_log_date_time': rawDateTime,
        'display_time': displayTime,
        'log_date_time': displayTime,
      });
    }

    // update markers & camera
    _updateMarkers(logs);
  }

  Widget AssignTo(String ContactPerson,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: () {
              // fetch employee list
              _mainBloc.add(ALLEmployeeNameCallEvent(
                  ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
            },
            child: Card(
              elevation: 3,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      controllerForLeft.text.isEmpty
                          ? hintTextvalue
                          : controllerForLeft.text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAssignToResponse(ALL_EmployeeNameListResponseState state) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    if (state?.all_employeeList_Response?.details != null) {
      for (var e in state.all_employeeList_Response.details) {
        arr_ALL_Name_ID_For_AssignTo
            .add(ALL_Name_ID(Name: e.employeeName, pkID: e.pkID));
      }
    }

    showcustomdialogWithIDForLocation(
      values: arr_ALL_Name_ID_For_AssignTo,
      context1: context,
      controller: edt_assignTo,
      controllerID: edt_assignToId,
      lable: "Select Employee",
      onValueSelected: () {
        // start auto refresh after selection
        _callLocationAPI();
        _startAutoRefreshTimer();
      },
    );
  }

  showcustomdialogWithIDForLocation({
    List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String lable,
    VoidCallback onValueSelected,
  }) async {
    TextEditingController searchController = TextEditingController();
    List<ALL_Name_ID> filteredValues = List.from(values ?? []);

    void filterSearch(String query) {
      filteredValues = (values ?? [])
          .where((item) =>
              item.Name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }

    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return StatefulBuilder(
          builder: (context123, setState123) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context123).size.height * 0.85,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Title
                      Text(
                        lable,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                      ),

                      SizedBox(height: 15),

                      /// Search Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search...",
                            icon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            setState123(() {
                              filterSearch(value);
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 15),

                      /// List
                      Expanded(
                        child: filteredValues.isEmpty
                            ? Center(
                                child: Text(
                                  "No records found",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredValues.length,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {
                                      controller.text =
                                          filteredValues[index].Name;
                                      controllerID.text =
                                          filteredValues[index].pkID.toString();

                                      Navigator.of(context1).pop();

                                      if (onValueSelected != null) {
                                        onValueSelected();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 6,
                                            backgroundColor: colorPrimary,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              filteredValues[index].Name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      ),

                      SizedBox(height: 10),

                      /// Cancel
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context1),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget SlipDate() {
    return Container(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text("Select Date",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: () => _selectSlipDate(),
            child: Card(
              elevation: 3,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      edt_SlipDate.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_SlipDate.text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )),
                    Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectSlipDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        edt_SlipDate.text = "${picked.day}-${picked.month}-${picked.year}";
        edt_Reverse_SlipDate.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });

      // immediate fetch & start auto-refresh if employee already selected
      _callLocationAPI();
      if (edt_assignToId.text.isNotEmpty) {
        _startAutoRefreshTimer();
      }
    }
  }

  Future<bool> _onBackPressed() async {
    // On back, stop auto refresh and return to home
    _cancelAutoRefreshTimer();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendRow({Key key, this.color, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
