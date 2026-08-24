import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:soleoserp/main.dart';
import 'package:soleoserp/models/api_requests/company_details/company_details_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/broadcast_msg/share_msg.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class SerialKeyScreen extends BaseStatefulWidget {
  static const routeName = '/SerialKeyScreen';

  _SerialKeyScreenState createState() => _SerialKeyScreenState();
}

class _SerialKeyScreenState extends BaseState<SerialKeyScreen>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  FirstScreenBloc _firstScreenBloc;
  int count = 0;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _IPCotroller = TextEditingController();
  TextEditingController EmailTO = TextEditingController();
  CompanyDetailsResponse _offlineLoggedInData;
  LoginUserDetialsResponse _offlineLoggedInDetailsData;

  String InvalidUserMessage = "";

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SerialKeyDropDown = [];
  bool value = false;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

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
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  int prgresss = 0;
  final urlController = TextEditingController();

  bool isLoading = true;
  bool onWebLoadingStop = true;
  URLRequest urlRequest;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    getIPDropDown();
    _firstScreenBloc = FirstScreenBloc(baseBloc);
    _initPackageInfo();
    getLocationLivePermission();

    FirebaseMessaging.instance.getToken().then((token) async {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          if (state is MasterBaseURLResponseState) {
            _onMasterBaseURLAPIResponse(state);
          }
          if (state is ComapnyDetailsEventResponseState) {
            _onCompanyDetailsCallSucess(state.companyDetailsResponse);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ComapnyDetailsEventResponseState ||
              currentState is MasterBaseURLResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
            right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
            top: 50,
            bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopView(),
            SizedBox(height: 50),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  _onCompanyDetailsCallSucess(CompanyDetailsResponse response) {
    if (response.details.length != 0) {
      SharedPrefHelper.instance.setCompanyData(response);
      _offlineLoggedInData = SharedPrefHelper.instance.getCompanyData();
      SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_REGISTERED, true);

      navigateTo(context, FirstScreen.routeName, clearAllStack: true);

      print("Company Details : " +
          response.details[0].companyName.toString() +
          "");
    } else {
      showCommonDialogWithSingleOption(context, "Invalid SerialKey",
          positiveButtonTitle: "OK");
    }
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          IMG_HEADER_LOGO,
          height: 100,
          width: 100,
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          "Registration",
          style: TextStyle(
            color: colorPrimary,
            fontSize: 48,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Register your account",
          style: TextStyle(
            color: Color(0xff019ee9),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SerialKeyTextField(),
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
            ),
            child: getCommonButton(baseTheme, () {
              print("MobileAppVersion" +
                  " BuildNumber : " +
                  _packageInfo.buildNumber.toString() +
                  " Version : " +
                  _packageInfo.version.toString());
              _onTapOfLogin();
            }, "Register"),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onTapOfLogin() async {
    if (_userNameController.text != "") {
      print("SERRRR" + _userNameController.text.toString().toUpperCase());

      ///Orchid
      if (_userNameController.text.toString().toLowerCase() ==
          "oer2-c9hd-t5pc-gyk3") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.orchid.sharvayaInfotech",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///MMV
      else if (_userNameController.text.toString().toLowerCase() ==
          "harv-mmvs-ayaf-rais") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.sharvayafrenchaichi",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///SK Spices
      else if (_userNameController.text.toString().toLowerCase() ==
              "sk09-spcs-uscf-9t3k" ||
          _userNameController.text.toString().toLowerCase() ==
              "bbbb-bbbb-bbbb-bbbb") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.sharvayainfotech.egroceryshope",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///My GEC
      else if (_userNameController.text.toString().toLowerCase() ==
              "mya6-g9ec-vs3p-h4pl" ||
          _userNameController.text.toString().toLowerCase() ==
              "test-0000-mgcf-0222") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.mygec.sharvayainfotech",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///HIR Building Master
      else if (_userNameController.text.toString().toLowerCase() ==
              "hira-wdvb-plxz-yhbn" ||
          _userNameController.text.toString().toLowerCase() ==
              "test-0000-hirf-0225") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.hirindustries.sharvayainfotech",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///Swastik
      else if (_userNameController.text.toString().toLowerCase() ==
          "sw0t-gla5-ind7-as71") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.swastikglass.sharvayainfotech",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///TTRI
      else if (_userNameController.text.toString().toLowerCase() ==
              "ttgh-34dl-rasb-iq7f" ||
          _userNameController.text.toString().toLowerCase() ==
              "test-0000-ttrf-0218") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.sharvaya.toyotattri",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///AIM
      else if (_userNameController.text.toString().toLowerCase() ==
              "a9gm-ip9s-fqt5-3n7d" ||
          _userNameController.text.toString().toLowerCase() ==
              "test-0000-aimf-0226") {
        showotherclientpropmt(
            context,
            "https://play.google.com/store/apps/details?id=com.sharvaya.customizationk",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      }

      ///E-Ashwa
      else if (_userNameController.text.toString().toLowerCase() ==
              "asha-pura-entr-pise" ||
          _userNameController.text.toString().toLowerCase() ==
              "test-0000-easw-0223") {
        showotherclientpropmt(context, "",
            "This is not your customised application kindly Uninstall this application and install application from play store !",
            positiveButtonTitle: "OK");
      } else {
        if (_userNameController.text.toString().toLowerCase() ==
                "test-0000-solf-0212" ||
            _userNameController.text.toString().toLowerCase() ==
                "c12c-nks1-jk90-as12") {
          showCommonDialogWithSingleOption(context, "In-Active Serial Key!",
              positiveButtonTitle: "OK");
        } else {
          _firstScreenBloc.add(MasterBaseURLCallEvent(CompanyDetailsApiRequest(
              serialKey: _userNameController.text.toString())));
        }
      }
    } else {
      showCommonDialogWithSingleOption(context, "Serial Key field is blank !",
          positiveButtonTitle: "OK");
    }
    //TODO
  }

  Widget SerialKeyTextField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Text("Serial Key",
                style: TextStyle(
                    fontSize: 15,
                    color:
                        colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: Color(0xffE0E0E0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          maxLength: 19,
                          controller: _userNameController,
                          cursorColor: Color(0xFFF1E6FF),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                            ),
                            hintText: "xxxx-xxxx-xxxx-xxxx",
                            border: InputBorder.none,
                            counterStyle: TextStyle(height: double.minPositive),
                            counterText: "",
                          ),
                          onChanged: (String value) async {
                            setState(() {
                              if (count <= _userNameController.text.length &&
                                  (_userNameController.text.length == 4 ||
                                      _userNameController.text.length == 9 ||
                                      _userNameController.text.length == 14)) {
                                _userNameController.text =
                                    _userNameController.text + "-";
                                int pos = _userNameController.text.length;
                                _userNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: pos));
                              } else if (count >=
                                      _userNameController.text.length &&
                                  (_userNameController.text.length == 4 ||
                                      _userNameController.text.length == 9 ||
                                      _userNameController.text.length == 14)) {
                                _userNameController.text =
                                    _userNameController.text.substring(
                                        0, _userNameController.text.length - 1);
                                int pos = _userNameController.text.length;
                                _userNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: pos));
                              }
                              count = _userNameController.text.length;
                            });
                          })),
                ],
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Text("IP",
                      style: TextStyle(
                          fontSize: 15,
                          color:
                              colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                Card(
                  elevation: 5,
                  color: Color(0xffE0E0E0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          maxLength: 19,
                          controller: _IPCotroller,
                          cursorColor: Color(0xFFF1E6FF),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                            ),
                            hintText: "xxxx-xxxx-xxxx-xxxx",
                            border: InputBorder.none,
                            counterStyle: TextStyle(height: double.minPositive),
                            counterText: "",
                          ),
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //HPL
  void _onMasterBaseURLAPIResponse(MasterBaseURLResponseState state) {
    SharedPrefHelper.instance.setBaseURL("http://192.168.1.43:130/");

    if (SharedPrefHelper.instance.getBaseURL() != "") {
      _firstScreenBloc.add(CompanyDetailsCallEvent(CompanyDetailsApiRequest(
          serialKey: _userNameController.text.toString())));
    } else {
      showCommonDialogWithSingleOption(context, "Something Went Wrong !",
          positiveButtonTitle: "OK");
    }
  }

  // void _onMasterBaseURLAPIResponse(MasterBaseURLResponseState state) {
  //   SharedPrefHelper.instance
  //       .setBaseURL(state.masterBaseURLResponse.details[0].baseURL + "/");

  //   if (SharedPrefHelper.instance.getBaseURL() != "") {
  //     _firstScreenBloc.add(CompanyDetailsCallEvent(CompanyDetailsApiRequest(
  //         serialKey: _userNameController.text.toString())));
  //   } else {
  //     showCommonDialogWithSingleOption(context, "Something Went Wrong !",
  //         positiveButtonTitle: "OK");
  //   }
  // }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future showotherclientpropmt(
    BuildContext context,
    String PlaystoreLink,
    String message1, {
    String positiveButtonTitle = "OK",
    GestureTapCallback onTapOfPositiveButton,
    bool useRootNavigator = true,
    EdgeInsetsGeometry margin: const EdgeInsets.only(left: 20, right: 20),
  }) async {
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
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        color: colorGrayVeryDark,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          message1,
                          style: TextStyle(
                            color: colorBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: getCommonButton(baseTheme, () async {
                                try {
                                  await launch(
                                    PlaystoreLink,
                                  );
                                } catch (e) {
                                  showAppNotFoundFromPlayStore(context,
                                      "Application is not available on play store Kindly Visit Support Person !",
                                      positiveButtonTitle: "OK");
                                }
                              }, "Visit Play Store",
                                  backGroundColor: colorPrimary, radius: 25.0),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: getCommonButton(baseTheme, () {
                                navigateTo(context, SerialKeyScreen.routeName,
                                    clearAllStack: true);
                              }, "Close",
                                  backGroundColor: colorPrimary, radius: 25.0),
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

  void VisitPlayStore(String playstoreLink) async {
    final url = playstoreLink;

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
      );
    }
  }

  Future showAppNotFoundFromPlayStore(
    BuildContext context,
    String message1, {
    String positiveButtonTitle = "OK",
    GestureTapCallback onTapOfPositiveButton,
    bool useRootNavigator = true,
    EdgeInsetsGeometry margin: const EdgeInsets.only(left: 20, right: 20),
  }) async {
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
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          message1,
                          style: TextStyle(
                            color: colorBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: getCommonButton(baseTheme, () async {
                                SendMeaageToWhatsApp(context, "7310147026");
                              }, "Contact",
                                  backGroundColor: colorPrimary, radius: 25.0),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: getCommonButton(baseTheme, () {
                                navigateTo(context, SerialKeyScreen.routeName,
                                    clearAllStack: true);
                              }, "Close",
                                  backGroundColor: colorPrimary, radius: 25.0),
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

  void SendMeaageToWhatsApp(BuildContext conetxt, String mobileNumber) {
    showCommonDialogWithTwoOptions(
        conetxt,
        "Do you have Two Accounts of WhatsApp ?" +
            "\n" +
            "Select one From below Option !",
        positiveButtonTitle: "WhatsApp",
        onTapOfPositiveButton: () {
          Navigator.pop(conetxt);
          onButtonTap(Share.whatsapp_personal, mobileNumber);
        },
        negativeButtonTitle: "Business",
        onTapOfNegativeButton: () {
          Navigator.pop(conetxt);

          _launchWhatsAppBuz(mobileNumber);
          //onButtonTap(Share.whatsapp_business,model);
        });
  }

  Future<void> onButtonTap(Share share, String MobileNumber) async {
    String response;
    debugPrint(response);
  }

  void getIPDropDown() {
    arr_ALL_Name_ID_For_ModeOfTransfer.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "http://122.169.111.101:108/";
      } else if (i == 1) {
        all_name_id.Name = "http://208.109.14.134:83/";
      }
      arr_ALL_Name_ID_For_ModeOfTransfer.add(all_name_id);
    }
  }

  void _launchWhatsAppBuz(String MobileNo) async {
    String msg = "Dear Support Team , \nWe Are Using This Serial Key : " +
        _userNameController.text.toString() +
        "\nBut Application is Not Available On Play Store \nKindly Share Application Link Please !";

    await launch(
        "https://wa.me/${MobileNo.length == 10 ? "+91" + MobileNo : MobileNo}?text=$msg");
  }

  Future<bool> getLocationLivePermission() async {
    // ✅ Check service enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    // ✅ Step 1: Foreground permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // must go to settings manually
    }

    // ✅ Step 2: Background permission (if app requires always-on)
    if (permission == LocationPermission.whileInUse) {
      // request background via permission_handler
      if (!await Permission.locationAlways.isGranted) {
        await Permission.locationAlways.request();
      }
    }

    // ✅ Permission granted
    Position position = await Geolocator.getCurrentPosition();
    Latitude = position.latitude.toString();
    Longitude = position.longitude.toString();
    return true;
  }

  Future<void> checkPermissionStatus() async {
    // foreground
    bool granted = await Permission.location.isGranted;
    bool permanentlyDenied = await Permission.location.isPermanentlyDenied;

    // background
    bool backgroundGranted = await Permission.locationAlways.isGranted;
    bool backgroundPermanentlyDenied =
        await Permission.locationAlways.isPermanentlyDenied;

    // ✅ Foreground request
    if (!granted && !permanentlyDenied) {
      await Permission.location.request();
    }

    // ✅ Background request (separate step)
    if (granted && !backgroundGranted && !backgroundPermanentlyDenied) {
      await Permission.locationAlways.request();
    }

    // restricted
    if (await Permission.location.isRestricted) {
      await Permission.location.request();
    }

    // battery optimization
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    // ✅ Update global flag
    is_LocationService_Permission = granted || backgroundGranted;

    // ✅ Ensure service is ON
    if (is_LocationService_Permission) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }
    }
  }
}
