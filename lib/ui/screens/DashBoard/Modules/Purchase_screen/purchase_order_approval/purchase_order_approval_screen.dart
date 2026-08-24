import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/PO_approval_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_approval_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/sales_order_approval_status_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/PO_approval_list_response.dart';
import 'package:soleoserp/models/api_responses/salesOrder_Approval/salesOrder_approval_status_list_response.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

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

class PurchaseOrderApprovalListScreen extends BaseStatefulWidget {
  static const routeName = '/PurchaseOrderApprovalListScreen';

  @override
  _PurchaseOrderApprovalListScreenState createState() =>
      _PurchaseOrderApprovalListScreenState();
}

class _PurchaseOrderApprovalListScreenState
    extends BaseState<PurchaseOrderApprovalListScreen>
    with BasicScreen, WidgetsBindingObserver {
  static const String _statusCategoryPOApproval = "poaaprlval";

  MainBloc _mainBloc;
  int _pageNo = 0;
  bool isListExist = false;
  POApprovalListResponse _leaveRequestListResponse;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;

  String _selectedFilterStatus = "Pending";

  final List<String> _filterStatusList = [
    "ALL",
    "Pending",
    "Approved",
  ];

  final List<String> _updateStatusList = [
    "Pending",
    "Approved",
  ];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    _mainBloc = MainBloc(baseBloc);

    _mainBloc.add(
        POApprovalStatusListRequestEvent(SalesOrderApprovalStatusListRequest(
      pkID: "0",
      StatusCategory: _statusCategoryPOApproval,
      PageNo: "1",
      PageSize: "1000",
      CompanyId: CompanyID.toString(),
    )));

    _fetchList(page: 1);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _fetchList({int page = 1}) {
    _mainBloc.add(POApprovalListRequestEvent(POApprovalRequest(
      ApprovalStatus:
          _selectedFilterStatus == "ALL" ? "" : _selectedFilterStatus,
      LoginUserID: LoginUserID,
      PageNo: page.toString(),
      PageSize: "10",
      CompanyId: CompanyID.toString(),
      SearchKey: _searchCtrl.text.trim(),
    )));
  }

  void _onSearchChanged(String _) {
    _debounceTimer?.cancel();
    _debounceTimer =
        Timer(const Duration(milliseconds: 600), () => _fetchList(page: 1));
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() => _selectedFilterStatus = status);
    _fetchList(page: 1);
  }

  void _applyApprovalStatusList(POApprovalStatusListResponseState state) {
    final details = state.response?.details ?? [];
    final List<String> statuses = details
        .map((e) => e.inquiryStatus?.trim() ?? "")
        .where((s) => s.isNotEmpty)
        .toList();

    final List<String> uniqueStatuses = [];
    final Set<String> seen = {};
    for (final s in statuses) {
      final key = s.toLowerCase();
      if (seen.add(key)) {
        uniqueStatuses.add(s);
      }
    }

    final List<String> nextFilter = ["ALL", ...uniqueStatuses];
    final List<String> nextUpdate =
        uniqueStatuses.isNotEmpty ? uniqueStatuses : ["Pending", "Approved"];

    if (!mounted) return;
    setState(() {
      _filterStatusList
        ..clear()
        ..addAll(nextFilter);
      _updateStatusList
        ..clear()
        ..addAll(nextUpdate);
      if (!_filterStatusList.contains(_selectedFilterStatus)) {
        _selectedFilterStatus = "ALL";
      }
    });
  }

  String _resolveApprovalStatus(String status) {
    final value = status?.trim() ?? "";
    if (value.isEmpty) return "Pending";

    for (final item in _updateStatusList) {
      if (item.toLowerCase() == value.toLowerCase()) {
        return item;
      }
    }
    return value;
  }

  List<String> _buildApprovalStatusOptions(String status) {
    final resolvedStatus = _resolveApprovalStatus(status);
    final options = List<String>.from(_updateStatusList);
    if (!options
        .any((item) => item.toLowerCase() == resolvedStatus.toLowerCase())) {
      options.add(resolvedStatus);
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is POApprovalListResponseState) {
            _onInquiryListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is POApprovalListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is POApprovalStatusListResponseState) {
            _applyApprovalStatusList(state);
          }
          if (state is POApprovalSaveResponseState) {
            _onSalesOrderSaveResponseState(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is POApprovalStatusListResponseState ||
              currentState is POApprovalSaveResponseState) {
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
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'PO Approval',
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
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilterPanel(context),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async => _fetchList(page: 1),
                  child: _buildPOList(context),
                ),
              ),
            ],
          ),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
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
            child: Container(
              height: r.s(44),
              decoration: BoxDecoration(
                color: const Color(0xffF2F5FA),
                borderRadius: BorderRadius.circular(r.s(10)),
                border: Border.all(color: const Color(0xffDDE3EF)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.s(10)),
                    child: Icon(Icons.search,
                        color: Colors.grey.shade500, size: r.s(20)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      textInputAction: TextInputAction.search,
                      onChanged: (v) {
                        _onSearchChanged(v);
                        setState(() {});
                      },
                      onSubmitted: (_) {
                        _debounceTimer?.cancel();
                        FocusScope.of(context).unfocus();
                        _fetchList(page: 1);
                      },
                      decoration: InputDecoration(
                        hintText: "Search PO no / customer...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: r.f(13)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: r.s(12)),
                      ),
                      style:
                          TextStyle(fontSize: r.f(13), color: Colors.black87),
                    ),
                  ),
                  if (_searchCtrl.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        _debounceTimer?.cancel();
                        _fetchList(page: 1);
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.all(r.s(8)),
                        child: Icon(Icons.close,
                            size: r.s(16), color: Colors.grey),
                      ),
                    ),
                  SizedBox(width: r.s(4)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: r.s(38),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: r.s(12)),
              itemCount: _filterStatusList.length,
              separatorBuilder: (_, __) => SizedBox(width: r.s(7)),
              itemBuilder: (_, i) {
                final status = _filterStatusList[i];
                final isSelected = _selectedFilterStatus == status;
                final color = _statusColor(status);
                return GestureDetector(
                  onTap: () => _onStatusChipTapped(status),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(horizontal: r.s(14)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? color : color.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(r.s(20)),
                      border: Border.all(
                        color: isSelected ? color : color.withOpacity(0.35),
                        width: 1.3,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: r.f(12),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: r.s(10)),
        ],
      ),
    );
  }

  Widget _buildPOList(BuildContext context) {
    final r = _R(context);
    if (isListExist && _leaveRequestListResponse != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: (info) {
          if (shouldPaginate(info)) {
            _onInquiryListPagination();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
          itemCount: _leaveRequestListResponse.details.length,
          itemBuilder: (ctx, i) => _buildPOCard(ctx, i),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildPOCard(BuildContext context, int index) {
    final r = _R(context);
    final detail = _leaveRequestListResponse.details[index];

    final String cardStatus = _resolveApprovalStatus(detail.approvalStatus);
    final List<String> statusOptions =
        _buildApprovalStatusOptions(detail.approvalStatus);

    final Color statusColor = _statusColor(cardStatus);

    String _fmtDate(String raw) {
      if (raw == null || raw.trim().isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    return Card(
      margin: EdgeInsets.only(bottom: r.s(10)),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.s(14))),
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
                EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(10)),
            decoration: BoxDecoration(
              color: const Color(0xff0066b3).withOpacity(0.05),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(r.s(14))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.orderNo ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: r.f(13.5),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0066b3),
                        ),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        _fmtDate(detail.orderDate),
                        style: TextStyle(
                          fontSize: r.f(11),
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: r.s(3)),
                      Text(
                        detail.customerName ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: r.f(12.5),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: r.s(8)),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: r.sw * 0.30),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.s(8), vertical: r.s(4)),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(r.s(20)),
                      border: Border.all(
                          color: statusColor.withOpacity(0.4), width: 1.1),
                    ),
                    child: Text(
                      cardStatus,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: r.f(10),
                        fontWeight: FontWeight.bold,
                      ),
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
                          Icons.person_outline,
                          "Customer",
                          detail.customerName ?? "N/A",
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
                          "Order Date",
                          _fmtDate(detail.orderDate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), r.s(12)),
            child: Row(
              children: [
                Text(
                  "Update :",
                  style: TextStyle(
                      fontSize: r.f(12),
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                SizedBox(width: r.s(6)),
                Expanded(
                  child: Container(
                    height: r.s(38),
                    padding: EdgeInsets.symmetric(horizontal: r.s(8)),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F5FA),
                      borderRadius: BorderRadius.circular(r.s(8)),
                      border: Border.all(color: const Color(0xffDDE3EF)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: cardStatus,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: r.f(12.5),
                            fontWeight: FontWeight.w500),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xff0066b3), size: r.s(20)),
                        items: statusOptions.map((s) {
                          return DropdownMenuItem<String>(
                            value: s,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: r.s(8),
                                  height: r.s(8),
                                  decoration: BoxDecoration(
                                    color: _statusColor(s),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: r.s(6)),
                                Flexible(
                                  child: Text(
                                    s,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: r.f(12.5),
                                        color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val == null) return;
                          FocusScope.of(context).unfocus();
                          setState(() {
                            detail.approvalStatus = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.s(8)),
                GestureDetector(
                  onTap: () => _onTapOfEditCustomer(detail),
                  child: Container(
                    height: r.s(38),
                    constraints: BoxConstraints(minWidth: r.s(60)),
                    padding: EdgeInsets.symmetric(horizontal: r.s(16)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xff108dcf),
                        Color(0xff0066b3),
                      ]),
                      borderRadius: BorderRadius.circular(r.s(8)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff0066b3).withOpacity(0.28),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: r.f(13),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green.shade600;
      case "closed":
        return Colors.red.shade700;
      case "pending":
        return Colors.blueGrey.shade600;
      case "all":
        return const Color(0xff0066b3);
      default:
        return Colors.blueGrey.shade600;
    }
  }

  void _onInquiryListCallSuccess(POApprovalListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _leaveRequestListResponse = state.response;
      } else {
        _leaveRequestListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
    if (_leaveRequestListResponse.details.length != 0) {
      isListExist = true;
    } else {
      isListExist = false;
    }
  }

  void _onInquiryListPagination() {
    int totalpage = _pageNo + 1;
    _fetchList(page: totalpage);
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onTapOfEditCustomer(POApprovalListResponseDetails detail) {
    final selectedStatus = _resolveApprovalStatus(detail.approvalStatus);

    FocusScope.of(context).unfocus();

    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to update PO Approval?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _mainBloc.add(POApprovalSaveRequestEvent(
            POApprovalSaveRequest(
                pkID: detail.pkID.toString(),
                ApprovalStatus: selectedStatus,
                LoginUserID: LoginUserID,
                CompanyId: CompanyID.toString()),
            context));
      },
    );
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {}

  void _onSalesOrderSaveResponseState(
      POApprovalSaveResponseState state, BuildContext context7up) {
    showCommonDialogWithSingleOption(context7up, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context7up);
      _fetchList(page: 1);
    });
  }
}
