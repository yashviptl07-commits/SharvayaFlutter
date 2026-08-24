import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/speed_test_dart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class InternetSpeedTester extends BaseStatefulWidget {
  static const routeName = '/InternetSpeedTester';

  @override
  _InternetSpeedTesterState createState() =>
      _InternetSpeedTesterState();
}

class _InternetSpeedTesterState
    extends BaseState<InternetSpeedTester>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";

  SpeedTestDart tester = SpeedTestDart();
  List<Server> bestServersList = [];

  double downloadRate = 0;
  double uploadRate = 0;
  double _speedValue = 0;

  bool readyToTest = false;
  bool loadingDownload = false;
  bool loadingUpload = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorDarkYellow;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setBestServers();
    });

    _mainBloc = MainBloc(baseBloc);
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
        },
        listenWhen: (oldState, currentState) {
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
        appBar: NewGradientAppBar(
          title: Text('Internet Speed Tester'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SfRadialGauge(
                    enableLoadingAnimation: true,
                    animationDuration: 4500,
                    axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: 60, ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0, endValue: 20, color: Colors.green),
                        GaugeRange(
                            startValue: 20, endValue: 40, color: Colors.orange),
                        GaugeRange(
                            startValue: 40, endValue: 60, color: Colors.red)
                      ], pointers: <GaugePointer>[
                        NeedlePointer(value: _speedValue)
                      ], annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text(
                                    "${_speedValue.toStringAsFixed(2)} Mb/s",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                            angle: 90,
                            positionFactor: 0.6)
                      ])
                    ]),
                const Text(
                  'Test Upload speed:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (loadingUpload)
                  Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Testing upload speed...'),
                    ],
                  )
                else
                  Text('Upload rate ${uploadRate.toStringAsFixed(2)} Mb/s'),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: loadingUpload
                      ? null
                      : () async {
                    if (!readyToTest || bestServersList.isEmpty) return;
                    await _testUploadSpeed();
                  },
                  child: const Text('Start'),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Test Download Speed:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (loadingDownload)
                  Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Testing download speed...'),
                    ],
                  )
                else
                  Text(
                      'Download rate  ${downloadRate.toStringAsFixed(2)} Mb/s'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: loadingDownload
                      ? null
                      : () async {
                    if (!readyToTest || bestServersList.isEmpty) return;
                    await _testDownloadSpeed();
                  },
                  child: const Text('Start'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _testDownloadSpeed() async {
    setState(() {
      loadingDownload = true;
    });
    final _downloadRate =
    await tester.testDownloadSpeed(servers: bestServersList);
    setState(() {
      downloadRate = _downloadRate;
      _speedValue = downloadRate;
      loadingDownload = false;
    });
  }

  Future<void> _testUploadSpeed() async {
    setState(() {
      loadingUpload = true;
    });

    final _uploadRate = await tester.testUploadSpeed(servers: bestServersList);

    setState(() {
      uploadRate = _uploadRate;
      _speedValue = uploadRate;
      loadingUpload = false;
    });
  }

  Future<void> setBestServers() async {
    final settings = await tester.getSettings();
    final servers = settings.servers;

    final _bestServersList = await tester.getBestServers(
      servers: servers,
    );

    setState(() {
      bestServersList = _bestServersList;
      readyToTest = true;
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

}