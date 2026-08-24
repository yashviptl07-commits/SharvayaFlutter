import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Material_Indent_request/Material_Indent_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Indent_request/Material_Indent_approval_update_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/Material_Indent_response/Material_Indent_list_response.dart';
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

class MaterialIndentApprovalScreen extends BaseStatefulWidget {
  static const routeName = '/MaterialIndentApprovalScreen';

  @override
  _MaterialIndentApprovalScreenState createState() =>
      _MaterialIndentApprovalScreenState();
}

class _MaterialIndentApprovalScreenState
    extends BaseState<MaterialIndentApprovalScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  int _pageNo = 0;
  bool isListExist = false;
  MaterialIndentListResponse _materialIndentListResponse;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;

  String _selectedFilterStatus = "ALL";

  final List<String> _filterStatusList = [
    "ALL",
    "Pending",
    "Approved",
    "Rejected",
    "OnHold",
    "Cash Purchase",
  ];

  final List<String> _updateStatusList = [
    "Pending",
    "Approved",
    "Rejected",
    "OnHold",
    "Cash Purchase",
  ];

  final Map<int, TextEditingController> _remarkControllers = {};

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);
    _fetchList(page: 1);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    for (final c in _remarkControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _fetchList({int page = 1}) {
    _mainBloc.add(MaterialIndentListRequestEvent(
        page,
        MaterialIndentListRequest(
          pkID: "0",
          SearchKey: _searchCtrl.text.trim(),
          ApprovalStatus:
              _selectedFilterStatus == "ALL" ? "" : _selectedFilterStatus,
          PageNo: page.toString(),
          PageSize: "10",
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString(),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (context, state) {
          if (state is MaterialIndentListResponseState) {
            _onIndentListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (_, cur) => cur is MaterialIndentListResponseState,
        listener: (context, state) {
          if (state is MaterialIndentApprovalUpdateResponseState) {
            _onIndentApprovalUpdateSuccess(state, context);
          }
        },
        listenWhen: (_, cur) =>
            cur is MaterialIndentApprovalUpdateResponseState,
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
            'Indent Approval',
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
                  child: _buildIndentList(context),
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
                        hintText: "Search indent no / product...",
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

  Widget _buildIndentList(BuildContext context) {
    final r = _R(context);
    if (isListExist && _materialIndentListResponse != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: (info) {
          if (shouldPaginate(info)) {
            _onIndentListPagination();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
          itemCount: _materialIndentListResponse.details.length,
          itemBuilder: (ctx, i) => _buildIndentCard(ctx, i),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildIndentCard(BuildContext context, int index) {
    final r = _R(context);
    final detail = _materialIndentListResponse.details[index];

    final String cardStatus = _updateStatusList.contains(detail.approvalStatus)
        ? detail.approvalStatus
        : "Pending";

    final Color statusColor = _statusColor(cardStatus);

    // Safe formatted date
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
                        detail.indentNo ?? "N/A",
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
                        _fmtDate(detail.indentDate),
                        style: TextStyle(
                          fontSize: r.f(11),
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: r.s(3)),
                      Text(
                        detail.productName ?? "N/A",
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
                // Status badge
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
                          Icons.inventory_2_outlined,
                          "Qty / Unit",
                          [
                            detail.quantity?.toString() ?? "N/A",
                            detail.unit ?? ""
                          ].where((e) => e.isNotEmpty).join(" "),
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.person_outline,
                          "Approved By",
                          detail.approvedBy ?? "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.person_outline,
                          "Employee Name",
                          detail.employeeName ?? "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.person_outline,
                          "Tech Spec By Eng",
                          detail.bfrProdRemark ?? "N/A",
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
                          "Indent Date",
                          _fmtDate(detail.indentDate),
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.notes_outlined,
                          "Remarks",
                          _getRemarks(detail),
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.notes_outlined,
                          "Requested By",
                          detail.createdEmployeeName ?? "N/A",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (cardStatus == "Approved")
            Padding(
              padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), 0),
              child: TextField(
                key: ValueKey('remark_${detail.pkID}'),
                controller: _remarkControllerFor(detail),
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
                onChanged: (v) {
                  detail.approvalStatus = v;
                  setState(() {});
                },
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

                // Dropdown — takes remaining space
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
                        items: _updateStatusList.map((s) {
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
                          detail.approvalStatus = val;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(width: r.s(8)),

                // Save button — fixed width so it never wraps
                GestureDetector(
                  onTap: () => _onTapOfEditIndent(detail),
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
      case "rejected":
        return Colors.red.shade600;
      case "onhold":
        return Colors.orange.shade700;
      case "cash purchase":
        return Colors.purple.shade600;
      case "all":
        return const Color(0xff0066b3);
      default:
        return Colors.blueGrey.shade600;
    }
  }

  TextEditingController _remarkControllerFor(
      MaterialIndentListResponseDetails detail) {
    return _remarkControllers.putIfAbsent(
      detail.pkID,
      () => TextEditingController(text: detail.remarks ?? detail.remarks ?? ""),
    );
  }

  String _getRemarks(MaterialIndentListResponseDetails detail) {
    if (detail.remarks?.trim()?.isNotEmpty == true) return detail.remarks;
    if (detail.remarks?.trim()?.isNotEmpty == true) return detail.remarks;
    return "N/A";
  }

  void _onIndentListCallSuccess(MaterialIndentListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _materialIndentListResponse = state.response;
      } else {
        _materialIndentListResponse?.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
    isListExist = (_materialIndentListResponse?.details.isNotEmpty) == true;
  }

  void _onIndentListPagination() => _fetchList(page: _pageNo + 1);

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onTapOfEditIndent(MaterialIndentListResponseDetails detail) {
    final selectedStatus = detail.approvalStatus?.trim() ?? "Pending";
    final remark = detail.remarks?.trim().isNotEmpty == true
        ? detail.remarks.trim()
        : detail.remarks?.trim() ?? "";

    FocusScope.of(context).unfocus();

    if (selectedStatus == "Approved" && remark.isEmpty) {
      showCommonDialogWithSingleOption(
        context,
        "Please add an approval remark before saving.",
        positiveButtonTitle: "OK",
      );
      return;
    }

    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to update the Indent Approval?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _mainBloc.add(MaterialIndentApprovalUpdateRequestEvent(
          MaterialIndentApprovalUpdateRequest(
            pkID: detail.pkID.toString(),
            ApprovalStatus: selectedStatus,
            ApprovalRemarks: remark,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
          ),
        ));
      },
    );
  }

  void _onIndentApprovalUpdateSuccess(
      MaterialIndentApprovalUpdateResponseState state, BuildContext context) {
    final message = state.response?.details?.isNotEmpty == true
        ? (state.response.details.first.column2 ??
            "Indent Approval Updated Successfully!")
        : "Indent Approval Updated Successfully!";

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
}
