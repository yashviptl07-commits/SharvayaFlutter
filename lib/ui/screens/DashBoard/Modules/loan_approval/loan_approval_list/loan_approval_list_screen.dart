import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/loan/loan_bloc.dart';
import 'package:soleoserp/models/api_requests/Loan/loan_approval_save_request.dart';
import 'package:soleoserp/models/api_requests/loan/loan_approval_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/loan/loan_list_response.dart';
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

class LoanApprovalListScreen extends BaseStatefulWidget {
  static const routeName = '/LoanApprovalListScreen';

  @override
  _LoanApprovalListScreenState createState() => _LoanApprovalListScreenState();
}

class _LoanApprovalListScreenState extends BaseState<LoanApprovalListScreen>
    with BasicScreen, WidgetsBindingObserver {
  LoanScreenBloc _leaveRequestScreenBloc;
  int _pageNo = 0;
  bool isListExist = false;
  LoanListResponse _leaveRequestListResponse;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];

  String _selectedFilterStatus = "Pending";

  final List<String> _filterStatusList = [
    "ALL",
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

    _leaveRequestScreenBloc = LoanScreenBloc(baseBloc);
    FetchFollowupStatusDetails();
    _fetchList();
  }

  void _fetchList() {
    _leaveRequestScreenBloc.add(LoanApprovalListCallEvent(
        LoanApprovalListRequest(
            pkID: "",
            ApprovalStatus:
                _selectedFilterStatus == "ALL" ? "" : _selectedFilterStatus,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID)));
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() => _selectedFilterStatus = status);
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _leaveRequestScreenBloc,
      child: BlocConsumer<LoanScreenBloc, LoanScreenStates>(
        builder: (BuildContext context, LoanScreenStates state) {
          if (state is LoanApprovalListResponseState) {
            _onInquiryListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is LoanApprovalListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, LoanScreenStates state) {
          if (state is LoanApprovalSaveResponseState) {
            _OnLoanApprovalSucess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LoanApprovalSaveResponseState) {
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
            'Loan Approval',
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
                  child: _buildLoanList(context),
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

  Widget _buildLoanList(BuildContext context) {
    final r = _R(context);
    if (isListExist && _leaveRequestListResponse != null) {
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _leaveRequestListResponse.details.length,
        itemBuilder: (ctx, i) => _buildLoanCard(ctx, i),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildLoanCard(BuildContext context, int index) {
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
                        _fmtDate(detail.createdDate ?? ""),
                        style: TextStyle(
                          fontSize: r.f(11),
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
                          Icons.attach_money_outlined,
                          "Loan Amount",
                          detail.loanAmount?.toString() ?? "0",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.format_list_numbered_outlined,
                          "No. Of Installments",
                          detail.noOfInstallments?.toString() ?? "0",
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
                          Icons.payment_outlined,
                          "Installment Amount",
                          detail.installmentAmount?.toString() ?? "0",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.calendar_today_outlined,
                          "Apply Date",
                          _fmtDate(detail.createdDate ?? ""),
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
      case "pending":
        return Colors.blueGrey.shade600;
      case "all":
        return const Color(0xff0066b3);
      default:
        return Colors.blueGrey.shade600;
    }
  }

  void _onInquiryListCallSuccess(LoanApprovalListResponseState state) {
    _leaveRequestListResponse = state.employeeListResponse;
    if (_leaveRequestListResponse.details.length != 0) {
      isListExist = true;
    } else {
      isListExist = false;
    }
  }

  void _onTapOfEditCustomer(LoanDetails detail) {
    final selectedStatus = detail.approvalStatus;

    FocusScope.of(context).unfocus();

    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to update this Loan Approval?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _leaveRequestScreenBloc.add(LoanApprovalSaveRequestCallEvent(
            detail.pkID,
            LoanApprovalSaveRequest(
                ApprovalStatus: selectedStatus,
                LoginUserID: LoginUserID,
                CompanyID: CompanyID.toString())));
      },
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {}

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

  void _OnLoanApprovalSucess(LoanApprovalSaveResponseState state) {
    showCommonDialogWithSingleOption(
        context, "Loan Approval Updated Successfully!",
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _fetchList();
    });
  }
}
