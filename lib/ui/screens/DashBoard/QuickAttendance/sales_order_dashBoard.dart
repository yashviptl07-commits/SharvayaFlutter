import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/salesOder_approval_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/sales_order_approval_status_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/salesOrder_Approval/salesOrder_Approval_List_Response.dart';
import 'package:soleoserp/models/api_responses/salesOrder_Approval/salesOrder_approval_status_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class SalesOrderDashboardScreen extends BaseStatefulWidget {
  static const routeName = '/SalesOrderDashboardScreen';

  @override
  _SalesOrderDashboardScreenState createState() =>
      _SalesOrderDashboardScreenState();
}

class _SalesOrderDashboardScreenState
    extends BaseState<SalesOrderDashboardScreen>
    with BasicScreen, WidgetsBindingObserver {
  SalesOrderBloc _salesOrderBloc;
  int _pageNo = 0;
  bool isListExist = false;

  SalesOrderApprovalListResponse _salesOrderListResponse; // For display
  SalesOrderApprovalListResponse _completeSalesOrderList; // For counts

  // Track the type of request that's being processed
  bool _isLoadingCompleteData = false;
  bool _isLoadingDisplayData = false;

  // Dynamic filter statuses from API
  List<SalesOrderApprovalStatusListResponseDetails> _statusList = [];
  Map<String, int> _statusCounts = {};
  String _selectedFilter = "All"; // Current selected filter

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Status = [];

  final TextEditingController edt_Search = TextEditingController();
  final TextEditingController edt_Status = TextEditingController();

  // Debounce timer for search
  Timer _debounceTimer;
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
  bool onWebLoadingStop = true;

  @override
  void initState() {
    super.initState();
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
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");

    _salesOrderBloc = SalesOrderBloc(baseBloc);
    edt_Status.text = "ALL";

    _salesOrderBloc.add(SalesOrderApprovalStatusListRequestEvent(
        SalesOrderApprovalStatusListRequest(
      pkID: "0",
      StatusCategory: "SOApproval",
      PageNo: "1",
      PageSize: "1000",
      CompanyId: CompanyID.toString(),
    )));

    // Add search listener
    edt_Search.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    edt_Search.removeListener(_onSearchChanged);
    edt_Search.dispose();
    edt_Status.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchData();
    });
  }

  void _fetchData() {
    String status = "";
    if (_selectedFilter != "All") {
      status = _selectedFilter;
    }

    _isLoadingDisplayData = true;

    // Always fetch filtered data for display
    _salesOrderBloc.add(SalesOrderApprovalListRequestEvent(
        SalesOrderApprovalListRequest(
            ApprovalStatus: status,
            LoginUserID: LoginUserID,
            PageNo: "1",
            PageSize: "10000000",
            CompanyId: CompanyID.toString(),
            SearchKey: edt_Search.text)));
  }

  void _fetchCompleteDataForCounts() {
    _isLoadingCompleteData = true;

    // Fetch complete data without any filters for counts
    _salesOrderBloc
        .add(SalesOrderApprovalListRequestEvent(SalesOrderApprovalListRequest(
            ApprovalStatus: "",
            LoginUserID: LoginUserID,
            PageNo: "1",
            PageSize: "10000000", // Fetch larger page size for counts
            CompanyId: CompanyID.toString(),
            SearchKey: "")));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _salesOrderBloc
        ..add(SalesOrderApprovalListRequestEvent(SalesOrderApprovalListRequest(
            ApprovalStatus: "",
            LoginUserID: LoginUserID,
            PageNo: "1",
            PageSize: "10000000",
            CompanyId: CompanyID.toString(),
            SearchKey: ""))),
      child: BlocConsumer<SalesOrderBloc, SalesOrderStates>(
        builder: (BuildContext context, SalesOrderStates state) {
          if (state is SalesOrderApprovalListResponseState) {
            // Use WidgetsBinding to update UI after build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onListCallSuccess(state);
            });
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return currentState is SalesOrderApprovalListResponseState;
        },
        listener: (BuildContext context, SalesOrderStates state) {
          if (state is SalesOrderApprovalStatusListResponseState) {
            _onStatusListResponseState(state, context);
          }

          if (state is SalesOrderPDFGenerateResponseState) {
            _onGenerateQuotationPDFCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is SalesOrderPDFGenerateResponseState ||
              currentState is SalesOrderApprovalStatusListResponseState;
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
          title: Text('SO Dashboard'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorWhite),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              }),
        ),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              _buildFilterRow(),
              _buildSearchBar(),
              Expanded(
                child: _buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    // Create a list of all filter chips including "All" and all dynamic statuses
    List<Widget> filterChips = [];

    // Add "All" chip - Fixed width container
    filterChips.add(Container(
      width: 90,
      margin: EdgeInsets.only(right: 8),
      child: _buildFilterChip("All", _allCount, _selectedFilter == "All"),
    ));

    // Add dynamic status chips from API
    for (var status in _statusList) {
      if (status.inquiryStatus != null && status.inquiryStatus.isNotEmpty) {
        filterChips.add(Container(
          width: 100,
          margin: EdgeInsets.only(right: 8),
          child: _buildFilterChip(
              status.inquiryStatus,
              _statusCounts[status.inquiryStatus] ?? 0,
              _selectedFilter == status.inquiryStatus),
        ));
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filterChips,
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
        _fetchData();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff0066b3) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Color(0xff0066b3) : Colors.grey[300],
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label.length > 12 ? '${label.substring(0, 10)}...' : label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            Text(
              count.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xff0066b3),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: TextField(
          controller: edt_Search,
          decoration: InputDecoration(
            hintText: "Search by Customer or Order No...",
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: edt_Search.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, size: 20),
                    onPressed: () {
                      edt_Search.clear();
                      _fetchData();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_isLoadingDisplayData && _salesOrderListResponse == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0066b3)),
        ),
      );
    }

    if (isListExist == true && _salesOrderListResponse != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(scrollInfo)) {
            _onPagination();
            return true;
          }
          return false;
        },
        child: Column(
          children: [
            _salesOrderListResponse.details.length != 0
                ? OneTimeGenerateSO(
                    _salesOrderListResponse.details[0], context, "new")
                : Container(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _salesOrderListResponse.details.length,
                itemBuilder: (context, index) {
                  return _buildCompactCard(index);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND, height: 150, width: 150),
            SizedBox(height: 16),
            Text(
              "No Sales Orders Found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCompactCard(int index) {
    SalesOrderApprovalListResponseDetails item =
        _salesOrderListResponse.details[index];

    Color statusColor = _getStatusColor(item.approvalStatus);
    String status = item.approvalStatus?.toLowerCase() ?? '';

    //bool showPdf = status.contains('dispatch') || status.contains('disptach');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              /// 🔵 LEFT STATUS COLOR STRIP
              Container(
                width: 5,
                height: 110,
                color: statusColor,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📄 PDF BUTTON (Rounded Icon Style)
                      //if (showPdf)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.picture_as_pdf,
                              color: Colors.red),
                          onPressed: () async {
                            String PrintHeaderYES = SiteURL +
                                "/SalesOrder.aspx?PrintHeader=yes&MobilePdf=yes&userid=" +
                                LoginUserID +
                                "&password=" +
                                Password +
                                "&pQuotID=" +
                                item.pkID.toString() +
                                "&pageType=so";

                            print(
                                "PrintHeaderYES" + "  PDF : " + PrintHeaderYES);

                            await _showMyDialog(item, PrintHeaderYES);
                          },
                        ),
                      ),

                      /// 📌 MAIN CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Customer + Status
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.customerName ?? "N/A",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1F2937),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                /// Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.approvalStatus ?? "N/A",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// Order No
                            Row(
                              children: [
                                Icon(Icons.receipt_long,
                                    size: 16, color: Colors.grey.shade600),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.orderNo ?? "N/A",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// Order Date
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 6),
                                Text(
                                  item.orderDate.getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "dd-MM-yyyy",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'on hold':
        return Colors.purple;
      case 'ready to dispatch':
      case 'disptach':
      case 'dispatch':
        return Colors.blue;
      case 'production done':
        return Colors.teal;
      case 'partial production done':
        return Colors.cyan;
      case 'partial ready to dispatch':
        return Colors.lightBlue;
      case 'partial dispatch':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  int get _allCount {
    if (_completeSalesOrderList != null) {
      return _completeSalesOrderList.details.length;
    } else if (_salesOrderListResponse != null) {
      return _salesOrderListResponse.details.length;
    }
    return 0;
  }

  void _onListCallSuccess(SalesOrderApprovalListResponseState state) {
    // Determine the type of response based on the request parameters
    // Since we can't access state.request, we need to determine this differently

    // Check if this is the complete data for counts (PageSize 1000 and no status filter)
    // We can infer this from the response itself or use a flag

    if (_isLoadingCompleteData) {
      // This is the complete data for counts
      _completeSalesOrderList = state.response;
      _isLoadingCompleteData = false;

      // Calculate counts from complete data
      _statusCounts.clear();
      for (var item in _completeSalesOrderList.details) {
        String status = item.approvalStatus ?? 'Unknown';
        _statusCounts[status] = (_statusCounts[status] ?? 0) + 1;
      }
    }

    if (_isLoadingDisplayData || !_isLoadingCompleteData) {
      // This is the filtered data for display
      _isLoadingDisplayData = false;

      if (_pageNo != state.newPage || state.newPage == 1) {
        if (state.newPage == 1) {
          _salesOrderListResponse = state.response;
        } else {
          _salesOrderListResponse.details.addAll(state.response.details);
        }
        _pageNo = state.newPage;
      }
    }

    // If complete data hasn't been loaded yet, use display data for counts temporarily
    if (_completeSalesOrderList == null && _salesOrderListResponse != null) {
      _statusCounts.clear();
      for (var item in _salesOrderListResponse.details) {
        String status = item.approvalStatus ?? 'Unknown';
        _statusCounts[status] = (_statusCounts[status] ?? 0) + 1;
      }
    }

    isListExist = _salesOrderListResponse?.details?.isNotEmpty ?? false;

    if (mounted) {
      setState(() {});
    }
  }

  void _onPagination() {
    if (_salesOrderListResponse == null) return;

    int totalpage = _pageNo + 1;
    String status = "";
    if (_selectedFilter != "All") {
      status = _selectedFilter;
    }

    _isLoadingDisplayData = true;

    _salesOrderBloc.add(SalesOrderApprovalListRequestEvent(
        SalesOrderApprovalListRequest(
            ApprovalStatus: status,
            LoginUserID: LoginUserID,
            PageNo: totalpage.toString(),
            PageSize: "10000000",
            CompanyId: CompanyID.toString(),
            SearchKey: edt_Search.text)));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onStatusListResponseState(
      SalesOrderApprovalStatusListResponseState state, BuildContext context) {
    _statusList = state.response.details;

    arr_ALL_Name_ID_For_Status.clear();

    ALL_Name_ID all_name_id = ALL_Name_ID();
    all_name_id.Name = "ALL";
    arr_ALL_Name_ID_For_Status.add(all_name_id);

    for (int i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.response.details[i].inquiryStatus;
      arr_ALL_Name_ID_For_Status.add(all_name_id);
    }

    // Initialize counts for all statuses
    for (var status in _statusList) {
      _statusCounts[status.inquiryStatus] = 0;
    }

    // Fetch complete data for counts first
    _fetchCompleteDataForCounts();

    // Then fetch filtered data for display
    _fetchData();

    if (mounted) {
      setState(() {});
    }
  }

  OneTimeGenerateSO(SalesOrderApprovalListResponseDetails model,
      BuildContext context123, String GenerateMode) {
    return Center(
      child: Container(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            Container(
              height: 5,
              width: 5,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/SalesOrder.aspx?MobilePdf=yes&userid=" +
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
                    baseBloc.emit(ShowProgressIndicatorState(true));

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
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;

                        print("sdf567" + pageTitle);
                      });
                    });
                    baseBloc.emit(ShowProgressIndicatorState(false));
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
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
      SalesOrderApprovalListResponseDetails model, String printWebURL) async {
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

  GenerateQT(SalesOrderApprovalListResponseDetails model,
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
                    });
                  });

                  showCommonDialogWithSingleOption(
                      context, "So Generated Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
                    _salesOrderBloc.add(SalesOrderPDFGenerateCallEvent(
                        SalesOrderPDFGenerateRequest(
                            CompanyId: CompanyID.toString(),
                            OrderNo: model.orderNo)));
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

  void _onGenerateQuotationPDFCallSuccess(
      SalesOrderPDFGenerateResponseState state) {
    navigateTo(context, PDFViewerScreen.routeName,
            arguments: PDFViewerScreenArguments(
                state.response.details[0].column1.toString()))
        .then((value) {
      // Always fetch filtered data for display
      _salesOrderBloc.add(SalesOrderApprovalListRequestEvent(
          SalesOrderApprovalListRequest(
              ApprovalStatus: "",
              LoginUserID: LoginUserID,
              PageNo: "1",
              PageSize: "10000000",
              CompanyId: CompanyID.toString(),
              SearchKey: edt_Search.text)));
    });
  }
}
