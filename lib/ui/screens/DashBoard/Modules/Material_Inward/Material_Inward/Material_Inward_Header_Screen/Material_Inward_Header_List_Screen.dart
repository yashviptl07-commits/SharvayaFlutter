import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Delete_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_List_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_list_Responce.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Header_Screen/Material_Inward_Header_Add_Edit_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialInwardListScreens extends BaseStatefulWidget {
  static const routeName = '/MaterialInwardListScreens';

  @override
  _MaterialInwardListScreensState createState() =>
      _MaterialInwardListScreensState();
}

class _MaterialInwardListScreensState
    extends BaseState<MaterialInwardListScreens>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  Function refreshList;
  MaterialInwardListMeetResponse _listResponse;
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

    _mainBloc.add(MaterialInwardListMeetCallEvent(
        1,
        MaterialInwardListRequestMeet(
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            CompanyId: CompanyID.toString(),
            pkID: "0",
            PageNo: "1",
            PageSize: "10")));

    getUserRights(_menuRightsResponse);

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) => _mainBloc
        ..add(MaterialInwardListMeetCallEvent(
            1,
            MaterialInwardListRequestMeet(
                LoginUserID: LoginUserID,
                SearchKey: edt_CustomerName.text,
                CompanyId: CompanyID.toString(),
                pkID: "0",
                PageNo: "1",
                PageSize: "10"))),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is MaterialInwardListCallMeetResponseState) {
            _onMaterialOutwardListResponseSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MaterialInwardListCallMeetResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          //_onDeleteBankVoucher
          if (state is MaterialInwardDeleteCallResponseState) {
            _onDeleteMaterialOutward(state);
          }
            if (state is SalesBillPDFGenerateResponseState) {
            _onGenerateSalesBillPDFCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesBillPDFGenerateResponseState ||
              currentState is MaterialInwardDeleteCallResponseState) {
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
          title: Text('Material Inward'),
          gradient: LinearGradient(colors: [
              Color(0xff108dcf),
              Color(0xff0066b3),
              Color(0xff108dcf),
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
                onPressed: () async {
                  _showFilterDialog(context);
                }),
            Visibility(
              visible: IsAddRights,
              child: IconButton(
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: colorWhite,
                    size: 30,
                  ),
                  onPressed: () async {
                    await _onTapOfDeleteALLProduct();
                    navigateTo(context, MaterialInwardAddEditMainScreen.routeName,
                        clearAllStack: true);
                  }),
            ),
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
                    _mainBloc.add(MaterialInwardListMeetCallEvent(
                        1,
                        MaterialInwardListRequestMeet(
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            CompanyId: CompanyID.toString(),
                            pkID: "0",
                            PageNo: "1",
                            PageSize: "10")));

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

  void _showFilterDialog(BuildContext context) {
    edt_CustomerName.text = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter Inwards"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: edt_CustomerName,
                readOnly: false, // Makes the field non-editable
                decoration: InputDecoration(
                    labelText: "Search Customer",
                    suffixIcon: Icon(Icons.search)
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            // Apply Filter Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mainBloc.add(
                    MaterialInwardListMeetCallEvent(
                        1,
                        MaterialInwardListRequestMeet(
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            CompanyId: CompanyID.toString(),
                            pkID: "0",
                            PageNo: "1",
                            PageSize: "10")));
              },
              child: Text("Apply"),
            ),
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
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

  ExpantionCustomer(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04;
    double fontSizeTitle = screenWidth * 0.045;
    double fontSizeLabel = screenWidth * 0.037;
    double fontSize = screenWidth * 0.04; // Consistent font size for all texts
    MaterialInwardListMeetResponseDetails model = _listResponse.details[index];

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
                    model.customerName,
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
                    _buildDetailRow("Inward Date	: ", model.inwardDate.getFormattedDate(
                        fromFormat:
                        "yyyy-MM-ddTHH:mm:ss",
                        toFormat: "dd-MM-yyyy"),
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Inward No : ", model.inwardNo,
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Location : ", model.locationName.toString(),
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Basic Amount : ", model.basicAmount.toString(),
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Tax Amount	 : ", model.taxAmount.toString(),
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Net Amount : ", model.netAmt.toString(),
                        fontSizeLabel, fontSizeLabel * 1.1),
                  ],
                ),
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {

                        showCommonDialogWithTwoOptions(
                            context, "Are you sure You want to print PDF ?",
                            negativeButtonTitle: "YES",
                            onTapOfNegativeButton: () async {
                              Navigator.pop(context);

                              String printHeaderYes = SiteURL +
                                  "/Inward.aspx?PrintHeader=yes&MobilePdf=yes&userid=" +
                                  LoginUserID +
                                  "&password=" +
                                  Password +
                                  "&pQuotID=" +
                                  model.pkID.toString();

                              print(printHeaderYes);

                              await _showMyDialog(model, printHeaderYes);
                            },
                            positiveButtonTitle: "No",
                            onTapOfPositiveButton: () async {
                              Navigator.pop(context);
                            });

                      },
                      icon: Icon(Icons.picture_as_pdf, color: colorRED, size: 30)),
                  IconButton(
                      onPressed: () {
                        _onTapOfEditData(model);
                      },
                      icon: Icon(Icons.edit, color: colorPrimary, size: 30)),
                  IconButton(
                      onPressed: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this record?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                              _mainBloc.add(MaterialInwardDeleteCallEvent(
                                MaterialInwardDeleteRequest(
                                    pkID: model.pkID.toString(), CompanyId: CompanyID.toString()),
                              ));
                            });
                      },
                      icon: Icon(Icons.delete,color: colorPrimary, size: 30))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    _mainBloc.add(MaterialInwardListMeetCallEvent(
        _pageNo + 1,
        MaterialInwardListRequestMeet(
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            CompanyId: CompanyID.toString(),
            pkID: "0",
            PageNo: (_pageNo+1).toString(),
            PageSize: "10")));
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
      MaterialInwardListCallMeetResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _listResponse = state.response;
      } else {
        _listResponse.details.addAll(state.response.details);
      }
      FinalTotalCount = state.response.totalCount;

      _pageNo = state.newPage;
    }

    getUserRights(_menuRightsResponse);
  }

  void _onDeleteMaterialOutward(MaterialInwardDeleteCallResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _mainBloc.add(MaterialInwardListMeetCallEvent(
          1,
          MaterialInwardListRequestMeet(
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              CompanyId: CompanyID.toString(),
              pkID: "0",
              PageNo: "1",
              PageSize: "10")));
    });
  }

  void _onTapOfEditData(MaterialInwardListMeetResponseDetails model) async {
    navigateTo(context, MaterialInwardAddEditMainScreen.routeName,
            arguments: MaterialInwardAddEditMainScreenArguments(model))
        .then((value) {
      _mainBloc.add(MaterialInwardListMeetCallEvent(
          1,
          MaterialInwardListRequestMeet(
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              CompanyId: CompanyID.toString(),
              pkID: "0",
              PageNo: "1",
              PageSize: "10")));
    });
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance()
        .deleteallMaterialInwardProductsProducts();
  }

  Future<void> _showMyDialog(
      MaterialInwardListMeetResponseDetails model, String GenerateMode) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait..! '),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child:  GenerateQT(model, context123, GenerateMode),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  GenerateQT(MaterialInwardListMeetResponseDetails model,
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
                        "/Inward.aspx?MobilePdf=yes&userid=" +
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

                  String pageTitle = "E-Office-Desk";

                  controller.getTitle().then((value) {
                    setState(() {
                      pageTitle = value;

                      print("sdf567" + pageTitle);
                    });
                  });

                  if (pageTitle == "E-Office-Desk") {
                    Navigator.pop(context123);
                    showCommonDialogWithSingleOption(
                        context, "Inward Generated Successfully ",
                        onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _mainBloc.add(SalesBillPDFGenerateCallEvent(
                              SalesBillPDFGenerateRequest(
                                  CompanyId: CompanyID.toString(),
                                  InvoiceNo: model.inwardNo)));
                          //Navigator.pop(context);
                        });
                  } else {
                    Navigator.pop(context123);
                    showCommonDialogWithSingleOption(
                        context, "Please Try Again !");
                  }

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

      if (menuRightsResponse.details[i].menuName == "pgInward") {
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
