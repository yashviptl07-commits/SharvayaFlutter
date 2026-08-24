import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Expense_Tracking_nikhil/expense_tracking_save_requests.dart';
import 'package:soleoserp/models/api_responses/Expense_Tracking_nikhil/expense_tracking_save_responses.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class ExpenseTrackingAddScreen extends BaseStatefulWidget {
  static const routeName = '/ExpenseTrackingAddScreen';

  @override
  _ExpenseTrackingAddScreenState createState() =>
      _ExpenseTrackingAddScreenState();
}

class _ExpenseTrackingAddScreenState extends BaseState<ExpenseTrackingAddScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  String _selectedVehicle = "";
  bool _isPunchIn = false;
  String _tripID = "";
  Position _startPosition;
  Position _currentPosition;
  double _totalDistanceMeters = 0.0;
  List<Position> _trackedPositions = [];
  Timer _locationTimer;
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _mainBloc = MainBloc(baseBloc);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mainBloc?.close();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      showCommonDialogWithSingleOption(
          context, "Location permission is required.");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _updateMapMarker(position);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _updateMapMarker(Position position) async {
    if (position == null) return;

    Set<Marker> newMarkers = {};

    LatLng officePos = LatLng(23.0225, 72.5714);
    newMarkers.add(Marker(
      markerId: MarkerId('office_loc'),
      position: officePos,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: "Office Location"),
    ));

    for (int i = 0; i < _trackedPositions.length; i++) {
      Position pos = _trackedPositions[i];
      if (i == _trackedPositions.length - 1 &&
          pos.latitude == position.latitude &&
          pos.longitude == position.longitude) {
        continue;
      }
      newMarkers.add(Marker(
        markerId: MarkerId('tracked_$i'),
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));
    }

    newMarkers.add(Marker(
      markerId: MarkerId('current_loc'),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      zIndex: 100,
    ));

    setState(() {
      _markers = newMarkers;
    });

    try {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15.0),
      ));
    } catch (e) {}
  }

  void _startPunchIn() async {
    if (_selectedVehicle.isEmpty) {
      showCommonDialogWithSingleOption(
          context, "Please select a vehicle type first.");
      return;
    }

    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) {
        showCommonDialogWithSingleOption(
            context, "Unable to get current location. Please try again.");
        return;
      }
    }

    setState(() {
      _isPunchIn = true;
      _startPosition = _currentPosition;
      _trackedPositions.clear();
      _trackedPositions.add(_startPosition);
      _totalDistanceMeters = 0.0;

      _tripID =
          "TRIP_${LoginUserID}_${DateTime.now().millisecondsSinceEpoch}_${_selectedVehicle}";
    });

    _startLocationTracking();
  }

  void _startLocationTracking() {
    _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        if (position != null && _trackedPositions.isNotEmpty) {
          Position lastPos = _trackedPositions.last;
          double dist = Geolocator.distanceBetween(lastPos.latitude,
              lastPos.longitude, position.latitude, position.longitude);

          setState(() {
            _currentPosition = position;
            if (dist > 5.0) {
              // only add if moved more than 5 meters
              _trackedPositions.add(position);
              _totalDistanceMeters += dist;
            }
            _updateMapMarker(position);
          });
        }
      } catch (e) {
        print("Error in tracking timer: $e");
      }
    });
  }

  void _startPunchOut() async {
    _locationTimer?.cancel();

    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    Position endPos = _currentPosition ?? _startPosition;

    DateTime startDT =
        DateTime.fromMillisecondsSinceEpoch(int.parse(_tripID.split('_')[2]));
    String startTimeStr =
        "${startDT.year}-${startDT.month.toString().padLeft(2, '0')}-${startDT.day.toString().padLeft(2, '0')} ${startDT.hour.toString().padLeft(2, '0')}:${startDT.minute.toString().padLeft(2, '0')}:${startDT.second.toString().padLeft(2, '0')}";

    DateTime endDT = DateTime.now();
    String endTimeStr =
        "${endDT.year}-${endDT.month.toString().padLeft(2, '0')}-${endDT.day.toString().padLeft(2, '0')} ${endDT.hour.toString().padLeft(2, '0')}:${endDT.minute.toString().padLeft(2, '0')}:${endDT.second.toString().padLeft(2, '0')}";

    double totalDistKm = _totalDistanceMeters / 1000.0;

    ExpenseTrackingSaveRequest request = ExpenseTrackingSaveRequest(
        pKID: "0",
        TripID: _tripID,
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        CompanyID: CompanyID.toString(),
        LoginUserID: LoginUserID,
        StartTime: startTimeStr,
        EndTime: endTimeStr,
        StartLatitude: _startPosition?.latitude?.toString() ?? "",
        StartLongitude: _startPosition?.longitude?.toString() ?? "",
        EndLatitude: endPos?.latitude?.toString() ?? "",
        EndLongitude: endPos?.longitude?.toString() ?? "",
        TotalDistanceKm: totalDistKm.toStringAsFixed(2),
        CreatedBy: LoginUserID,
        UpdatedBy: LoginUserID,
        IsDeleted: "false");

    _mainBloc.add(ExpenseTrackingSaveCallEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is ExpenseTrackingSaveResponseState) {
            _onSaveSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ExpenseTrackingSaveResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isPunchIn) {
          showCommonDialogWithSingleOption(
              context, "Please end the trip (Punch Out) before leaving.");
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Trip Action'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () {
                if (_isPunchIn) {
                  showCommonDialogWithSingleOption(context,
                      "Please end the trip (Punch Out) before leaving.");
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(Icons.arrow_back_outlined)),
        ),
        body: Column(
          children: [
            _buildVehicleSelection(),
            Expanded(
              child: Stack(
                children: [
                  _buildMap(),
                  _buildStatsOverlay(),
                ],
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Select Vehicle:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(width: 20),
          Row(
            children: [
              Radio(
                value: "2W",
                groupValue: _selectedVehicle,
                onChanged: _isPunchIn
                    ? null
                    : (val) {
                        setState(() {
                          _selectedVehicle = val.toString();
                        });
                      },
              ),
              Text("2W", style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(width: 10),
          Row(
            children: [
              Radio(
                value: "4W",
                groupValue: _selectedVehicle,
                onChanged: _isPunchIn
                    ? null
                    : (val) {
                        setState(() {
                          _selectedVehicle = val.toString();
                        });
                      },
              ),
              Text("4W", style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.0225, 72.5714),
        zoom: 14.4746,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        if (!_mapController.isCompleted) {
          _mapController.complete(controller);
        }
        if (_currentPosition != null) {
          _updateMapMarker(_currentPosition);
        }
      },
    );
  }

  Widget _buildStatsOverlay() {
    if (!_isPunchIn) return Container();

    double distKm = _totalDistanceMeters / 1000.0;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Distance",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text("${distKm.toStringAsFixed(2)} Km",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorPrimary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Vehicle",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text("$_selectedVehicle",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          if (!_isPunchIn)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _startPunchIn,
                child: Text("Punch In",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          if (_isPunchIn)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _startPunchOut,
                child: Text("Punch Out",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  void _onSaveSuccess(ExpenseTrackingSaveResponseState state) {
    if (state.expenseTrackingSaveResponse != null) {
      showCommonDialogWithSingleOption(context, "Trip saved successfully",
          onTapOfPositiveButton: () {
        Navigator.pop(context);
        Navigator.pop(context, true);
      });
    }
  }
}
