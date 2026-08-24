import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/attendance_employee/attendance_bloc.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_save_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/attendance/employee_attendance_list_general.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class _R {
  final double sw;
  final double sh;
  final double px;

  _R(BuildContext context)
      : sw = MediaQuery.of(context).size.width,
        sh = MediaQuery.of(context).size.height,
        px = MediaQuery.of(context).size.width / 390;

  double s(double v) => (v * px).clamp(v * 0.75, v * 1.35);
  double f(double v) => (v * px).clamp(v * 0.82, v * 1.20);
}

class AddUpdateAttendanceArguments {
  List<dynamic> selectedEvents = [];
  String EmployeeID = "";
  String PresentDate = "";

  AddUpdateAttendanceArguments(
      this.selectedEvents, this.EmployeeID, this.PresentDate);
}

class AttendanceAdd_EditScreen extends BaseStatefulWidget {
  static const routeName = '/AttendanceAdd_EditScreen';
  final AddUpdateAttendanceArguments arguments;

  AttendanceAdd_EditScreen(this.arguments);

  @override
  _AttendanceAdd_EditScreenState createState() =>
      _AttendanceAdd_EditScreenState();
}

class _AttendanceAdd_EditScreenState extends BaseState<AttendanceAdd_EditScreen>
    with BasicScreen, WidgetsBindingObserver {
  AttendanceBloc _FollowupBloc;
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _eventControllerIn_Time;
  TextEditingController _eventControllerOut_Time;
  TextEditingController _eventControllerNotes;

  List<dynamic> _selectedEvents = [];
  String _EmployeeID = "";
  String _PresentDate = "";
  bool isvisible_Out_time = false;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  DateTime selectedDate = DateTime.now();
  Location location = Location();
  bool _serviceEnabled;
  LocationData _locationData;
  bool is_LocationService_Permission = false;

  String MapAPIKey = "";
  String Address = "";
  String _currentLatitude = "";
  String _currentLongitude = "";

  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    MapAPIKey = _offlineCompanyData.details[0].MapApiKey ?? "";

    _FollowupBloc = AttendanceBloc(baseBloc);
    _eventControllerIn_Time = TextEditingController();
    _eventControllerNotes = TextEditingController();
    _eventControllerOut_Time = TextEditingController();

    _selectedEvents = widget.arguments.selectedEvents;
    _EmployeeID = widget.arguments.EmployeeID;
    _PresentDate = widget.arguments.PresentDate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkPermissionAndGetLocation();
      fillData();
    });
  }

  @override
  void dispose() {
    _eventControllerIn_Time.dispose();
    _eventControllerOut_Time.dispose();
    _eventControllerNotes.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    // Check location permission status
    ph.PermissionStatus status = await ph.Permission.location.status;

    if (status.isDenied) {
      // Request permission
      status = await ph.Permission.location.request();
    }

    if (status.isGranted) {
      is_LocationService_Permission = true;
      await _getCurrentLocation();
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      // Show dialog to open app settings
      showCommonDialogWithTwoOptions(
        context,
        "Location permission is required to mark attendance. Please enable it in settings.",
        negativeButtonTitle: "Cancel",
        positiveButtonTitle: "Open Settings",
        onTapOfPositiveButton: () async {
          await ph.openAppSettings();
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
      });
    }

    try {
      // Check if service is enabled
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) return;
      }

      // Get current location
      _locationData = await location.getLocation();

      if (_locationData != null) {
        _currentLatitude = _locationData.latitude.toString();
        _currentLongitude = _locationData.longitude.toString();

        // Save to SharedPreferences
        SharedPrefHelper.instance.setLatitude(_currentLatitude);
        SharedPrefHelper.instance.setLongitude(_currentLongitude);

        // Get address from coordinates
        await _getAddressFromCoordinates();
      }
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    if (MapAPIKey.isNotEmpty &&
        _currentLatitude.isNotEmpty &&
        _currentLongitude.isNotEmpty) {
      try {
        GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: double.parse(_currentLatitude),
          longitude: double.parse(_currentLongitude),
          googleMapApiKey: MapAPIKey,
        );

        if (mounted) {
          setState(() {
            Address = data.address ?? "";
          });
        }
      } catch (e) {
        print("Error getting address: $e");
        Address = "";
      }
    }
  }

  Future<String> getAddressFromLatLngMapMyIndia(
      String lat, String lng, String skey) async {
    String _host =
        'https://apis.mapmyindia.com/advancedmaps/v1/$skey/rev_geocode';
    final url = '$_host?lat=$lat&lng=$lng';

    if (lat != "" && lng != "null") {
      try {
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map data = jsonDecode(response.body);
          String _formattedAddress = data["results"][0]["formatted_address"];
          return _formattedAddress;
        }
      } catch (e) {
        print("Error: $e");
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<AttendanceBloc, AttendanceStates>(
        builder: (BuildContext context, AttendanceStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) => false,
        listener: (context, state) {
          if (state is AttendanceSaveCallResponseState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _onSaveAttendanceResponseSuccess(state);
            });
          }
        },
        listenWhen: (_, currentState) =>
            currentState is AttendanceSaveCallResponseState,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final r = _R(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'Add Attendance',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                navigateTo(context, AttendanceListScreen.routeName,
                    clearAllStack: true);
              },
              icon: Icon(Icons.home_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(r.s(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date Card
                _buildInfoCard(
                  context,
                  title: "Date",
                  value: _formatDate(_PresentDate),
                  icon: Icons.calendar_today_outlined,
                ),
                SizedBox(height: r.s(12)),

                // Location Card
                _buildLocationCard(context, r),
                SizedBox(height: r.s(12)),

                // In Time Card
                _buildTimeCard(
                  context,
                  title: "In Time",
                  controller: _eventControllerIn_Time,
                  icon: Icons.login_rounded,
                  color: const Color(0xff0066b3),
                  onTap: () =>
                      _selectFromTime(context, _eventControllerIn_Time),
                ),
                SizedBox(height: r.s(12)),

                // Out Time Card (Visible conditionally)
                if (isvisible_Out_time)
                  _buildTimeCard(
                    context,
                    title: "Out Time",
                    controller: _eventControllerOut_Time,
                    icon: Icons.logout_rounded,
                    color: const Color(0xff62bb47),
                    onTap: () =>
                        _selectToTime(context, _eventControllerOut_Time),
                  ),
                if (isvisible_Out_time) SizedBox(height: r.s(12)),

                // Notes Card
                _buildNotesCard(context, r),
                SizedBox(height: r.s(24)),

                // Save Button
                _buildSaveButton(context, r),
                SizedBox(height: r.s(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {String title, String value, IconData icon}) {
    final r = _R(context);
    return Container(
      padding: EdgeInsets.all(r.s(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(r.s(10)),
            decoration: BoxDecoration(
              color: const Color(0xff0066b3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.s(12)),
            ),
            child: Icon(icon, color: const Color(0xff0066b3), size: r.s(22)),
          ),
          SizedBox(width: r.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: r.f(11),
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: r.f(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1A2332),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, _R r) {
    return Container(
      padding: EdgeInsets.all(r.s(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.s(10)),
                decoration: BoxDecoration(
                  color: const Color(0xff62bb47).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(r.s(12)),
                ),
                child: Icon(Icons.location_on_outlined,
                    color: const Color(0xff62bb47), size: r.s(22)),
              ),
              SizedBox(width: r.s(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: r.f(11),
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: r.s(4)),
                    if (_isLoadingLocation)
                      Row(
                        children: [
                          SizedBox(
                            height: r.s(16),
                            width: r.s(16),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: const Color(0xff0066b3),
                            ),
                          ),
                          SizedBox(width: r.s(8)),
                          Text(
                            "Getting location...",
                            style: TextStyle(
                              fontSize: r.f(11),
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        Address.isNotEmpty ? Address : "Location not available",
                        style: TextStyle(
                          fontSize: r.f(12),
                          color: Address.isNotEmpty
                              ? const Color(0xff1A2332)
                              : Colors.grey.shade500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Lat/Long Row
          if (_currentLatitude.isNotEmpty && _currentLongitude.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: r.s(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Lat: $_currentLatitude",
                      style: TextStyle(
                        fontSize: r.f(10),
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Long: $_currentLongitude",
                      style: TextStyle(
                        fontSize: r.f(10),
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context,
      {String title,
      TextEditingController controller,
      IconData icon,
      Color color,
      VoidCallback onTap}) {
    final r = _R(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.s(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.s(14)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(r.s(10)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(r.s(12)),
              ),
              child: Icon(icon, color: color, size: r.s(22)),
            ),
            SizedBox(width: r.s(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: r.f(11),
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: r.s(4)),
                  Text(
                    controller.text.isEmpty
                        ? "Tap to select time"
                        : controller.text,
                    style: TextStyle(
                      fontSize: r.f(14),
                      fontWeight: FontWeight.w600,
                      color: controller.text.isEmpty
                          ? Colors.grey.shade400
                          : color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.access_time_rounded,
                color: Colors.grey.shade400, size: r.s(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, _R r) {
    return Container(
      padding: EdgeInsets.all(r.s(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.s(10)),
                decoration: BoxDecoration(
                  color: const Color(0xff108dcf).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(r.s(12)),
                ),
                child: Icon(Icons.notes_outlined,
                    color: const Color(0xff108dcf), size: r.s(22)),
              ),
              SizedBox(width: r.s(14)),
              Text(
                "Notes",
                style: TextStyle(
                  fontSize: r.f(13),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1A2332),
                ),
              ),
            ],
          ),
          SizedBox(height: r.s(12)),
          TextFormField(
            controller: _eventControllerNotes,
            minLines: 3,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Enter your notes here...',
              hintStyle:
                  TextStyle(fontSize: r.f(12), color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(r.s(10)),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(r.s(10)),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(r.s(10)),
                borderSide:
                    const BorderSide(color: Color(0xff0066b3), width: 1.5),
              ),
              contentPadding: EdgeInsets.all(r.s(12)),
            ),
            style: TextStyle(fontSize: r.f(13), color: const Color(0xff1A2332)),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, _R r) {
    return GestureDetector(
      onTap: _saveAttendance,
      child: Container(
        height: r.s(52),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff108dcf), Color(0xff0066b3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(r.s(14)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0066b3).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Save Attendance",
            style: TextStyle(
              fontSize: r.f(16),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _saveAttendance() async {
    // Refresh location before saving
    await _getCurrentLocation();

    // Auto-set current time when either field is empty.
    if (_eventControllerIn_Time.text.trim().isEmpty) {
      _eventControllerIn_Time.text = _formattedCurrentTime();
    }
    if (_eventControllerOut_Time.text.trim().isEmpty) {
      _eventControllerOut_Time.text = _formattedCurrentTime();
    }

    if (_eventControllerIn_Time.text.isNotEmpty &&
        _eventControllerOut_Time.text.isNotEmpty) {
      var fromDate = stringToTimeOfDay(_eventControllerIn_Time.text)
          .toString()
          .replaceAll(":", "");
      var toDate = stringToTimeOfDay(_eventControllerOut_Time.text)
          .toString()
          .replaceAll(":", "");

      String FromTime7up =
          fromDate.replaceAll("TimeOfDay(", "").replaceAll(")", "");
      String ToTime7up =
          toDate.replaceAll("TimeOfDay(", "").replaceAll(")", "");

      if (double.parse(FromTime7up) <= double.parse(ToTime7up)) {
        baseBloc.emit(ShowProgressIndicatorState(true));

        _FollowupBloc.add(AttendanceSaveCallEvent(AttendanceSaveApiRequest(
            EmployeeID: _EmployeeID,
            PresenceDate: _PresentDate,
            TimeIn: _eventControllerIn_Time.text,
            TimeOut: _eventControllerOut_Time.text,
            Latitude: _currentLatitude,
            Longitude: _currentLongitude,
            LocationAddress: Address,
            Notes: _eventControllerNotes.text,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
      } else {
        showCommonDialogWithSingleOption(
            context, "Invalid Time! Time-OUT must be greater than Time-IN",
            positiveButtonTitle: "OK");
      }
    } else {
      baseBloc.emit(ShowProgressIndicatorState(true));

      _FollowupBloc.add(AttendanceSaveCallEvent(AttendanceSaveApiRequest(
          EmployeeID: _EmployeeID,
          PresenceDate: _PresentDate,
          TimeIn: _eventControllerIn_Time.text,
          TimeOut: _eventControllerOut_Time.text,
          Latitude: _currentLatitude,
          Longitude: _currentLongitude,
          LocationAddress: Address,
          Notes: _eventControllerNotes.text,
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString())));
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  String _formatDate(String dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  String _formattedCurrentTime() {
    final now = TimeOfDay.now();
    final amPm = now.periodOffset.toString() == "12" ? "PM" : "AM";
    final hour = now.hourOfPeriod <= 9
        ? "0${now.hourOfPeriod}"
        : now.hourOfPeriod.toString();
    final minute = now.minute <= 9 ? "0${now.minute}" : now.minute.toString();
    return "$hour:$minute $amPm";
  }

  Future<void> _selectFromTime(
      BuildContext context, TextEditingController controller) async {
    if (_offlineLoggedInData.details[0].roleCode == 'admin' ||
        _offlineLoggedInData.details[0].roleCode == 'hradmin') {
      final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child,
            );
          });

      if (picked != null) {
        String AM_PM = picked.periodOffset.toString() == "12" ? "PM" : "AM";
        String hour = picked.hourOfPeriod <= 9
            ? "0${picked.hourOfPeriod}"
            : picked.hourOfPeriod.toString();
        String minute =
            picked.minute <= 9 ? "0${picked.minute}" : picked.minute.toString();
        controller.text = "$hour:$minute $AM_PM";
        setState(() {});
      }
    } else {
      selectedTime = TimeOfDay.now();
      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String hour = selectedTime.hourOfPeriod <= 9
          ? "0${selectedTime.hourOfPeriod}"
          : selectedTime.hourOfPeriod.toString();
      String minute = selectedTime.minute <= 9
          ? "0${selectedTime.minute}"
          : selectedTime.minute.toString();
      controller.text = "$hour:$minute $AM_PM";
      setState(() {});
    }
  }

  Future<void> _selectToTime(
      BuildContext context, TextEditingController controller) async {
    if (_offlineLoggedInData.details[0].roleCode == 'admin' ||
        _offlineLoggedInData.details[0].roleCode == 'hradmin') {
      final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child,
            );
          });

      if (picked != null) {
        String AM_PM = picked.periodOffset.toString() == "12" ? "PM" : "AM";
        String hour = picked.hourOfPeriod <= 9
            ? "0${picked.hourOfPeriod}"
            : picked.hourOfPeriod.toString();
        String minute =
            picked.minute <= 9 ? "0${picked.minute}" : picked.minute.toString();
        controller.text = "$hour:$minute $AM_PM";
        setState(() {});
      }
    } else {
      selectedTime = TimeOfDay.now();
      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String hour = selectedTime.hourOfPeriod <= 9
          ? "0${selectedTime.hourOfPeriod}"
          : selectedTime.hourOfPeriod.toString();
      String minute = selectedTime.minute <= 9
          ? "0${selectedTime.minute}"
          : selectedTime.minute.toString();
      controller.text = "$hour:$minute $AM_PM";
      setState(() {});
    }
  }

  void fillData() {
    final isAdmin = _offlineLoggedInData.details[0].roleCode == 'admin' ||
        _offlineLoggedInData.details[0].roleCode == 'hradmin';

    if (_selectedEvents.isNotEmpty) {
      final inTime = _selectedEvents.length > 0 && _selectedEvents[0] != null
          ? _selectedEvents[0].toString()
          : "";
      final outTime = _selectedEvents.length > 1 && _selectedEvents[1] != null
          ? _selectedEvents[1].toString()
          : "";
      final notes = _selectedEvents.length > 2 && _selectedEvents[2] != null
          ? _selectedEvents[2].toString()
          : "";

      _eventControllerIn_Time.text =
          inTime.isNotEmpty ? inTime : _formattedCurrentTime();
      _eventControllerOut_Time.text =
          outTime.isNotEmpty ? outTime : _formattedCurrentTime();
      _eventControllerNotes.text = notes;

      isvisible_Out_time = isAdmin || inTime.isNotEmpty;
    } else {
      isvisible_Out_time = isAdmin;
      if (_eventControllerIn_Time.text.trim().isEmpty) {
        _eventControllerIn_Time.text = _formattedCurrentTime();
      }
      if (_eventControllerOut_Time.text.trim().isEmpty) {
        _eventControllerOut_Time.text = _formattedCurrentTime();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSaveAttendanceResponseSuccess(AttendanceSaveCallResponseState state) {
    baseBloc.emit(ShowProgressIndicatorState(false));
    showCommonDialogWithSingleOption(context, state.response.details[0].column2,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
    });
  }
}
