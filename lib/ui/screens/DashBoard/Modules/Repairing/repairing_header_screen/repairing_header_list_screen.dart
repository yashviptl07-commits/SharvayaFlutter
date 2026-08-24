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
import 'package:soleoserp/models/api_requests/repairing_request/repairing_delete_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_list_response.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_header_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_header_screen/header_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class RepairingListMainScreen extends BaseStatefulWidget {
  static const routeName = '/RepairingListMainScreen';

  @override
  _RepairingListMainScreenState createState() => _RepairingListMainScreenState();
}

class _RepairingListMainScreenState
    extends BaseState<RepairingListMainScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  Function refreshList;
  RepairingListResponse _listResponse;
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

  List<File> documentList = [];
  List<File> documentListForSlip = [];
  int FinalTotalCount = 0;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  List<ALL_Name_ID> fileListName = [];
  List<ALL_Name_ID> fileListName1 = [];
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

    _mainBloc.add(RepairingListCallEvent(
        1,
        RepairingListRequest(
            pkID: "0",
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: "1",
            PageSize: "10",
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
      create: (BuildContext context) => _mainBloc..add(RepairingListCallEvent(
          1,
          RepairingListRequest(
              pkID: "0",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: "1",
              PageSize: "10",
              CompanyId: CompanyID.toString()))),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is RepairingListResponseState) {
            _onMaterialOutwardListResponseSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is RepairingListResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          //_onDeleteBankVoucher
          if (state is RepairingDeleteCallResponseState) {
            _onDeleteMaterialOutward(state);
          }
          if (state is SalesBillPDFGenerateResponseState) {
            _onGenerateSalesBillPDFCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesBillPDFGenerateResponseState ||
              currentState is RepairingDeleteCallResponseState) {
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
          title: Text('Repairing'),
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
                  Icons.water_damage_sharp,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
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
                    _mainBloc.add(RepairingListCallEvent(
                        1,
                        RepairingListRequest(
                            pkID: "0",
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            PageNo: "1",
                            PageSize: "10",
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                /* edt_FollowupEmployeeList.text = "";
                _onTapOfSearchView();*/
                return showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
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
                                style: TextStyle(color: colorPrimary),
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            color: colorLightGray,
                          ),
                          Container(
                            height: 5,
                          ),
                          /*ListTile(
                            // leading: Icon(Icons.copy),
                            title: _buildSearchView(),
                          ),*/
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
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight
                                            .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                    ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  elevation: 5,
                                  color: colorLightGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: edt_CustomerName,
                                            style: TextStyle(
                                                color: Colors
                                                    .black, // <-- Change this

                                                fontWeight: FontWeight.bold),
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
                            //leading: Icon(Icons.edit),
                            title: Center(
                                child: Row(
                              children: [
                                Flexible(
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context);
                                    _mainBloc.add(RepairingListCallEvent(
                                        1,
                                        RepairingListRequest(
                                            pkID: "0",
                                            LoginUserID: LoginUserID,
                                            SearchKey: edt_CustomerName.text,
                                            PageNo: "1",
                                            PageSize: "10",
                                            CompanyId: CompanyID.toString())));
                                  }, "Submit", radius: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context);
                                  }, "Close", radius: 15),
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
              },
              label: Image.asset(
                CUSTOM_SETTING,
                color: Colors.white,
                height: 32,
                width: 32,
              ),
              backgroundColor: colorPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: IsAddRights,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();

                  navigateTo(context, RepairingAddEditMainScreen.routeName,
                      clearAllStack: true);
                },
                label: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
                backgroundColor: colorPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    RepairingListResponseDetails model = _listResponse.details[index];

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
                        Text(model.customerName,
                            maxLines: max(0, 100), // Maximum of 2 lines
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
            subtitle: Row(
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
                                  Icons.calendar_month,
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
                                      Text("Date",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 10,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.repairingDate.getFormattedDate(
                                              fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                              toFormat:
                                                  "dd-MM-yyyy "), //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
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
                          Expanded(
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Slip",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 10,
                                          )),
                                      Text(
                                          model.repairingNo, //put your own long text here.
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
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
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
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
                                "/repairing.aspx?PrintHeader=yes&MobilePdf=yes&userid=" +
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
                                    Icons.phone,
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
                                        Text("Mobile",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: colorBlack,
                                              fontSize: 10,
                                            )),
                                        // Wrap the value text to a new line if it exceeds two lines
                                        Text(model.primaryMobileNo,
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
                                    Icons.phone,
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
                                        Text("Alternate Mobile",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: colorBlack,
                                              fontSize: 10,
                                            )),
                                        // Wrap the value text to a new line if it exceeds two lines
                                        Text(model.alternateMobileNo,
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
                          height: 15,
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
                                              Icons.production_quantity_limits,
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
                                                Text("Product Name	",
                                                    style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: colorBlack,
                                                      fontSize: 10,
                                                    )),
                                                Text(
                                                    model.productName,
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
                                              Icons.numbers,
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
                                                Text("IMEI",
                                                    style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: colorBlack,
                                                      fontSize: 10,
                                                    )),
                                                Text(
                                                    model.iMEINo,
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
                                                Text("Assign To	",
                                                    style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: colorBlack,
                                                      fontSize: 10,
                                                    )),
                                                Text(
                                                    model.assigntoEmployeeName == null ? "---N/A---" : model.assigntoEmployeeName ,
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
                                                Text("Created By	",
                                                    style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: colorBlack,
                                                      fontSize: 10,
                                                    )),
                                                Text(
                                                    model.createdBy,
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
                                              Icons.calendar_month,
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
                                                Text("Expected Delivery",
                                                    style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: colorBlack,
                                                      fontSize: 10,
                                                    )),
                                                Text(
                                                    model.deliveryDate.getFormattedDate(
                                                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                                        toFormat:
                                                        "dd-MM-yyyy "),
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
                              _onTapOfEditData(model);
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
                                  showCommonDialogWithTwoOptions(context,
                                      "Are you sure you want to delete this record?",
                                      negativeButtonTitle: "No",
                                      positiveButtonTitle: "Yes",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context).pop();
                                    _mainBloc.add(RepairingDeleteCallEvent(
                                        RepairingDeleteRequest(
                                      pkID: model.pkID,
                                      CompanyId: CompanyID.toString(),
                                    )));
                                  });
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
              ),
              SizedBox(
                height: 15,
              )
            ],
          ));
    }

  void _onInquiryListPagination() {
    _mainBloc.add(RepairingListCallEvent(
        _pageNo+1,
        RepairingListRequest(
            pkID: "0",
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: (_pageNo+1).toString(),
            PageSize: "10",
            CompanyId: CompanyID.toString())));
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

  void _onMaterialOutwardListResponseSuccess(
      RepairingListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _listResponse = state.repairingListResponse;
      } else {
        _listResponse.details.addAll(state.repairingListResponse.details);
      }
      FinalTotalCount = state.repairingListResponse.totalCount;

      _pageNo = state.newPage;
    }
  }

  void _onDeleteMaterialOutward(RepairingDeleteCallResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _mainBloc.add(MaterialOutwardListCallEvent(
          1,
          MaterialOutwardListMainRequest(
              pkID: "0",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: "1",
              PageSize: "10",
              CompanyId: CompanyID.toString())));
    });
  }

  void _onTapOfEditData(RepairingListResponseDetails model) async {
    navigateTo(context, RepairingAddEditMainScreen.routeName,
        arguments: RepairingAddEditMainScreenArguments(model))
        .then((value) {
      _mainBloc.add(MaterialOutwardListCallEvent(
          1,
          MaterialOutwardListMainRequest(
              pkID: "0",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: "1",
              PageSize: "10",
              CompanyId: CompanyID.toString())));
    });
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLMaterialOutwardProduct();
  }

  Future<void> _showMyDialog(
      RepairingListResponseDetails model, String printWebURL) async {
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

  GenerateQT(RepairingListResponseDetails model,
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
                        "/repairing.aspx?MobilePdf=yes&userid=" +
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
                      context, "Repairing PDF Generated Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
                    _mainBloc.add(SalesBillPDFGenerateCallEvent(
                        SalesBillPDFGenerateRequest(
                            CompanyId: CompanyID.toString(),
                            InvoiceNo: model.repairingNo)));
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
      _mainBloc.add(MaterialOutwardListCallEvent(
          1,
          MaterialOutwardListMainRequest(
              pkID: "0",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: "1",
              PageSize: "10",
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
