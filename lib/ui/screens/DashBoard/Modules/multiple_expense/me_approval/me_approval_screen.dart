import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/sales_order_approval_status_list_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_approval_update_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_approval_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_approval_list_response.dart';
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

class MultiExpenseApprovalScreen extends BaseStatefulWidget {
  static const routeName = '/MultiExpenseApprovalScreen';

  @override
  _MultiExpenseApprovalScreenState createState() =>
      _MultiExpenseApprovalScreenState();
}

class _MultiExpenseApprovalScreenState
    extends BaseState<MultiExpenseApprovalScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  int _pageNo = 0;
  bool isListExist = false;
  MultipleExpenseApprovalListResponse _multipleExpenseApprovalListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int _companyID = 0;
  String _loginUserID = "";
  String _selectedFilterStatus = "ALL";
  List<String> _apiStatuses = [];
  List<String> _filterChipStatuses = ["ALL"];

  final Map<int, String> _localSelectedStatus = {};
  final Map<int, TextEditingController> _remarkControllers = {};

  List<MultipleExpenseApprovalListResponseDetails> get _visibleDetails {
    final all = _multipleExpenseApprovalListResponse?.details ?? [];
    if (_selectedFilterStatus == "ALL") return all;
    final sel = _selectedFilterStatus.trim().toLowerCase();
    return all.where((d) {
      // Use the ORIGINAL api status on the model, NOT the local dropdown value
      final s = (d.approvalStatus ?? "").trim().toLowerCase();
      final effective = s.isEmpty
          ? (_apiStatuses.isNotEmpty ? _apiStatuses.first.toLowerCase() : "")
          : s;
      return effective == sel;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _companyID = _offlineCompanyData.details[0].pkId;
    _loginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);
    _fetchApprovalStatusList();
    _fetchList(page: 1);
  }

  @override
  void dispose() {
    for (final c in _remarkControllers.values) c.dispose();
    super.dispose();
  }

  void _fetchList({int page = 1}) {
    _mainBloc.add(MultiExpenseApprovalListRequestEvent(
        MultiExpenseApprovalListRequest(
          pkID: "0",
          ApprovalStatus:
              _selectedFilterStatus == "ALL" ? "" : _selectedFilterStatus,
          PageNo: page.toString(),
          PageSize: "10",
          LoginUserID: _loginUserID,
          CompanyId: _companyID.toString(),
          Month: "",
          Year: "",
        ),
        page));
  }

  void _fetchApprovalStatusList() {
    _mainBloc.add(MultiExpenseApprovalStatusListRequestEvent(
        SalesOrderApprovalStatusListRequest(
      pkID: "0",
      StatusCategory: "ExpenseApproval",
      PageNo: "1",
      PageSize: "1000",
      CompanyId: _companyID.toString(),
    )));
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    if (_selectedFilterStatus == status) return;
    setState(() => _selectedFilterStatus = status);
    _fetchList(page: 1);
  }

  String _localStatusFor(MultipleExpenseApprovalListResponseDetails detail) {
    if (_localSelectedStatus.containsKey(detail.pkID)) {
      return _localSelectedStatus[detail.pkID];
    }
    return _resolveStatus(detail.approvalStatus);
  }

  TextEditingController _remarkControllerFor(
      MultipleExpenseApprovalListResponseDetails detail) {
    return _remarkControllers.putIfAbsent(
      detail.pkID,
      () => TextEditingController(
          text: detail.approvalRemarks?.trim()?.isNotEmpty == true
              ? detail.approvalRemarks
              : (detail.expenseNotes ?? "")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (context, state) => super.build(context),
        buildWhen: (_, __) => false,
        listener: (context, state) {
          if (state is MultiExpenseApprovalListResponseState) {
            _onListSuccess(state);
          }
          if (state is MultiExpenseApprovalStatusListResponseState) {
            _onStatusListSuccess(state);
          }
          if (state is MultiExpenseApprovalUpdateResponseState) {
            _onUpdateSuccess(state, context);
          }
        },
        listenWhen: (_, cur) =>
            cur is MultiExpenseApprovalListResponseState ||
            cur is MultiExpenseApprovalStatusListResponseState ||
            cur is MultiExpenseApprovalUpdateResponseState,
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
            'Multiple Expense Approval',
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
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilterPanel(context),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async => _fetchList(page: 1),
                  child: _buildList(context),
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
          SizedBox(height: r.s(10)),
          SizedBox(
            height: r.s(38),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: r.s(12)),
              itemCount: _filterChipStatuses.length,
              separatorBuilder: (_, __) => SizedBox(width: r.s(7)),
              itemBuilder: (_, i) {
                final status = _filterChipStatuses[i];
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

  Widget _buildList(BuildContext context) {
    final r = _R(context);
    final visible = _visibleDetails;
    if (isListExist && _multipleExpenseApprovalListResponse != null) {
      if (visible.isEmpty) {
        return Center(
          child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
              height: r.s(180), width: r.s(180)),
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (info) {
          if (shouldPaginate(info)) {
            _fetchList(page: _pageNo + 1);
            return true;
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
          itemCount: visible.length,
          itemBuilder: (ctx, i) => _buildCard(ctx, visible[i]),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildCard(
      BuildContext context, MultipleExpenseApprovalListResponseDetails detail) {
    final r = _R(context);

    final String cardStatus = _localStatusFor(detail);
    final List<String> dropdownOptions = _buildCardDropdownOptions(cardStatus);

    final String dropdownValue = dropdownOptions.firstWhere(
      (s) => s.toLowerCase() == cardStatus.toLowerCase(),
      orElse: () =>
          dropdownOptions.isNotEmpty ? dropdownOptions.first : cardStatus,
    );

    final remarkController = _remarkControllerFor(detail);
    final bool showRemarkBox = _requiresRemark(cardStatus);

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
                        detail.voucherNo ?? "N/A",
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
                        _fmtDate(detail.expenseDate),
                        style:
                            TextStyle(fontSize: r.f(11), color: Colors.black54),
                      ),
                      SizedBox(height: r.s(3)),
                      Text(
                        detail.expenseNotes ?? detail.employeename ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: r.f(12.5), color: Colors.black87),
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
                      color: _statusColor(_resolveStatus(detail.approvalStatus))
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(r.s(20)),
                      border: Border.all(
                          color: _statusColor(
                                  _resolveStatus(detail.approvalStatus))
                              .withOpacity(0.4),
                          width: 1.1),
                    ),
                    child: Text(
                      _resolveStatus(detail.approvalStatus),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color:
                            _statusColor(_resolveStatus(detail.approvalStatus)),
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
                        _infoTile(r, Icons.currency_rupee, "Amount",
                            "₹${detail.amount?.toString() ?? "0"}"),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.person_outline,
                          "Employee",
                          detail.createdEmployeeName ??
                              detail.updatedEmployeeName ??
                              "N/A",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoTile(r, Icons.calendar_today_outlined,
                            "Expense Date", _fmtDate(detail.expenseDate)),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.notes_outlined, "Remarks",
                            _getRemarks(detail)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showRemarkBox)
            Padding(
              padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), 0),
              child: TextField(
                key: ValueKey('remark_${detail.pkID}'),
                controller: remarkController,
                maxLines: 2,
                style: TextStyle(fontSize: r.f(13)),
                decoration: InputDecoration(
                  labelText: "Approval Remark *",
                  labelStyle: TextStyle(
                      fontSize: r.f(12), color: const Color(0xff0066b3)),
                  hintText: "Enter remark...",
                  hintStyle: TextStyle(fontSize: r.f(12)),
                  filled: true,
                  fillColor: const Color(0xffF2F5FA),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(r.s(8)),
                      borderSide: const BorderSide(color: Color(0xffDDE3EF))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(r.s(8)),
                      borderSide: const BorderSide(color: Color(0xffDDE3EF))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(r.s(8)),
                      borderSide: const BorderSide(color: Color(0xff0066b3))),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: r.s(12), vertical: r.s(10)),
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

                // Dropdown
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
                        value: dropdownValue,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: r.f(12.5),
                            fontWeight: FontWeight.w500),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xff0066b3), size: r.s(20)),
                        items: dropdownOptions.map((s) {
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
                            _localSelectedStatus[detail.pkID] = val;
                            if (!_requiresRemark(val)) {
                              _remarkControllers[detail.pkID]?.clear();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.s(8)),
                GestureDetector(
                  onTap: () => _onTapSave(detail),
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
              Text(label,
                  style: TextStyle(
                      fontSize: r.f(10),
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
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
    switch (status.trim().toLowerCase()) {
      case "approved":
        return Colors.green.shade600;
      case "rejected":
        return Colors.red.shade600;
      case "pending":
        return Colors.blueGrey.shade600;
      case "onhold":
      case "on hold":
        return Colors.orange.shade700;
      case "cash purchase":
        return Colors.purple.shade600;
      case "all":
        return const Color(0xff0066b3);
      default:
        return Colors.blueGrey.shade400;
    }
  }

  bool _requiresRemark(String status) =>
      status.trim().toLowerCase() == "approved";

  String _getRemarks(MultipleExpenseApprovalListResponseDetails detail) {
    if (detail.approvalRemarks?.trim()?.isNotEmpty == true)
      return detail.approvalRemarks;
    if (detail.expenseNotes?.trim()?.isNotEmpty == true)
      return detail.expenseNotes;
    return "N/A";
  }

  String _resolveStatus(String raw) {
    final value = raw?.trim() ?? "";
    if (_apiStatuses.isNotEmpty) {
      for (final s in _apiStatuses) {
        if (s.toLowerCase() == value.toLowerCase()) return s;
      }
    }
    if (value.isEmpty) {
      return _apiStatuses.isNotEmpty ? _apiStatuses.first : "Pending";
    }
    return value;
  }

  List<String> _buildCardDropdownOptions(String resolvedStatus) {
    final options = List<String>.from(_apiStatuses);
    if (options.isEmpty) return [resolvedStatus];
    if (!options.any((s) => s.toLowerCase() == resolvedStatus.toLowerCase())) {
      options.insert(0, resolvedStatus);
    }
    return options;
  }

  void _onListSuccess(MultiExpenseApprovalListResponseState state) {
    if (!mounted) return;
    setState(() {
      if (_pageNo != state.newPage || state.newPage == 1) {
        if (state.newPage == 1) {
          _multipleExpenseApprovalListResponse = state.response;
          _localSelectedStatus.clear();
          for (final c in _remarkControllers.values) c.dispose();
          _remarkControllers.clear();
        } else {
          _multipleExpenseApprovalListResponse?.details
              .addAll(state.response.details ?? []);
        }
        _pageNo = state.newPage;
      }
      isListExist =
          (_multipleExpenseApprovalListResponse?.details?.isNotEmpty) == true;
    });
  }

  void _onStatusListSuccess(MultiExpenseApprovalStatusListResponseState state) {
    if (!mounted) return;
    final details = state.response?.details ?? [];
    final List<String> seen = [];
    final Set<String> seenLower = {};
    for (final d in details) {
      final s = d.inquiryStatus?.trim() ?? "";
      if (s.isNotEmpty && seenLower.add(s.toLowerCase())) {
        seen.add(s);
      }
    }
    final List<String> chips = ["ALL", ...seen];
    setState(() {
      _apiStatuses = seen;
      _filterChipStatuses = chips;
      if (!_filterChipStatuses.contains(_selectedFilterStatus)) {
        _selectedFilterStatus = "ALL";
      }
    });
  }

  void _onUpdateSuccess(
      MultiExpenseApprovalUpdateResponseState state, BuildContext context) {
    final message = state.response?.details?.isNotEmpty == true
        ? (state.response.details.first.column2 ??
            "Expense Approval Updated Successfully!")
        : "Expense Approval Updated Successfully!";

    showCommonDialogWithSingleOption(
      context,
      message,
      positiveButtonTitle: "OK",
      onTapOfPositiveButton: () {
        Navigator.pop(context);
        _fetchList(page: 1);
      },
    );
  }

  void _onTapSave(MultipleExpenseApprovalListResponseDetails detail) {
    FocusScope.of(context).unfocus();
    final selectedStatus = _localStatusFor(detail);
    final remark = (_remarkControllers[detail.pkID]?.text.trim() ?? "");
    if (_requiresRemark(selectedStatus) && remark.isEmpty) {
      showCommonDialogWithSingleOption(
        context,
        "Please add an approval remark before saving.",
        positiveButtonTitle: "OK",
      );
      return;
    }

    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to update the Expense Approval?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _mainBloc.add(MultiExpenseApprovalUpdateRequestEvent(
          MultiExpenseApprovalUpdateRequest(
            pkID: detail.pkID.toString(),
            LoginUserID: _loginUserID,
            ApprovalStatus: selectedStatus,
            ApprovalRemarks: remark,
            CompanyId: _companyID.toString(),
          ),
        ));
      },
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }
}
