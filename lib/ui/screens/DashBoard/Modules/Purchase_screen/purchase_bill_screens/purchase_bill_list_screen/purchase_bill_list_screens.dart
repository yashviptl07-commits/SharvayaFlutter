import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_delete_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_list_screen_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_header_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_list_screen_response.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseBillListScreen extends BaseStatefulWidget {
  static const routeName = '/PurchaseBillListScreen';

  @override
  _PurchaseBillListScreenState createState() => _PurchaseBillListScreenState();
}

enum Share {
  facebook,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

class _PurchaseBillListScreenState extends BaseState<PurchaseBillListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  int _pageNo = 0;
  PurchaseBillListResponse _purchaseBillListResponse;
  bool expanded = true;

  int CompanyID = 0;
  String LoginUserID = "";
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  String SiteURL = "";
  String Password = "";
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
  final urlController = TextEditingController();
  String url = "";
  bool isLoading = true;
  int prgresss = 0;
  double progress = 0;
  CustomerDetails customerDetails = CustomerDetails();
  bool onWebLoadingStop = true;
  final TextEditingController edt_CustomerName = TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
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
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;

    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");
    print("PWDf" + Password.toString());
    _mainBloc = MainBloc(baseBloc);

    _mainBloc.add(PurchaseBillListRequestEvent(
        1,
        PurchaseBillListRequest(
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            CompanyId: CompanyID,
            pkID: 0,
            PageNo: 1,
            PageSize: 10)));

    getUserRights(_menuRightsResponse);

    baseBloc.emit(ShowProgressIndicatorState(true));
    _mainBloc.add(DeleteGenericAdditionalChargesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc
        ..add(PurchaseBillListRequestEvent(
            1,
            PurchaseBillListRequest(
                LoginUserID: LoginUserID,
                SearchKey: edt_CustomerName.text,
                CompanyId: CompanyID,
                pkID: 0,
                PageNo: 1,
                PageSize: 10))),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is PurchaseBillListResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }

          if (state is DeleteAllGenericAdditionalChargesState) {
            _OnDeleteAllGenericCharges(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is PurchaseBillListResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is DeleteAllGenericAdditionalChargesState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is SalesBillPDFGenerateResponseState) {
            _onGenerateShortInvoicePDFCallSuccess(state);
          }

          if (state is PurchaseBillDeleteResponseState) {
            _onShortInvoiceDeleteResponseState(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesBillPDFGenerateResponseState ||
              currentState is PurchaseBillDeleteResponseState) {
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
        appBar: NewGradientAppBar(
          title: Text('Purchase Bill List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: colorWhite,
                ),
                onPressed: () {
                  _showFilterDialog(context);
                }),
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _mainBloc.add(PurchaseBillListRequestEvent(
                        1,
                        PurchaseBillListRequest(
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            CompanyId: CompanyID,
                            pkID: 0,
                            PageNo: 1,
                            PageSize: 10)));

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
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
        floatingActionButton: IsAddRights == true
            ? FloatingActionButton(
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();
                  navigateTo(context, PurchaseBillAddEditScreen.routeName);
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLPurchaseBillProduct();
  }

  void _showFilterDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    edt_CustomerName.text = "";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Title
                Text(
                  "Filter Purchase Bill",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),

                // Search Field with Icon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Search Purchase Bill",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Card(
                      elevation: 8,
                      color: Colors.grey[50],
                      shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: edt_CustomerName,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: "Search Purchase Bill...",
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[600]),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _mainBloc.add(ShortInvoiceListRequestEvent(
                            1,
                            ShortInvoiceListRequest(
                                LoginUserID: LoginUserID,
                                SearchKey: edt_CustomerName.text,
                                CompanyId: CompanyID.toString(),
                                pkID: "0",
                                PageNo: "1",
                                PageSize: "10")));
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_purchaseBillListResponse == null) {
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
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildInquiryListItem(index);
              },
              shrinkWrap: true,
              itemCount: _purchaseBillListResponse.details.length,
            ),
          ),
        ],
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(PurchaseBillListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _purchaseBillListResponse = state.response;
      } else {
        _purchaseBillListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
    getUserRights(_menuRightsResponse);
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    _mainBloc.add(PurchaseBillListRequestEvent(
        _pageNo + 1,
        PurchaseBillListRequest(
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            CompanyId: CompanyID,
            pkID: 0,
            PageNo: _pageNo + 1,
            PageSize: 10)));
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
    double fontSizeLabel = screenWidth * 0.037;
    double fontSize = screenWidth * 0.04;
    PurchaseBillListResponseDetails model =
        _purchaseBillListResponse.details[index];

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                    _buildDetailRow(
                        "Invoice Date	: ",
                        model.invoiceDate.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy"),
                        fontSizeLabel,
                        fontSizeLabel * 1.1),
                    _buildDetailRow(
                        "Invoice No : ",
                        model.invoiceNo == null ? "N/A" : model.invoiceNo,
                        fontSizeLabel,
                        fontSizeLabel * 1.1),
                    _buildDetailRow(
                        "Gst : ",
                        model.gSTNO == null ? "N/A" : model.gSTNO,
                        fontSizeLabel,
                        fontSizeLabel * 1.1),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRowForAmt(
                    "BasicAmt :",
                    model.basicAmt.toString(),
                    "TaxAmt :",
                    model.taxAmt.toString(),
                    fontSizeLabel,
                    fontSizeLabel * 1.1,
                  ),
                  _buildDetailRowForAmt(
                    "ROfAmt :",
                    model.rOffAmt.toString(),
                    "NetAmt :",
                    model.netAmt.toString(),
                    fontSizeLabel,
                    fontSizeLabel * 1.1,
                  ),
                ],
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
                                  "/PurchaseBill.aspx?PrintHeader=yes&MobilePdf=yes&userid=" +
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
                      icon: Icon(Icons.picture_as_pdf,
                          color: colorRED, size: 30)),
                  IsEditRights == true
                      ? IconButton(
                          onPressed: () {
                            _onTapOfEditData(model);
                          },
                          icon: Icon(Icons.edit, color: colorPrimary, size: 30))
                      : Container(),
                  IsDeleteRights == true
                      ? IconButton(
                          onPressed: () {
                            showCommonDialogWithTwoOptions(context,
                                "Are you sure you want to delete this record?",
                                negativeButtonTitle: "No",
                                positiveButtonTitle: "Yes",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                              _mainBloc.add(PurchaseBillDeleteRequestEvent(
                                PurchaseBillDeleteDeleteRequest(
                                    pkID: model.pkID, CompanyId: CompanyID),
                              ));
                            });
                          },
                          icon:
                              Icon(Icons.delete, color: colorPrimary, size: 30))
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRowForAmt(
    String label,
    String value,
    String label1,
    String value1,
    double labelFontSize,
    double valueFontSize,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left block
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _labelStyle(labelFontSize)),
              const SizedBox(height: 2),
              Text(
                value,
                style:
                    TextStyle(color: Colors.black87, fontSize: valueFontSize),
              ),
            ],
          ),
        ),

        // Right block
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: _labelStyle(labelFontSize)),
              const SizedBox(height: 2),
              Text(
                value1,
                style:
                    TextStyle(color: Colors.black87, fontSize: valueFontSize),
              ),
            ],
          ),
        ),
      ],
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

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Future<void> _showMyDialog(
      PurchaseBillListResponseDetails model, String printWebURL) async {
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

  GenerateQT(PurchaseBillListResponseDetails model, BuildContext context123,
      String printWebURL) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 20,
            width: 20,
            child: Visibility(
              visible: true,
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(printWebURL)),
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

                      if (pageTitle == "E-Office-Desk") {
                        Navigator.pop(context123);
                        showCommonDialogWithSingleOption(
                            context, "Purchase Bill Generated Successfully ",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _mainBloc.add(SalesBillPDFGenerateCallEvent(
                              SalesBillPDFGenerateRequest(
                                  CompanyId: CompanyID.toString(),
                                  InvoiceNo: model.invoiceNo)));
                        });
                      } else {
                        Navigator.pop(context123);
                        showCommonDialogWithSingleOption(
                            context, "Please Try Again !");
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

  void _onGenerateShortInvoicePDFCallSuccess(
      SalesBillPDFGenerateResponseState state) {
    navigateTo(context, PDFViewerScreen.routeName,
            arguments: PDFViewerScreenArguments(
                state.response.details[0].column1.toString()))
        .then((value) {
      _mainBloc.add(PurchaseBillListRequestEvent(
          1,
          PurchaseBillListRequest(
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              CompanyId: CompanyID,
              pkID: 0,
              PageNo: 1,
              PageSize: 10)));
    });
  }

  void _OnMenuRightsSucess(UserMenuRightsResponseState state) {
    for (int i = 0; i < state.userMenuRightsResponse.details.length; i++) {
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

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgPurchaseBill") {
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

  void _onShortInvoiceDeleteResponseState(
      PurchaseBillDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _mainBloc.add(PurchaseBillListRequestEvent(
          1,
          PurchaseBillListRequest(
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              CompanyId: CompanyID,
              pkID: 0,
              PageNo: 1,
              PageSize: 10)));
    });
  }

  void _onTapOfEditData(PurchaseBillListResponseDetails model) async {
    navigateTo(context, PurchaseBillAddEditScreen.routeName,
            arguments: PurchaseBillAddEditScreenArguments(model))
        .then((value) {
      _mainBloc.add(PurchaseBillListRequestEvent(
          1,
          PurchaseBillListRequest(
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              CompanyId: CompanyID,
              pkID: 0,
              PageNo: 1,
              PageSize: 10)));
    });
  }

  void _OnDeleteAllGenericCharges(
      DeleteAllGenericAdditionalChargesState state) {}
}
