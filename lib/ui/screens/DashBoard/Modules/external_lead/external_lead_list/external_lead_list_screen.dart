import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/external_lead/external_lead_bloc.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/bulk_assign_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/external_lead_list_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/external_lead_search_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/external_lead_list_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/external_leadsearch_response_by_name.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/FollowupDialog/external_lead_followup_dialog.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_add_edit/external_lead_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_list/search_external_lead_screen.dart';
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

class ExternalLeadListScreen extends BaseStatefulWidget {
  static const routeName = '/ExternalLeadListScreen';

  @override
  _ExternalLeadListScreenState createState() => _ExternalLeadListScreenState();
}

class _ExternalLeadListScreenState extends BaseState<ExternalLeadListScreen>
    with BasicScreen, WidgetsBindingObserver {
  static const int _minSearchLength = 3;

  ExternalLeadBloc _expenseBloc;
  int _pageNo = 0;
  bool isListExist = false;
  ExternalLeadListResponse _expenseListResponse;
  ExternalLeadOnlyNameDetails _externalDetails;
  bool expanded = true;
  double sizeboxsize = 12;
  int label_color = 0xff0066b3;
  int title_color = 0xff0066b3;
  String foos = 'One';
  int selected = 0;
  bool isExpand = false;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  int CompanyID = 0;
  String LoginUserID = "";
  String ConstantMAster = "";
  bool isProductExistAfter = false;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();

  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  bool isDeleteVisible = true;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  Set<int> selectedLeadIds = {};

  // Search controller
  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;
  int _searchQueryToken = 0;
  FocusNode _searchFocusNode;

  String _selectedLeadStatus = "ALL Leads";

  final List<String> _leadStatusList = [
    "ALL Leads",
    "New",
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
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    LeadStatus();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    edt_FollowupStatus.text = "Account";
    edt_LeadStatus.text = "ALL Leads";
    _expenseBloc = ExternalLeadBloc(baseBloc);
    edt_LeadStatus.addListener(followerEmployeeList);
    getUserRights(_menuRightsResponse);

    _searchFocusNode = FocusNode();

    _fetchList();

    _expenseBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "AssignMultipleLead",
            CompanyId: CompanyID.toString())));

    isExpand = false;
    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    edt_FollowupStatus.dispose();
    edt_LeadStatus.dispose();
    edt_FollowupEmployeeList.dispose();
    edt_FollowupEmployeeUserID.dispose();
    _searchFocusNode?.dispose();
    super.dispose();
  }

  void _fetchList() {
    _expenseBloc.add(ExternalLeadListCallEvent(
        1,
        ExternalLeadListRequest(
            pkID: "",
            acid: "",
            LeadStatus:
                _selectedLeadStatus == "ALL Leads" ? "" : _selectedLeadStatus,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
  }

  void _searchLeads({bool immediate = false}) {
    final query = _searchCtrl.text.trim();
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();

    if (query.isEmpty) {
      _fetchList();
      return;
    }

    if (query.length < _minSearchLength) {
      setState(() {});
      return;
    }

    final currentToken = ++_searchQueryToken;
    void runSearch() {
      if (!mounted || currentToken != _searchQueryToken) return;
      _expenseBloc.add(ExternalLeadSearchByIDCallEvent(
          ExternalLeadSearchRequest(
              CompanyId: CompanyID.toString(),
              word: query,
              needALL: "1",
              LoginUserID: LoginUserID,
              LeadStatus: _selectedLeadStatus == "ALL Leads"
                  ? ""
                  : _selectedLeadStatus.toString())));
    }

    if (immediate) {
      runSearch();
    } else {
      _debounceTimer = Timer(const Duration(milliseconds: 350), runSearch);
    }
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedLeadStatus = status;
      edt_LeadStatus.text = status;
    });
    _searchQueryToken++;
    _searchLeads(immediate: true);
  }

  Color _getStatusColor(String status) {
    if (status == null) return Colors.blueGrey.shade600;
    switch (status.toLowerCase()) {
      case "new":
        return Colors.blue.shade600;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _expenseBloc,
      child: BlocConsumer<ExternalLeadBloc, ExternalLeadStates>(
        builder: (BuildContext context, ExternalLeadStates state) {
          if (state is ExternalLeadListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is ExternalLeadSearchByIDResponseState) {
            _onInquirySearchCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ExternalLeadListCallResponseState ||
              currentState is ExternalLeadSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is ConstantResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ExternalLeadStates state) {
          if (state is ExternalLeadDeleteCallResponseState) {
            _onExpenseRequestDeleteCallSucess(state, context);
          }
          if (state is BulkAssignListResponseState) {
            _onBulkAssignListResponseStateCallSuccess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ExternalLeadDeleteCallResponseState ||
              currentState is BulkAssignListResponseState) {
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
            'Portal Lead List',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle_sharp,
                  color: Colors.white, size: 24),
              onPressed: showSortBottomSheet,
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.white, size: 24),
              onPressed: () {
                return showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          title: Center(
                            child: Text(
                              "~~~Filter~~~",
                              style: TextStyle(color: const Color(0xff0066b3)),
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          color: const Color(0xffDDE3EF),
                        ),
                        Container(
                          height: 5,
                        ),
                        ListTile(
                          title: _buildEmplyeeListView(),
                        ),
                        Container(
                          height: 10,
                        ),
                        ListTile(
                          title: Center(
                              child: Row(
                            children: [
                              Flexible(
                                child: getCommonButton(baseTheme, () {
                                  Navigator.pop(context);
                                  if (_externalDetails != null) {
                                    _expenseBloc.add(
                                        ExternalLeadSearchByIDCallEvent(
                                            ExternalLeadSearchRequest(
                                                CompanyId: CompanyID.toString(),
                                                word: _externalDetails.value
                                                    .toString(),
                                                needALL: "0",
                                                LoginUserID: LoginUserID,
                                                LeadStatus:
                                                    edt_LeadStatus.text ==
                                                            "ALL Leads"
                                                        ? ""
                                                        : edt_LeadStatus.text
                                                            .toString())));
                                  }
                                  edt_FollowupEmployeeList.text = "";

                                  _externalDetails = null;
                                }, "Submit", radius: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: getCommonButton(baseTheme, () {
                                  Navigator.pop(context);
                                }, "Close", radius: 15),
                              ),
                            ],
                          )),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
                    );
                  },
                );
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
            context: context, UserName: "KISHAN", RolCode: "Admin"),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilterPanel(context),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async {
                    edt_FollowupEmployeeList.text = "";
                    if (_searchCtrl.text.trim().length >= _minSearchLength) {
                      _searchLeads(immediate: true);
                    } else {
                      _fetchList();
                    }
                    _expenseBloc.add(ConstantRequestEvent(
                        CompanyID.toString(),
                        ConstantRequest(
                            ConstantHead: "AssignMultipleLead",
                            CompanyId: CompanyID.toString())));
                    getUserRights(_menuRightsResponse);
                  },
                  child: _buildLeadList(),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.s(12)),
            child: _buildStatusFilter(r),
          ),
          SizedBox(height: r.s(10)),
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

  Widget _buildEmplyeeListView() {
    final r = _R(context);
    return InkWell(
      onTap: () {
        edt_FollowupEmployeeList.text = "";
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Customer",
            style: TextStyle(
              fontSize: r.f(12),
              color: const Color(0xff0066b3),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: r.s(5)),
          Card(
            elevation: 2,
            color: const Color(0xffF2F5FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.s(10))),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: r.s(15), vertical: r.s(12)),
              width: double.maxFinite,
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: const Color(0xff0066b3), size: r.s(20)),
                  SizedBox(width: r.s(10)),
                  Expanded(
                    child: Text(
                      edt_FollowupEmployeeList.text.isEmpty
                          ? "Search Customer"
                          : edt_FollowupEmployeeList.text,
                      style: TextStyle(
                        color: edt_FollowupEmployeeList.text.isEmpty
                            ? Colors.grey
                            : Colors.black,
                        fontSize: r.f(13),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: const Color(0xff0066b3), size: r.s(20)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeadList() {
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
          itemBuilder: (ctx, i) => _buildLeadCard(ctx, i),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildLeadCard(BuildContext context, int index) {
    final r = _R(context);
    final model = _expenseListResponse.details[index];

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
          // Header Section
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
                        model.companyName ?? "N/A",
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
                // Status Chip
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
                // Checkbox for bulk assign
                if (isProductExistAfter == false &&
                    model.leadStatus != "Qualified")
                  SizedBox(
                    width: r.s(30),
                    child: Checkbox(
                      value: selectedLeadIds.contains(model.pkId),
                      onChanged: (bool value) {
                        setState(() {
                          if (value == true) {
                            selectedLeadIds.add(model.pkId);
                          } else {
                            selectedLeadIds.remove(model.pkId);
                          }
                        });
                      },
                      activeColor: const Color(0xff0066b3),
                    ),
                  ),
              ],
            ),
          ),
          // Info Section - Two Columns
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
                        _infoTile(r, Icons.person_outline, "Sender",
                            model.senderName ?? "N/A"),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.person_add_outlined, "Assigned To",
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
          // Action Buttons
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
                  _actionChip(r, Icons.edit_outlined, "Update",
                      () => _onTapOfEditCustomer(model)),
              ],
            ),
          ),
          // Details Section
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(0), r.s(14), r.s(12)),
            child: Column(
              children: [
                _detailRow(r, "Lead No", model.pkId.toString()),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Product", model.forProduct ?? "N/A"),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Created By", model.senderName ?? "N/A"),
                SizedBox(height: r.s(6)),
                _detailRow(
                    r, "Created Date", _fmtDate(model.createdDate ?? "")),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Industry", model.industryName ?? "N/A"),
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

  void showSortBottomSheet() {
    final r = _R(context);
    double textSize = r.f(14);
    double paddingSize = r.s(16);

    edt_FollowupEmployeeList.text = "";
    edt_FollowupEmployeeUserID.text = "0";

    showAnimatedDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(paddingSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Assign Bulk Lead",
                  style: TextStyle(
                    fontSize: textSize,
                    color: const Color(0xff0066b3),
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: paddingSize),
                GestureDetector(
                  onTap: () => showcustomdialogWithID(
                      values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
                      context1: context,
                      controller: edt_FollowupEmployeeList,
                      controllerID: edt_FollowupEmployeeUserID,
                      lable: "Select Employee "),
                  child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("Assign To *",
                                style: TextStyle(
                                    fontSize: r.f(13),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Card(
                            elevation: 5,
                            color: const Color(0xffF2F5FA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        controller: edt_FollowupEmployeeList,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText: "Select Assign To",
                                          labelStyle: const TextStyle(
                                            color: Color(0xFF000000),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: r.f(14),
                                          color: const Color(0xFF000000),
                                        )),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                SizedBox(height: paddingSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: r.f(13),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: paddingSize),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          String leadIdsCsv = selectedLeadIds.join(',');

                          if (edt_FollowupEmployeeUserID.text != "0") {
                            if (selectedLeadIds.isNotEmpty) {
                              _expenseBloc.add(BulkAssignListRequestEvent(
                                BulkAssignListRequest(
                                  EmployeeID:
                                      edt_FollowupEmployeeUserID.text.trim(),
                                  LeadIDs: ",$leadIdsCsv",
                                  CompanyId: CompanyID.toString(),
                                ),
                              ));
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Please select at least one lead.")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please select an employee.")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0066b3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Apply",
                          style: TextStyle(
                            fontSize: r.f(13),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      animationType: DialogTransitionType.size,
    );
  }

  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 5; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "ALL Leads";
      }
      if (i == 1) {
        all_name_id.Name = "New";
      } else if (i == 2) {
        all_name_id.Name = "Disqualified";
      } else if (i == 3) {
        all_name_id.Name = "Qualified";
      } else if (i == 4) {
        all_name_id.Name = "InProcess";
      }
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  void _onInquiryListCallSuccess(ExternalLeadListCallResponseState state) {
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
    if (_searchCtrl.text.trim().length >= _minSearchLength) {
      return;
    }
    _expenseBloc.add(ExternalLeadListCallEvent(
        _pageNo + 1,
        ExternalLeadListRequest(
            pkID: "",
            acid: "",
            LeadStatus:
                _selectedLeadStatus == "ALL Leads" ? "" : _selectedLeadStatus,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
  }

  void _onFollowupTap(ExternalLeadDetails detail) {
    ALL_Name_ID all_name_ID_telecallerdetails = ALL_Name_ID();

    all_name_ID_telecallerdetails.Ext_EmployeeName = detail.employeeName;
    all_name_ID_telecallerdetails.Ext_EmployeeID = detail.employeeID.toString();

    if (detail.leadStatus == "New") {
      all_name_ID_telecallerdetails.Ext_EmployeeName =
          _offlineLoggedInData.details[0].employeeName;
      all_name_ID_telecallerdetails.Ext_EmployeeID =
          _offlineLoggedInData.details[0].employeeID.toString();
    }
    all_name_ID_telecallerdetails.Ext_ID = detail.pkId;
    all_name_ID_telecallerdetails.Ext_Status =
        detail.leadStatus.toString() == "New"
            ? "InProcess"
            : detail.leadStatus.toString();
    all_name_ID_telecallerdetails.Name = detail.companyName.toString();

    navigateTo(context, FollowUpFromExternalLeadAddEditScreen.routeName,
            arguments: AddUpdateFollowupFromExternalLeadScreenArguments(
                all_name_ID_telecallerdetails))
        .then((value) {
      _searchLeads(immediate: true);
    });
  }

  void _onTapOfEditCustomer(ExternalLeadDetails detail) {
    navigateTo(context, ExternalLeadAddEditScreen.routeName,
            arguments: AddUpdateExternalLeadScreenArguments(
                _pageNo, _selectedLeadStatus, detail))
        .then((value) {
      ALL_Name_ID all_name_id = value;
      _selectedLeadStatus = all_name_id.Name;
      edt_LeadStatus.text = all_name_id.Name;
      _pageNo = all_name_id.pkID;
      _searchLeads(immediate: true);
    });
  }

  void _onExpenseRequestDeleteCallSucess(
      ExternalLeadDeleteCallResponseState state, BuildContext buildContext123) {
    navigateTo(buildContext123, ExternalLeadListScreen.routeName,
        clearAllStack: true);
  }

  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchExternalLeadScreen.routeName,
            arguments: AddUpdateExternalLeadSearchScreenArguments(
                edt_LeadStatus.text == "ALL Leads"
                    ? ""
                    : edt_LeadStatus.text.toString()))
        .then((value) {
      if (value != null) {
        _externalDetails = value;
        edt_FollowupEmployeeList.text = _externalDetails.label;
      }
    });
  }

  void _onInquirySearchCallSuccess(ExternalLeadSearchByIDResponseState state) {
    _expenseListResponse = state.response;
    if (_expenseListResponse.details.length != 0) {
      isListExist = true;
    } else {
      isListExist = false;
    }
  }

  void _onBulkAssignListResponseStateCallSuccess(
      BulkAssignListResponseState state) {
    showCommonDialogWithSingleOption(
        Globals.context, state.bulkAssignListResponse.details[0].column2,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      selectedLeadIds.clear();
      _searchLeads(immediate: true);
    });
  }

  followerEmployeeList() {
    _selectedLeadStatus = edt_LeadStatus.text;
    _searchLeads(immediate: true);
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = LoginUserID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }

      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgExternalLeads") {
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

  void _onGetConstant(ConstantResponseState state) {
    ConstantMAster = state.response.details[0].value.toString();

    if (ConstantMAster.toLowerCase() == "yes") {
      isProductExistAfter = false;
    } else {
      isProductExistAfter = true;
    }
  }
}
