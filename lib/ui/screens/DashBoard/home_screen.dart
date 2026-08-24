import 'dart:convert';
import 'dart:async';
import 'dart:io' show Directory, File, Platform;
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shine/flutter_shine.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_request/Logout_Count/logout_count_request.dart';
import 'package:soleoserp/TestingLocation/location_service/logic/location_controller/location_controller_cubit.dart';
import 'package:soleoserp/TestingLocation/tools/background_service.dart';
import 'package:soleoserp/blocs/other/bloc_modules/dashboard/dashboard_user_rights_screen_bloc.dart';
import 'package:soleoserp/main.dart';
import 'package:soleoserp/models/api_requests/api_token/api_token_update_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/company_details/company_details_request.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/dasboard_count_request.dart';
import 'package:soleoserp/models/api_requests/other/follower_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/menu_rights_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/other/dashboard_count_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/push_notification_service.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Expense_Tracking_nikhil/expense_tracking_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_list/external_lead_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request/leave_request_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/location_screen/locationtracking%20_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/near_by_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/punch_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/punch_screen_for_binekar.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/sales_order_dashBoard.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/ui/screens/authentication/serial_key_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/image_full_screen.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends BaseStatefulWidget {
  static const routeName = '/homeScreen';
//From Office

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Widget _buildTopActionIcons({
  @required BuildContext context,
  @required LoginUserDetialsResponse offlineLoggedInData,
  @required CompanyDetailsResponse offlineCompanyData,
  @required FutureOr<void> Function() getLocationLivePermission,
  @required VoidCallback showDashBoardCountDateFilterSheet,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.grey.shade50,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        )
      ],
    ),
    child: Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _TopActionIconButton(
                icon: Icons.watch_later,
                onTap: () async {
                  await Future.sync(() => getLocationLivePermission());

                  if (offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "BINE-KARS-EDJT-CVPL") {
                    navigateTo(context, PunchScreenForBinekar.routeName,
                        clearAllStack: true);
                  } else {
                    navigateTo(context, PunchScreen.routeName,
                        clearAllStack: true);
                  }
                },
              ),
              offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                          "SI08-SB94-MY45-RY15" ||
                      offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                          "TEST-0000-SI0F-0208"
                  ? _TopActionIconButton(
                      icon: Icons.person_search,
                      onTap: () async {
                        navigateTo(
                          context,
                          NearByPinCodeScreen.routeName,
                          clearAllStack: true,
                        );
                      },
                    )
                  : const SizedBox(),
              offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "B6X2-RIGO-URQ3-C7H5"
                  ? Row(
                      children: [
                        _TopActionIconButton(
                          icon: Icons.person_search,
                          onTap: () async {
                            navigateTo(
                              context,
                              NearByPinCodeScreen.routeName,
                              clearAllStack: true,
                            );
                          },
                        ),
                        offlineLoggedInData.details[0].roleCode == 'admin'
                            ? _TopActionIconButton(
                                icon: Icons.receipt_long,
                                onTap: () async {
                                  navigateTo(
                                    context,
                                    SalesOrderDashboardScreen.routeName,
                                    clearAllStack: true,
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),
              offlineCompanyData.details[0].LiveLocationFlag == true
                  ? Row(
                      children: [
                        /* _TopActionIconButton(
                          icon: Icons.analytics,
                          onTap: () {
                            showDashBoardCountDateFilterSheet();
                          },
                        ),*/
                        _TopActionIconButton(
                          icon: Icons.add_location,
                          onTap: () async {
                            navigateTo(
                                context, LocationListMainScreen.routeName,
                                clearAllStack: true);
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    ),
  );
}

class _HomeScreenState extends BaseState<HomeScreen>
    with SingleTickerProviderStateMixin, BasicScreen {
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  ALL_EmployeeList_Response _offlineALLEmployeeListData;
  DashBoardScreenBloc _dashBoardScreenBloc;
  bool isCustomerExist = false;
  bool isInquiryExist = false;
  bool isFollowupExist = false;
  bool isExpenseExist = false;
  bool IsExistInIOS = false;
  bool isLoading = true;
  bool islodding = true;
  bool onWebLoadingStop = false;
  bool isCurrentTime = true;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_HR = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Lead = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Office = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Support = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Purchase = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Production = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Account = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Dealer = [];
  List<ALL_Name_ID> arr_UserRightsWithMenuName = [];
  List<String> SplitSTr = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_DashBoard_Widgets = [];

  final TextEditingController ImgFromTextFiled = TextEditingController();
  final urlController = TextEditingController();

  String SiteURL = "";
  String Password = "";
  String LoginUserID = "";
  String IOSAPPStatus = "";
  String AndroidAppStatus = "";
  String url = "";
  String EmployeeImage = "https://img.icons8.com/color/2x/no-image.png";
  int CompanyID = 0;
  int prgresss = 0;
  double progress = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var delay = const Duration(seconds: 3);
  FirebaseMessaging _messaging;
  PushNotificationService pushNotificationService = PushNotificationService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  File Lunch_In_OUT_File;
  String ConstantMAster = "";
  bool isDashBoardWidget = false;
  bool islead = false;
  bool isSale = false;
  bool isAccount = false;
  bool isProduction = false;
  bool isHR = false;
  bool isPurchase = false;
  bool isOffice = false;
  bool isSupport = false;
  final double runSpacing = 4;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  BackgroundService backgroundService;
  LocationControllerCubit globalLocationCubit = LocationControllerCubit();

  @pragma('vm:entry-point')
  @override
  Future<void> didChangeDependencies() async {
    if (await backgroundService.instance.isRunning()) {
      await backgroundService.initializeService();
    }

    backgroundService.instance.on('on_location_changed').listen((event) async {
      if (event != null) {
        final position = Position(
          longitude: double.tryParse(event['longitude'].toString()) ?? 0.0,
          latitude: double.tryParse(event['latitude'].toString()) ?? 0.0,
        );

        // Accessing the globally available LocationControllerCubit instance
        await globalLocationCubit.onLocationChanged(location: position);
      }
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _dashBoardScreenBloc = DashBoardScreenBloc(baseBloc);
    imageCache.clear();
    initPlatformState();
    checkPermissionStatus();
    getLocationLivePermission();
    checkPhotoPermissionStatus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    screenStatusBarColor = colorWhite;
    checkIntialMessage();
    pushNotificationService.setupInteractedMessage();
    pushNotificationService.getToken();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _dashBoardScreenBloc.add(CompanyDetailsCallEvent(CompanyDetailsApiRequest(
        serialKey: _offlineLoggedInData.details[0].serialKey.toString())));
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    backgroundService = BackgroundService();
    AndroidAppStatus = _offlineCompanyData.details[0].AndroidApp;
    IOSAPPStatus = _offlineCompanyData.details[0].IOSApp;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password = _offlineLoggedInData.details[0].userPassword;
    ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";
    FirebaseMessaging.instance.getToken().then((token) async {
      final tokenStr = token.toString();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("TokenSP", tokenStr);
      _dashBoardScreenBloc.add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
          CompanyId: CompanyID.toString(),
          UserID: LoginUserID,
          TokenNo: tokenStr)));
    });

    _dashBoardScreenBloc.add(FollowerEmployeeListCallEvent(
        FollowerEmployeeListRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    _dashBoardScreenBloc.add(ALLEmployeeNameCallEvent(
        ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));

    getLeadListFromDashBoard(arr_ALL_Name_ID_For_Lead);
    getDashBoardWidget(arr_ALL_Name_ID_For_DashBoard_Widgets);
    getSaleListFromDashBoard(arr_ALL_Name_ID_For_Sales);
    getAccountListFromDashBoard(arr_ALL_Name_ID_For_Account);
    getHRListFromDashBoard(arr_ALL_Name_ID_For_HR);
    getOfficeListFromDashBoard(arr_ALL_Name_ID_For_Office);
    getSupportListFromDashBoard(arr_ALL_Name_ID_For_Support);
    getPurchaseListFromDashBoard(arr_ALL_Name_ID_For_Purchase);
    getProductionListFromDashBoard(arr_ALL_Name_ID_For_Production);
    getDealerListFromDashBoard(arr_ALL_Name_ID_For_Dealer);

    _dashBoardScreenBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "AttendenceWithImage",
            CompanyId: CompanyID.toString())));

    if (_offlineLoggedInData.details[0].EmployeeImage != "" ||
        _offlineLoggedInData.details[0].EmployeeImage != null) {
      setState(() {
        ImgFromTextFiled.text =
            _offlineLoggedInData.details[0].EmployeeImage == null ||
                    _offlineLoggedInData.details[0].EmployeeImage == ""
                ? ""
                : _offlineCompanyData.details[0].siteURL +
                    _offlineLoggedInData.details[0].EmployeeImage.toString();
      });
    } else {
      ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";
    }

    getDetailsOfImage(
        "https://img.icons8.com/color/2x/no-image.png", "demo.png");
  }

  @override
  void dispose() {
    super.dispose();
    SplitSTr = [];
    ImgFromTextFiled.dispose();
  }

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) => _dashBoardScreenBloc
        ..add(MenuRightsCallEvent(MenuRightsRequest(
            CompanyID: CompanyID.toString(), LoginUserID: LoginUserID))),
      child: BlocConsumer<DashBoardScreenBloc, DashBoardScreenStates>(
        builder: (BuildContext context, DashBoardScreenStates state) {
          //handle states

          if (state is ComapnyDetailsEventResponseState) {
            _OnCompanyResponse(state);
          }

          if (state is APITokenUpdateState) {
            _OnTokenUpdateResponse(state);
          }
          if (state is MenuRightsEventResponseState) {
            _onDashBoardCallSuccess(state, context);
          }

          if (state is FollowerEmployeeListByStatusCallResponseState) {
            _onFollowerEmployeeListByStatusCallSuccess(state);
          }

          if (state is ALL_EmployeeNameListResponseState) {
            _onALLEmployeeListByStatusCallSuccess(state);
          }

          if (state is EmployeeListResponseState) {
            _OnFethEmployeeImage(state);
          }

          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          if (currentState is APITokenUpdateState ||
              currentState is MenuRightsEventResponseState ||
              currentState is FollowerEmployeeListByStatusCallResponseState ||
              currentState is ALL_EmployeeNameListResponseState ||
              currentState is EmployeeListResponseState ||
              currentState is ConstantResponseState ||
              currentState is ComapnyDetailsEventResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DashBoardScreenStates state) {
          if (state is DashBoardCountResponseState) {
            _onDashBoardCountResponseState(state, context);
          }

          if (state is PunchOutWebMethodState) {
            _OnwebSucessResponse(state);
          }

          if (state is PunchWithoutAttendenceSaveResponseState) {
            _OnPunchOutWithoutImageSucess(state);
          }

          if (state is LogOutCountResponseState) {
            _OnLogoutCount(state);
          }
          //handle states
        },
        listenWhen: (oldState, currentState) {
          if (currentState is PunchOutWebMethodState ||
              currentState is PunchWithoutAttendenceSaveResponseState ||
              currentState is LogOutCountResponseState ||
              currentState is DashBoardCountResponseState) {
            return true;
          }
          //return true for state for which listener method should be called
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context123) {
    //getcurrentTimeInfoFromMain(context123);

    final w = (MediaQuery.of(context).size.width - runSpacing * (4 - 1)) / 4;

    print("FromScreen" + ConstantMAster.toString());
    if (Platform.isAndroid) {
      // Android-specific code

      // IsExistInIOS = true;
      if (AndroidAppStatus == "Active") {
        IsExistInIOS = true;
      } else {
        IsExistInIOS = false;
      }
      print("ISIOS" + "Android-specific code");
    } else if (Platform.isIOS) {
      // iOS-specific code

      if (IOSAPPStatus == "Active") {
        IsExistInIOS = true;
      } else {
        IsExistInIOS = false;
      }
      print("ISIOS" + "iOS-specific code");
    }

    return IsExistInIOS == true
        ? Scaffold(
            backgroundColor: colorGray,
            appBar: AppBar(
              leading: Builder(
                builder: (context) => Container(
                  margin: EdgeInsets.only(top: 14, left: 10),
                  child: IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              title: Container(
                margin: EdgeInsets.only(top: 20),
                child: FlutterShine(
                  light: Light(intensity: 1, position: Point(5, 5)),
                  builder: (BuildContext context, ShineShadow shineShadow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "DashBoard",
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              backgroundColor: colorVeryLightGray,
              foregroundColor: colorPrimary,
              elevation: 0,
              primary: false,
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    UserProfileDialog(context1: context123);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 10),
                    child: Icon(
                      Icons.person_pin_rounded,
                      size: 30,
                      color: colorPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SharedPrefHelper.instance.prefs.setString("Is_Dealer", "");
                    _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                            "BLG3-AF78-TO5F-NW16"
                        ? _onTaptoLogOutBluetone()
                        : _onTapOfLogOut();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Icon(
                      Icons.login,
                      size: 30,
                      color: colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _dashBoardScreenBloc.add(CompanyDetailsCallEvent(
                    CompanyDetailsApiRequest(
                        serialKey: _offlineLoggedInData.details[0].serialKey
                            .toString())));

                getLocationLivePermission();

                checkPermissionStatus();

                checkPhotoPermissionStatus();

                _dashBoardScreenBloc.add(AttendanceCallEvent(
                    AttendanceApiRequest(
                        pkID: "",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        Month: selectedDate.month.toString(),
                        Year: selectedDate.year.toString(),
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
                _dashBoardScreenBloc.add(ConstantRequestEvent(
                    CompanyID.toString(),
                    ConstantRequest(
                        ConstantHead: "AttendenceWithImage",
                        CompanyId: CompanyID.toString())));
                _dashBoardScreenBloc.add(MenuRightsCallEvent(MenuRightsRequest(
                    CompanyID: CompanyID.toString(),
                    LoginUserID: LoginUserID)));

                _dashBoardScreenBloc.add(FollowerEmployeeListCallEvent(
                    FollowerEmployeeListRequest(
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
                _dashBoardScreenBloc.add(ALLEmployeeNameCallEvent(
                    ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
              },
              child: Container(
                color: colorWhite,
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                ),
                child: ListView(
                  children: [
                    _buildTopActionIcons(
                      context: context,
                      offlineLoggedInData: _offlineLoggedInData,
                      offlineCompanyData: _offlineCompanyData,
                      getLocationLivePermission: getLocationLivePermission,
                      showDashBoardCountDateFilterSheet:
                          _showDashBoardCountDateFilterSheet,
                    ),
                    const SizedBox(height: 10),

                    ///___________________DashBoard______________________________

                    arr_ALL_Name_ID_For_DashBoard_Widgets.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isDashBoardWidget = !isDashBoardWidget;
                                isSale = false;
                                islead = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_WIDGETSS,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "DashBoard Widgets",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isDashBoardWidget == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_DashBoard_Widgets.length != 0
                        ? Visibility(
                            visible: isDashBoardWidget,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_DashBoard_Widgets
                                          .length, (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_DashBoard_Widgets[
                                                    index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_DashBoard_Widgets[
                                                    index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///___________________Leads____________________________
                    arr_ALL_Name_ID_For_Lead.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                islead = !islead;

                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_LEAD,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Leads",
                                                style: TextStyle(
                                                    color: colorWhite,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          islead == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Lead.length != 0
                        ? Visibility(
                            visible: islead,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Lead.length, (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Lead[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Lead[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///___________________Sales______________________________

                    arr_ALL_Name_ID_For_Sales.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isSale = !isSale;
                                islead = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_SALES,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Sales",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isSale == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Sales.length != 0
                        ? Visibility(
                            visible: isSale,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Sales.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Sales[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Sales[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///____________________Production_______________________

                    arr_ALL_Name_ID_For_Production.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isProduction = !isProduction;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_PRODUCTION,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Text(
                                          "Production",
                                          style: TextStyle(
                                              color: colorWhite,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          isProduction == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Production.length != 0
                        ? Visibility(
                            visible: isProduction,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Production.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Production[
                                                    index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Production[
                                                    index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///____________________Account_________________________

                    arr_ALL_Name_ID_For_Account.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isAccount = !isAccount;
                                islead = false;
                                isSale = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_ACCOUNT,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Account",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isAccount == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Account.length != 0
                        ? Visibility(
                            visible: isAccount,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Account.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Account[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Account[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    ///___________________HR_______________________________

                    arr_ALL_Name_ID_For_HR.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isHR = !isHR;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isPurchase = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_HR,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "HR",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isHR == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_HR.length != 0
                        ? Visibility(
                            visible: isHR,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_HR.length, (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_HR[index].Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_HR[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///__________________Purchase__________________________

                    arr_ALL_Name_ID_For_Purchase.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isPurchase = !isPurchase;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isOffice = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_PURCHASE,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Purchase",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isPurchase == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    arr_ALL_Name_ID_For_Purchase.length != 0
                        ? Visibility(
                            visible: isPurchase,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Purchase.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Purchase[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Purchase[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///___________________Office____________________________

                    arr_ALL_Name_ID_For_Office.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isOffice = !isOffice;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isSupport = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_OFFICE,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Office",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isOffice == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Office.length != 0
                        ? Visibility(
                            visible: isOffice,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Office.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Office[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Office[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///___________________Support____________________________

                    arr_ALL_Name_ID_For_Support.length != 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isSupport = !isSupport;
                                islead = false;
                                isSale = false;
                                isAccount = false;
                                isProduction = false;
                                isHR = false;
                                isPurchase = false;
                                isOffice = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue,
                                        Colors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          DASHBOARD_SUPPORT,
                                          width: 42,
                                          height: 42,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Support",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          isSupport == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          color: colorWhite,
                                          size: 38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Support.length != 0
                        ? Visibility(
                            visible: isSupport,
                            child: Card(
                              elevation: 5,
                              color: colorGreenVeryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10, bottom: 5),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                      arr_ALL_Name_ID_For_Support.length,
                                      (index) {
                                    return Container(
                                      width: w,
                                      height: w,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              colorWhite, //colorCombination(title),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Support[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Support[index]
                                                .Name1),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ))
                        : Container(),

                    ///___________________Dealer___________________________

                    arr_ALL_Name_ID_For_Dealer.length != 0
                        ? SizedBox(
                            height: 20,
                          )
                        : Container(),
                    arr_ALL_Name_ID_For_Dealer.length != 0
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 5.0, left: 10, right: 10, bottom: 5),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: (100 / 100),
                              ),
                              itemCount: arr_ALL_Name_ID_For_Dealer.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: makeDashboardItem(
                                      arr_ALL_Name_ID_For_Dealer[index].Name,
                                      Icons.person,
                                      context123,
                                      arr_ALL_Name_ID_For_Dealer[index].Name1),
                                );
                              },
                            ))
                        : Container(),
                  ],
                ),
              ),
            ),
            drawer: build_Drawer(
              context: context123,
              UserName: _offlineLoggedInData.details[0].userID,
              RolCode: _offlineLoggedInData.details[0].roleName,
            ),
          )
        : Scaffold(
            body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                IOSBAND,
                height: 200,
                width: 200,
              )),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "You Are No Longer Available To Use This App !" +
                      "\nIf You want to access this App then Please Contact To Our Department.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorBlack,
                      fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Text(
                  "Email: info@sharvayainfotech.com" +
                      "\nContact No.: +91 9099988302",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await SharedPrefHelper.instance
                      .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
                  _dashBoardScreenBloc
                    ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
                        CompanyId: CompanyID.toString(),
                        UserID: LoginUserID,
                        TokenNo: "")));
                  SharedPrefHelper.instance
                      .putBool(SharedPrefHelper.IS_REGISTERED, false);
                  //SharedPrefHelper.instance.setBaseURL("");
                  navigateTo(context, SerialKeyScreen.routeName,
                      clearAllStack: true);
                },
                child: Card(
                    color: colorPrimary,
                    child: Container(
                      // width: double.infinity,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: Text(
                          "Close",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colorWhite),
                        ),
                      ),
                    )),
              )
            ],
          ));
  }

  Future<void> _onTapOfLogOut() async {
    await SharedPrefHelper.instance
        .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
    _dashBoardScreenBloc.add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
        CompanyId: CompanyID.toString(), UserID: LoginUserID, TokenNo: "")));
    navigateTo(context, FirstScreen.routeName, clearAllStack: true);
  }

  void _onDashBoardCallSuccess(
      MenuRightsEventResponseState response, BuildContext context123) {
    getLocationLivePermission();
    // array_MenuRightsList.clear();
    arr_UserRightsWithMenuName.clear();
    SharedPrefHelper.instance.setMenuRightsData(response.menuRightsResponse);

    arr_ALL_Name_ID_For_HR.clear();
    arr_ALL_Name_ID_For_Lead.clear();
    arr_ALL_Name_ID_For_Office.clear();
    arr_ALL_Name_ID_For_Support.clear();
    arr_ALL_Name_ID_For_Purchase.clear();
    arr_ALL_Name_ID_For_Production.clear();
    arr_ALL_Name_ID_For_Sales.clear();
    arr_ALL_Name_ID_For_Account.clear();
    arr_ALL_Name_ID_For_Dealer.clear();
    arr_ALL_Name_ID_For_DashBoard_Widgets.clear();
    /*response.menuRightsResponse.details
        .sort((a, b) => a.toString().compareTo(b.toString()));*/
    for (var i = 0; i < response.menuRightsResponse.details.length; i++) {
      print("MenuRightsResponseFromScreen : " +
          response.menuRightsResponse.details[i].menuName);

      ///-----------------------------------------DashBoard Widget----------------------------------------

      /*    if (response.menuRightsResponse.details[i].menuName == "pgDashDaily") {
         if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
             "TEST-0000-SI0F-0208" ||
             _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                 "SI08-SB94-MY45-RY15") {
           ALL_Name_ID all_name_id1 = ALL_Name_ID();
           all_name_id1.Name = "Follow-up";
           all_name_id1.Name1 = "assets/dashboard/lead/follow-up.png";
           arr_ALL_Name_ID_For_DashBoard_Widgets.add(all_name_id1);


           ALL_Name_ID all_name_id2 = ALL_Name_ID();
           all_name_id2.Name = "To-Do Widget";
           all_name_id2.Name1 = "assets/dashboard/office/Task.png";
           arr_ALL_Name_ID_For_DashBoard_Widgets.add(all_name_id2);
         }
      }
*/
      ///arr_ALL_Name_ID_For_DashBoard_Widgets

      ///-----------------------------------------Leads----------------------------------------

      //RepairingListMainScreen

      if (response.menuRightsResponse.details[i].menuName == "pgRepairing") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Repairing";
        all_name_id.Name1 = "assets/dashboard/lead/img_1.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      }

      if (response.menuRightsResponse.details[i].menuName == "pgInquiry") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Inquiry";
        all_name_id.Name1 = "assets/dashboard/lead/Inquiry.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);

        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = "Quick Inquiry";
        all_name_id1.Name1 = "assets/dashboard/lead/quickInquiry.jpg";
        arr_ALL_Name_ID_For_Lead.add(all_name_id1);
      }

      if (response.menuRightsResponse.details[i].menuName ==
          "pgAlmightyInquiry") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Existing Lead";
        all_name_id.Name1 = "assets/dashboard/lead/Inquiry.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgQuickInquiry") {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = "Lead Generation";
        all_name_id1.Name1 = "assets/dashboard/lead/quickInquiry.jpg";
        arr_ALL_Name_ID_For_Lead.add(all_name_id1);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAlmightyFollowup") {
        ALL_Name_ID all_name_id12 = ALL_Name_ID();
        all_name_id12.Name = "Existing Visit";
        all_name_id12.Name1 = "assets/dashboard/lead/follow-up.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id12);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgQuickFollowUp") {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = "Visit Punch In/Out";
        all_name_id1.Name1 = "assets/dashboard/lead/follow-up.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id1);
      }

      if (response.menuRightsResponse.details[i].menuName == "pgMudraInquiry") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "MR09-DF34-TP45-55PE" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SD0F-0221") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Mudra Inquiry";
          all_name_id.Name1 = "assets/dashboard/lead/Inquiry.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);

          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Quick Inquiry";
          all_name_id1.Name1 = "assets/dashboard/lead/quickInquiry.jpg";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        }
      }

      if (response.menuRightsResponse.details[i].menuName ==
          "pgInquiryInfoBlue") {
        if (_offlineLoggedInData.details[0].serialKey ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "BlueToneInquiry";
          all_name_id.Name1 = "assets/dashboard/lead/Inquiry.png";
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "BlueToneQuickInquiry";
          all_name_id1.Name1 = "assets/dashboard/lead/quickInquiry.jpg";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Inquiry";
          all_name_id.Name1 = "assets/dashboard/lead/Inquiry.png";

          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "SI08-SB94-MY45-RY15" ||
              _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                  "TEST-0000-SI0F-0208") {
            ALL_Name_ID all_name_id1 = ALL_Name_ID();
            all_name_id1.Name = "Quick Inquiry";
            all_name_id1.Name1 = "assets/dashboard/lead/quickInquiry.jpg";
            arr_ALL_Name_ID_For_Lead.add(all_name_id1);
          }

          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgFollowup") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SW0T-GLA5-IND7-AS71" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SI08-SB94-MY45-RY15") {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Quick Follow-up";
          all_name_id1.Name1 = "assets/dashboard/lead/follow-up.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);

          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "SI08-SB94-MY45-RY15") {
            ALL_Name_ID all_name_id1 = ALL_Name_ID();
            all_name_id1.Name = "Follow-Up";
            all_name_id1.Name1 = "assets/dashboard/lead/follow-up.png";
            arr_ALL_Name_ID_For_Lead.add(all_name_id1);
          }
        } else {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Quick Follow-up";
          all_name_id1.Name1 = "assets/dashboard/lead/follow-up.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);

          ALL_Name_ID all_name_id12 = ALL_Name_ID();
          all_name_id12.Name = "Follow-Up";
          all_name_id12.Name1 = "assets/dashboard/lead/follow-up.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id12);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgQuotation") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-ACBF-0214" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "DHSI-09RY-BATH-ACCU") {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Acura Quotation";
          all_name_id1.Name1 = "assets/dashboard/lead/quotation.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        } else if (_offlineLoggedInData
                    .details[0].serialKey
                    .toUpperCase() ==
                "TEST-0000-GREE-EDGE" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "GR5T-E7K3-EN2G-LAP4" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "GRON-N793-EN2P-LLP6") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "New Quotation";
          all_name_id.Name1 = "assets/dashboard/lead/quotation.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Quotation";
          all_name_id.Name1 = "assets/dashboard/lead/quotation.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pghplQuotation") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Hpl Quotation";
        all_name_id.Name1 = "assets/dashboard/lead/quotation.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExternalLeads") {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Portal Leads";
        all_name_id.Name1 = "assets/dashboard/lead/portal_lead.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgTeleCaller") {
        if (_offlineLoggedInData.details[0].serialKey
                .toString()
                .toLowerCase() ==
            "sw0t-gla5-ind7-as71") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Tele Caller";
          all_name_id.Name1 = "assets/dashboard/lead/telecaller_img.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "TeleCaller";
          all_name_id.Name1 = "assets/dashboard/lead/telecaller_img.png";
          all_name_id.PresentDate = "GeneralTeleCaller";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "lnkCustomer1") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Customer";
        all_name_id.Name1 = "assets/dashboard/lead/img.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "lnkProudct1") {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = "Product";
        all_name_id1.Name1 = "assets/dashboard/lead/product.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id1);
      } else if (response.menuRightsResponse.details[i].menuName == "pgAsset") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Asset Issue";
        all_name_id.Name1 = "assets/dashboard/lead/quotation.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgReturn") {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Asset Return";
        all_name_id.Name1 = "assets/dashboard/lead/quotation.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      }

      ///_________________________________Sales____________________________________________________

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesOrder") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "test-0000-acbf-0214") {
          if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
              "dhsi-09ry-bath-accu") {
            if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
                "dol2-6uh7-ph03-in5h") {
              ALL_Name_ID all_name_id = ALL_Name_ID();
              all_name_id.Name = "SalesOrder";
              all_name_id.Name1 = "assets/dashboard/sales/sales_order.png";
              arr_ALL_Name_ID_For_Sales.add(all_name_id);
            }
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesTarget") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Sales Target";
        all_name_id.Name1 = "assets/dashboard/sales/sales_target.png";
        arr_ALL_Name_ID_For_Sales.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesOrderApproval") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "test-0000-acbf-0214") {
          if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
              "dhsi-09ry-bath-accu") {
            ALL_Name_ID all_name_id = ALL_Name_ID();
            all_name_id.Name = "Sales Order Approval";
            all_name_id.Name1 =
                "assets/dashboard/sales/Sales_Order_Approval.png";
            arr_ALL_Name_ID_For_Sales.add(all_name_id);
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesBill") {
        {
          if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
              "test-0000-acbf-0214") {
            if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
                "dhsi-09ry-bath-accu") {
              ALL_Name_ID all_name_id = ALL_Name_ID();
              all_name_id.Name = "SalesBill";
              all_name_id.Name1 = "assets/dashboard/sales/sale_bill.png";
              arr_ALL_Name_ID_For_Sales.add(all_name_id);
            }
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgShortInvoice") {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = "Short Invoice";
        all_name_id1.Name1 = "assets/dashboard/lead/quotation.png";
        arr_ALL_Name_ID_For_Sales.add(all_name_id1);
      }

      ///__________________________________Production____________________________________________________

      else if (response.menuRightsResponse.details[i].menuName == "pgOutward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Outward";
        all_name_id.Name1 = "assets/dashboard/product/mo.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Inward";
        all_name_id.Name1 = "assets/dashboard/product/mi.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgIndentApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Indent Approval";
        all_name_id.Name1 = "assets/dashboard/product/mi.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      }
      /*else if (response.menuRightsResponse.details[i].menuName ==
          "pgInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "6CTR-6KWG-3TQV-3WU0") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Inward";
          all_name_id.Name1 = "assets/dashboard/product/mi.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      }*/
      /* if (response.menuRightsResponse.details[i].menuName ==
          "pgPackingChecklist") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Packing Checklist";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/inspection.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgChecking") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Final Checking";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/Packing.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInstallation") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Installation";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/Packing.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgProductionActivity") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Production Activity";
          all_name_id.Name1 =
              "http://dolphin.sharvayainfotech.in/images/Worklog.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Inward";
          all_name_id.Name1 = "assets/dashboard/product/mi.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgOutward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Outward";
          all_name_id.Name1 = "assets/dashboard/product/mo.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialMovementInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Store Inward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/inbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialMovementOutward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Store Outward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/outbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialConsumption") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Consumption";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/consumption.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInspection") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Inspection Check List";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/inspection.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJobCardInward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Job Card Inward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/inbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJobCardOutward") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Job Card Outward";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/outbox.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgIndent") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Material Indent";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/indent.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSiteSurvey") {
        if (_offlineLoggedInData.details[0].serialKey
                .toUpperCase()
                .toString() ==
            "TEST-0000-SI0F-0208") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Site Survey";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/survey.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id);

          ALL_Name_ID all_name_id2 = ALL_Name_ID();
          all_name_id2.Name = "Site Survey Report";
          all_name_id2.Name1 =
              "http://demo.sharvayainfotech.in/images/survey.png";
          arr_ALL_Name_ID_For_Production.add(all_name_id2);
        }
      }*/

      ///-------------------------------------Account---------------------------------------------------------

      ///Bank voucher Pending from Mayank Development
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgBankVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "BankVoucher";
        all_name_id.Name1 = "assets/dashboard/account/bank_voucher.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgCashVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "CashVoucher";
        all_name_id.Name1 = "assets/dashboard/account/cash_voucher.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgCreditNote") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Credit Note";
        all_name_id.Name1 = "assets/dashboard/account/Credit_Note.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgDebitNote") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Debit Note";
        all_name_id.Name1 = "assets/dashboard/account/debit_notes.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPettyCash") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Petty Cash";
        all_name_id.Name1 = "assets/dashboard/account/Petty_Cash.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJournalVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Journal Voucher";
        all_name_id.Name1 = "assets/dashboard/account/Journal_Voucher.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMultiExpense") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Multiple Expense";
        all_name_id.Name1 = "assets/dashboard/hr/Expense.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMultiExpenseApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Multiple Expense Approval";
        all_name_id.Name1 = "assets/dashboard/hr/Expense.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      }

      ///-------------------------------------HR---------------------------------------------------------
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgLeaveRequest") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Leave Request";
        all_name_id.Name1 = "assets/dashboard/hr/apply_for_leave.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgLeaveApprovalView") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Leave Approval";
        all_name_id.Name1 = "assets/dashboard/sales/Sales_Order_Approval.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAttendance") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() !=
            "AL2M-7IG1-H8S2-TOY3") {
          ALL_Name_ID all_name_id = ALL_Name_ID();

          all_name_id.Name = "Attendance";
          all_name_id.Name1 = "assets/dashboard/hr/attendance.png";
          arr_ALL_Name_ID_For_HR.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();

          all_name_id.Name = "Attendance";
          all_name_id.Name1 = "assets/dashboard/hr/attendance.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExpense") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Expense";
        all_name_id.Name1 = "assets/dashboard/hr/Expense.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExpenseTracking") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Expense Tracking";
        all_name_id.Name1 = "assets/dashboard/hr/Expense.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgEmployee") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Employee";
        all_name_id.Name1 = "assets/dashboard/hr/employee.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgLoanApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Loan Approval";
        all_name_id.Name1 = "assets/dashboard/sales/Sales_Order_Approval.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMissedPunch") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Missed Punch";
        all_name_id.Name1 = "assets/dashboard/hr/attendance.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMissedPunchApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Missed Punch Approval";
        all_name_id.Name1 = "assets/dashboard/sales/Sales_Order_Approval.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAdvance") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Salary Adv/Upad";
        all_name_id.Name1 = "assets/dashboard/hr/salary_add_upad.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName == "pgLoan") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Loan Installments";
        all_name_id.Name1 = "assets/dashboard/hr/loan_Installments.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPayslip1") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Pay Slip";
        all_name_id.Name1 = "assets/images/paySlip.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      }

      ///----------------------------------Purchase________________________________________________________

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurcOrder") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Order";
        all_name_id.Name1 = "assets/dashboard/purchase/purchaseorder.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
        // }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurchaseOrderApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Order Approval";
        all_name_id.Name1 = "assets/dashboard/sales/Sales_Order_Approval.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurchaseBill") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Bill";
        all_name_id.Name1 = "assets/dashboard/purchase/purchse_bill.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      }

      ///------------------------------------Office_________________________________________________________

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgVisitorInfo") {
        ALL_Name_ID all_name_id2 = ALL_Name_ID();
        all_name_id2.Name = "Visitor Management";
        all_name_id2.Name1 = "assets/dashboard/office/visitors.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id2);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgDailyActivity") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Daily Activities";
        all_name_id.Name1 = "assets/dashboard/office/dailyactivity.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSIDailyActivity") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Sharvaya Daily Activities";
        all_name_id.Name1 = "assets/dashboard/office/dailyactivity.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName == "pgToDO") {
        print("Test Task " + response.menuRightsResponse.details[i].menuName ==
            "pgToDO");
        //ToDoWidgetListScreen
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
                "si08-sb94-my45-ry15" ||
            _offlineLoggedInData.details[0].serialKey.toLowerCase() ==
                "test-0000-si0f-0208") {
          ALL_Name_ID all_name_id2 = ALL_Name_ID();
          all_name_id2.Name = "To-Do Widget";
          all_name_id2.Name1 = "assets/dashboard/office/Task.png";
          arr_ALL_Name_ID_For_Office.add(all_name_id2);

          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "To-Do";
          all_name_id.Name1 = "assets/dashboard/office/Task.png";
          arr_ALL_Name_ID_For_Office.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "To-Do";
          all_name_id.Name1 = "assets/dashboard/office/Task.png";
          arr_ALL_Name_ID_For_Office.add(all_name_id);
        }

        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
            "si08-sb94-my45-ry15") {
          if (LoginUserID == "satish") {
            ALL_Name_ID all_name_id2 = ALL_Name_ID();
            all_name_id2.Name = "Activity Summary";
            all_name_id2.Name1 = "assets/dashboard/office/Task.png";
            arr_ALL_Name_ID_For_Office.add(all_name_id2);
          }
        }
      }

      ///------------------------------------Support_________________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgComplaintMudra") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "MudraComplaint";
        all_name_id.Name1 = "assets/dashboard/support/complaint.jpg";
        arr_ALL_Name_ID_For_Support.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgVisitMudra") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "MudraAttendVisit";
        all_name_id.Name1 = "assets/dashboard/support/visit.png";
        arr_ALL_Name_ID_For_Support.add(all_name_id);
      } else if (/*response.menuRightsResponse.details[i].menuName ==
       "pgVisitMudra"*/
          i == 0) {
        if (_offlineLoggedInData.details[0].serialKey ==
                "TEST-0000-SD0F-0221" ||
            _offlineLoggedInData.details[0].serialKey ==
                "MR09-DF34-TP45-55PE") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Quick Visit";
          all_name_id.Name1 = "assets/dashboard/support/visit.png";
          arr_ALL_Name_ID_For_Support.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgComplaint") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "acsi-c803-cup0-shel") {
          if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "VK34-SOFG-NDH2-35JK") {
            ALL_Name_ID all_name_id = ALL_Name_ID();
            all_name_id.Name = "Technical Visit";
            all_name_id.Name1 = "assets/dashboard/support/complaint.jpg";
            arr_ALL_Name_ID_For_Support.add(all_name_id);
          } else {
            if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SI0F-0208") {
              ALL_Name_ID all_name_id = ALL_Name_ID();
              all_name_id.Name = "Technical Visit";
              all_name_id.Name1 = "assets/dashboard/support/complaint.jpg";
              arr_ALL_Name_ID_For_Support.add(all_name_id);

              ALL_Name_ID all_name_id5 = ALL_Name_ID();
              all_name_id5.Name = "Complaint";
              all_name_id5.Name1 = "assets/dashboard/support/complaint.jpg";
              arr_ALL_Name_ID_For_Support.add(all_name_id5);
            } else {
              if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
                      "gr5t-e7k3-en2g-lap4" ||
                  _offlineLoggedInData.details[0].serialKey.toLowerCase() !=
                      "gron-n793-en2p-llp6") {
                {
                  ALL_Name_ID all_name_id5 = ALL_Name_ID();
                  all_name_id5.Name = "Complaint";
                  all_name_id5.Name1 = "assets/dashboard/support/complaint.jpg";
                  arr_ALL_Name_ID_For_Support.add(all_name_id5);
                }
              } else {
                ALL_Name_ID all_name_id = ALL_Name_ID();
                all_name_id.Name = "Complaint";
                all_name_id.Name1 = "assets/dashboard/support/complaint.jpg";
                arr_ALL_Name_ID_For_Support.add(all_name_id);
              }
            }
          }
        }
      } else if (response.menuRightsResponse.details[i].menuName == "pgVisit") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
            "ah45-ghdf-ni23-ind6") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Agni AttendVisit";
          all_name_id.Name1 = "assets/dashboard/support/visit.png";
          arr_ALL_Name_ID_For_Support.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Attend Visit";
          all_name_id.Name1 = "assets/dashboard/support/visit.png";
          arr_ALL_Name_ID_For_Support.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgContractInfo") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Maintenance Contract";
        all_name_id.Name1 = "assets/dashboard/support/amc.png";
        arr_ALL_Name_ID_For_Support.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgServiceMaster") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Service Report";
        all_name_id.Name1 = "assets/dashboard/lead/quotation.png";
        arr_ALL_Name_ID_For_Support.add(all_name_id);
      }

      /*if (ISDelaer == "Dealer") {
        arr_ALL_Name_ID_For_HR.clear();
        arr_ALL_Name_ID_For_Lead.clear();
        arr_ALL_Name_ID_For_Office.clear();
        arr_ALL_Name_ID_For_Support.clear();
        arr_ALL_Name_ID_For_Purchase.clear();
        arr_ALL_Name_ID_For_Production.clear();
        arr_ALL_Name_ID_For_Sales.clear();
        arr_ALL_Name_ID_For_Account.clear();

        if (i == 0) {
          ALL_Name_ID all_name_id0 = ALL_Name_ID();
          all_name_id0.Name = "Customer";
          all_name_id0.Name1 = "assets/dashboard/lead/debit_notes.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id0);

          ALL_Name_ID all_name_id2 = ALL_Name_ID();
          all_name_id2.Name = "Product";
          all_name_id2.Name1 = "assets/dashboard/lead/product.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id2);

          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "SalesBill";
          all_name_id.Name1 = "assets/dashboard/sales/sale_bill.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id);

          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Purchase Bill";
          all_name_id1.Name1 = "assets/dashboard/purchase/purchse_bill.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id1);

          ALL_Name_ID all_name_id3 = ALL_Name_ID();
          all_name_id3.Name = "BankVoucher";
          all_name_id3.Name1 = "assets/dashboard/account/bank_voucher.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id3);

          ALL_Name_ID all_name_id4 = ALL_Name_ID();
          all_name_id4.Name = "CashVoucher";
          all_name_id4.Name1 = "assets/dashboard/account/cash_voucher.png";
          arr_ALL_Name_ID_For_Dealer.add(all_name_id4);
        }
      }*/
    }

    /* if (ISDelaer != "Dealer") {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = "Customer";
      all_name_id.Name1 = "assets/dashboard/lead/debit_notes.png";
      arr_ALL_Name_ID_For_Lead.add(all_name_id);

      ALL_Name_ID all_name_id1 = ALL_Name_ID();
      all_name_id1.Name = "Product";
      all_name_id1.Name1 = "assets/dashboard/lead/product.png";
      arr_ALL_Name_ID_For_Lead.add(all_name_id1);
    }*/

    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "aasi-67ro-h01i-zh6u") {
      arr_ALL_Name_ID_For_HR.clear();
      arr_ALL_Name_ID_For_Lead.clear();
      // arr_ALL_Name_ID_For_Office.clear();
      arr_ALL_Name_ID_For_Support.clear();
      arr_ALL_Name_ID_For_Purchase.clear();
      arr_ALL_Name_ID_For_Production.clear();
      arr_ALL_Name_ID_For_Sales.clear();
      arr_ALL_Name_ID_For_Account.clear();
    }

    arr_ALL_Name_ID_For_Office
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    arr_ALL_Name_ID_For_HR
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    arr_ALL_Name_ID_For_Office
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));

    arr_ALL_Name_ID_For_Support
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));

    for (var i = 0; i < arr_ALL_Name_ID_For_HR.length; i++) {
      print("MenuRightsHR : " + arr_ALL_Name_ID_For_HR[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Lead.length; i++) {
      print("MenuRightsSales : " + arr_ALL_Name_ID_For_Lead[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Office.length; i++) {
      print("MenuRightsOffice : " + arr_ALL_Name_ID_For_Office[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Support.length; i++) {
      print("MenuRightsSupport : " + arr_ALL_Name_ID_For_Support[i].Name);
    }
  }

  _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListByStatusCallResponseState state) {
    print("testweb" + state.response.details[0].employeeName);
    SharedPrefHelper.instance.setFollowerEmployeeListData(state.response);
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    print("_offlineFollowerEmployeeListData" +
        _offlineFollowerEmployeeListData.details[0].employeeName +
        "");
  }

  void _onALLEmployeeListByStatusCallSuccess(
      ALL_EmployeeNameListResponseState state) {
    SharedPrefHelper.instance
        .setALLEmployeeListData(state.all_employeeList_Response);
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();
  }

  void _OnFethEmployeeImage(EmployeeListResponseState state) {
    for (int i = 0; i < state.employeeListResponse.details.length; i++) {
      if (_offlineLoggedInData.details[0].employeeID ==
          state.employeeListResponse.details[i].pkID) {
        if (state.employeeListResponse.details[i].employeeImage != "") {
          ImgFromTextFiled.text = "";
          ImgFromTextFiled.text = _offlineCompanyData.details[0].siteURL +
              state.employeeListResponse.details[i].employeeImage;
          break;
        }
      }
    }
  }

  void _OnTokenUpdateResponse(APITokenUpdateState state) {
    if (state.firebaseTokenResponse.details[0].column2 != "") {
      print("APDdfd" +
          " API Token Response : " +
          state.firebaseTokenResponse.details[0].column2);
    }
  }

  void MovetoFollowupScreen(
      BuildContext Notifycontext, String Title, String BodyDetails) {
    SplitSTr = BodyDetails.split("By");
    print("NotificationSplitedValue" +
        " Value : " +
        SplitSTr[0].toString() +
        " 2nd : " +
        SplitSTr[1].toString());
    //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);

    navigateTo(Notifycontext, FollowupListScreen.routeName,
            clearAllStack: true,
            arguments: FollowupListScreenArguments(SplitSTr[1].toString()))
        .then((value) {
      SplitSTr = [];
    });
  }

  onTimerFinished() {}

  void _OnwebSucessResponse(PunchOutWebMethodState state) {
    print("Webresponse" + state.response);
  }

  void registerNotification() async {
    /* await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );*/
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!' +
          message.notification.title);
      print("message Id - onMessageOpenedApp ${message.messageId}");
      if (Globals.objectedNotifications.contains(message.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(message.messageId);
      if (message.data['title'] == "Inquiry") {
        // navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);
        Navigator.pushNamed(
          Globals.context,
          InquiryListScreen.routeName,
          arguments: MessageArguments(message, true),
        );
      } else if (message.data['title'] == "Follow-up") {
        navigateTo(Globals.context, FollowupListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "FollowUp") {
        MovetoFollowupScreen(Globals.context, message.notification.title,
            message.notification.body);
      } else if (message.data['title'] == "Quotation") {
        navigateTo(Globals.context, QuotationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "New Quotation") {
        navigateTo(Globals.context, GreenEdgeQuotationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Sales Order") {
        navigateTo(Globals.context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Sales Invoice") {
        navigateTo(Globals.context, SalesBillListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Complaint") {
        navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "To-Do") {
        navigateTo(Globals.context, ToDoListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Leave Request") {
        navigateTo(Globals.context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "TeleCaller") {
        navigateTo(Globals.context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Quick Inquiry") {
        navigateTo(Globals.context, InquiryListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Portal Lead") {
        navigateTo(Globals.context, ExternalLeadListScreen.routeName,
            clearAllStack: true);
      }
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Grant the Permission");
    } else {
      print("Permission Decline By User");
    }
  }

  checkIntialMessage() async {
    RemoteMessage intialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (intialMessage != null) {
      print("message Id - intialMessage ${intialMessage.messageId}");
      if (Globals.objectedNotifications.contains(intialMessage.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(intialMessage.messageId);

      /* PushNotification notification = PushNotification(
        title: intialMessage.notification!.title,
        body: intialMessage.notification!.body,
        dataTitle: intialMessage.data['title'],
        databody: intialMessage.data['body']
    );*/

      if (intialMessage.data['title'] == "Inquiry") {
        navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
      } else if (intialMessage.data['title'] == "Follow-up") {
        navigateTo(Globals.context, FollowupListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "FollowUp") {
        MovetoFollowupScreen(
            context, intialMessage.data['title'], intialMessage.data['body']);

        //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
      } else if (intialMessage.data['title'] == "Quotation") {
        navigateTo(Globals.context, QuotationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "New Quotation") {
        navigateTo(Globals.context, GreenEdgeQuotationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Sales Order") {
        navigateTo(Globals.context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Sales Invoice") {
        navigateTo(Globals.context, SalesBillListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Complaint") {
        navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "To-Do") {
        navigateTo(Globals.context, ToDoListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Leave Request") {
        navigateTo(Globals.context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "TeleCaller") {
        navigateTo(Globals.context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Quick Inquiry") {
        navigateTo(Globals.context, InquiryListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Portal Lead") {
        navigateTo(Globals.context, ExternalLeadListScreen.routeName,
            clearAllStack: true);
      }

      //
    }
  }

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void checkPhotoPermissionStatus() async {
    bool granted = await Permission.storage.isGranted;
    bool Denied = await Permission.storage.isDenied;
    bool PermanentlyDenied = await Permission.storage.isPermanentlyDenied;
    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());
    if (Denied == true) {
      await Permission.storage.request();
    }
    if (await Permission.location.isRestricted) {
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      openAppSettings();
    }
    if (granted == true) {}
  }

  void getLocationLivePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      checkPermissionStatus();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        print("A12215534" +
            "Location permissions are  denied, we cannot request permissions.");

        permission = await Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      print("A12215534" +
          "Location permissions are permanently denied, we cannot request permissions.");

      permission = await Geolocator.requestPermission();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();

      print("CurrentLatLong" +
          position.latitude.toString() +
          " , " +
          position.longitude.toString());

      SharedPrefHelper.instance.setLatitude(position.latitude.toString());
      SharedPrefHelper.instance.setLongitude(position.longitude.toString());
    }

    if (permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();

      print("CurrentLatLong" +
          position.latitude.toString() +
          " , " +
          position.longitude.toString());

      SharedPrefHelper.instance.setLatitude(position.latitude.toString());
      SharedPrefHelper.instance.setLongitude(position.longitude.toString());
    }
  }

  void getDetailsOfImage(String docURLFromListing, String docname) async {
    await urlToFile(docURLFromListing, docname.toString());
  }

  urlToFile(String imageUrl, String filenamee) async {
    if (Uri.parse(imageUrl).isAbsolute == true) {
      try {
        http.Response response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          Directory dir = await getApplicationDocumentsDirectory();
          dir.exists();
          String pathName = p.join(dir.path, filenamee);

          print("77575sdd7" + imageUrl);

          File file = new File(pathName);

          print("7757sds5sdd7" + file.path);

          try {
            await file.writeAsBytes(response.bodyBytes);
          } catch (e) {
            print("hdfhjfdhh" + e.toString());
          }

          Lunch_In_OUT_File = file;
        }
      } catch (e) {
        print("775757" + e.toString());
      }
    }
  }

  void _onGetConstant(ConstantResponseState state) {
    print("ConstantValue" + state.response.details[0].value.toString());

    ConstantMAster = state.response.details[0].value.toString();
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

  Future<void> OpenDriveLink(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri.parse(phoneNumber);
    await launch(launchUri.toString());
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

  UserProfileDialog({BuildContext context1}) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(8), // Border width
                      decoration: BoxDecoration(
                          color: colorLightGray, shape: BoxShape.circle),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(80), // Image radius
                          child: ImageFullScreenWrapperWidget(
                            child: /*Image.network(ImgFromTextFiled.text,
                                fit: BoxFit.cover)*/
                                ImgFromTextFiled.text != ""
                                    ? Image.network(
                                        ImgFromTextFiled.text,
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          return child;
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Image.asset(
                                              LOADDER,
                                              height: 100,
                                              width: 100,
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace stackTrace) {
                                          return Image.asset(
                                            NO_IMAGE_FOUND,
                                            height: 100,
                                            width: 100,
                                          );
                                        },

                                        // fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        NO_IMAGE_FOUND,
                                        height: 100,
                                        width: 100,
                                      ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "User : ",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                              child: Text(
                                  _offlineLoggedInData.details[0].employeeName,
                                  style: TextStyle(
                                    color: colorBlack,
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Role : ",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            child:
                                Text(_offlineLoggedInData.details[0].roleName,
                                    style: TextStyle(
                                      color: colorBlack,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "State : ",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            child:
                                Text(_offlineLoggedInData.details[0].StateName,
                                    style: TextStyle(
                                      color: colorBlack,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: getCommonButton(baseTheme, () {
                        Navigator.pop(context123);
                      }, "Close", backGroundColor: colorPrimary, radius: 25.0),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  Future<void> _initPackageInfo(String APIMobileVersion) async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;

    int mobileAPIVersion = int.parse(APIMobileVersion);
    int CurrentMobileVersion = int.parse(_packageInfo.buildNumber);
//15
    if (mobileAPIVersion > CurrentMobileVersion) {
      if (Platform.isAndroid == true) {
        await showDialog(
          barrierDismissible: false,
          context: Globals.context,
          builder: (BuildContext context123) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              children: [
                SizedBox(
                    width: MediaQuery.of(context123).size.width,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            GOOGLE_PLAY,
                            width: 200,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 1,
                            color: colorGrayVeryDark,
                          ),
                          Text(
                            "Update App ?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "A new version of Sharvaya ERP is available on play-store \n would you like to update it now ? ",
                              style: TextStyle(
                                fontSize: 12,
                                color: colorBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Releases Notes :",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Minor updates and improvements.",
                            style: TextStyle(fontSize: 12, color: colorBlack),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context123);
                                  }, "Skip",
                                      backGroundColor: colorPrimary,
                                      radius: 25.0),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: getCommonButton(baseTheme, () async {
                                    await launch(
                                      "https://play.google.com/store/apps/details?id=com.sharvayainfotech.eofficedesk",
                                    );
                                  }, "Update",
                                      backGroundColor: colorPrimary,
                                      radius: 25.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            );
          },
        );
      }
    }

    print("MobileAppVersion123" +
        " BuildNumber : " +
        _packageInfo.buildNumber.toString() +
        " Version : " +
        _packageInfo.version.toString() +
        "MobileAPI" +
        APIMobileVersion);
  }

  void _OnCompanyResponse(ComapnyDetailsEventResponseState state) {
    print(state.companyDetailsResponse.details[0].mobileAppVersion);
    _initPackageInfo(
        state.companyDetailsResponse.details[0].mobileAppVersion.toString());
  }

  _onTaptoLogOutBluetone() {
    _dashBoardScreenBloc.add(LogoutCountRequestEvent(LogoutCountRequest(
        LoginUserID: LoginUserID, CompanyId: CompanyID.toString())));
  }

  void _OnLogoutCount(LogOutCountResponseState state) {
    String msg = " Followup Important Task Missing \n\n" +
        "Todays Count (" +
        state.response.details[0].todayCount.toString() +
        ")" +
        "\n" +
        "Missed Count (" +
        state.response.details[0].missedCount.toString() +
        ")" +
        "\n" +
        "Future Count (" +
        state.response.details[0].futureCount.toString() +
        ")" +
        "\n";

    bool isCompleted = false;

    if (state.response.details[0].todayCount == 0 &&
        state.response.details[0].missedCount == 0 &&
        state.response.details[0].futureCount == 0) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }

    showCommonDialogWithSingleOption(context, msg,
        onTapOfPositiveButton: () async {
      if (isCompleted == true) {
        await SharedPrefHelper.instance
            .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
        _dashBoardScreenBloc
          ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
              CompanyId: CompanyID.toString(),
              UserID: LoginUserID,
              TokenNo: "")));
        navigateTo(context, FirstScreen.routeName, clearAllStack: true);
      } else {
        navigateTo(context, FollowupListScreen.routeName);
      }
    });
  }

  void _onDashBoardCountResponseState(
      DashBoardCountResponseState state, BuildContext context) {
    DashBoardCountResponseDetails dashboardDetails =
        state.response.details.first;
    showDashboardCountsDialog(context, dashboardDetails);
  }

  void showDashboardCountsDialog(
      BuildContext context, DashBoardCountResponseDetails details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              "Dashboard Summary",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildCountCard("📞", "Contacts", details.contacts),
                    _buildCountCard("🗓️", "To Do", details.toDO),
                    _buildCountCard("📋", "Followup", details.followup),
                    _buildCountCard("📋", "Followup1", details.followup1),
                    _buildCountCard("📋", "Followup2", details.followup2),
                    _buildCountCard("🛫", "Leave", details.leave),
                    _buildCountCard("🔁", "Login/Logout", details.loginLogout),
                    _buildCountCard("❓", "Inquiry", details.inquiry),
                    _buildCountCard("🧾", "Quotation", details.quotation),
                    _buildCountCard("📦", "Sales Order", details.salesOrder),
                    _buildCountCard(
                        "🛒", "Purchase Order", details.purchaseOrder),
                    _buildCountCard(
                        "💰", "Sales Invoice", details.salesInvoice),
                    _buildCountCard(
                        "📄", "Purchase Invoice", details.purchaseInvoice),
                    _buildCountCard("📥", "Inward", details.inward),
                    _buildCountCard("📤", "Outward", details.outward),
                    _buildCountCard(
                        "🗓", "Daily Activity", details.dailyActivity),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCountCard(String emoji, String label, int count) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            "$count",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  void _showDashBoardCountDateFilterSheet() {
    final DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    DateTime toDate = DateTime(now.year, now.month, now.day);

    String fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

    Future<void> pickFromDate(
        void Function(void Function()) setModalState) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101),
      );
      if (picked == null) return;
      final normalized = DateTime(picked.year, picked.month, picked.day);
      setModalState(() {
        fromDate = normalized;
        if (toDate.isBefore(fromDate)) {
          toDate = fromDate;
        }
      });
    }

    Future<void> pickToDate(
        void Function(void Function()) setModalState) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: fromDate,
        lastDate: DateTime(2101),
      );
      if (picked == null) return;
      final normalized = DateTime(picked.year, picked.month, picked.day);
      setModalState(() {
        toDate = normalized;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 14,
                  bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.analytics,
                              color: Colors.indigo.shade700),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Dashboard Count Filter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select From & To dates (default is today).',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _DateFieldTile(
                            label: 'From Date',
                            value: fmt(fromDate),
                            icon: Icons.event,
                            onTap: () => pickFromDate(setModalState),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateFieldTile(
                            label: 'To Date',
                            value: fmt(toDate),
                            icon: Icons.event_available,
                            onTap: () => pickToDate(setModalState),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                fromDate =
                                    DateTime(now.year, now.month, now.day);
                                toDate = DateTime(now.year, now.month, now.day);
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('RESET'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final String from = fmt(fromDate);
                              final String to = fmt(toDate);

                              _dashBoardScreenBloc.add(
                                DashBoardCountRequestEvent(
                                  DashBoardCountRequest(
                                    UserID: LoginUserID,
                                    FromDate: from,
                                    ToDate: to,
                                    CompanyId: CompanyID.toString(),
                                  ),
                                ),
                              );

                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'APPLY',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _TopActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopActionIconButton({
    Key key,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Icon(icon, size: 26, color: colorPrimary),
          ),
        ),
      ),
    );
  }
}

class _DateFieldTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _DateFieldTile({
    Key key,
    this.label,
    this.value,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo.shade700, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
          ],
        ),
      ),
    );
  }
}
