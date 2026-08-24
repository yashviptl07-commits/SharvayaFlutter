// ignore_for_file: missing_return

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/materail_outward_export_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_delete_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_document_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_delete_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_list_response.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/maintenance_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_add_update/maintenance_add_update_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_header_screen/header_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/ui/widgets/new_common_widget.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenanceListScreen extends BaseStatefulWidget {
  static const routeName = '/MaintenanceListScreen';

  @override
  _MaintenanceListScreenState createState() =>
      _MaintenanceListScreenState();
}

class _MaintenanceListScreenState
    extends BaseState<MaintenanceListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  Function refreshList;
  MaintenanceListResponse _listResponse;
  int _pageNo = 0;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHieght = 50;
  bool isDeleteVisible = true;
  int selected = 0;
  bool isExpand = false;

  final TextEditingController edt_CustomerName = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String SiteURL = "";
  String Password = "";
  final urlController = TextEditingController();
  URLRequest urlRequest;
  String url = "";
  double progress = 0;
  int prgresss = 0;
  PullToRefreshController pullToRefreshController;
  bool onWebLoadingStop = true;
  bool isLoading = true;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

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

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password = _offlineLoggedInData.details[0].userPassword;
    _mainBloc = MainBloc(baseBloc);
    isExpand = false;
    edt_CustomerName.text = "";

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

    _mainBloc.add(MaintenanceListCallEvent(
        1,
        MaintenanceListRequest(
            pkID: "0",
            Status : "",
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: 1,
            PageSize: 10,
            CompanyId: CompanyID.toString())));

    getUserRights(_menuRightsResponse);

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) =>  _mainBloc..add(MaintenanceListCallEvent(
          1,
          MaintenanceListRequest(
              pkID: "0",
              Status : "",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: 1,
              PageSize: 10,
              CompanyId: CompanyID.toString()))),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is MaintenanceListResponseState) {
            _onMaterialOutwardListResponseSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MaintenanceListResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          //_onDeleteBankVoucher
          if (state is MaintenanceDeleteCallResponseState) {
            _onDeleteMaterialOutward(state);
          }
          if (state is SalesBillPDFGenerateResponseState) {
            _onGenerateSalesBillPDFCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesBillPDFGenerateResponseState ||
              currentState is MaintenanceDeleteCallResponseState) {
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
        backgroundColor: Colors.blue.shade50,
        appBar: NewGradientAppBar(
          title: Text('AMC'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () async {
                await _onTapOfDeleteALLProduct();
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  return showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Wrap(
                          children: [
                            ListTile(
                              // leading: Icon(Icons.share),
                              title: Center(
                                child: Text(
                                  "~~~Filter~~~",
                                  style: TextStyle(color: colorBlack),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              color: colorBlack,
                            ),
                            Container(
                              height: 5,
                            ),
                            Container(
                              height: 10,
                            ),
                            ListTile(
                              // leading: Icon(Icons.copy),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Search content",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorBlack,
                                          fontWeight: FontWeight
                                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Card(
                                    elevation: 5,
                                    color: colorWhite,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Container(
                                      height: 50,
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15),
                                      width: double.maxFinite,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: edt_CustomerName,
                                              style: TextStyle(
                                                  color: Colors
                                                      .black, // <-- Change this
                                                  fontWeight: FontWeight.bold, fontSize: 15),
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 15,
                                                    bottom: 11,
                                                    top: 11,
                                                    right: 15),
                                                hintText: "Tap to search content",
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.search,
                                            color: colorGrayDark,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                            ),
                            ListTile(
                              title: Center(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: getCommonButton(baseTheme, () {
                                          Navigator.pop(context);
                                          _mainBloc.add(MaintenanceListCallEvent(
                                              1,
                                              MaintenanceListRequest(
                                                  pkID: "0",
                                                  Status : "",
                                                  LoginUserID: LoginUserID,
                                                  SearchKey: edt_CustomerName.text,
                                                  PageNo: 1,
                                                  PageSize: 10,
                                                  CompanyId: CompanyID.toString())));
                                        }, "Submit", radius: 10),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: getCommonButton(baseTheme, () {
                                          Navigator.pop(context);
                                        }, "Close", radius: 10),
                                      ),
                                    ],
                                  )),
                            ),
                            Container(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SI0F-0208" || _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "BINE-KARS-EDJT-CVPL"
                ? IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();

                  navigateTo(context, MaintenanceAddEditScreen.routeName,
                      clearAllStack: true);
                })
                : Container(),
            SizedBox(width: 10)
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
                    _mainBloc.add(MaintenanceListCallEvent(
                        1,
                        MaintenanceListRequest(
                            pkID: "0",
                            Status : "",
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            PageNo: 1,
                            PageSize: 10,
                            CompanyId: CompanyID.toString())));

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    child: Column(
                      children: [Expanded(child: _buildInquiryList())],
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

/*  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }*/

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
          MaintenanceDetails model = _listResponse.details[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visit ID and Complaint No
                  MultipleList(
                    label: "AMC Code",
                    value: model.inquiryNo.toString(),
                    icon: Icon(Icons.badge, color: Colors.blueAccent),
                    label1: "Customer Name",
                    value1: model.customerName.getFormattedDate(
                        fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy"),
                    icon1: Icon(Icons.date_range, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 15),
                  ChetGptKiKrupa(
                    label: "Sales Executive",
                    value: model.createdBy,
                    icon: Icon(Icons.badge, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          String printHeaderYes = SiteURL +
                              "/contractinfo.aspx?PrintHeader=yes&MobilePdf=yes&userid=" +
                              LoginUserID +
                              "&password=" +
                              Password +
                              "&pQuotID=" +
                              model.pkID.toString();

                          print("PrintHeaderYES" + "  PDF : " + printHeaderYes);

                          await _showMyDialog(model, printHeaderYes);
                        },
                        icon: Icon(Icons.picture_as_pdf, color: Colors.white, size: 18),
                        label: Text(
                          "pdf",
                          style: TextStyle(fontSize: 14), // Smaller text size
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5), // Less padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(100, 30), // Adjust size of the button
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Edit and Delete Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IsEditRights == true
                          ? ElevatedButton.icon(
                        onPressed: () {
                          _onTapOfEditData(model);
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text("Edit"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      )
                          : Container(),
                      IsDeleteRights == true
                          ? ElevatedButton.icon(
                        onPressed: () {
                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to delete this record?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                                _mainBloc.add(MaintenanceDeleteCallEvent(
                                    MaintenanceDeleteRequest(
                                      pkID: model.pkID,
                                      CompanyId: CompanyID.toString(),
                                    )));
                              });
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
        itemCount: _listResponse.details.length,
      ),
    );
  }

/*  ExpantionCustomer(BuildContext context, int index) {
    MaintenanceDetails model =  _listResponse.details[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: Colors.grey.shade200,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: colorBlack,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // Use Expanded to allow the text to wrap onto new lines
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer Name",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorBlack,
                            fontSize: 10,
                          )),
                      // Wrap the value text to a new line if it exceeds two lines
                      Text(model.customerName == null ? "": model.customerName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: colorBlack,
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String printHeaderYes = SiteURL +
                              "/contractinfo.aspx?PrintHeader=yes&MobilePdf=yes&userid=" +
                              LoginUserID +
                              "&password=" +
                              Password +
                              "&pQuotID=" +
                              model.pkID.toString();

                          print("PrintHeaderYES" + "  PDF : " + printHeaderYes);

                          await _showMyDialog(model, printHeaderYes);
                        },
                        child: Container(
                          child: Image.asset(
                            PDF_ICON,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.numbers,
                                  color: colorBlack,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  // Use Expanded to allow the text to wrap onto new lines
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("AMC Code",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 10,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(model.inquiryNo,
                                          maxLines:
                                          max(0, 100), // Maximum of 2 lines
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.numbers,
                                  color: colorBlack,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  // Use Expanded to allow the text to wrap onto new lines
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("IMEI",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 10,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(model.iMEINo,
                                          maxLines:
                                          max(0, 100), // Maximum of 2 lines
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: colorBlack,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("Contact",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorBlack,
                                                    fontSize: 10,
                                                  )),
                                              Text(
                                                  model.contactNumber, //put your own long text here.
                                                  maxLines: 3,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: colorBlack,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: colorBlack,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("Sales Executive	",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorBlack,
                                                    fontSize: 10,
                                                  )),
                                              Text(
                                                  model.createdBy, //put your own long text here.
                                                  maxLines: 3,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: colorBlack,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: colorBlack,
            ),
            SizedBox(
              height: 15,
            ),
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SI0F-0208" || _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "BINE-KARS-EDJT-CVPL"
                ?
            Row(
              children: [
                Visibility(
                  visible: IsEditRights,
                  child: Flexible(
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            //MaterialOutwardListMainResponseDetails

                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.edit,
                                size: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colorWhite),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Visibility(
                  visible: IsDeleteRights,
                  child: Flexible(
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        onPressed: () {

                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.delete,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colorWhite),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ) : Container(),
            SizedBox(
              height: 15,
            )
          ],
        ));
  }*/

  void _onInquiryListPagination() {
    _mainBloc.add(MaintenanceListCallEvent(
        /*_pageNo+*/1,
        MaintenanceListRequest(
            pkID: "0",
            Status : "",
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: 1/*(_pageNo+1).toString()*/,
            PageSize: 10,
            CompanyId: CompanyID.toString())));
  }

/*  Widget _buildInquiryList() {
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
  }*/

  void _onMaterialOutwardListResponseSuccess(MaintenanceListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _listResponse = state.maintenanceListResponse;
      } else {
        _listResponse.details.addAll(state.maintenanceListResponse.details);
      }
      _pageNo = state.newPage;
    }

    getUserRights(_menuRightsResponse);
  }

  void _onDeleteMaterialOutward(MaintenanceDeleteCallResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);

          _mainBloc.add(MaintenanceListCallEvent(
              1,
              MaintenanceListRequest(
                  pkID: "0",
                  Status : "",
                  LoginUserID: LoginUserID,
                  SearchKey: edt_CustomerName.text,
                  PageNo: 1,
                  PageSize: 10,
                  CompanyId: CompanyID.toString())));
        });
  }

  void _onTapOfEditData(MaintenanceDetails model) async {

    navigateTo(context, MaintenanceAddEditScreen.routeName,
        arguments: MaintenanceAddEditScreenArguments(model))
        .then((value) {
      _mainBloc.add(MaintenanceListCallEvent(
          1,
          MaintenanceListRequest(
              pkID: "0",
              Status : "",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: 1,
              PageSize: 10,
              CompanyId: CompanyID.toString())));
    });
  }


  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLMaintenanceProduct();
  }

  Future<void> _showMyDialog(
      MaintenanceDetails model, String printWebURL) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait..!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQT(model, context123, printWebURL),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  GenerateQT(MaintenanceDetails model,
      BuildContext context123, String printWebURL) {
    return Center(
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
                        "/contractinfo.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password +
                        "&pQuotID=" +
                        model.pkID.toString())),
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
                shouldOverrideUrlLoading: (controller, navigationAction) async {
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
                    this.url = url.toString();
                    urlController.text = this.url;
                  });

                  String pageTitle = "";

                  controller.getTitle().then((value) {
                    setState(() {
                      pageTitle = value;

                      print("sdf567" + pageTitle);
                    });
                  });

                  showCommonDialogWithSingleOption(
                      context, "ContractInfo PDF Generated Successfully ",
                      onTapOfPositiveButton: () {
                        Navigator.of(context).pop();

                        Navigator.of(context123).pop();
                        _mainBloc.add(SalesBillPDFGenerateCallEvent(
                            SalesBillPDFGenerateRequest(
                                CompanyId: CompanyID.toString(),
                                InvoiceNo: model.inquiryNo)));
                        //Navigator.pop(context);
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
                    // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                  }

                  //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Lottie.asset('assets/lang/sample_kishan_two.json',
                width: 100, height: 100),
          )
        ],
      ),
    );
  }

  void _onGenerateSalesBillPDFCallSuccess(
      SalesBillPDFGenerateResponseState state) {
    // _launchURL(state.response.details[0].column1.toString());

    navigateTo(context, PDFViewerScreen.routeName,
        arguments: PDFViewerScreenArguments(
            state.response.details[0].column1.toString()))
        .then((value) {
      _mainBloc.add(MaintenanceListCallEvent(
          1,
          MaintenanceListRequest(
              pkID: "0",
              Status : "",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: 1,
              PageSize: 10,
              CompanyId: CompanyID.toString())));
    });
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgOutward") {
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
}
