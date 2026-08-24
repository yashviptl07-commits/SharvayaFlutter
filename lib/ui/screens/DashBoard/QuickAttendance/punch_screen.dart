import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as location;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/dashboard/dashboard_user_rights_screen_bloc.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/other/menu_rights_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/daily_report_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geo;

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

class PunchScreen extends BaseStatefulWidget {
  static const routeName = '/PunchScreen';

  @override
  _PunchScreenState createState() => _PunchScreenState();
}

class _PunchScreenState extends BaseState<PunchScreen>
    with BasicScreen, WidgetsBindingObserver {
  DashBoardScreenBloc _dashBoardScreenBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  bool isPunchIn = false;
  bool isPunchOut = false;
  int CompanyID = 0;
  String LoginUserID = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isSendEmail = false;
  final TextEditingController PuchInTime = TextEditingController();
  final TextEditingController PuchOutTime = TextEditingController();
  final TextEditingController ImgFromTextFiled = TextEditingController();
  String ConstantMAster = "";
  bool isCurrentTime = true;
  bool is_LocationService_Permission;
  location.Location locationService = location.Location();
  String Address = "";
  String Latitude = "";
  String Longitude = "";
  TextEditingController EmailTO = TextEditingController();
  TextEditingController EmailBCC = TextEditingController();
  TextEditingController FromDate = TextEditingController();
  TextEditingController ReverseFromDate = TextEditingController();
  TextEditingController ToDate = TextEditingController();
  String SiteURL = "";
  String Password = "";
  bool isLoading = true;
  final urlController = TextEditingController();
  String url = "";
  bool onWebLoadingStop = false;
  bool islodding = true;
  bool isVisibleRights = false;
  bool permissionGranted;
  bool isTapLiveLocation = false;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _getStoragePermission();
    getLocationLivePermission();
    checkCameraPermissionStatus();
    _dashBoardScreenBloc = DashBoardScreenBloc(baseBloc);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");

    EmailTO.text = "";

    _dashBoardScreenBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "AttendenceWithImage",
            CompanyId: CompanyID.toString())));

    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));

    _dashBoardScreenBloc.add(MenuRightsCallEvent(MenuRightsRequest(
        CompanyID: CompanyID.toString(), LoginUserID: LoginUserID)));

    if (_offlineLoggedInData.details[0].EmployeeImage != "" &&
        _offlineLoggedInData.details[0].EmployeeImage != null) {
      setState(() {
        ImgFromTextFiled.text = _offlineCompanyData.details[0].siteURL +
            _offlineLoggedInData.details[0].EmployeeImage.toString();
      });
    } else {
      ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dashBoardScreenBloc,
      child: BlocConsumer<DashBoardScreenBloc, DashBoardScreenStates>(
        builder: (BuildContext context, DashBoardScreenStates state) {
          if (state is AttendanceListCallResponseState) {
            _OnAttendanceListResponse(state);
          }
          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }
          if (state is MenuRightsEventResponseState) {
            _onMenuRightsResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is AttendanceListCallResponseState ||
              currentState is ConstantResponseState ||
              currentState is MenuRightsEventResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DashBoardScreenStates state) {
          if (state is PunchAttendenceSaveResponseState) {
            _onPunchAttandanceSaveResponse(state);
          }
          if (state is AttendanceSaveCallResponseState) {
            _onAttandanceSaveResponse(state);
          }
          if (state is PunchWithoutAttendenceSaveResponseState) {
            _OnPunchOutWithoutImageSucess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendanceSaveCallResponseState ||
              currentState is PunchOutWebMethodState ||
              currentState is PunchAttendenceSaveResponseState ||
              currentState is PunchWithoutAttendenceSaveResponseState) {
            return true;
          }
          return false;
        },
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
            'Daily Operation',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: RefreshIndicator(
          color: const Color(0xff0066b3),
          onRefresh: () async {
            _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
                pkID: "",
                EmployeeID:
                    _offlineLoggedInData.details[0].employeeID.toString(),
                Month: selectedDate.month.toString(),
                Year: selectedDate.year.toString(),
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
            _dashBoardScreenBloc.add(ConstantRequestEvent(
                CompanyID.toString(),
                ConstantRequest(
                    ConstantHead: "AttendenceWithImage",
                    CompanyId: CompanyID.toString())));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(r.s(16)),
              child: Column(
                children: [
                  // Profile Section
                  _buildProfileSection(context, r),
                  SizedBox(height: r.s(16)),

                  // Location Card
                  _buildLocationCard(context, r),
                  SizedBox(height: r.s(20)),

                  // Punch Controls
                  if (isVisibleRights)
                    _buildPunchControls(context, r)
                  else
                    _buildNoRightsCard(context, r),
                ],
              ),
            ),
          ),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, _R r) {
    return Container(
      padding: EdgeInsets.all(r.s(16)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff108dcf), Color(0xff0066b3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(r.s(20)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0066b3).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: r.s(65),
            height: r.s(65),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: NetworkImage(ImgFromTextFiled.text),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
            child: ImgFromTextFiled.text.isEmpty
                ? const Icon(Icons.person, color: Colors.white, size: 35)
                : null,
          ),
          SizedBox(width: r.s(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _offlineLoggedInData.details[0].employeeName ?? "Employee",
                  style: TextStyle(
                    fontSize: r.f(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: r.s(12), color: Colors.white70),
                    SizedBox(width: r.s(5)),
                    Text(
                      DateFormat('dd MMMM yyyy').format(selectedDate),
                      style: TextStyle(
                        fontSize: r.f(12),
                        color: Colors.white70,
                      ),
                    ),
                  ],
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
      padding: EdgeInsets.all(r.s(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
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
                padding: EdgeInsets.all(r.s(8)),
                decoration: BoxDecoration(
                  color: const Color(0xff62bb47).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(r.s(12)),
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: Color(0xff62bb47), size: 22),
              ),
              SizedBox(width: r.s(12)),
              Expanded(
                child: Text(
                  "Current Location",
                  style: TextStyle(
                    fontSize: r.f(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1A2332),
                  ),
                ),
              ),
              if (_isLoadingLocation)
                SizedBox(
                  height: r.s(20),
                  width: r.s(20),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xff0066b3),
                  ),
                ),
            ],
          ),
          SizedBox(height: r.s(12)),
          if (Latitude.isNotEmpty && Longitude.isNotEmpty)
            Container(
              padding: EdgeInsets.all(r.s(12)),
              decoration: BoxDecoration(
                color: const Color(0xffF2F5FA),
                borderRadius: BorderRadius.circular(r.s(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Latitude",
                            style: TextStyle(
                                fontSize: r.f(10),
                                color: Colors.grey.shade500)),
                        Text(Latitude,
                            style: TextStyle(
                                fontSize: r.f(13),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff1A2332))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Longitude",
                            style: TextStyle(
                                fontSize: r.f(10),
                                color: Colors.grey.shade500)),
                        Text(Longitude,
                            style: TextStyle(
                                fontSize: r.f(13),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff1A2332))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: r.s(10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_city,
                  size: r.s(14), color: Colors.grey.shade500),
              SizedBox(width: r.s(6)),
              Expanded(
                child: Text(
                  Address.isNotEmpty
                      ? Address
                      : "Tap 'Get Location' to fetch address",
                  style: TextStyle(
                    fontSize: r.f(11),
                    color: Address.isNotEmpty
                        ? const Color(0xff1A2332)
                        : Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.s(12)),
          GestureDetector(
            onTap: () async {
              setState(() => _isLoadingLocation = true);
              await getLocationLivePermission456();
              setState(() => _isLoadingLocation = false);
            },
            child: Container(
              height: r.s(44),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff108dcf), Color(0xff0066b3)],
                ),
                borderRadius: BorderRadius.circular(r.s(12)),
              ),
              child: Center(
                child: Text(
                  "Get Live Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: r.f(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchControls(BuildContext context, _R r) {
    return Column(
      children: [
        // Punch In Button
        _buildPunchButton(
          context,
          r,
          title: "PUNCH IN",
          time: PuchInTime.text,
          isActive: isPunchIn,
          icon: Icons.login_rounded,
          color: const Color(0xff0066b3),
          onTap: _onPunchIn,
        ),
        SizedBox(height: r.s(16)),

        // Punch Out Button
        _buildPunchButton(
          context,
          r,
          title: "PUNCH OUT",
          time: PuchOutTime.text,
          isActive: isPunchOut,
          icon: Icons.logout_rounded,
          color: const Color(0xff62bb47),
          onTap: _onPunchOut,
        ),
        SizedBox(height: r.s(16)),

        // Daily Report Button
        _buildActionButton(
          context,
          r,
          title: "Daily Report",
          icon: Icons.email_outlined,
          color: const Color(0xff108dcf),
          onTap: _showDailyReportDialog,
        ),
      ],
    );
  }

  Widget _buildPunchButton(BuildContext context, _R r,
      {String title,
      String time,
      bool isActive,
      IconData icon,
      Color color,
      VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.s(16)),
          child: Padding(
            padding: EdgeInsets.all(r.s(20)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(r.s(12)),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(r.s(14)),
                  ),
                  child: Icon(icon, color: color, size: r.s(28)),
                ),
                SizedBox(width: r.s(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: r.f(14),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: r.s(4)),
                      Text(
                        time.isEmpty ? "Not punched yet" : time,
                        style: TextStyle(
                          fontSize: r.f(18),
                          fontWeight: FontWeight.bold,
                          color: isActive ? color : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.s(8), vertical: r.s(4)),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(r.s(12)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: color, size: r.s(14)),
                        SizedBox(width: r.s(4)),
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: r.f(10),
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, _R r,
      {String title, IconData icon, Color color, VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.s(16)),
          child: Padding(
            padding: EdgeInsets.all(r.s(16)),
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
                SizedBox(width: r.s(16)),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: r.f(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1A2332),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.grey.shade400, size: r.s(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoRightsCard(BuildContext context, _R r) {
    return Container(
      padding: EdgeInsets.all(r.s(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
      ),
      child: Column(
        children: [
          Icon(Icons.security_outlined,
              size: r.s(60), color: Colors.grey.shade400),
          SizedBox(height: r.s(16)),
          Text(
            "Access Restricted",
            style: TextStyle(
              fontSize: r.f(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xff1A2332),
            ),
          ),
          SizedBox(height: r.s(8)),
          Text(
            "Your attendance rights are disabled.\nPlease contact administrator.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.f(13),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDailyReportDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.fromLTRB(20, 16, 12, 12),
                  decoration: BoxDecoration(
                    color: const Color(0xff0066b3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Report",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: Colors.white, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: DailyReport(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Original logic methods (keep as is, just adding navigation calls)
  Future<void> _onPunchIn() async {
    // Your existing punch in logic here
    // Call the same methods you already have
    TimeOfDay selectedTime = TimeOfDay.now();
    if (isTapLiveLocation) {
      if (isCurrentTime) {
        if (isPunchIn) {
          showCommonDialogWithSingleOption(
            context,
            "${_offlineLoggedInData.details[0].employeeName}\nPunch In : ${PuchInTime.text}",
            positiveButtonTitle: "OK",
          );
        } else {
          if (ConstantMAster.toString() == "" ||
              ConstantMAster.toString().toLowerCase() == "no") {
            _dashBoardScreenBloc.add(
              PunchWithoutImageAttendanceSaveRequestEvent(
                PunchWithoutImageAttendanceSaveRequest(
                  Mode: "punchin",
                  pkID: "0",
                  EmployeeID:
                      _offlineLoggedInData.details[0].employeeID.toString(),
                  PresenceDate:
                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                  TimeIn: "${selectedTime.hour}:${selectedTime.minute}",
                  TimeOut: "",
                  LunchIn: "",
                  LunchOut: "",
                  LoginUserID: LoginUserID,
                  Notes: "",
                  Latitude: Latitude,
                  Longitude: Longitude,
                  LocationAddress: Address,
                  CompanyId: CompanyID.toString(),
                ),
              ),
            );
          } else {
            final canOpenCamera = await _ensurePunchImagePermissions();
            if (!canOpenCamera) {
              return;
            }

            await _captureAndUploadPunchImage(mode: "punchin");
          }
        }
      } else {
        getcurrentTimeInfoFromMaindfd();
      }
    } else {
      showCommonDialogWithSingleOption(
        context,
        "Kindly Tap On Get Live Location!",
        positiveButtonTitle: "OK",
      );
    }
  }

  Future<void> _onPunchOut() async {
    // Your existing punch out logic here
    if (isTapLiveLocation) {
      if (isCurrentTime) {
        punchoutLogic();
      } else {
        getcurrentTimeInfoFromMaindfd();
      }
    } else {
      showCommonDialogWithSingleOption(
        context,
        "Kindly Tap On Get Live Location!",
        positiveButtonTitle: "OK",
      );
    }
  }

  void _onGetConstant(ConstantResponseState state) {
    ConstantMAster = state.response.details[0].value.toString();
  }

  void getcurrentTimeInfoFromMaindfd() async {
    // Keep existing code
    DateTime startDate = await NTP.now();
    var now = startDate;
    var formatter = DateFormat('yyyy-MM-ddTHH');
    String currentday = formatter.format(now);
    String PresentDate1 = formatter.format(DateTime.now());

    if (DateTime.parse(currentday) != DateTime.parse(PresentDate1)) {
      isCurrentTime = false;
      return showCommonDialogWithSingleOption(context,
          "Your Device DateTime is not correct as per current DateTime, Kindly Update Your Device Time!",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, HomeScreen.routeName, clearAllStack: true);
      });
    } else {
      isCurrentTime = true;
    }
  }

  void checkCameraPermissionStatus() async {
    await _ensureCameraPermission();
  }

  Future<bool> _ensureCameraPermission() async {
    final granted = await permissionHandler.Permission.camera.isGranted;
    final denied = await permissionHandler.Permission.camera.isDenied;
    final permanentlyDenied =
        await permissionHandler.Permission.camera.isPermanentlyDenied;

    if (granted) {
      return true;
    }

    if (denied) {
      final status = await permissionHandler.Permission.camera.request();
      if (status.isGranted) {
        return true;
      }
    }

    if (await permissionHandler.Permission.camera.isRestricted ||
        permanentlyDenied) {
      _showPermissionDialog(
        'Camera Permission Required',
        'Camera permission is required to capture punch in/out photos.',
      );
      permissionHandler.openAppSettings();
    }

    return false;
  }

  Future<bool> _ensureStoragePermissionIfNeeded() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      return true;
    }

    final status = await permissionHandler.Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    final requestStatus = await permissionHandler.Permission.storage.request();
    if (requestStatus.isGranted) {
      return true;
    }

    if (requestStatus.isPermanentlyDenied) {
      _showPermissionDialog(
        'Storage Permission Required',
        'Storage permission is needed on older Android devices for punch image processing.',
      );
      permissionHandler.openAppSettings();
    }

    return false;
  }

  Future<bool> _ensurePunchImagePermissions() async {
    final cameraAllowed = await _ensureCameraPermission();
    if (!cameraAllowed) {
      return false;
    }

    final storageAllowed = await _ensureStoragePermissionIfNeeded();
    if (!storageAllowed) {
      return false;
    }

    permissionGranted = true;
    return true;
  }

  Future<void> _captureAndUploadPunchImage({String mode}) async {
    final imagepicker = ImagePicker();
    XFile file = await imagepicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (file == null) {
      return;
    }

    final file1 = File(file.path);
    final dir = await path_provider.getTemporaryDirectory();
    final extension = p.extension(file1.path);
    final timestamp1 = DateTime.now().millisecondsSinceEpoch;

    final filename = _offlineLoggedInData.details[0].employeeID.toString() +
        "_" +
        DateTime.now().day.toString() +
        "_" +
        DateTime.now().month.toString() +
        "_" +
        DateTime.now().year.toString() +
        "_" +
        timestamp1.toString() +
        extension;

    final targetPath = dir.absolute.path + "/" + filename;
    final File compressedFile = await testCompressAndGetFile(file1, targetPath);

    baseBloc.emit(ShowProgressIndicatorState(true));
    _dashBoardScreenBloc.add(PunchAttendanceSaveRequestEvent(
        compressedFile,
        PunchAttendanceSaveRequest(
          pkID: "0",
          CompanyId: CompanyID.toString(),
          Mode: mode,
          EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
          FileName: filename,
          PresenceDate:
              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
          Time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
          Notes: "",
          Latitude: Latitude,
          Longitude: Longitude,
          LocationAddress: Address,
          LoginUserId: LoginUserID,
        )));
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );
    return result;
  }

  void punchoutLogic() async {
    // Keep existing code
    if (isPunchIn == true) {
      TimeOfDay selectedTime = TimeOfDay.now();

      if (isPunchOut == true) {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() !=
            "SW0T-GLA5-IND7-AS71") {
          showCommonDialogWithSingleOption(context,
              "${_offlineLoggedInData.details[0].employeeName}\nPunch Out : ${PuchOutTime.text}",
              positiveButtonTitle: "OK");
        }
      } else {
        if (ConstantMAster.toString() == "" ||
            ConstantMAster.toString().toLowerCase() == "no") {
          _dashBoardScreenBloc.add(PunchWithoutImageAttendanceSaveRequestEvent(
              PunchWithoutImageAttendanceSaveRequest(
                  Mode: "punchout",
                  pkID: "0",
                  EmployeeID:
                      _offlineLoggedInData.details[0].employeeID.toString(),
                  PresenceDate:
                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                  TimeIn: "",
                  TimeOut: "${selectedTime.hour}:${selectedTime.minute}",
                  LunchIn: "",
                  LunchOut: "",
                  LoginUserID: LoginUserID,
                  Notes: "",
                  Latitude: Latitude,
                  Longitude: Longitude,
                  LocationAddress: Address,
                  CompanyId: CompanyID.toString())));
        } else {
          final canOpenCamera = await _ensurePunchImagePermissions();
          if (!canOpenCamera) {
            return;
          }

          await _captureAndUploadPunchImage(mode: "punchout");
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Punch in Is Required!",
          positiveButtonTitle: "OK");
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _OnAttendanceListResponse(AttendanceListCallResponseState state) {
    String PDate = "";
    String CDate = "";

    if (state.response.details.isNotEmpty) {
      for (int i = 0; i < state.response.details.length; i++) {
        if (state.response.details[i].presenceDate != "") {
          PDate = state.response.details[i].presenceDate.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
          CDate =
              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";

          DateTime APIDate = DateFormat("dd-MM-yyyy").parse(PDate);
          DateTime CurrentDate = DateFormat("dd-MM-yyyy").parse(CDate);

          if (APIDate == CurrentDate) {
            if (state.response.details[i].timeIn != "") {
              PuchInTime.text = state.response.details[i].timeIn.toString();
              isPunchIn = true;
            } else {
              isPunchIn = false;
              PuchInTime.text = "";
            }
            if (state.response.details[i].timeOut != "") {
              PuchOutTime.text = state.response.details[i].timeOut.toString();
              isPunchOut = true;
            } else {
              isPunchOut = false;
              PuchOutTime.text = "";
            }
            break;
          } else {
            isPunchIn = false;
            isPunchOut = false;
            PuchInTime.text = "";
            PuchOutTime.text = "";
          }
        }
      }
    } else {
      isPunchIn = false;
      isPunchOut = false;
    }
  }

  void _onPunchAttandanceSaveResponse(PunchAttendenceSaveResponseState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _onAttandanceSaveResponse(AttendanceSaveCallResponseState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _OnPunchOutWithoutImageSucess(
      PunchWithoutAttendenceSaveResponseState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  void _onMenuRightsResponse(MenuRightsEventResponseState response) {
    for (var i = 0; i < response.menuRightsResponse.details.length; i++) {
      if (response.menuRightsResponse.details[i].menuName == "pgAttendance") {
        isVisibleRights = true;
      }
    }
  }

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    if (android.version.sdkInt < 33) {
      permissionHandler.PermissionStatus status =
          await permissionHandler.Permission.storage.request();
      if (status.isGranted) {
        setState(() => permissionGranted = true);
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog('Storage Permission Required',
            'Storage permission is needed for temporary image processing.');
      } else {
        setState(() => permissionGranted = false);
      }
    } else {
      setState(() => permissionGranted = true);
    }
  }

  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              permissionHandler.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void getLocationLivePermission() async {
    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      checkPermissionStatus();
      return;
    }

    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
    }

    if (permission == geolocator.LocationPermission.whileInUse ||
        permission == geolocator.LocationPermission.always) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();
      Latitude = position.latitude.toString();
      Longitude = position.longitude.toString();

      List<geo.Placemark> placemark = await geo.placemarkFromCoordinates(
        double.parse(Latitude),
        double.parse(Longitude),
      );
      Address =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";
    }
  }

  void getLocationLivePermission456() async {
    baseBloc.emit(ShowProgressIndicatorState(true));
    await getLocationLivePermission();
    baseBloc.emit(ShowProgressIndicatorState(false));
    isTapLiveLocation = true;
    setState(() {});
  }

  void checkPermissionStatus() async {
    if (!await locationService.serviceEnabled()) {
      if (Platform.isAndroid) {
        locationService.requestService();
      }
    }
    final granted = await permissionHandler.Permission.location.isGranted;
    bool Denied = await permissionHandler.Permission.location.isDenied;
    bool PermanentlyDenied =
        await permissionHandler.Permission.location.isPermanentlyDenied;

    if (granted) {
      return;
    }

    if (Denied == true) {
      await permissionHandler.Permission.location.request();
    }
    if (await permissionHandler.Permission.location.isRestricted) {
      permissionHandler.openAppSettings();
    }
    if (PermanentlyDenied == true) {
      permissionHandler.openAppSettings();
    }
  }
}
