import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/sharvaya_daily_activity_delete_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/sharvaya_daily_activity_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/sharvaya_daily_activity%202/sharvaya_daily_activity_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Daily_Activity_For_Sharvaya/Daily_Activity_For_Sharvaya_Add_Update.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class AddUpdateDailyActivityListScreenArguments {
  String ListDate;

  AddUpdateDailyActivityListScreenArguments(this.ListDate);
}

class DailyActivityForSharvayaListScreen extends BaseStatefulWidget {
  static const routeName = '/DailyActivityForSharvayaListScreen';

  final AddUpdateDailyActivityListScreenArguments arguments;

  DailyActivityForSharvayaListScreen(this.arguments);

  @override
  _DailyActivityForSharvayaListScreenState createState() =>
      _DailyActivityForSharvayaListScreenState();
}

class _DailyActivityForSharvayaListScreenState
    extends BaseState<DailyActivityForSharvayaListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  Function refreshList;
  SharvayaDailyActivityListResponse _listResponse;
  int _pageNo = 0;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHieght = 50;
  bool isDeleteVisible = true;
  int selected = 0;
  bool isExpand = false;
  double _fontSize_Label = 12;
  double _fontSize_Title = 15;
  bool _isForUpdate;
  bool _hasCallSupport = false;

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  double totduration = 0.00;
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_FollowupStatusReverse =
      TextEditingController();
  final TextEditingController TASKTOTALDURATION = TextEditingController();
  final urlController = TextEditingController();
  //List<BankVoucherDetailsTable> _contactsList = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  List<File> documentList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  String FinalTotalCount = "";
  String SiteURL = "";
  String Password = "";
  String url = "";
  bool onWebLoadingStop = true;
  bool isLoading = true;
  int prgresss = 0;
  double progress = 0;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        disallowOverScroll: true,
        enableViewportScale: true,
        suppressesIncrementalRendering: true,
        allowsAirPlayForMediaPlayback: true,
        allowsBackForwardNavigationGestures: true,
        allowsLinkPreview: true,
        allowsPictureInPictureMediaPlayback: true,
        isFraudulentWebsiteWarningEnabled: true,
        selectionGranularity: IOSWKSelectionGranularity.DYNAMIC,
        dataDetectorTypes: [IOSWKDataDetectorTypes.NONE],
        sharedCookiesEnabled: true,
        automaticallyAdjustsScrollIndicatorInsets: true,
        accessibilityIgnoresInvertColors: true,
        decelerationRate: IOSUIScrollViewDecelerationRate.NORMAL,
        alwaysBounceVertical: true,
        alwaysBounceHorizontal: true,
        scrollsToTop: true,
        isPagingEnabled: true,
        maximumZoomScale: 1.0,
        minimumZoomScale: 1.0,
        contentInsetAdjustmentBehavior:
            IOSUIScrollViewContentInsetAdjustmentBehavior.NEVER,
        isDirectionalLockEnabled: true,
        pageZoom: 1.0,
        limitsNavigationsToAppBoundDomains: true,
        useOnNavigationResponse: true,
        applePayAPIEnabled: true,
        disableLongPressContextMenuOnLinks: true,
        disableInputAccessoryView: true,
      ));
  PullToRefreshController pullToRefreshController;
  InAppWebViewController webViewController;
  ContextMenu contextMenu;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text =
        _offlineLoggedInData.details[0].employeeID.toString();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");

    _mainBloc = MainBloc(baseBloc);
    isExpand = false;

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    edt_FollowupStatus.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();

    edt_FollowupStatusReverse.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      edt_FollowupStatus.text = widget.arguments.ListDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      _mainBloc.add(SharvayaDailyActivityListEvent(
          1,
          SharvayaDailyActivityListRequest(
            pkID: 0,
            ActivityDate: edt_FollowupStatusReverse.text,
            EmployeeID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID,
          )));
    } else {
      _mainBloc.add(SharvayaDailyActivityListEvent(
          1,
          SharvayaDailyActivityListRequest(
            pkID: 0,
            ActivityDate: edt_FollowupStatusReverse.text,
            EmployeeID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID,
          )));
    }

    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    edt_FollowupStatus.addListener(followerEmployeeList);
    edt_FollowupStatusReverse.addListener(followerEmployeeList);
    edt_FollowupEmployeeList.addListener(followerEmployeeList);
    edt_FollowupEmployeeUserID.addListener(followerEmployeeList);

    getUserRights(_menuRightsResponse);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is SharvayaDailyActivityListResponseState) {
            _onMayankSharvayaDailyActivitySuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is SharvayaDailyActivityListResponseState) {
            return true;
          }
          if (currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is SharvayaDailyActivityDeleteResponseState) {
            _onDeleteBankVoucher(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SharvayaDailyActivityDeleteResponseState) {
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
        backgroundColor: colorWhite,
        appBar: NewGradientAppBar(
          title: Text(
            'Daily Work Log',
            style: TextStyle(fontSize: 20),
          ),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: colorWhite,
                ),
                onPressed: () {
                  navigateTo(context, DailyActivityForSharvayaAddEdit.routeName,
                      clearAllStack: true);
                }),
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      _mainBloc.add(SharvayaDailyActivityListEvent(
                          1,
                          SharvayaDailyActivityListRequest(
                            pkID: 0,
                            ActivityDate: edt_FollowupStatusReverse.text,
                            EmployeeID: edt_FollowupEmployeeUserID.text,
                            PageNo: 1,
                            PageSize: 10,
                            LoginUserID: LoginUserID,
                            CompanyId: CompanyID,
                          )));

                      getUserRights(_menuRightsResponse);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 4, // Equivalent to 1.5 when scaled
                                child: _buildEmployeeListView(),
                              ),
                              SizedBox(
                                  width: 4), // Spacer for better separation
                              Flexible(
                                flex: 3, // Equivalent to 2 when scaled
                                child: _buildSearchView(),
                              ),
                            ],
                          ),
                          Expanded(child: _buildInquiryList()),
                        ],
                      ),
                    )),
              ),
              _buildCount()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_listResponse.details.toString() != "") {
              _showEmailMyDialog(_listResponse.details);
              print(SiteURL +
                  "DailyActivity.aspx?MobilePdf=yes&userid=" +
                  LoginUserID +
                  "&password=" +
                  Password);
            } else {
              showCommonDialogWithSingleOption(context,
                  "Customer's Email Not Found\nKindly Update Email From Customer Master !",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.pop(context);
              });
            }
          },
          child: Icon(Icons.email),
        ),
      ),
    );
  }

  followerEmployeeList() {
    print(
        "CurrentEMP Text is ${edt_FollowupStatusReverse.text + " USERID : " + edt_FollowupEmployeeUserID.text}");
    _mainBloc.add(SharvayaDailyActivityListEvent(
        1,
        SharvayaDailyActivityListRequest(
          pkID: 0,
          ActivityDate: edt_FollowupStatusReverse.text,
          EmployeeID: edt_FollowupEmployeeUserID.text,
          PageNo: 1,
          PageSize: 10,
          LoginUserID: LoginUserID,
          CompanyId: CompanyID,
        )));
    setState(() {});
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = "";
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }

      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].pkID.toString();
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  Widget _buildEmployeeListView() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.035;

    return InkWell(
      onTap: () {
        showCustomDialogWithIDForScreen(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_FollowupEmployeeList,
            controllerID: edt_FollowupEmployeeUserID,
            label: "Select Employee");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Select Employee",
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10),
            elevation: 10,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: edt_FollowupEmployeeList,
                      decoration: InputDecoration(
                        hintText: "--- Select ---",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showCustomDialogWithIDForScreen({
    List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String label,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label at the top of the dialog
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // List of options
                Container(
                  height: 200, // Adjust as necessary or make it dynamic
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: values.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context123).pop();
                          controller.text = values[index].Name;
                          controllerID.text = values[index].pkID.toString();
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent,
                                  ),
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.only(right: 12),
                                ),
                                Expanded(
                                  child: Text(
                                    values[index].Name,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),

                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context123).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchView() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.035;

    return InkWell(
      onTap: () {
        _selectDate(context, edt_FollowupStatus, edt_FollowupStatusReverse);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Select Date",
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10),
            elevation: 10,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: edt_FollowupStatus,
                enabled: false,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "Select Date",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController edt_followupStatusReverse) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_FollowupStatus.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_FollowupStatusReverse.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04;
    double fontSizeTitle = screenWidth * 0.045;
    double fontSizeLabel = screenWidth * 0.037;
    double fontSize = screenWidth * 0.04; // Consistent font size for all texts
    SharvayaDailyActivityListResponseDetails model =
        _listResponse.details[index];

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      //padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 8,
        shadowColor: Colors.blue[600],
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding, top: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Name", style: _labelStyle(fontSize)),
                  Text(
                    model.customerName.isNotEmpty
                        ? model.customerName
                        : model.taskDescription,
                    overflow: TextOverflow.ellipsis,
                    style: _valueStyle(fontSize),
                  ),
                ],
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: padding / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Employee Name: ", model.employeeName,
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Work Notes: ", model.taskDescription,
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Category: ", model.taskCategory,
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow(
                        "Estimated Hrs: ",
                        model.estHours.toString(),
                        fontSizeLabel,
                        fontSizeLabel * 1.1),
                    _buildDetailRow("Work Hrs: ", model.taskDuration.toString(),
                        fontSizeLabel, fontSizeLabel * 1.1),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        _onTapOfEditVehicleFuel(model);
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this record?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _mainBloc.add(SharvayaDailyActivityDeleteEvent(
                            SharvayaDailyActivityDeleteRequest(
                                pkID: model.pkID, CompanyId: CompanyID),
                          ));
                        });
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _valueStyle(double fontSize) => TextStyle(
        color: Colors.black87,
        fontSize: fontSize,
      );

// Helper styles for labels and titles
  TextStyle _labelStyle(double fontSize) => TextStyle(
        color: Colors.blueAccent,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      );

// Helper for building detail rows
  Widget _buildDetailRow(
      String label, String value, double labelFontSize, double valueFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle(labelFontSize)),
          Expanded(
            child: Text(value,
                style:
                    TextStyle(color: Colors.black87, fontSize: valueFontSize)),
          ),
        ],
      ),
    );
  }

  void _onInquiryListPagination() {
    _mainBloc.add(SharvayaDailyActivityListEvent(
        _pageNo + 1,
        SharvayaDailyActivityListRequest(
          pkID: 0,
          ActivityDate: edt_FollowupStatusReverse.text,
          EmployeeID: edt_FollowupEmployeeUserID.text,
          PageNo: _pageNo + 1,
          PageSize: 10,
          LoginUserID: LoginUserID,
          CompanyId: CompanyID,
        )));
  }

  Widget _buildInquiryList() {
    if (_listResponse == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _listResponse.details.length,
      ),
    );
  }

  void _onMayankSharvayaDailyActivitySuccess(
      SharvayaDailyActivityListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _listResponse = state.response;
      } else {
        _listResponse.details.addAll(state.response.details);
      }
      FinalTotalCount = state.response.totalDuration;

      _pageNo = state.newPage;
    }
  }

  String formatDecimalToTime(double decimalHours) {
    int totalMinutes = (decimalHours * 60).round();
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }

  void _onTapOfEditVehicleFuel(
      SharvayaDailyActivityListResponseDetails model) async {
    navigateTo(context, DailyActivityForSharvayaAddEdit.routeName,
            arguments: DailyActivityForSharvayaAddEditArguments2(model))
        .then((value) {
      _mainBloc.add(SharvayaDailyActivityListEvent(
          1,
          SharvayaDailyActivityListRequest(
            pkID: 0,
            ActivityDate: edt_FollowupStatusReverse.text,
            EmployeeID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID,
          )));
    });
  }

  void _onDeleteBankVoucher(SharvayaDailyActivityDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _mainBloc.add(SharvayaDailyActivityListEvent(
          1,
          SharvayaDailyActivityListRequest(
            pkID: 0,
            ActivityDate: edt_FollowupStatusReverse.text,
            EmployeeID: edt_FollowupEmployeeUserID.text,
            PageNo: 1,
            PageSize: 10,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID,
          )));
    });
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgDailyActivity") {
        _mainBloc.add(UserMenuRightsRequestEvent(
            menuRightsResponse.details[i].menuId.toString(),
            UserMenuRightsRequest(
                MenuID: menuRightsResponse.details[i].menuId.toString(),
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
        break;
      }
    }
  }

  void _OnMenuRightsSucess(UserMenuRightsResponseState state) {
    for (int i = 0; i < state.userMenuRightsResponse.details.length; i++) {
      print("DSFsdfkk" +
          " MenuName :" +
          state.userMenuRightsResponse.details[i].addFlag1.toString());

      IsAddRights = state.userMenuRightsResponse.details[i].addFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsEditRights = state.userMenuRightsResponse.details[i].editFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsDeleteRights = state.userMenuRightsResponse.details[i].delFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
    }
  }

  Widget _buildCount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.blue,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 3),
                child: Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text(
                  "Total Task Duration\t:",
                  style: TextStyle(
                    fontFamily: "Poppins_Regular",
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  // totduration.toStringAsFixed(2),
                  FinalTotalCount == null
                      ? "0 hour : 0 minutes"
                      : FinalTotalCount,
                  style: TextStyle(
                    fontFamily: "Poppins_Regular",
                    fontSize: 15,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showEmailMyDialog(
      List<SharvayaDailyActivityListResponseDetails> model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Sending Email ...!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateDailyActivitySendEmail(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  GenerateDailyActivitySendEmail(
      List<SharvayaDailyActivityListResponseDetails> model,
      BuildContext context123) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(SiteURL +
                        "DailyActivity.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password),
                  ),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;
                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(uri.toString())) {
                        await launch(uri.toString());
                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    String pageTitle = await controller.getTitle() ?? "";
                    setState(() {
                      if (pageTitle == "E-Office-Desk") {
                        Navigator.pop(context);
                        showCommonDialogWithSingleOption(
                          context,
                          "Email Sent Successfully",
                          onTapOfPositiveButton: () {
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        Navigator.pop(context);
                        showCommonDialogWithSingleOption(
                          context,
                          "Email Sending Process Start. Tap One More Time For Email Button And Also Confirm Your Email Configuration!",
                        );
                      }
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint("LoadWeb ${consoleMessage.message}");
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            ),
          ],
        ),
      ),
    );

    /* Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "DailyActivity.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password)),

                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    String pageTitle = "";
                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;
                        print("dfkpageTitle" + value);

                        if (pageTitle == "E-Office-Desk") {
                          Navigator.pop(context);
                          showCommonDialogWithSingleOption(
                              context, "Email Sent Successfully ",
                              onTapOfPositiveButton: () {
                                Navigator.pop(context);
                              });
                        } else {
                          Navigator.pop(context);
                          showCommonDialogWithSingleOption(
                              context, "Email Sending Process Start Tap One More Time For Email Button And Also Confirm Your Email Configuration!");
                        }
                      });
                    });

                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                    }

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
          ],
        ),
      ),
    );*/
  }

  /*void sendEmail(List<SharvayaDailyActivityListResponseDetails> details) async {
    List<String> dailydata = [];
    for (int i = 0; i < details.length; i++) {
      dailydata.add(" => " +
          "Category : " +
          details[i].taskCategory +
          "\nWork Notes : " +
          details[i].taskDescription +
          "\n" +
          " ( " +
          (details[i].taskDuration == 0
              ? "0.00"
              : details[i].taskDuration.toString()) +
          " Hrs )\n\n");
    }

    String ReportToEmail = "";

    String ReportToCC = "";
    String ReportToCC1 = "";
    String ReportToCC2 = "";

    ReportToEmail = "ashish.rathod@sharvayainfotech.com";
    ReportToCC = "jalpa.shah@sharvayainfotech.com";

    if (_offlineLoggedInData.details[0].employeeName == "Dhara") {
      //Dhara
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeName == "Bhavini Desai") {
      //Bhavini
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeName == "Nisha Desai") {
      //Nisha
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeName == "Dev Prajapati") {
      //Dev
      ReportToEmail = "payal.vaghasiya@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC2 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeName == "Payal Vaghasiya") {
      //Payal
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }

    if (_offlineLoggedInData.details[0].employeeName == "Yash Bandhara") {
      //Yash
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }

    if (_offlineLoggedInData.details[0].employeeName == "Shivam Bhadoriya") {
      //Shivam
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeName == "Trilok Patel	") {
      //Trilok
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }

    if (_offlineLoggedInData.details[0].employeeName == "Vedant Domadiya") {
      //Vedant
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    final mailtoLink = Mailto(
      to: [ReportToEmail],
      cc: [ReportToCC, ReportToCC1, ReportToCC2],
      subject: 'Daily Report  ' + edt_FollowupStatus.text,
      body: 'Respected Sir,\n'
              'Daily Report Points\n\n' +
          dailydata
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '\nTotal Hours : ' + TASKTOTALDURATION.text),
    );
    await launch('$mailtoLink');
  }*/

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }
}
