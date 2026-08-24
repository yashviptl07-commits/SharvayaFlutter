import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/telecaller/telecaller_bloc.dart';
import 'package:soleoserp/models/api_requests/customer/customer_delete_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/tele_caller_search_by_name_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/telecaller_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/telecaller/telecaller_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/telecaller_followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/FollowUpDialog/telecaller_followup_ADD_EDIT_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_add_edit/telecaller_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/broadcast_msg/make_call.dart';
import 'package:soleoserp/utils/broadcast_msg/share_msg.dart';
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

class TeleCallerListScreen extends BaseStatefulWidget {
  static const routeName = '/TeleCallerListScreen';

  @override
  _TeleCallerListScreenState createState() => _TeleCallerListScreenState();
}

class _TeleCallerListScreenState extends BaseState<TeleCallerListScreen>
    with BasicScreen, WidgetsBindingObserver {
  TeleCallerBloc _expenseBloc;
  int _pageNo = 0;
  bool isListExist = false;
  TeleCallerListResponse _expenseListResponse;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;

  String _selectedLeadStatus = "ALL Leads";

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  bool isDeleteVisible = true;

  final List<String> _leadStatusList = [
    "ALL Leads",
    "Disqualified",
    "Qualified",
    "InProcess",
  ];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    _expenseBloc = TeleCallerBloc(baseBloc);

    getUserRights(_menuRightsResponse);
    _fetchList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _fetchList() {
    _expenseBloc.add(TeleCallerListCallEvent(
        1,
        TeleCallerListRequest(
            pkID: "",
            acid: "",
            LeadStatus:
                _selectedLeadStatus == "ALL Leads" ? "" : _selectedLeadStatus,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
            SearchKey: _searchCtrl.text.trim().length > 2
                ? _searchCtrl.text.trim()
                : "")));
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _fetchList();
    });
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() => _selectedLeadStatus = status);
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _expenseBloc,
      child: BlocConsumer<TeleCallerBloc, TeleCallerStates>(
        builder: (BuildContext context, TeleCallerStates state) {
          if (state is TeleCallerListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is TeleCallerSearchByIDResponseState) {
            _onInquirySearchCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is TeleCallerListCallResponseState ||
              currentState is TeleCallerSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, TeleCallerStates state) {
          if (state is TeleCallerDeleteCallResponseState) {
            _onExpenseRequestDeleteCallSucess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is TeleCallerDeleteCallResponseState) {
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
            'TeleCaller List',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IsAddRights == true
                ? IconButton(
                    icon: const Icon(Icons.add_circle_sharp,
                        color: Colors.white, size: 24),
                    onPressed: () {
                      navigateTo(context, TeleCallerAddEditScreen.routeName,
                          clearAllStack: true);
                    },
                  )
                : Container(),
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
            context: context, UserName: "KISHAN", RolCode: "Admin"),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilterPanel(context),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async {
                    getUserRights(_menuRightsResponse);
                    _fetchList();
                  },
                  child: _buildTeleCallerList(context),
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
                  child: _buildSearchField(r),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.s(12)),
            child: _buildStatusFilter(r),
          ),
          SizedBox(height: r.s(10)),
        ],
      ),
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
                hintText: "Search customer by name...",
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
                _debounceTimer?.cancel();
                _fetchList();
                setState(() {});
              },
              child:
                  Icon(Icons.close, size: r.s(16), color: Colors.grey.shade500),
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
          "Lead Status",
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
            itemCount: _leadStatusList.length,
            separatorBuilder: (_, __) => SizedBox(width: r.s(7)),
            itemBuilder: (_, i) {
              final status = _leadStatusList[i];
              final isSelected = _selectedLeadStatus == status;
              final color = _getStatusColor(status);
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

  Widget _buildTeleCallerList(BuildContext context) {
    final r = _R(context);
    if (isListExist && _expenseListResponse != null) {
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
          itemCount: _expenseListResponse.details.length,
          itemBuilder: (ctx, i) => _buildTeleCallerCard(ctx, i),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildTeleCallerCard(BuildContext context, int index) {
    final r = _R(context);
    final model = _expenseListResponse.details[index];

    if (model.leadSource != "TeleCaller") return Container();

    Color statusColor = _getStatusColor(model.leadStatus);

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
                  child: Text(
                    model.senderName?.substring(0, 1).toUpperCase() ?? "C",
                    style: TextStyle(
                      fontSize: r.f(16),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0066b3),
                    ),
                  ),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.senderName ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: r.f(14),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0066b3),
                        ),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        model.primaryMobileNo ?? "N/A",
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
                      model.leadStatus ?? "N/A",
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
                        _infoTile(r, Icons.business_outlined, "Company",
                            model.companyName ?? "N/A"),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.person_outline, "Assigned To",
                            model.employeeName ?? "N/A"),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoTile(r, Icons.email_outlined, "Email",
                            model.senderMail ?? "N/A"),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.calendar_today_outlined,
                            "Query Date", _fmtDate(model.queryDatetime ?? "")),
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
                    () => MakeCall.callto(model.primaryMobileNo)),
                _actionChip(r, Icons.message, "WhatsApp",
                    () => ShareMsg.msg(context, model.primaryMobileNo)),
                _actionChip(
                    r, Icons.add, "Followup", () => _onFollowupTap(model)),
                if (IsEditRights == true)
                  _actionChip(r, Icons.edit_outlined, "Edit",
                      () => _onTapOfEditCustomer(model)),
                if (IsDeleteRights == true)
                  _actionChip(r, Icons.delete_outline, "Delete",
                      () => _onTapOfDeleteCustomer(model.pkId),
                      isDelete: true),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(0), r.s(14), r.s(12)),
            child: Column(
              children: [
                _detailRow(r, "Product", model.forProduct ?? "N/A"),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Created By", model.senderName ?? "N/A"),
                SizedBox(height: r.s(6)),
                _detailRow(
                    r, "Created Date", _fmtDate(model.createdDate ?? "")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(_R r, IconData icon, String label, VoidCallback onTap,
      {bool isDelete = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
        decoration: BoxDecoration(
          color: isDelete ? Colors.red.shade50 : const Color(0xffF2F5FA),
          borderRadius: BorderRadius.circular(r.s(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: r.s(14),
                color:
                    isDelete ? Colors.red.shade600 : const Color(0xff0066b3)),
            SizedBox(width: r.s(4)),
            Text(
              label,
              style: TextStyle(
                fontSize: r.f(11),
                fontWeight: FontWeight.w500,
                color: isDelete ? Colors.red.shade600 : const Color(0xff1A2332),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(_R r, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: r.s(80),
          child: Text(
            label,
            style: TextStyle(fontSize: r.f(10), color: Colors.grey.shade500),
          ),
        ),
        SizedBox(width: r.s(8)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: r.f(11), color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  Color _getStatusColor(String status) {
    if (status == null) return Colors.blueGrey.shade600;
    switch (status.toLowerCase()) {
      case "qualified":
        return Colors.green.shade600;
      case "disqualified":
        return Colors.red.shade600;
      case "inprocess":
        return Colors.orange.shade700;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  void _onInquiryListCallSuccess(TeleCallerListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _expenseListResponse = state.response;
      } else {
        _expenseListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
    if (_expenseListResponse.details.length != 0) {
      isListExist = true;
    } else {
      isListExist = false;
    }
  }

  void _onInquiryListPagination() {
    _expenseBloc.add(TeleCallerListCallEvent(
        _pageNo + 1,
        TeleCallerListRequest(
            pkID: "",
            acid: "",
            LeadStatus:
                _selectedLeadStatus == "ALL Leads" ? "" : _selectedLeadStatus,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
  }

  void _onInquirySearchCallSuccess(TeleCallerSearchByIDResponseState state) {
    _expenseListResponse = state.response;
    isListExist = true;
  }

  void _onFollowupTap(TeleCallerListDetails detail) {
    ALL_Name_ID all_name_ID_telecallerdetails = ALL_Name_ID();
    all_name_ID_telecallerdetails.Ext_EmployeeName = detail.employeeName;
    all_name_ID_telecallerdetails.Ext_EmployeeID = detail.employeeID.toString();
    all_name_ID_telecallerdetails.Ext_ID = detail.pkId;
    all_name_ID_telecallerdetails.Ext_Status = detail.leadStatus.toString();

    navigateTo(context, FollowUpFromTeleCallerddEditScreen.routeName,
            arguments: AddUpdateFollowupFromTeleCallerScreenArguments(
                all_name_ID_telecallerdetails))
        .then((value) {
      _fetchList();
    });
  }

  void _onTapOfEditCustomer(TeleCallerListDetails detail) {
    navigateTo(context, TeleCallerAddEditScreen.routeName,
            arguments: AddUpdateTeleCallerScreenArguments(
                _pageNo, _selectedLeadStatus, detail))
        .then((value) {
      _fetchList();
    });
  }

  void _onTapOfDeleteCustomer(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this TeleCaller Lead?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _expenseBloc.add(TeleCallerDeleteCallEvent(
          id, CustomerDeleteRequest(CompanyID: CompanyID.toString())));
    });
  }

  void _onExpenseRequestDeleteCallSucess(
      TeleCallerDeleteCallResponseState state, BuildContext buildContext123) {
    _fetchList();
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
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
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgTeleCaller") {
        _expenseBloc.add(UserMenuRightsRequestEvent(
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
      IsAddRights = state.userMenuRightsResponse.details[i].addFlag1
              .toLowerCase()
              .toString() ==
          "true";
      IsEditRights = state.userMenuRightsResponse.details[i].editFlag1
              .toLowerCase()
              .toString() ==
          "true";
      IsDeleteRights = state.userMenuRightsResponse.details[i].delFlag1
              .toLowerCase()
              .toString() ==
          "true";
    }
  }
}
