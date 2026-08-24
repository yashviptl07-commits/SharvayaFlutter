import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soleoserp/TestingLocation/location_service/logic/location_controller/location_controller_cubit.dart';
import 'package:soleoserp/TestingLocation/tools/background_service.dart';
import 'package:soleoserp/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:soleoserp/main.dart';
import 'package:soleoserp/models/api_requests/login/login_user_details_api_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/todo_bg_services.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/authentication/serial_key_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

class FirstScreen extends BaseStatefulWidget {
  static const routeName = '/firstScreen';

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends BaseState<FirstScreen>
    with BasicScreen, WidgetsBindingObserver {
  Position position;
  final _formKey = GlobalKey<FormState>();
  FirstScreenBloc _firstScreenBloc;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInDetailsData;
  String InvalidUserMessage = "";
  bool _isObscure = true;
  String SiteUrl = "";
  bool is_dealer = false;
  int _selectedIndex = 0;
  int CompanyID = 0;
  String ConstantMAster = "";
  BackgroundServiceForTodo backgroundServiceForTodo;
  BackgroundService backgroundService;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _selectedIndex = 0;
    getLocationLivePermission();

    SiteUrl = _offlineCompanyData.details[0].siteURL;
    CompanyID = _offlineCompanyData.details[0].pkId;
    _firstScreenBloc = FirstScreenBloc(baseBloc);
    backgroundServiceForTodo = BackgroundServiceForTodo();
    backgroundService = BackgroundService();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          //handle states

          if (state is ConstantResponseState) {
            _onGetDMSConstant(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ConstantResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          if (state is LoginUserDetialsCallEventResponseState) {
            _onLoginCallSuccess(state.response);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LoginUserDetialsCallEventResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              SizedBox(height: 20),
              _buildDelaerLoginForm(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onLoginCallSuccess(LoginUserDetialsResponse response) async {
    if (response.details.isEmpty) return;

    final userDetails = response.details[0];

    if (userDetails.activeFlagDesc == "Inactive") {
      showCommonDialogWithSingleOption(
        Globals.context,
        "User is Inactive",
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
          _userNameController.clear();
          _passwordController.clear();
          Navigator.pop(context);
        },
      );
      return;
    }

    // Save login status & user data
    SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);
    SharedPrefHelper.instance.setLoginUserData(response);

    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineLoggedInDetailsData = SharedPrefHelper.instance.getLoginUserData();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        "CompanyId", _offlineCompanyData.details[0].pkId.toString());
    await preferences.setString("LoginUserID", userDetails.userID);
    await preferences.setString(
        "ApiKey", _offlineCompanyData.details[0].baseURL);
    await preferences.setString("userID", response.details[0].userID);
    await preferences.setString(
        "EmployeeId", response.details[0].employeeID.toString());

    // 👉 Save cubit before navigation (IMPORTANT)
    final locationCubit = context.read<LocationControllerCubit>();

    // Navigate immediately
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);

    // Run background tasks safely without context
    Future.microtask(() async {
      await Fluttertoast.showToast(
          msg: "Setting up your account in background...");

      // FCM token
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await preferences.setString("TokenSP", token);
      }

      // Serial key checks
      if (_isSpecialSerialKeyForTodo(userDetails.serialKey)) {
        await _initializeBackgroundServiceForTodo();
      } else if (_offlineCompanyData.details[0].LiveLocationFlag) {
        print(_offlineCompanyData.details[0].LiveLocationFlag);
        await Fluttertoast.showToast(
            msg: "Special license detected, initializing service...");

        final permission = await locationCubit.enableGPSWithPermission();

        if (permission) {
          await locationCubit.locationFetchByDeviceGPS();
          await _initializeBackgroundService();
        }
      }
    });
  }

  /// Helper to check special serial keys
  bool _isSpecialSerialKeyForTodo(String key) {
    if (key == null || key == "") return false;
    final formattedKey = key.toUpperCase();
    return ["SHLO-K34S-ION1-ND8S"].contains(formattedKey);
  }

  /// Helper to initialize background service For TodoActivity
  Future<void> _initializeBackgroundServiceForTodo() async {
    await backgroundServiceForTodo.initializeServiceTodo();
    backgroundServiceForTodo.setServiceAsForeground();
  }

  /// Helper to initialize background service For Location Tracking
  Future<void> _initializeBackgroundService() async {
    await backgroundService.initializeService();
    backgroundService.setServiceAsForeground();
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onDoubleTap: () {
            showCommonDialogWithSingleOption(context,
                "Your BaseURL : " + SharedPrefHelper.instance.getBaseURL(),
                positiveButtonTitle: "OK");
          },
          child: Container(
            width: 200.0,
            height: 100.0,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                  child: Center(
                child: Image.network(
                    SiteUrl + "/images/companylogo/CompanyLogo.png"),
              )),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Login",
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
          "Log in to your existent account",
          style: TextStyle(
            color: Color(0xff019ee9),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDelaerLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          getCommonTextFormField(
            context,
            baseTheme,
            title: "Username",
            hint: "enter username",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: ImageIcon(
              Image.asset(
                IC_USERNAME,
                color: colorPrimary,
                width: 10,
                height: 10,
              ).image,
            ),
            controller: _userNameController,
          ),
          SizedBox(
            height: 25,
          ),
          getCommonTextFormField(
            context,
            baseTheme,
            title: "Password",
            hint: "enter password",
            obscureText: _isObscure,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            controller: _passwordController,
          ),
          SizedBox(
            height: 52,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: getCommonButton(baseTheme, () async {
                  _onTapOfLogin();
                }, "Login", radius: 30, backGroundColor: colorPrimary),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: getCommonButton(baseTheme, () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.setString("TokenSP", "");

                  final service = FlutterBackgroundService();
                  service.invoke("stopService");
                  setState(() {});
                  backgroundServiceForTodo.stopService();
                  backgroundService.stopService();
                  await context
                      .read<LocationControllerCubit>()
                      .stopLocationFetch();
                  _onTapOfRegister();
                }, "Registration", radius: 30, backGroundColor: colorPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTapOfLogin() {
    if (_userNameController.text != "") {
      if (_passwordController.text != "") {
        final service = FlutterBackgroundService();
        service.invoke("stopService");
        SharedPrefHelper.instance.prefs
            .setString("Is_Dealer", _selectedIndex == 0 ? "Company" : "Dealer");

        _firstScreenBloc.add(LoginUserDetailsCallEvent(
            LoginUserDetialsAPIRequest(
                userID: _userNameController.text.toString(),
                password: _passwordController.text.toString(),
                companyId: _offlineCompanyData.details[0].pkId)));
      } else {
        showCommonDialogWithSingleOption(context, "Password Is Required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "UserName Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
    //TODO
  }

  void _onTapOfRegister() async {
    SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_REGISTERED, false);
    await SharedPrefHelper.instance
        .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
    navigateTo(context, SerialKeyScreen.routeName, clearAllStack: true);
  }

  void _onGetDMSConstant(ConstantResponseState state) {
    print("ConstantValue" + state.response.details[0].value.toString());

    ConstantMAster = state.response.details[0].value.toString();
  }

  Future<void> getLocationLivePermission() async {
    // Check if service is ON
    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await geolocator.Geolocator.openLocationSettings();
      throw ('Location services are disabled.');
    }

    // Foreground check
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();

    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        throw ('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // cannot re-request, send to settings
      await openAppSettings();
      throw ('Location permissions are permanently denied. Please enable them from Settings.');
    }

    // Foreground granted → try background upgrade if needed
    if (permission == geolocator.LocationPermission.whileInUse) {
      // request background explicitly (needs permission_handler)
      if (!await Permission.locationAlways.isGranted) {
        await Permission.locationAlways.request();
      }
    }

    // Get location (works for whileInUse or always)
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition();

    Latitude = position.latitude.toString();
    Longitude = position.longitude.toString();
  }
}
