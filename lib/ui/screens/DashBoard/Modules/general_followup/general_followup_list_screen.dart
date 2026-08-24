import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:soleoserp/models/api_requests/followup/followup_count_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_delete_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/telecaller_followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_share_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/broadcast_msg/make_call.dart';
import 'package:soleoserp/utils/broadcast_msg/share_msg.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import '../../home_screen.dart';

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

class GeneralFollowupListScreenArguments {
  String EmployeeName;
  GeneralFollowupListScreenArguments(this.EmployeeName);
}

class GeneralFollowupListScreen extends BaseStatefulWidget {
  static const routeName = '/GeneralFollowupListScreen';
  final GeneralFollowupListScreenArguments arguments;

  GeneralFollowupListScreen(this.arguments);

  @override
  _GeneralFollowupListScreenState createState() =>
      _GeneralFollowupListScreenState();
}

class _GeneralFollowupListScreenState
    extends BaseState<GeneralFollowupListScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  int _pageNo = 0;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  List<FilterDetails> arr_FollowupList = [];

  bool isListExist = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  int TotalCount = 0;
  int FinalTotalCount = 0;

  bool _isForUpdate;
  String NotificationEmpName = "";
  List<InquirySharedEmpDetails> arr_Inquiry_Share_Emp_List = [];

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();

  String _selectedFilterStatus = "Todays";
  String _selectedEmployeeID = "";
  final List<String> _filterStatusList = ["Todays", "Missed", "Future"];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _FollowupBloc = FollowupBloc(baseBloc);

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      NotificationEmpName = widget.arguments.EmployeeName;
    }

    getUserRights(_menuRightsResponse);

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;
    _selectedEmployeeID = edt_FollowupEmployeeUserID.text;

    _fetchList();
    _fetchCount();
  }

  void _fetchList() {
    _FollowupBloc.add(FollowupFilterListCallEvent(
        _selectedFilterStatus,
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: _selectedEmployeeID,
            PageNo: 1,
            PageSize: 10)));
  }

  void _fetchCount() {
    _FollowupBloc.add(FollowupCountRequestEvent(
        _selectedFilterStatus,
        FollowupCountRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: _selectedEmployeeID,
            FollowupStatus: _selectedFilterStatus)));
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedFilterStatus = status;
    });
    _fetchList();
    _fetchCount();
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
          _fetchCount();
        });
  }

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupFilterListCallResponseState) {
            _onFollowupListCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          if (state is FollowupDeleteCallResponseState) {
            _onFollowupDeleteCallSucess(state, context);
          }
          if (state is InquiryShareEmpListResponseState) {
            _OnInquiryShareEmpListResponse(state);
          }
          if (state is FollowUpCountState) {
            _OnFetchTotalCount(state);
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is FollowupFilterListCallResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is FollowupDeleteCallResponseState ||
              currentState is InquiryShareEmpListResponseState ||
              currentState is FollowUpCountState;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final r = _R(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'General Followup',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: r.s(8), vertical: r.s(4)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(r.s(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.white, size: r.s(16)),
                  SizedBox(width: r.s(4)),
                  Text(
                    FinalTotalCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.f(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (IsAddRights == true)
              IconButton(
                icon: const Icon(Icons.add_circle_sharp,
                    color: Colors.white, size: 24),
                onPressed: () {
                  navigateTo(context, FollowUpAddEditScreen.routeName,
                      arguments: AddUpdateFollowupScreenArguments(
                          null, _selectedFilterStatus, ""));
                },
              ),
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilterPanel(context, r),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async {
                    _fetchList();
                    _fetchCount();
                    getUserRights(_menuRightsResponse);
                  },
                  child: _buildFollowupList(context, r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context, _R r) {
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
            padding:
                EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(5)),
            child: _buildEmployeeFilter(r),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(5)),
            child: _buildStatusFilter(r),
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
                  child: Text(
                    edt_FollowupEmployeeList.text.isEmpty
                        ? "Select Employee"
                        : edt_FollowupEmployeeList.text,
                    style: TextStyle(
                      color: edt_FollowupEmployeeList.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(12),
                      fontWeight: FontWeight.w500,
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
          height: r.s(38),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filterStatusList.length,
            separatorBuilder: (_, __) => SizedBox(width: r.s(7)),
            itemBuilder: (_, i) {
              final status = _filterStatusList[i];
              final isSelected = _selectedFilterStatus == status;
              final color = _getStatusColor(status);
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

  Widget _buildFollowupList(BuildContext context, _R r) {
    if (!isListExist && arr_FollowupList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Followups Found",
              style: TextStyle(
                  fontSize: r.f(14),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(scrollInfo)) {
          _onFollowupListPagination();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: arr_FollowupList.length,
        itemBuilder: (ctx, i) => _buildFollowupCard(ctx, r, i),
      ),
    );
  }

  Widget _buildFollowupCard(BuildContext context, _R r, int index) {
    final model = arr_FollowupList[index];

    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    bool isTeleCaller = model.extpkID.toString().toLowerCase() != "0";

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
              children: [
                CircleAvatar(
                  radius: r.s(20),
                  backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                  child: Text(
                    model.customerName?.substring(0, 1).toUpperCase() ?? "C",
                    style: TextStyle(
                        fontSize: r.f(16),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0066b3)),
                  ),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.customerName ?? "N/A",
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        model.contactNo1 ?? "N/A",
                        style:
                            TextStyle(fontSize: r.f(11), color: Colors.black54),
                      ),
                    ],
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
                      children: [
                        _infoTile(r, Icons.calendar_today_outlined,
                            "Followup Date", _fmtDate(model.followupDate)),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.category_outlined, "Followup Type",
                            model.inquiryStatus ?? "N/A"),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      children: [
                        _infoTile(r, Icons.calendar_today_outlined,
                            "Next Followup", _fmtDate(model.nextFollowupDate)),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                            r,
                            Icons.people_outline,
                            "Next Time",
                            model.preferredTime?.isNotEmpty == true
                                ? model.preferredTime
                                : "N/A"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(8)),
            child: Wrap(
              spacing: r.s(8),
              runSpacing: r.s(8),
              children: [
                _actionChip(r, Icons.call, "Call",
                    () => MakeCall.callto(model.contactNo1)),
                _actionChip(r, Icons.share, "Share",
                    () => ShareMsg.msg(context, model.contactNo1)),
                _actionChip(r, Icons.history, "History", () {
                  if (isTeleCaller) {
                    MoveToTeleCallerfollowupHistoryPage(
                        model.extpkID.toString(), "Followup");
                  } else {
                    MoveTofollowupHistoryPage(
                        model.inquiryNo, model.customerID.toString());
                  }
                }),
                _actionChip(
                    r, Icons.add, "Followup", () => _navigateToFollowUp(model)),
                if (model.inquiryNo != "" &&
                    (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
                            "dol2-6uh7-ph03-in5h" ||
                        _offlineLoggedInData.details[0].serialKey
                                .toLowerCase() ==
                            "test-0000-si0f-0208"))
                  _actionChip(
                      r, Icons.share, "Share Lead", () => _shareInquiry(model)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(5), r.s(14), r.s(12)),
            child: Column(
              children: [
                if (model.meetingNotes != null && model.meetingNotes.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(r.s(8)),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(r.s(8))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_outlined,
                            size: r.s(12), color: const Color(0xff0066b3)),
                        SizedBox(width: r.s(6)),
                        Expanded(
                          child: Text(
                            model.meetingNotes,
                            style: TextStyle(
                                fontSize: r.f(11), color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Created By", model.employeeName ?? "N/A"),
              ],
            ),
          )
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: r.f(10),
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              Text(value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: r.f(12), color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionChip(_R r, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
        decoration: BoxDecoration(
            color: const Color(0xffF2F5FA),
            borderRadius: BorderRadius.circular(r.s(20))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: r.s(14), color: const Color(0xff0066b3)),
          SizedBox(width: r.s(4)),
          Text(label,
              style: TextStyle(
                  fontSize: r.f(10),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1A2332))),
        ]),
      ),
    );
  }

  Widget _detailRow(_R r, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: r.s(80),
            child: Text(label,
                style:
                    TextStyle(fontSize: r.f(10), color: Colors.grey.shade500))),
        SizedBox(width: r.s(8)),
        Expanded(
            child: Text(value,
                style: TextStyle(fontSize: r.f(11), color: Colors.black87))),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'todays':
        return Colors.blue.shade600;
      case 'missed':
        return Colors.red.shade600;
      case 'future':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void _navigateToFollowUp(FilterDetails model) {
    model.meetingNotes = "";
    model.pkID = 0;
    model.followupDate = "";
    model.nextFollowupDate = "";
    model.preferredTime = "";

    navigateTo(context, FollowUpAddEditScreen.routeName,
            arguments: AddUpdateFollowupScreenArguments(
                model, _selectedFilterStatus, ""))
        .then((value) {
      setState(() {
        _selectedFilterStatus = value;
        _fetchList();
        _fetchCount();
      });
    });
  }

  void _shareInquiry(FilterDetails model) {
    _FollowupBloc.add(InquiryShareEmpListRequestEvent(
        InquiryShareEmpListRequest(
            InquiryNo: model.inquiryNo, CompanyId: CompanyID.toString())));
  }

  void _onFollowupListCallSuccess(FollowupFilterListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        arr_FollowupList.clear();
        arr_FollowupList.addAll(state.followupFilterListResponse.details);
        isListExist = arr_FollowupList.isNotEmpty;
        TotalCount = state.followupFilterListResponse.totalCount;
      } else {
        arr_FollowupList.addAll(state.followupFilterListResponse.details);
      }
      _pageNo = state.newPage;
    }
  }

  void _onFollowupListPagination() {
    _FollowupBloc.add(FollowupFilterListCallEvent(
        _selectedFilterStatus,
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: _selectedEmployeeID,
            PageNo: _pageNo + 1,
            PageSize: 10)));
  }

  void _onFollowupDeleteCallSucess(
      FollowupDeleteCallResponseState state, BuildContext buildContext123) {
    showCommonDialogWithSingleOption(
        context, state.followupDeleteResponse.details[0].column1.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _fetchList();
      _fetchCount();
    });
  }

  void _onTapOfDeleteCustomer(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Followup?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _FollowupBloc.add(FollowupDeleteByNameCallEvent(
          id, FollowupDeleteRequest(CompanyId: CompanyID.toString())));
    });
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo, String CustomerID) {
    return navigateTo(context, FollowupHistoryScreen.routeName,
        arguments: FollowupHistoryScreenArguments(inquiryNo, CustomerID));
  }

  Future<void> MoveToTeleCallerfollowupHistoryPage(
      String inquiryNo, String CustomerID) {
    return navigateTo(context, TeleCallerFollowupHistoryScreen.routeName,
        arguments:
            TeleCallerFollowupHistoryScreenArguments(inquiryNo, CustomerID));
  }

  void _OnInquiryShareEmpListResponse(InquiryShareEmpListResponseState state) {
    arr_Inquiry_Share_Emp_List.clear();
    if (state.response.totalCount != 0) {
      arr_Inquiry_Share_Emp_List.addAll(state.response.details);
    } else {
      InquirySharedEmpDetails inquirySharedEmpDetails =
          InquirySharedEmpDetails();
      inquirySharedEmpDetails.inquiryNo = state.InquiryNo;
      inquirySharedEmpDetails.employeeID =
          _offlineLoggedInData.details[0].employeeID;
      inquirySharedEmpDetails.createdBy =
          _offlineLoggedInData.details[0].userID;
      arr_Inquiry_Share_Emp_List.add(inquirySharedEmpDetails);
    }
    if (arr_Inquiry_Share_Emp_List.isNotEmpty) {
      navigateTo(context, InquiryShareScreen.routeName,
          arguments:
              AddInquiryShareScreenArguments(arr_Inquiry_Share_Emp_List));
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _OnFetchTotalCount(FollowUpCountState state) {
    FinalTotalCount =
        state.count.toString().isEmpty ? 0 : int.parse(state.count.toString());
    if (!mounted) return;
    setState(() {});
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
    if (NotificationEmpName.isNotEmpty) {
      for (int i = 0; i < arr_ALL_Name_ID_For_Folowup_EmplyeeList.length; i++) {
        if (NotificationEmpName.trim().toLowerCase() ==
            arr_ALL_Name_ID_For_Folowup_EmplyeeList[i]
                .Name
                .trim()
                .toLowerCase()) {
          edt_FollowupEmployeeList.text =
              arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name;
          edt_FollowupEmployeeUserID.text =
              arr_ALL_Name_ID_For_Folowup_EmplyeeList[i].Name1.toString();
          _selectedEmployeeID = edt_FollowupEmployeeUserID.text;
          break;
        }
      }
    }
    if (!mounted) return;
    setState(() {});
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgFollowup") {
        _FollowupBloc.add(UserMenuRightsRequestEvent(
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
      IsAddRights =
          state.userMenuRightsResponse.details[i].addFlag1.toLowerCase() ==
              "true";
      IsEditRights =
          state.userMenuRightsResponse.details[i].editFlag1.toLowerCase() ==
              "true";
      IsDeleteRights =
          state.userMenuRightsResponse.details[i].delFlag1.toLowerCase() ==
              "true";
    }
  }
}
