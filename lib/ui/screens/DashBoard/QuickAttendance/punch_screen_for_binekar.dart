import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:ntp/ntp.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/dashboard/dashboard_user_rights_screen_bloc.dart';
import 'package:soleoserp/models/api_requests/MyGetPunching/my_get_punching_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/other/menu_rights_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;

class PunchScreenForBinekar extends BaseStatefulWidget {
  static const routeName = '/PunchScreenForBinekar';

  @override
  _PunchScreenForBinekarState createState() => _PunchScreenForBinekarState();
}

class _PunchScreenForBinekarState extends BaseState<PunchScreenForBinekar>
    with BasicScreen, WidgetsBindingObserver {
  // geolocator.Position _currentPosition;

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
  final TextEditingController LunchInTime = TextEditingController();
  final TextEditingController LunchOutTime = TextEditingController();
  final TextEditingController ImgFromTextFiled = TextEditingController();
  String ConstantMAster = "";
  bool isCurrentTime = true;

  bool is_LocationService_Permission;
  Location location = new Location();
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

  bool isLunchIn = false;
  bool isLunchOut = false;

  @override
  void initState() {
    super.initState();

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

    if (_offlineLoggedInData.details[0].EmployeeImage != "" ||
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

          if (state is MyGetPunchingState) {
            _OnMyGetPunchingState(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendanceSaveCallResponseState ||
              currentState is PunchOutWebMethodState ||
              currentState is PunchAttendenceSaveResponseState ||
              currentState is PunchWithoutAttendenceSaveResponseState ||
              currentState is MyGetPunchingState) {
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
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NewGradientAppBar(
            title: Text('Daily Operation'),
            gradient: LinearGradient(colors: [
              Color(0xff108dcf),
              Color(0xff0066b3),
              Color(0xff62bb47),
            ]),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.water_damage_sharp,
                    color: colorWhite,
                  ),
                  onPressed: () {
                    //_onTapOfLogOut();
                    navigateTo(context, HomeScreen.routeName,
                        clearAllStack: true);
                  })
            ],
          ),
          body: RefreshIndicator(
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
            child: Container(
              color: colorVeryLightGray,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorPrimary),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Location Details",
                              style: TextStyle(
                                  color: colorYellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25)),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text("Latitude : ",
                                      style: TextStyle(
                                          color: colorYellow,
                                          fontWeight: FontWeight.bold))),
                              Flexible(
                                  child: Text(Latitude,
                                      style: TextStyle(color: colorWhite))),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text("Longitude : ",
                                      style: TextStyle(
                                          color: colorYellow,
                                          fontWeight: FontWeight.bold))),
                              Flexible(
                                  child: Text(Longitude,
                                      style: TextStyle(color: colorWhite))),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Address : ",
                                style: TextStyle(
                                  color: colorYellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(Address,
                                  style: TextStyle(color: colorWhite)),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              getLocationLivePermission456();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    elevation: 5,
                                    color: colorYellow,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Container(
                                      height: 55,
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Get Live Location",
                                                style: TextStyle(
                                                    color: colorPrimary,
                                                    // <-- Change this
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isVisibleRights == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  TimeOfDay selectedTime = TimeOfDay.now();
                                  if (isTapLiveLocation == true) {
                                    if (Address != "" || Address != null) {
                                      if (isCurrentTime == true) {
                                        if (isPunchIn == true) {
                                          showCommonDialogWithSingleOption(
                                              context,
                                              _offlineLoggedInData
                                                      .details[0].employeeName +
                                                  " \n Punch In : " +
                                                  PuchInTime.text,
                                              positiveButtonTitle: "OK");
                                        } else {
                                          if (permissionGranted == false) {
                                            _getStoragePermission();
                                          } else {
                                            if (ConstantMAster.toString() ==
                                                    "" ||
                                                ConstantMAster.toString()
                                                        .toLowerCase() ==
                                                    "no") {
                                              _dashBoardScreenBloc.add(
                                                  PunchWithoutImageAttendanceSaveRequestEvent(
                                                      PunchWithoutImageAttendanceSaveRequest(
                                                          Mode: "punchin",
                                                          pkID: "0",
                                                          EmployeeID:
                                                              _offlineLoggedInData
                                                                  .details[0]
                                                                  .employeeID
                                                                  .toString(),
                                                          PresenceDate:
                                                              selectedDate
                                                                      .year
                                                                      .toString() +
                                                                  "-" +
                                                                  selectedDate
                                                                      .month
                                                                      .toString() +
                                                                  "-" +
                                                                  selectedDate
                                                                      .day
                                                                      .toString(),
                                                          TimeIn: selectedTime
                                                                  .hour
                                                                  .toString() +
                                                              ":" +
                                                              selectedTime
                                                                  .minute
                                                                  .toString(),
                                                          TimeOut: "",
                                                          LunchIn: "",
                                                          LunchOut: "",
                                                          LoginUserID:
                                                              LoginUserID,
                                                          Notes: "",
                                                          Latitude: Latitude,
                                                          Longitude: Longitude,
                                                          LocationAddress:
                                                              Address,
                                                          CompanyId: CompanyID
                                                              .toString())));
                                            } else {
                                              showCommonDialogWithTwoOptions(
                                                  context,
                                                  "Are you sure you want to Save this PunchIn?",
                                                  negativeButtonTitle: "No",
                                                  positiveButtonTitle: "Yes",
                                                  onTapOfPositiveButton:
                                                      () async {
                                                Navigator.of(context).pop();

                                                final imagepicker =
                                                    ImagePicker();
                                                XFile file =
                                                    await imagepicker.pickImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 85,
                                                );
                                                if (file != null) {
                                                  CroppedFile croppedFile =
                                                      await ImageCropper()
                                                          .cropImage(
                                                    sourcePath: file.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .square,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio16x9
                                                    ],
                                                    uiSettings: [
                                                      AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Crop & Resize',
                                                          toolbarColor:
                                                              colorPrimary,
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                      IOSUiSettings(
                                                        title: 'Crop & Resize',
                                                      ),
                                                      WebUiSettings(
                                                        context: context,
                                                      ),
                                                    ],
                                                  );
                                                  File file1 =
                                                      File(croppedFile.path);
                                                  final dir = await path_provider
                                                      .getTemporaryDirectory();
                                                  final extension =
                                                      p.extension(file1.path);
                                                  int timestamp1 = DateTime
                                                          .now()
                                                      .millisecondsSinceEpoch;
                                                  String filenamepunchin =
                                                      _offlineLoggedInData
                                                              .details[0]
                                                              .employeeID
                                                              .toString() +
                                                          "_" +
                                                          DateTime.now()
                                                              .day
                                                              .toString() +
                                                          "_" +
                                                          DateTime.now()
                                                              .month
                                                              .toString() +
                                                          "_" +
                                                          DateTime.now()
                                                              .year
                                                              .toString() +
                                                          "_" +
                                                          timestamp1
                                                              .toString() +
                                                          extension;
                                                  final targetPath =
                                                      dir.absolute.path +
                                                          "/" +
                                                          filenamepunchin;
                                                  File file1231 =
                                                      await testCompressAndGetFile(
                                                          file1, targetPath);
                                                  final bytes = file1231
                                                      .readAsBytesSync()
                                                      .lengthInBytes;
                                                  final kb = bytes / 1024;
                                                  final mb = kb / 1024;
                                                  print("Image File Is Largre" +
                                                      " KB : " +
                                                      kb.toString() +
                                                      " MB : " +
                                                      mb.toString());
                                                  final snackBar = SnackBar(
                                                    content: Text(" KB : " +
                                                        kb.toStringAsFixed(2) +
                                                        " MB : " +
                                                        mb.toStringAsFixed(2) +
                                                        " Location : " +
                                                        " Lat : " +
                                                        SharedPrefHelper
                                                            .instance
                                                            .getLatitude() +
                                                        " Long : " +
                                                        SharedPrefHelper
                                                            .instance
                                                            .getLongitude() +
                                                        " Address : " +
                                                        Address),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  baseBloc.emit(
                                                      ShowProgressIndicatorState(
                                                          true));
                                                  var base64img = base64Encode(
                                                      File(file1231.path)
                                                          .readAsBytesSync());
                                                  _dashBoardScreenBloc
                                                      .add(MyGetPunchingEvent(
                                                          0,
                                                          MyGetPunchingRequest(
                                                            pkID: "0",
                                                            CompanyId: CompanyID
                                                                .toString(),
                                                            Mode: "punchIN",
                                                            EmployeeID:
                                                                _offlineLoggedInData
                                                                    .details[0]
                                                                    .employeeID
                                                                    .toString(),
                                                            ImageURL:
                                                                filenamepunchin,
                                                            PresenceDate: selectedDate
                                                                    .year
                                                                    .toString() +
                                                                "-" +
                                                                selectedDate
                                                                    .month
                                                                    .toString() +
                                                                "-" +
                                                                selectedDate.day
                                                                    .toString(),
                                                            Time: selectedTime
                                                                    .hour
                                                                    .toString() +
                                                                ":" +
                                                                selectedTime
                                                                    .minute
                                                                    .toString(),
                                                            Notes: "",
                                                            Latitude: Latitude,
                                                            Longitude:
                                                                Longitude,
                                                            LocationAddress:
                                                                Address,
                                                            LoginUserId:
                                                                LoginUserID,
                                                            base64txt:
                                                                base64img, //"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"
                                                            //base64:
                                                          )));
                                                  baseBloc.emit(
                                                      ShowProgressIndicatorState(
                                                          false));
                                                } else {
                                                  showCommonDialogWithSingleOption(
                                                      context,
                                                      "Something Went Wrong File Not Found Exception!",
                                                      positiveButtonTitle:
                                                          "OK");
                                                }
                                              });
                                            }
                                          }
                                        }
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    } else {
                                      {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "For getting address Kindly Tap On Get Live Location !",
                                            positiveButtonTitle: "OK");
                                      }
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(context,
                                        "Kindly Tap On Get Live Location !",
                                        positiveButtonTitle: "OK");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            isPunchIn == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isPunchIn == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          isPunchIn == true
                                              ? Text(
                                                  PuchInTime.text,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: colorPrimary),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Card(
                                        elevation: 5,
                                        color: PuchInTime.text == ""
                                            ? colorRED
                                            : colorPresentDay,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Punch In",
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        // <-- Change this
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay selectedTime = TimeOfDay.now();
                                  print("yryry123" + Address.toString());
                                  if (isTapLiveLocation == true) {
                                    if (Address != "" || Address != null) {
                                      if (isCurrentTime == true) {
                                        if (isPunchIn == true) {
                                          if (isPunchOut == false) {
                                            if (isLunchIn == true) {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  _offlineLoggedInData
                                                          .details[0]
                                                          .employeeName +
                                                      " \n Lunch In : " +
                                                      LunchInTime.text,
                                                  positiveButtonTitle: "OK");
                                            } else {
                                              if (ConstantMAster.toString() ==
                                                      "" ||
                                                  ConstantMAster.toString()
                                                          .toLowerCase() ==
                                                      "no") {
                                                _dashBoardScreenBloc.add(PunchWithoutImageAttendanceSaveRequestEvent(
                                                    PunchWithoutImageAttendanceSaveRequest(
                                                        Mode: "lunchin",
                                                        pkID: "0",
                                                        EmployeeID:
                                                            _offlineLoggedInData
                                                                .details[0]
                                                                .employeeID
                                                                .toString(),
                                                        PresenceDate: selectedDate
                                                                .year
                                                                .toString() +
                                                            "-" +
                                                            selectedDate.month
                                                                .toString() +
                                                            "-" +
                                                            selectedDate.day
                                                                .toString(),
                                                        TimeIn: "",
                                                        TimeOut: "",
                                                        LunchIn: selectedTime
                                                                .hour
                                                                .toString() +
                                                            ":" +
                                                            selectedTime.minute
                                                                .toString(),
                                                        LunchOut: "",
                                                        LoginUserID:
                                                            LoginUserID,
                                                        Notes: "",
                                                        Latitude: Latitude,
                                                        Longitude: Longitude,
                                                        LocationAddress:
                                                            Address,
                                                        CompanyId: CompanyID
                                                            .toString())));
                                              } else {
                                                if (permissionGranted ==
                                                    false) {
                                                  //await Permission.storage.request();

                                                  //checkPhotoPermissionStatus();

                                                  _getStoragePermission();
                                                } else {
                                                  showCommonDialogWithTwoOptions(
                                                      context,
                                                      "Are you sure you want to Save this LunchIn?",
                                                      negativeButtonTitle: "No",
                                                      positiveButtonTitle:
                                                          "Yes",
                                                      onTapOfPositiveButton:
                                                          () async {
                                                    Navigator.of(context).pop();

                                                    final imagepicker =
                                                        ImagePicker();

                                                    XFile file =
                                                        await imagepicker
                                                            .pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 85,
                                                    );

                                                    if (file != null) {
                                                      CroppedFile croppedFile =
                                                          await ImageCropper()
                                                              .cropImage(
                                                        sourcePath: file.path,
                                                        aspectRatioPresets: [
                                                          CropAspectRatioPreset
                                                              .square,
                                                          CropAspectRatioPreset
                                                              .ratio3x2,
                                                          CropAspectRatioPreset
                                                              .original,
                                                          CropAspectRatioPreset
                                                              .ratio4x3,
                                                          CropAspectRatioPreset
                                                              .ratio16x9
                                                        ],
                                                        uiSettings: [
                                                          AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Crop & Resize',
                                                              toolbarColor:
                                                                  colorPrimary,
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                              lockAspectRatio:
                                                                  false),
                                                          IOSUiSettings(
                                                            title:
                                                                'Crop & Resize',
                                                          ),
                                                          WebUiSettings(
                                                            context: context,
                                                          ),
                                                        ],
                                                      );

                                                      File file1 = File(
                                                          croppedFile.path);

                                                      final dir =
                                                          await path_provider
                                                              .getTemporaryDirectory();

                                                      final extension =
                                                          p.extension(
                                                              file1.path);

                                                      int timestamp1 = DateTime
                                                              .now()
                                                          .millisecondsSinceEpoch;

                                                      String filenameLunchIn =
                                                          _offlineLoggedInData
                                                                  .details[0]
                                                                  .employeeID
                                                                  .toString() +
                                                              "_" +
                                                              DateTime.now()
                                                                  .day
                                                                  .toString() +
                                                              "_" +
                                                              DateTime.now()
                                                                  .month
                                                                  .toString() +
                                                              "_" +
                                                              DateTime.now()
                                                                  .year
                                                                  .toString() +
                                                              "_" +
                                                              timestamp1
                                                                  .toString() +
                                                              extension;

                                                      final targetPath =
                                                          dir.absolute.path +
                                                              "/" +
                                                              filenameLunchIn;
                                                      File file1231 =
                                                          await testCompressAndGetFile(
                                                              file1,
                                                              targetPath);
                                                      final bytes = file1231
                                                          .readAsBytesSync()
                                                          .lengthInBytes;
                                                      final kb = bytes / 1024;
                                                      final mb = kb / 1024;

                                                      print(
                                                          "Image File Is Largre" +
                                                              " KB : " +
                                                              kb.toString() +
                                                              " MB : " +
                                                              mb.toString());
                                                      final snackBar = SnackBar(
                                                        content: Text(" KB : " +
                                                            kb.toStringAsFixed(
                                                                2) +
                                                            " MB : " +
                                                            mb.toStringAsFixed(
                                                                2) +
                                                            " Location : " +
                                                            " Lat : " +
                                                            SharedPrefHelper
                                                                .instance
                                                                .getLatitude() +
                                                            " Long : " +
                                                            SharedPrefHelper
                                                                .instance
                                                                .getLongitude() +
                                                            " Address : " +
                                                            Address),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);

                                                      baseBloc.emit(
                                                          ShowProgressIndicatorState(
                                                              true));
                                                      var base64img =
                                                          base64Encode(File(
                                                                  file1231.path)
                                                              .readAsBytesSync());
                                                      _dashBoardScreenBloc.add(
                                                          MyGetPunchingEvent(
                                                              0,
                                                              MyGetPunchingRequest(
                                                                pkID: "0",
                                                                CompanyId: CompanyID
                                                                    .toString(),
                                                                Mode: "lunchin",
                                                                EmployeeID: _offlineLoggedInData
                                                                    .details[0]
                                                                    .employeeID
                                                                    .toString(),
                                                                ImageURL:
                                                                    filenameLunchIn,
                                                                PresenceDate: selectedDate
                                                                        .year
                                                                        .toString() +
                                                                    "-" +
                                                                    selectedDate
                                                                        .month
                                                                        .toString() +
                                                                    "-" +
                                                                    selectedDate
                                                                        .day
                                                                        .toString(),
                                                                Time: selectedTime
                                                                        .hour
                                                                        .toString() +
                                                                    ":" +
                                                                    selectedTime
                                                                        .minute
                                                                        .toString(),
                                                                Notes: "",
                                                                Latitude:
                                                                    Latitude,
                                                                Longitude:
                                                                    Longitude,
                                                                LocationAddress:
                                                                    Address,
                                                                LoginUserId:
                                                                    LoginUserID,
                                                                base64txt:
                                                                    base64img,
                                                                //base64:
                                                              )));
                                                      baseBloc.emit(
                                                          ShowProgressIndicatorState(
                                                              false));
                                                    }
                                                  });
                                                }
                                              }
                                            }
                                          } else {
                                            if (isLunchIn == false) {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  "After Punch Out, You can't be able to do Lunch In!!",
                                                  positiveButtonTitle: "OK");
                                            }
                                          }
                                        } else {
                                          showCommonDialogWithSingleOption(
                                              context, "Punch in Is Required !",
                                              positiveButtonTitle: "OK");
                                        }
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    } else {
                                      {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "For getting address Kindly Tap On Get Live Location !",
                                            positiveButtonTitle: "OK");
                                      }
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(context,
                                        "Kindly Tap On Get Live Location !",
                                        positiveButtonTitle: "OK");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            isLunchIn == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isLunchIn == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          isLunchIn == true
                                              ? Text(
                                                  LunchInTime.text,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: colorPrimary),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Card(
                                        elevation: 5,
                                        color: LunchInTime.text == ""
                                            ? colorRED
                                            : colorPresentDay,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Lunch In",
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        // <-- Change this
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (isTapLiveLocation == true) {
                                    if (Address != "" || Address != null) {
                                      if (isCurrentTime == true) {
                                        lunchoutLogic();
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    } else {
                                      {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "For getting address Kindly Tap On Get Live Location !",
                                            positiveButtonTitle: "OK");
                                      }
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(context,
                                        "Kindly Tap On Get Live Location !",
                                        positiveButtonTitle: "OK");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            isLunchOut == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isLunchOut == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          isLunchOut == true
                                              ? Text(
                                                  LunchOutTime.text,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: colorPrimary),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Card(
                                        elevation: 5,
                                        color: LunchOutTime.text == ""
                                            ? colorRED
                                            : colorPresentDay,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Lunch Out",
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        // <-- Change this
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (isTapLiveLocation == true) {
                                    if (Address != "" || Address != null) {
                                      if (isCurrentTime == true) {
                                        punchoutLogic();
                                      } else {
                                        getcurrentTimeInfoFromMaindfd();
                                      }
                                    } else {
                                      {
                                        showCommonDialogWithSingleOption(
                                            context,
                                            "For getting address Kindly Tap On Get Live Location !",
                                            positiveButtonTitle: "OK");
                                      }
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(context,
                                        "Kindly Tap On Get Live Location !",
                                        positiveButtonTitle: "OK");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            isPunchOut == true
                                                ? Icons.watch_later
                                                : Icons.watch_later_outlined,
                                            color: isPunchOut == true
                                                ? colorPresentDay
                                                : colorRED,
                                            size: 42,
                                          ),
                                          isPunchOut == true
                                              ? Text(
                                                  PuchOutTime.text,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: colorPrimary),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Card(
                                        elevation: 5,
                                        color: PuchOutTime.text == ""
                                            ? colorRED
                                            : colorPresentDay,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Punch Out",
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        // <-- Change this
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*InkWell(
                          onTap: () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0))),
                                    title: Column(
                                      children: [
                                        Text(
                                          "Daily Report",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: colorPrimary),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                      ],
                                    ),
                                    content:  Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: DailyReport()),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(5),
                                          child: Column(
                                            children: [
                                              Divider(
                                                thickness: 2,
                                              ),
                                              getCommonButton(baseTheme, () {
                                                Navigator.pop(context);
                                              }, "Close", radius: 10),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });

                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Column(
                                  children: [
                                    Icon(
                                      Icons.mail
                                      ,
                                      color:  colorPrimary,
                                      size: 42,
                                    ),
                                    Text(
                                      "E-Mail",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: colorPrimary),
                                    )

                                  ],
                                ),
                                Card(
                                  elevation: 5,
                                  color: colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    height: 55,
                                    width: 100,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Daily Report",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  // <-- Change this
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),*/
                            ],
                          )
                        : Center(
                            child: Container(
                              child: Text(
                                  "Your Attendance Rights Are Disable.\nKindly Enable From Web Application",
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    //Navigator.pop(context);
  }

  void _OnAttendanceListResponse(AttendanceListCallResponseState state) {
    String PDate = "";
    String CDate = "";

    if (state.response.details.isNotEmpty) {
      for (int i = 0; i < state.response.details.length; i++) {
        /*PresenceDate*/
        if (state.response.details[i].presenceDate != "") {
          PDate = state.response.details[i].presenceDate.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
          print("APIDAte" + PDate);

          CDate = selectedDate.day.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.year.toString();
          print("CurrentDAte" + CDate);

          DateTime APIDate = new DateFormat("dd-MM-yyyy").parse(PDate);
          DateTime CurrentDate = new DateFormat("dd-MM-yyyy").parse(CDate);

          if (APIDate == CurrentDate) {
            print("ConditionTrue");

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

            if (state.response.details[i].LunchIn != "") {
              LunchInTime.text = state.response.details[i].LunchIn.toString();

              isLunchIn = true;
            } else {
              isLunchIn = false;
              LunchInTime.text = "";
            }
            if (state.response.details[i].LunchOut != "") {
              LunchOutTime.text = state.response.details[i].LunchOut.toString();

              isLunchOut = true;
            } else {
              isLunchOut = false;
              LunchOutTime.text = "";
            }

            break;
          } else {
            isPunchIn = false;
            isPunchOut = false;
            isLunchIn = false;
            isLunchOut = false;
            PuchInTime.text = ""; //state.response.details[i].timeIn.toString();
            PuchOutTime.text =
                ""; //state.response.details[i].timeOut.toString();
            LunchInTime.text = "";
            LunchOutTime.text = "";
            print("ConditionFalse");
            // isPunchIn = false;
          }
        }

        print("TodayAttendance" +
            "Emp_Name : " +
            state.response.details[i].employeeName +
            " InTime : " +
            state.response.details[i].timeIn.toString());
      }
    } else {
      isPunchIn = false;
      isPunchOut = false;
    }
  }

  void _onGetConstant(ConstantResponseState state) {
    print("ConstantValue" + state.response.details[0].value.toString());

    ConstantMAster = state.response.details[0].value.toString();
  }

  void getcurrentTimeInfoFromMaindfd() async {
    DateTime startDate = await NTP.now();
    print('NTP DateTime: ${startDate} ${DateTime.now()}');

    var now = startDate;
    var formatter = new DateFormat('yyyy-MM-ddTHH');
    String currentday = formatter.format(now);
    String PresentDate1 = formatter.format(DateTime.now());
    print(
        'NTP DateTime123456: ${DateTime.parse(currentday)} ${DateTime.parse(PresentDate1)}');

    if (DateTime.parse(currentday) != DateTime.parse(PresentDate1)) {
      //  navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
      isCurrentTime = false;

      return showCommonDialogWithSingleOption(context,
          "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, HomeScreen.routeName, clearAllStack: true);
      });
    } else {
      isCurrentTime = true;
    }
  }

  void checkCameraPermissionStatus() async {
    bool granted = await Permission.camera.isGranted;
    bool Denied = await Permission.camera.isDenied;
    bool PermanentlyDenied = await Permission.camera.isPermanentlyDenied;
    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());
    if (Denied == true) {
      await Permission.camera.request();
    }
    if (await Permission.camera.isRestricted) {
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      openAppSettings();
    }
    if (granted == true) {}
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print('testCompressAndGetFile');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );
    print(file.lengthSync());
    print(result?.lengthSync());
    return result;
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

    // For Android 12 and below (API < 33)
    if (android.version.sdkInt < 33) {
      permissionHandler.PermissionStatus status =
      await permissionHandler.Permission.storage.request();

      if (status.isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          'Storage Permission Required',
          'Storage permission is needed for temporary image processing. Please enable it in app settings.',
        );
      } else {
        setState(() {
          permissionGranted = false;
        });
      }
    } else {
      // For Android 13+ - NO STORAGE PERMISSIONS NEEDED!
      // Camera photos are saved to app-specific cache automatically
      setState(() {
        permissionGranted = true;
      });
    }
  }

// Helper method to show permission dialog
  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                permissionHandler.openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void getLocationLivePermission() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      checkPermissionStatus();
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      //permission = await Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        print("A12215534" +
            "Location permissions are  denied, we cannot request permissions.");

        permission = await geolocator.Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      print("A12215534" +
          "Location permissions are permanently denied, we cannot request permissions.");

      permission = await geolocator.Geolocator.requestPermission();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == geolocator.LocationPermission.whileInUse) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();

      Latitude = position.latitude.toString();
      Longitude = position.longitude.toString();

      print("CurrentLatLong" +
          Latitude.toString() +
          " , " +
          Longitude.toString());
      List<geo.Placemark> placemark = [];

      double lat = Latitude != "" ? double.parse(Latitude) : 0.00;
      double lang = Longitude != "" ? double.parse(Longitude) : 0.00;

      placemark = await geo.placemarkFromCoordinates(lat, lang);
      Address =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";

      /*  geolocator.Geolocator
          .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((geolocator.Position position) {
        setState(() {
          _currentPosition = position;


              getAddressFromLatLong();
        });
      }).catchError((e) {
        print(e);
      });*/

      /* location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        SharedPrefHelper.instance.setLatitude(currentLocation.latitude.toString());
        SharedPrefHelper.instance.setLongitude(currentLocation.longitude.toString());
      });*/
    }

    if (permission == geolocator.LocationPermission.always) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();

      Latitude = position.latitude.toString();
      Longitude = position.longitude.toString();

      print("CurrentLatLong" +
          Latitude.toString() +
          " , " +
          Longitude.toString());
      List<geo.Placemark> placemark = [];

      double lat = Latitude != "" ? double.parse(Latitude) : 0.00;
      double lang = Longitude != "" ? double.parse(Longitude) : 0.00;

      placemark = await geo.placemarkFromCoordinates(lat, lang);
      Address =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";

      /*geolocator.Geolocator
          .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((geolocator.Position position) {
        setState(() {
          _currentPosition = position;
          getAddressFromLatLong();
        });
      }).catchError((e) {
        print(e);
      });*/

      /* location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        SharedPrefHelper.instance.setLatitude(currentLocation.latitude.toString());
        SharedPrefHelper.instance.setLongitude(currentLocation.longitude.toString());
      });*/
    }
  }

  void getLocationLivePermission456() async {
    baseBloc.emit(ShowProgressIndicatorState(true));

    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      checkPermissionStatus();
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      //permission = await Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        print("A12215534" +
            "Location permissions are  denied, we cannot request permissions.");

        permission = await geolocator.Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      print("A12215534" +
          "Location permissions are permanently denied, we cannot request permissions.");

      permission = await geolocator.Geolocator.requestPermission();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == geolocator.LocationPermission.whileInUse) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();

      Latitude = position.latitude.toString();
      Longitude = position.longitude.toString();

      print("CurrentLatLong" +
          Latitude.toString() +
          " , " +
          Longitude.toString());
      List<geo.Placemark> placemark = [];

      double lat = Latitude != "" ? double.parse(Latitude) : 0.00;
      double lang = Longitude != "" ? double.parse(Longitude) : 0.00;

      placemark = await geo.placemarkFromCoordinates(lat, lang);
      Address =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";

      /*  geolocator.Geolocator
          .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((geolocator.Position position) {
        setState(() {
          _currentPosition = position;


              getAddressFromLatLong();
        });
      }).catchError((e) {
        print(e);
      });*/

      /* location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        SharedPrefHelper.instance.setLatitude(currentLocation.latitude.toString());
        SharedPrefHelper.instance.setLongitude(currentLocation.longitude.toString());
      });*/

      setState(() {});
    }

    if (permission == geolocator.LocationPermission.always) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();

      Latitude = position.latitude.toString();
      Longitude = position.longitude.toString();

      print("CurrentLatLong" +
          Latitude.toString() +
          " , " +
          Longitude.toString());
      List<geo.Placemark> placemark = [];

      double lat = Latitude != "" ? double.parse(Latitude) : 0.00;
      double lang = Longitude != "" ? double.parse(Longitude) : 0.00;

      placemark = await geo.placemarkFromCoordinates(lat, lang);
      Address =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";

      /*geolocator.Geolocator
          .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((geolocator.Position position) {
        setState(() {
          _currentPosition = position;
          getAddressFromLatLong();
        });
      }).catchError((e) {
        print(e);
      });*/

      /* location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        SharedPrefHelper.instance.setLatitude(currentLocation.latitude.toString());
        SharedPrefHelper.instance.setLongitude(currentLocation.longitude.toString());
      });*/
    }

    baseBloc.emit(ShowProgressIndicatorState(false));

    isTapLiveLocation = true;
  }

  void checkPermissionStatus() async {
    if (!await location.serviceEnabled()) {
      // location.requestService();

      if (Platform.isAndroid) {
        location.requestService();
        /*showCommonDialogWithSingleOption(Globals.context,
            "Can't get current location, Please make sure you enable GPS and try again !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          AppSettings.openLocationSettings();
          Navigator.pop(context);
        });*/
      }
    }
    bool granted = await Permission.location.isGranted;
    bool Denied = await Permission.location.isDenied;
    bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;

    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());

    if (Denied == true) {
      // openAppSettings();
      is_LocationService_Permission = false;
      await Permission.location.request();
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.
      is_LocationService_Permission = true;
      await Permission.location.request();
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /*punchoutLogic() async {
    if (isPunchIn == true) {
      TimeOfDay selectedTime = TimeOfDay.now();

      //EmailTO.text = model.emailAddress;

      */ /*PunchAttendanceSaveRequest(
        Mode: "punchout",
        pkID: "0",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        PresenceDate: selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString(),
        TimeIn:
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        TimeOut:
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        LunchIn: "",
        LunchOut: "",
        LoginUserID: LoginUserID,
        Notes: "",
        Latitude: Latitude,
        Longitude: Longitude,
        LocationAddress: Address,
        CompanyId: CompanyID.toString(),
      );*/ /*
      PunchAttendanceSaveRequest punchAttendanceSaveRequest =
      PunchAttendanceSaveRequest(
        pkID: "0",
        CompanyId: CompanyID.toString(),
        Mode: "punchout",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        FileName: "demo.png",
        PresenceDate: selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString(),
        Time:
        selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        Notes: "",
        Latitude: Latitude,
        Longitude: Longitude,
        LocationAddress: Address,
        LoginUserId: LoginUserID,
      );

      if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
          "SW0T-GLA5-IND7-AS71") {
        ///MustCheck
        ///showcustomdialogSendEmail(context1: context, att: punchAttendanceSaveRequest);
      }

      if (isPunchOut == true) {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "SW0T-GLA5-IND7-AS71") {
          ///MustCheck
          ///showcustomdialogSendEmail(context1: context, att: punchAttendanceSaveRequest);
        } else {
          showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Punch Out : " +
                  PuchOutTime.text,
              positiveButtonTitle: "OK");
        }
      } else {
        if (permissionGranted==false) {
          //await Permission.storage.request();

          _getStoragePermission();
        } else {
          if (ConstantMAster.toString() == "" ||
              ConstantMAster.toString().toLowerCase() == "no") {
            _dashBoardScreenBloc.add(
                PunchWithoutImageAttendanceSaveRequestEvent(
                    PunchWithoutImageAttendanceSaveRequest(
                        Mode: "punchout",
                        pkID: "0",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        PresenceDate: selectedDate.year.toString() +
                            "-" +
                            selectedDate.month.toString() +
                            "-" +
                            selectedDate.day.toString(),
                        TimeIn: "",
                        TimeOut: selectedTime.hour.toString() +
                            ":" +
                            selectedTime.minute.toString(),
                        LunchIn: "",
                        LunchOut: "",
                        LoginUserID: LoginUserID,
                        Notes: "",
                        Latitude: Latitude,
                        Longitude: Longitude,
                        LocationAddress: Address,
                        CompanyId: CompanyID.toString())));
          } else {
            final imagepicker = ImagePicker();

            XFile file = await imagepicker.pickImage(
                source: ImageSource.camera, imageQuality: 85);

            File filerty = File(file.path);

            final extension = p.extension(filerty.path);

            int timestamp1 = DateTime.now().millisecondsSinceEpoch;

            */ /*String filenamepunchout =
                _offlineLoggedInData.details[0].employeeID.toString() +
                    "_" +
                    DateTime.now().day.toString() +
                    "_" +
                    DateTime.now().month.toString() +
                    "_" +
                    DateTime.now().year.toString() +
                    "_" +
                    timestamp1.toString() +
                    extension;
            */ /*

            if (file != null) {
              File file1 = File(file.path);

              final dir = await path_provider.getTemporaryDirectory();

              final extension = p.extension(file1.path);

              int timestamp1 = DateTime.now().millisecondsSinceEpoch;

              String filenamepunchout =
                  _offlineLoggedInData.details[0].employeeID.toString() +
                      "_" +
                      DateTime.now().day.toString() +
                      "_" +
                      DateTime.now().month.toString() +
                      "_" +
                      DateTime.now().year.toString() +
                      "_" +
                      timestamp1.toString() +
                      extension;

              final targetPath = dir.absolute.path + "/" + filenamepunchout;
              File file1231 = await testCompressAndGetFile(file1, targetPath);
              final bytes = file1231.readAsBytesSync().lengthInBytes;
              final kb = bytes / 1024;
              final mb = kb / 1024;

              print("Image File Is Largre" +
                  " KB : " +
                  kb.toString() +
                  " MB : " +
                  mb.toString() +
                  " Location : " +
                  " Lat : " +
                  SharedPrefHelper.instance.getLatitude() +
                  " Long : " +
                  SharedPrefHelper.instance.getLongitude() +
                  " Address : " +
                  Address);
              final snackBar = SnackBar(
                content: Text(" KB : " +
                    kb.toStringAsFixed(2) +
                    " MB : " +
                    mb.toStringAsFixed(2) +
                    " Location : " +
                    " Lat : " +
                    Latitude +
                    " Long : " +
                    Longitude +
                    " Address : " +
                    Address),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              _dashBoardScreenBloc.add(PunchAttendanceSaveRequestEvent(
                  file1231,
                  PunchAttendanceSaveRequest(
                    pkID: "0",
                    CompanyId: CompanyID.toString(),
                    Mode: "punchout",
                    EmployeeID:
                    _offlineLoggedInData.details[0].employeeID.toString(),
                    FileName: filenamepunchout,
                    PresenceDate: selectedDate.year.toString() +
                        "-" +
                        selectedDate.month.toString() +
                        "-" +
                        selectedDate.day.toString(),
                    Time: selectedTime.hour.toString() +
                        ":" +
                        selectedTime.minute.toString(),
                    Notes: "",
                    Latitude: Latitude,
                    Longitude: Longitude,
                    LocationAddress: Address,
                    LoginUserId: LoginUserID,
                  )));
            } */ /*else {
              showCommonDialogWithSingleOption(
                  context, "Something Went Wrong File Not Found Exception !",
                  positiveButtonTitle: "OK");
            }*/ /*
          }
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Punch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }*/

  punchoutLogic() async {
    if (isPunchIn == true) {
      TimeOfDay selectedTime = TimeOfDay.now();

      if (isPunchOut == true) {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "SW0T-GLA5-IND7-AS71") {
          ///MustCheck
          ///showcustomdialogSendEmail(context1: context, att: punchAttendanceSaveRequest);
        } else {
          showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Punch Out : " +
                  PuchOutTime.text,
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
                  PresenceDate: selectedDate.year.toString() +
                      "-" +
                      selectedDate.month.toString() +
                      "-" +
                      selectedDate.day.toString(),
                  TimeIn: "",
                  TimeOut: selectedTime.hour.toString() +
                      ":" +
                      selectedTime.minute.toString(),
                  LunchIn: "",
                  LunchOut: "",
                  LoginUserID: LoginUserID,
                  Notes: "",
                  Latitude: Latitude,
                  Longitude: Longitude,
                  LocationAddress: Address,
                  CompanyId: CompanyID.toString())));
        } else {
          if (permissionGranted == false) {
            //await Permission.storage.request();

            //checkPhotoPermissionStatus();

            _getStoragePermission();
          } else {
            showCommonDialogWithTwoOptions(
                context, "Are you sure you want to Save this PunchOut?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
              Navigator.of(context).pop();
              final imagepicker = ImagePicker();

              XFile file = await imagepicker.pickImage(
                  source: ImageSource.camera, imageQuality: 85);
              if (file != null) {
                CroppedFile croppedFile = await ImageCropper().cropImage(
                  sourcePath: file.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Crop & Resize',
                        toolbarColor: colorPrimary,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Crop & Resize',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );

                File file1 = File(croppedFile.path);

                final dir = await path_provider.getTemporaryDirectory();

                final extension = p.extension(file1.path);

                int timestamp1 = DateTime.now().millisecondsSinceEpoch;

                String filenamepunchout =
                    _offlineLoggedInData.details[0].employeeID.toString() +
                        "_" +
                        DateTime.now().day.toString() +
                        "_" +
                        DateTime.now().month.toString() +
                        "_" +
                        DateTime.now().year.toString() +
                        "_" +
                        timestamp1.toString() +
                        extension;

                final targetPath = dir.absolute.path + "/" + filenamepunchout;
                File file1231 = await testCompressAndGetFile(file1, targetPath);
                final bytes = file1231.readAsBytesSync().lengthInBytes;
                final kb = bytes / 1024;
                final mb = kb / 1024;

                print("Image File Is Largre" +
                    " KB : " +
                    kb.toString() +
                    " MB : " +
                    mb.toString() +
                    " Location : " +
                    " Lat : " +
                    SharedPrefHelper.instance.getLatitude() +
                    " Long : " +
                    SharedPrefHelper.instance.getLongitude() +
                    " Address : " +
                    Address);
                final snackBar = SnackBar(
                  content: Text(" KB : " +
                      kb.toStringAsFixed(2) +
                      " MB : " +
                      mb.toStringAsFixed(2) +
                      " Location : " +
                      " Lat : " +
                      SharedPrefHelper.instance.getLatitude() +
                      " Long : " +
                      SharedPrefHelper.instance.getLongitude() +
                      " Address : " +
                      Address),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                baseBloc.emit(ShowProgressIndicatorState(true));
                var base64img =
                    base64Encode(File(file1231.path).readAsBytesSync());
                _dashBoardScreenBloc.add(MyGetPunchingEvent(
                    0,
                    MyGetPunchingRequest(
                      pkID: "0",
                      CompanyId: CompanyID.toString(),
                      Mode: "punchout",
                      EmployeeID:
                          _offlineLoggedInData.details[0].employeeID.toString(),
                      ImageURL: filenamepunchout,
                      PresenceDate: selectedDate.year.toString() +
                          "-" +
                          selectedDate.month.toString() +
                          "-" +
                          selectedDate.day.toString(),
                      Time: selectedTime.hour.toString() +
                          ":" +
                          selectedTime.minute.toString(),
                      Notes: "",
                      Latitude: Latitude,
                      Longitude: Longitude,
                      LocationAddress: Address,
                      LoginUserId: LoginUserID,
                      base64txt:
                          base64img, //"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"
                      //base64:
                    )));
                baseBloc.emit(ShowProgressIndicatorState(false));
              }
            });
          }
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Punch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }

  lunchoutLogic() async {
    if (isLunchIn == true) {
      //EmailTO.text = model.emailAddress;
      TimeOfDay selectedTime = TimeOfDay.now();

      if (isPunchOut == false) {
        PunchAttendanceSaveRequest punchAttendanceSaveRequest =
            PunchAttendanceSaveRequest(
          pkID: "0",
          CompanyId: CompanyID.toString(),
          Mode: "lunchout",
          EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
          FileName: "demo.png",
          PresenceDate: selectedDate.year.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.day.toString(),
          Time: selectedTime.hour.toString() +
              ":" +
              selectedTime.minute.toString(),
          Notes: "",
          Latitude: Latitude,
          Longitude: Longitude,
          LocationAddress: Address,
          LoginUserId: LoginUserID,
        );

        if (isLunchOut == true) {
          showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Lunch Out : " +
                  LunchOutTime.text,
              positiveButtonTitle: "OK");
        } else {
          if (ConstantMAster.toString() == "" ||
              ConstantMAster.toString().toLowerCase() == "no") {
            _dashBoardScreenBloc.add(
                PunchWithoutImageAttendanceSaveRequestEvent(
                    PunchWithoutImageAttendanceSaveRequest(
                        Mode: "lunchout",
                        pkID: "0",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        PresenceDate: selectedDate.year.toString() +
                            "-" +
                            selectedDate.month.toString() +
                            "-" +
                            selectedDate.day.toString(),
                        TimeIn: "",
                        TimeOut: "",
                        LunchIn: "",
                        LunchOut: selectedTime.hour.toString() +
                            ":" +
                            selectedTime.minute.toString(),
                        LoginUserID: LoginUserID,
                        Notes: "",
                        Latitude: Latitude,
                        Longitude: Longitude,
                        LocationAddress: Address,
                        CompanyId: CompanyID.toString())));
          } else {
            if (permissionGranted == false) {
              //await Permission.storage.request();

              //checkPhotoPermissionStatus();

              _getStoragePermission();
            } else {
              showCommonDialogWithTwoOptions(
                  context, "Are you sure you want to Save this LunchOut?",
                  negativeButtonTitle: "No",
                  positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
                Navigator.of(context).pop();

                final imagepicker = ImagePicker();

                XFile file = await imagepicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                );

                if (file != null) {
                  CroppedFile croppedFile = await ImageCropper().cropImage(
                    sourcePath: file.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Crop & Resize',
                          toolbarColor: colorPrimary,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Crop & Resize',
                      ),
                      WebUiSettings(
                        context: context,
                      ),
                    ],
                  );

                  File file1 = File(croppedFile.path);

                  final dir = await path_provider.getTemporaryDirectory();

                  final extension = p.extension(file1.path);

                  int timestamp1 = DateTime.now().millisecondsSinceEpoch;

                  String filenameLunchOut =
                      _offlineLoggedInData.details[0].employeeID.toString() +
                          "_" +
                          DateTime.now().day.toString() +
                          "_" +
                          DateTime.now().month.toString() +
                          "_" +
                          DateTime.now().year.toString() +
                          "_" +
                          timestamp1.toString() +
                          extension;

                  final targetPath = dir.absolute.path + "/" + filenameLunchOut;
                  File file1231 =
                      await testCompressAndGetFile(file1, targetPath);
                  final bytes = file1231.readAsBytesSync().lengthInBytes;
                  final kb = bytes / 1024;
                  final mb = kb / 1024;

                  print("Image File Is Largre" +
                      " KB : " +
                      kb.toString() +
                      " MB : " +
                      mb.toString());
                  final snackBar = SnackBar(
                    content: Text(
                        " KB : " + kb.toString() + " MB : " + mb.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  baseBloc.emit(ShowProgressIndicatorState(true));
                  var base64img =
                      base64Encode(File(file1231.path).readAsBytesSync());
                  _dashBoardScreenBloc.add(MyGetPunchingEvent(
                      0,
                      MyGetPunchingRequest(
                        pkID: "0",
                        CompanyId: CompanyID.toString(),
                        Mode: "lunchout",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        ImageURL: filenameLunchOut,
                        PresenceDate: selectedDate.year.toString() +
                            "-" +
                            selectedDate.month.toString() +
                            "-" +
                            selectedDate.day.toString(),
                        Time: selectedTime.hour.toString() +
                            ":" +
                            selectedTime.minute.toString(),
                        Notes: "",
                        Latitude: Latitude,
                        Longitude: Longitude,
                        LocationAddress: Address,
                        LoginUserId: LoginUserID,
                        base64txt:
                            base64img, //"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"
                        //base64:
                      )));
                  baseBloc.emit(ShowProgressIndicatorState(false));
                }
              });
            }
          }
        }
      } else {
        if (isLunchOut == false) {
          showCommonDialogWithSingleOption(
              context, "After Punch Out, You can't be able to do Lunch Out!!",
              positiveButtonTitle: "OK");
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Lunch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }

  void _OnMyGetPunchingState(MyGetPunchingState state) {
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }
}
