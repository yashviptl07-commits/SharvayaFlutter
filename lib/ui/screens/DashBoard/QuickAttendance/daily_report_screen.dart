import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/other/bloc_modules/dashboard/dashboard_user_rights_screen_bloc.dart';
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
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

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

class DailyReport extends BaseStatefulWidget {
  static const routeName = '/DailyReport';

  @override
  _DailyReportState createState() => _DailyReportState();
}

class _DailyReportState extends BaseState<DailyReport>
    with BasicScreen, WidgetsBindingObserver {
  DashBoardScreenBloc _dashBoardScreenBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isSendEmail = false;
  String ConstantMAster = "";
  bool isCurrentTime = true;
  bool is_LocationService_Permission;

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
  ContextMenu contextMenu;
  bool isVisibleRights = false;

  InAppWebViewController webViewController;
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
      ));
  PullToRefreshController pullToRefreshController;
  double progress = 0;
  int prgresss = 0;
  bool permissionGranted;

  @override
  void initState() {
    super.initState();
    _dashBoardScreenBloc = DashBoardScreenBloc(baseBloc);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");

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
    EmailTO.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dashBoardScreenBloc,
      child: BlocConsumer<DashBoardScreenBloc, DashBoardScreenStates>(
        builder: (BuildContext context, DashBoardScreenStates state) {
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
          return super.build(context);
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
        body: Column(
          children: [
            _buildHeader(context, r),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(r.s(16)),
                child: Column(
                  children: [
                    _buildDateCard(context, r),
                    SizedBox(height: r.s(16)),
                    _buildEmailCard(context, r),
                    SizedBox(height: r.s(24)),
                    _buildSendButton(context, r),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _R r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(r.s(20), r.s(50), r.s(20), r.s(24)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff108dcf), Color(0xff0066b3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.s(10)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(r.s(14)),
                ),
                child: const Icon(Icons.email_outlined,
                    color: Colors.white, size: 28),
              ),
              SizedBox(width: r.s(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Report',
                    style: TextStyle(
                      fontSize: r.f(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: r.s(2)),
                  Text(
                    'Send report to your email',
                    style: TextStyle(
                      fontSize: r.f(12),
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(BuildContext context, _R r) {
    return Container(
      padding: EdgeInsets.all(r.s(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(r.s(10)),
            decoration: BoxDecoration(
              color: const Color(0xff108dcf).withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.s(12)),
            ),
            child: Icon(Icons.calendar_today_outlined,
                color: const Color(0xff108dcf), size: r.s(22)),
          ),
          SizedBox(width: r.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Report Date",
                  style: TextStyle(
                    fontSize: r.f(11),
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  DateFormat('dd MMMM yyyy').format(selectedDate),
                  style: TextStyle(
                    fontSize: r.f(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1A2332),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
            decoration: BoxDecoration(
              color: const Color(0xff62bb47).withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.s(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    size: r.s(12), color: const Color(0xff62bb47)),
                SizedBox(width: r.s(4)),
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: r.f(10),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff62bb47),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard(BuildContext context, _R r) {
    return Container(
      padding: EdgeInsets.all(r.s(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.email_outlined,
                  color: const Color(0xff0066b3), size: r.s(20)),
              SizedBox(width: r.s(10)),
              Text(
                "Recipient Email",
                style: TextStyle(
                  fontSize: r.f(14),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1A2332),
                ),
              ),
            ],
          ),
          SizedBox(height: r.s(12)),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffF5F7FA),
              borderRadius: BorderRadius.circular(r.s(12)),
              border: Border.all(color: const Color(0xffE8ECF0)),
            ),
            child: TextField(
              controller: EmailTO,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: "Enter email address",
                hintStyle:
                    TextStyle(fontSize: r.f(13), color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: r.s(14), vertical: r.s(14)),
                prefixIcon: Icon(Icons.person_outline,
                    size: r.s(18), color: Colors.grey.shade500),
              ),
              style:
                  TextStyle(fontSize: r.f(14), color: const Color(0xff1A2332)),
            ),
          ),
          SizedBox(height: r.s(8)),
          Container(
            padding: EdgeInsets.all(r.s(10)),
            decoration: BoxDecoration(
              color: const Color(0xffF0F7FF),
              borderRadius: BorderRadius.circular(r.s(10)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: r.s(14), color: const Color(0xff108dcf)),
                SizedBox(width: r.s(8)),
                Expanded(
                  child: Text(
                    "Daily report will be sent to this email address",
                    style: TextStyle(
                        fontSize: r.f(10), color: const Color(0xff108dcf)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, _R r) {
    return GestureDetector(
      onTap: _onSendPressed,
      child: Container(
        height: r.s(52),
        width: double.infinity,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                "Send Report",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== ORIGINAL METHODS - KEPT EXACTLY THE SAME ====================

  void _onSendPressed() async {
    if (EmailTO.text != "") {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(EmailTO.text);

      if (emailValid == true) {
        String webmethod = SiteURL +
            "/DashboardDaily.aspx?MobilePdf=yes&userid=" +
            LoginUserID +
            "&password=" +
            Password +
            "&emailaddress=" +
            EmailTO.text;
        print("webreq" + webmethod);
        _showMyDialog(context, EmailTO.text);
      } else {
        showCommonDialogWithSingleOption(context, "Email is not valid !",
            positiveButtonTitle: "OK");
      }
    } else {
      showCommonDialogWithSingleOption(context, "Email TO is Required !",
          positiveButtonTitle: "OK");
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    return Future.value(false);
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

  Future<void> _showMyDialog(
      BuildContext dailogContext, String textEmaill) async {
    return showDialog<int>(
      context: dailogContext,
      barrierDismissible: false,
      builder: (BuildContext dailogContextsub) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Please wait ...!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQT(dailogContext, textEmaill),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  GenerateQT(BuildContext dailogContext, String emailTOstr) {
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
                          "/DashboardDaily.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&emailaddress=" +
                          emailTOstr)),
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
                        await launch(url);
                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                    return NavigationActionPolicy.CANCEL;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      islodding = false;
                    });
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
                          Navigator.pop(dailogContext);
                          showCommonDialogWithSingleOption(
                              dailogContext, "Email Sent Successfully ",
                              onTapOfPositiveButton: () {
                            Navigator.pop(dailogContext);
                            Navigator.pop(context);
                          });
                        } else {
                          Navigator.pop(dailogContext);
                          showCommonDialogWithSingleOption(
                              dailogContext, "Please Try Again !");
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
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
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
    );
  }

  void _onMenuRightsResponse(MenuRightsEventResponseState response) {
    for (var i = 0; i < response.menuRightsResponse.details.length; i++) {
      if (response.menuRightsResponse.details[i].menuName == "pgAttendance") {
        isVisibleRights = true;
      }
    }
  }
}
