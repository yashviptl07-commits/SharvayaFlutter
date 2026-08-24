import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/pay_slip_request/pay_slip_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/pay_slip_response/pay_slip_list_response.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
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

class PaySlipListScreen extends BaseStatefulWidget {
  static const routeName = '/PaySlipListScreen';

  @override
  _PaySlipListScreenState createState() => _PaySlipListScreenState();
}

class _PaySlipListScreenState extends BaseState<PaySlipListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  PaySlipListResponse _paySlipListResponse;

  LoginUserDetialsResponse _userData;
  CompanyDetailsResponse _companyData;
  String _companyId = "";
  String LoginUserID = "";
  String SiteURL = "";
  String Password = "";

  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController edt_Year = TextEditingController();
  final TextEditingController edt_Month = TextEditingController();

  Timer _debounce;
  int _pageNo = 1;
  int _pendingPageNo = 0;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isFetchingPage = false;
  bool _pdfGenerationTriggered = false;
  ScrollController _scrollController = ScrollController();

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

  String _selectedYear = "2025";
  String _selectedMonth = "---All---";

  final List<String> _monthList = [
    "---All---",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  final List<String> _yearList = [
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
  ];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);

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

    _userData = SharedPrefHelper.instance.getLoginUserData();
    _companyData = SharedPrefHelper.instance.getCompanyData();
    _companyId = _companyData.details[0].pkId.toString();
    LoginUserID = _userData.details[0].userID.toString();
    SiteURL = _companyData.details[0].siteURL.toString();
    Password = _userData.details[0].userPassword.toString();

    _setCurrentMonthYearDefaults();

    _mainBloc = MainBloc(baseBloc);
    _fetchProductList(reset: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMoreData) {
        _fetchMoreData();
      }
    });
  }

  void _setCurrentMonthYearDefaults() {
    final now = DateTime.now();
    final currentYear = now.year.toString();

    if (!_yearList.contains(currentYear)) {
      _yearList.add(currentYear);
      _yearList.sort();
    }

    _selectedYear = currentYear;
    _selectedMonth = (now.month >= 1 && now.month <= 12)
        ? _monthList[now.month]
        : "---All---";

    edt_Year.text = _selectedYear;
    edt_Month.text = _selectedMonth;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchProductList({bool reset = false}) {
    if (reset) {
      _pageNo = 1;
      _pendingPageNo = 0;
      _hasMoreData = true;
      _isLoadingMore = false;
      _isFetchingPage = false;
      _pdfGenerationTriggered = false;
      _paySlipListResponse = null;
      if (mounted) {
        setState(() {});
      }
    }

    if (_isFetchingPage || !_hasMoreData) return;

    String monthValue =
        _selectedMonth == "---All---" ? "0" : _getMonthNumber(_selectedMonth);

    _isFetchingPage = true;
    _pendingPageNo = _pageNo;

    _mainBloc.add(PaySlipListListCallEvent(
      PaySlipListRequest(
        pkID: "0",
        SearchKey: _searchCtrl.text.trim(),
        Month: monthValue,
        Year: _selectedYear,
        PageNo: _pendingPageNo.toString(),
        PageSize: "10",
        CompanyId: _companyId,
      ),
    ));
  }

  String _getMonthNumber(String month) {
    switch (month) {
      case "January":
        return "1";
      case "February":
        return "2";
      case "March":
        return "3";
      case "April":
        return "4";
      case "May":
        return "5";
      case "June":
        return "6";
      case "July":
        return "7";
      case "August":
        return "8";
      case "September":
        return "9";
      case "October":
        return "10";
      case "November":
        return "11";
      case "December":
        return "12";
      default:
        return "0";
    }
  }

  void _fetchMoreData() {
    if (_isFetchingPage || !_hasMoreData) return;
    setState(() {
      _isLoadingMore = true;
    });
    _fetchProductList();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _fetchProductList(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        listener: (context, state) {
          if (state is PaySlipListResponseState) {
            _onPaySlipListResponseState(state);
          }
        },
        buildWhen: (old, current) => current is PaySlipListResponseState,
        builder: (context, state) {
          return super.build(context);
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'Pay Slip',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: [
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              tooltip: 'Home',
              onPressed: () => navigateTo(context, HomeScreen.routeName,
                  clearAllStack: true),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
              onPressed: () => _fetchProductList(),
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilterPanel(context),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async => _fetchProductList(reset: true),
                  child: _buildPaySlipList(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context) {
    final r = _R(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(8)),
            child: Row(
              children: [
                Expanded(
                  child: _buildYearFilter(r),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: _buildMonthFilter(r),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(12), r.s(0), r.s(12), r.s(10)),
            child: _buildSearchField(r),
          ),
        ],
      ),
    );
  }

  Widget _buildYearFilter(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Year",
          style: TextStyle(
            fontSize: r.f(11),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(4)),
        Container(
          height: r.s(40),
          padding: EdgeInsets.symmetric(horizontal: r.s(10)),
          decoration: BoxDecoration(
            color: const Color(0xffF2F5FA),
            borderRadius: BorderRadius.circular(r.s(10)),
            border: Border.all(color: const Color(0xffDDE3EF)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedYear,
              style: TextStyle(
                color: Colors.black87,
                fontSize: r.f(13),
                fontWeight: FontWeight.w500,
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xff0066b3), size: r.s(20)),
              items: _yearList.map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                    edt_Year.text = value;
                  });
                  _fetchProductList(reset: true);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthFilter(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Month",
          style: TextStyle(
            fontSize: r.f(11),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(4)),
        Container(
          height: r.s(40),
          padding: EdgeInsets.symmetric(horizontal: r.s(10)),
          decoration: BoxDecoration(
            color: const Color(0xffF2F5FA),
            borderRadius: BorderRadius.circular(r.s(10)),
            border: Border.all(color: const Color(0xffDDE3EF)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedMonth,
              style: TextStyle(
                color: Colors.black87,
                fontSize: r.f(13),
                fontWeight: FontWeight.w500,
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xff0066b3), size: r.s(20)),
              items: _monthList.map((month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                    edt_Month.text = value;
                  });
                  _fetchProductList(reset: true);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(_R r) {
    return Container(
      height: r.s(44),
      padding: EdgeInsets.symmetric(horizontal: r.s(12)),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5FA),
        borderRadius: BorderRadius.circular(r.s(10)),
        border: Border.all(color: const Color(0xffDDE3EF)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade500, size: r.s(20)),
          SizedBox(width: r.s(10)),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              onChanged: (v) {
                _onSearchChanged(v);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search by employee name...",
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: r.f(13)),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: r.f(13), color: Colors.black87),
            ),
          ),
          if (_searchCtrl.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();
                _debounce?.cancel();
                _fetchProductList(reset: true);
                setState(() {});
              },
              child:
                  Icon(Icons.close, size: r.s(16), color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }

  Widget _buildPaySlipList(BuildContext context) {
    final r = _R(context);

    if (_paySlipListResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: r.s(40),
              width: r.s(40),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xff0066b3),
              ),
            ),
            SizedBox(height: r.s(16)),
            Text(
              "Loading payslips...",
              style: TextStyle(
                fontSize: r.f(12),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    if (_paySlipListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Payslips Found",
              style: TextStyle(
                fontSize: r.f(14),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: r.s(8)),
            Text(
              "Try changing month/year or search criteria",
              style: TextStyle(
                fontSize: r.f(12),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
      itemCount: _paySlipListResponse.details.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _paySlipListResponse.details.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: r.s(16)),
            child: Center(
              child: SizedBox(
                height: r.s(30),
                width: r.s(30),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xff0066b3),
                ),
              ),
            ),
          );
        }
        final model = _paySlipListResponse.details[index];
        return _buildPaySlipCard(context, model);
      },
    );
  }

  Widget _buildPaySlipCard(
      BuildContext context, PaySlipListResponseDetails model) {
    final r = _R(context);

    return Card(
      margin: EdgeInsets.only(bottom: r.s(10)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.s(14)),
      ),
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
            decoration: BoxDecoration(
              color: const Color(0xff0066b3).withOpacity(0.05),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(r.s(14))),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: r.s(22),
                  backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                  child: Text(
                    model.employeeName?.substring(0, 1).toUpperCase() ?? "E",
                    style: TextStyle(
                      fontSize: r.f(18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0066b3),
                    ),
                  ),
                ),
                SizedBox(width: r.s(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.employeeName ?? "N/A",
                        style: TextStyle(
                          fontSize: r.f(14),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0066b3),
                        ),
                      ),
                      SizedBox(height: r.s(4)),
                      Text(
                        "ID: ${model.employeeID ?? "N/A"}",
                        style: TextStyle(
                          fontSize: r.f(11),
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _handlePdfAction(context, model),
                  child: Container(
                    padding: EdgeInsets.all(r.s(8)),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(r.s(10)),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red.shade600,
                      size: r.s(22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), 0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoTile(
                          r,
                          Icons.work_outline,
                          "Designation",
                          model.designation ?? "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.person_outline,
                          "Gender",
                          model.gender ?? "N/A",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoTile(
                          r,
                          Icons.calendar_today_outlined,
                          "Pay Date",
                          _formatDate(model.payDate ?? ""),
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.attach_money_outlined,
                          "Net Salary",
                          "₹${model.netSalary?.toStringAsFixed(2) ?? "0"}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(12)),
            child: Wrap(
              spacing: r.s(8),
              runSpacing: r.s(8),
              children: [
                _salaryChip(r, "Work Days", model.wDays?.toString() ?? "0"),
                _salaryChip(r, "Present", model.pDays?.toString() ?? "0"),
                _salaryChip(r, "Leaves", model.lDays?.toString() ?? "0"),
                _salaryChip(r, "OT Hours", model.overTime?.toString() ?? "0"),
                _salaryChip(r, "Income", "₹${model.salaryMonth ?? "0"}"),
                _salaryChip(
                    r, "Deduction", "₹${model.dA?.toStringAsFixed(2) ?? "0"}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _salaryChip(_R r, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5FA),
        borderRadius: BorderRadius.circular(r.s(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: r.f(10),
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: r.f(11),
              fontWeight: FontWeight.bold,
              color: const Color(0xff0066b3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(_R r, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: r.s(13), color: const Color(0xff0066b3)),
        SizedBox(width: r.s(5)),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: r.f(10),
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: r.f(12), color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return "N/A";
    }
  }

  void _onPaySlipListResponseState(PaySlipListResponseState state) {
    final response =
        state.response ?? PaySlipListResponse(details: [], totalCount: 0);
    final int requestedPage = _pendingPageNo == 0 ? 1 : _pendingPageNo;
    final incomingDetails = response.details ?? [];

    setState(() {
      if (requestedPage <= 1 || _paySlipListResponse == null) {
        _paySlipListResponse = response;
      } else {
        _paySlipListResponse.details ??= [];
        final existingIds = _paySlipListResponse.details
            .map((e) => e.pkID?.toString())
            .where((e) => e != null)
            .toSet();
        _paySlipListResponse.details.addAll(
          incomingDetails
              .where((item) => !existingIds.contains(item.pkID?.toString())),
        );
        _paySlipListResponse.totalCount =
            response.totalCount ?? _paySlipListResponse.totalCount;
      }

      final currentCount = _paySlipListResponse.details?.length ?? 0;
      final totalCount = _paySlipListResponse.totalCount ?? 0;
      _hasMoreData = incomingDetails.isNotEmpty
          ? (totalCount > 0
              ? currentCount < totalCount
              : incomingDetails.length == 10)
          : false;

      if (_hasMoreData) {
        _pageNo = requestedPage + 1;
      }

      _isLoadingMore = false;
      _isFetchingPage = false;
      _pendingPageNo = 0;
    });

    if (_paySlipListResponse != null &&
        _paySlipListResponse.details.isNotEmpty &&
        !_pdfGenerationTriggered) {
      _pdfGenerationTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          OneTimeGenerateSO("0", context, "new");
        }
      });
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  // ==================== PDF METHODS - KEPT EXACTLY THE SAME ====================

  OneTimeGenerateSO(
      String CustomerID, BuildContext context123, String GenerateMode) {
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
                          "/PayrollSlip.aspx?MobilePdf=yes&userid=$LoginUserID&password=$Password")),
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
                      final targetUrl = Uri.tryParse(url ?? "");
                      if (targetUrl != null && await canLaunchUrl(targetUrl)) {
                        await launchUrl(targetUrl);
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

  void _handlePdfAction(
      BuildContext context, PaySlipListResponseDetails model) {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure? You want to open pdf?",
      negativeButtonTitle: "NO",
      onTapOfNegativeButton: () {
        Navigator.of(context).pop();
      },
      positiveButtonTitle: "YES",
      onTapOfPositiveButton: () async {
        Navigator.of(context).pop();
        final String printUrl =
            "$SiteURL/PayrollSlip.aspx?PrintHeader=no&MobilePdf=yes"
            "&userid=$LoginUserID&password=$Password&pQuotID=${model.pkID}";
        await _showMyDialog(model, printUrl);
      },
    );
  }

  Future<void> _showMyDialog(
      PaySlipListResponseDetails model, String printWebURL) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context123) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: GenerateQT(model, context123, printWebURL),
          ),
        );
      },
    );
  }

  GenerateQT(PaySlipListResponseDetails model, BuildContext context123,
      String printWebURL) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 1,
          width: 1,
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
                  final targetUrl = Uri.tryParse(url ?? "");
                  if (targetUrl != null && await canLaunchUrl(targetUrl)) {
                    await launchUrl(targetUrl);
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
                  context,
                  "Pay Slip Generated Successfully",
                  onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
                    String cleanName = model.employeeName.replaceAll(" ", "");
                    DateTime payDate = DateTime.parse(model.payDate);
                    String month = DateFormat('M').format(payDate);
                    String year = payDate.year.toString();
                    String fileName = "Pay_${cleanName}_${month}_$year.pdf";
                    print("$SiteURL/PDF/$fileName");
                    navigateTo(
                      context,
                      PDFViewerScreen.routeName,
                      arguments: PDFViewerScreenArguments(
                        "$SiteURL/PDF/$fileName",
                      ),
                    ).then((value) => _fetchProductList());
                  },
                );
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
        SizedBox(
          width: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                height: 34,
                width: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xff0066b3),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
