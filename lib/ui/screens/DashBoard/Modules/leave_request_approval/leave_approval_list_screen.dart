import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/leave_request/leave_request_bloc.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_approval_save_request.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_request_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_request_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
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

class LeaveRequestApprovalListScreen extends BaseStatefulWidget {
  static const routeName = '/LeaveRequestApprovalListScreen';

  @override
  _LeaveRequestApprovalListScreenState createState() =>
      _LeaveRequestApprovalListScreenState();
}

class _LeaveRequestApprovalListScreenState
    extends BaseState<LeaveRequestApprovalListScreen>
    with BasicScreen, WidgetsBindingObserver {
  LeaveRequestScreenBloc _leaveRequestScreenBloc;
  int _pageNo = 0;
  bool isListExist = false;
  LeaveRequestListResponse _leaveRequestListResponse;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];

  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();

  String _selectedFilterStatus = "Pending";
  String _selectedEmployeeID = "";

  final List<String> _filterStatusList = [
    "Pending",
    "Approved",
    "Rejected",
  ];

  final List<String> _updateStatusList = [
    "Pending",
    "Approved",
    "Rejected",
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

    _leaveRequestScreenBloc = LeaveRequestScreenBloc(baseBloc);
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text =
        _offlineLoggedInData.details[0].employeeID.toString();
    _selectedEmployeeID = edt_FollowupEmployeeUserID.text;
    FetchFollowupStatusDetails();
    _fetchList();
  }

  void _fetchList() {
    _leaveRequestScreenBloc.add(LeaveRequestCallEvent(
        1,
        LeaveRequestListAPIRequest(
            EmployeeID: _selectedEmployeeID,
            ApprovalStatus:
                _selectedFilterStatus == "ALL" ? "" : _selectedFilterStatus,
            Month: "",
            Year: "",
            CompanyId: CompanyID)));
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() => _selectedFilterStatus = status);
    _fetchList();
  }

  void _onEmployeeFilterTap() {
    showcustomdialog(
        values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
        context1: context,
        controller: edt_FollowupEmployeeList,
        controller2: edt_FollowupEmployeeUserID,
        lable: "Select Employee",
        onValueSelected: () {
          setState(() {
            _selectedEmployeeID = edt_FollowupEmployeeUserID.text;
          });
          _fetchList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _leaveRequestScreenBloc,
      child: BlocConsumer<LeaveRequestScreenBloc, LeaveRequestStates>(
        builder: (BuildContext context, LeaveRequestStates state) {
          if (state is LeaveRequestStatesResponseState) {
            _onInquiryListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is LeaveRequestStatesResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, LeaveRequestStates state) {
          if (state is LeaveApprovalSaveResponseState) {
            _onLeaveApprovalSaveCallSucess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LeaveApprovalSaveResponseState) {
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
            'Leave Approval',
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
                  onRefresh: () async => _fetchList(),
                  child: _buildLeaveList(context),
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
                  child: _buildEmployeeFilter(r),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: _buildStatusFilter(r),
                ),
              ],
            ),
          ),
          SizedBox(height: r.s(10)),
        ],
      ),
    );
  }

  Widget _buildEmployeeFilter(_R r) {
    return InkWell(
      onTap: _onEmployeeFilterTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Employee",
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: edt_FollowupEmployeeList,
                    enabled: false,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: r.f(12),
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "Select Employee",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down,
                    color: const Color(0xff0066b3), size: r.s(22)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Filter Status",
          style: TextStyle(
            fontSize: r.f(11),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(4)),
        Container(
          height: r.s(40),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filterStatusList.length,
            separatorBuilder: (_, __) => SizedBox(width: r.s(7)),
            itemBuilder: (_, i) {
              final status = _filterStatusList[i];
              final isSelected = _selectedFilterStatus == status;
              final color = _statusColor(status);
              return GestureDetector(
                onTap: () => _onStatusChipTapped(status),
                child: Container(
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
                      fontSize: r.f(11),
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveList(BuildContext context) {
    final r = _R(context);
    if (isListExist && _leaveRequestListResponse != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(scrollInfo)) {
            _onInquiryListPagination();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
          itemCount: _leaveRequestListResponse.details.length,
          itemBuilder: (ctx, i) => _buildLeaveCard(ctx, i),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildLeaveCard(BuildContext context, int index) {
    final r = _R(context);
    final detail = _leaveRequestListResponse.details[index];

    final String cardStatus = _updateStatusList.contains(detail.approvalStatus)
        ? detail.approvalStatus
        : "Pending";

    final Color statusColor = _statusColor(cardStatus);

    String _fmtDate(String raw) {
      if (raw == null || raw.trim().isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    String _fmtDateTime(String raw) {
      if (raw == null || raw.trim().isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss",
              toFormat: "dd-MM-yyyy HH:mm") ??
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
                CircleAvatar(
                  radius: r.s(20),
                  backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                  child: Icon(Icons.person_outline,
                      color: const Color(0xff0066b3), size: r.s(20)),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.employeeName ?? "N/A",
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
                        "${_fmtDate(detail.fromDate)} - ${_fmtDate(detail.toDate)}",
                        style: TextStyle(
                          fontSize: r.f(10),
                          color: Colors.black54,
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
                          Icons.description_outlined,
                          "Reason",
                          detail.reasonForLeave ?? "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.category_outlined,
                          "Leave Type",
                          (detail.leaveType == "--Not Available--" ||
                                  detail.leaveType == null)
                              ? "N/A"
                              : detail.leaveType,
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
                          Icons.person_outline,
                          "Created By",
                          detail.createdBy ?? "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.calendar_today_outlined,
                          "Created Date",
                          _fmtDateTime(detail.createdDate ?? ""),
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
                        value: detail.approvalStatus,
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
                maxLines: 2,
                style: TextStyle(fontSize: r.f(11.5), color: Colors.black87),
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
      case "pending":
        return Colors.blueGrey.shade600;
      case "all":
        return const Color(0xff0066b3);
      default:
        return Colors.blueGrey.shade600;
    }
  }

  void _onInquiryListCallSuccess(LeaveRequestStatesResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _leaveRequestListResponse = state.leaveRequestListResponse;
      } else {
        _leaveRequestListResponse.details
            .addAll(state.leaveRequestListResponse.details);
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
    _leaveRequestScreenBloc.add(LeaveRequestCallEvent(
        _pageNo + 1,
        LeaveRequestListAPIRequest(
            EmployeeID: _selectedEmployeeID,
            ApprovalStatus:
                _selectedFilterStatus == "ALL" ? "" : _selectedFilterStatus,
            Month: "",
            Year: "",
            CompanyId: CompanyID)));
  }

  void _onTapOfEditCustomer(LeaveRequestDetails detail) {
    FocusScope.of(context).unfocus();

    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to update this record?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _leaveRequestScreenBloc.add(LeaveRequestApprovalSaveCallEvent(
          detail.pkID,
          LeaveApprovalSaveAPIRequest(
              ApprovalStatus: detail.approvalStatus,
              LoginUserID: LoginUserID,
              CompanyId: CompanyID)));
    });
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = "";
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].pkID.toString();
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  void FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      if (i == 0) {
        all_name_id.Name = "Pending";
      } else if (i == 1) {
        all_name_id.Name = "Approved";
      } else if (i == 2) {
        all_name_id.Name = "Rejected";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onLeaveApprovalSaveCallSucess(
      LeaveApprovalSaveResponseState state, BuildContext buildContext123) {
    _fetchList();
  }
}
