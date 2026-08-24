import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/repairing_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

/// check In Github Push

class RepairingDetailsListScreenArgument {

  RepairingDetailsListScreenArgument();
}

class RepairingDetailsListScreen extends BaseStatefulWidget {
  static const routeName = '/RepairingDetailsListScreen';
  final RepairingDetailsListScreenArgument arguments;

  RepairingDetailsListScreen(this.arguments);
  @override
  _RepairingDetailsListScreenState createState() =>
      _RepairingDetailsListScreenState();
}

class _RepairingDetailsListScreenState
    extends BaseState<RepairingDetailsListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  final TextEditingController TotalSumOfBase = TextEditingController();
  final TextEditingController TotalSumOfScore = TextEditingController();

  String LoginUserID;
  String CompanyID;

  List<RepairingDetailsTable> _productList = [];
  double sizeboxsize = 12;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  List<File> MultipleVideoList = [];
  List<String> MultipleBase64List = [];

  MainBloc _mainBloc;
  int _productID = 0;
  bool permissionGranted;
  String base64img = "";
  bool isProductExist = false;
  final imagepicker = ImagePicker();
  Function onTapOfBack;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _mainBloc = MainBloc(baseBloc);

    TotalSumOfBase.text;
    TotalSumOfScore.text;

    print("mdhcvdiu" + _productList.length.toString());

    screenStatusBarColor = colorWhite;
    if (widget.arguments != null) {}

    getProduct();

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is UpdateAuditActivityDetailsTableState) {
            _SpecificationSaveResponse(state);
          }
          /*if (state is DeleteByPkIdResponseState) {
            _OnGetQuotationProductList(state);
          }

          if (state is UpdateAuditActivityImageUploadDetailsTableState) {
            _AuditActivityUploadImageSaveResponse(state);
          }*/
        },
        listenWhen: (oldState, currentState) {
          if (
              currentState is UpdateAuditActivityDetailsTableState) {
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
          title: Text('Repairing details List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () {
                if (onTapOfBack == null) {
                  Navigator.of(context).pop();
                } else {
                  onTapOfBack();
                }
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () async {
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
                    getProduct();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        Expanded(child: _buildContactsListView())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (onTapOfBack == null) {
      Navigator.of(context).pop();
    } else {
      onTapOfBack();
    }
  }

  Widget _buildContactsListView() {
    if (_productList.length != 0) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _productList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED
          /*height: 200,
              width: 200*/
        ),
      );
    }
  }

  Future<void> getProduct() async {
    _productList.clear();

    _productList.addAll(
        await OfflineDbHelper.getInstance().getRepairing());

    setState(() {});
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    RepairingDetailsTable model = _productList[index];

    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: model.CheckFlag == "true"
                            ? colorGreen
                            : colorRED,
                        width: 3.0),
                  ),
                  color: colorWhiteMix,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //margin: EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Description",
                                                    style: TextStyle(
                                                        fontStyle:
                                                        FontStyle.italic,
                                                        color: colorBlack,
                                                        fontSize: 10,
                                                        //fontWeight: FontWeight.bold,
                                                        letterSpacing: .3),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Card(
                                                    elevation: 3,
                                                    child: Container(
                                                      child: TextFormField(
                                                        enabled: false,
                                                        initialValue:
                                                        model.CheckListName,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            model.CheckListName =
                                                                newValue;
                                                          });
                                                        },
                                                        style: TextStyle(
                                                          color: colorBlack,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 12,
                                                          letterSpacing: .3,
                                                        ),
                                                        decoration:
                                                        InputDecoration(
                                                          contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10),
                                                          border: InputBorder
                                                              .none, // Hide the default border
                                                          hintText:
                                                          'Enter Base rating', // Placeholder text
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Checkbox(
                                          value: model.CheckFlag == "true",
                                          onChanged: (value) {
                                            setState(() {
                                              model.CheckFlag = value.toString();
                                              if (model.CheckFlag == "false") {
                                                model.CheckFlag = "false";
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Center(
                                        child: getCommonButton(baseTheme, () {
                                          showCommonDialogWithTwoOptions(
                                              context,
                                              "Are you sure you want to Save Save This Details ?",
                                              negativeButtonTitle: "No",
                                              positiveButtonTitle: "Yes",
                                              onTapOfPositiveButton: () {
                                                Navigator.of(context).pop();
                                                _mainBloc.add(UpdateAuditActivityDetailsTableEvent(
                                                    context,
                                                    RepairingDetailsTable(
                                                        "0",//String pkID,
                                                        model.ParentID,//String ParentID,
                                                        model.RepairingNo,//String RepairingNo,
                                                        model.CheckListID,//String CheckListID,
                                                        model.CheckListName,//String CheckListName,
                                                        model.CheckFlag,//String CheckFlag,
                                                        LoginUserID, //InquiryStatus
                                                        CompanyID.toString(), //InquiryStatus
                                                        id: model.id)));
                                              });
                                        }, "Save",
                                            backGroundColor:
                                            model.CheckFlag == "true"
                                                ? colorGreen
                                                : colorRED,
                                            height: 40,
                                            width: 100),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  )),
            ),
            SizedBox(height: 5),
            Divider(
              thickness: 1.0,
              color: colorBlack,
            ),
            //SizedBox(height: 5),
          ],
        ));
  }

  void _SpecificationSaveResponse(UpdateAuditActivityDetailsTableState state) {
    //Navigator.of(state.context).pop(state.response.toString());
    //Navigator.of(context).pop();
  }

}

