import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:soleoserp/models/api_requests/followup/quick_followup_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/followup/quick_followup_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_add_edit/quick_followup_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_list/quick_followUp_report_list_screen.dart';
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

class QuickFollowupListScreen extends BaseStatefulWidget {
  static const routeName = '/QuickFollowupListScreen';

  @override
  _QuickFollowupListScreenState createState() =>
      _QuickFollowupListScreenState();
}

class _QuickFollowupListScreenState extends BaseState<QuickFollowupListScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  QuickFollowupListResponse _FollowupListResponse;

  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  bool isListExist = false;

  List<ALL_Name_ID> arr_EmployeeList = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController edt_employeeName = TextEditingController();
  final TextEditingController edt_employeeID = TextEditingController();
  final TextEditingController edt_filter_customerName = TextEditingController();

  String _selectedStatus = "active";
  String _selectedEmployeeID = "";

  final List<String> _filterStatusList = [
    "active",
    "todays",
    "missed",
    "future",
    "completestatus",
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

    edt_employeeName.text = _offlineLoggedInData.details[0].employeeName;
    edt_employeeID.text = _offlineLoggedInData.details[0].employeeID.toString();
    _selectedEmployeeID = edt_employeeID.text;
    edt_filter_customerName.text = "";

    _FollowupBloc = FollowupBloc(baseBloc);

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    _fetchList();
  }

  void _fetchList() {
    _FollowupBloc.add(QuickFollowupListRequestEvent(QuickFollowupListRequest(
        FollowupStatus: _selectedStatus,
        CompanyId: CompanyID.toString(),
        EmployeeID: _selectedEmployeeID,
        SearchKey: edt_filter_customerName.text)));
  }

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedStatus = status;
    });
    _fetchList();
  }

  void _onEmployeeFilterTap() {
    showcustomdialogWithTWOName(
        values: arr_EmployeeList,
        context1: context,
        controller: edt_employeeName,
        controller1: edt_employeeID,
        lable: "Select Employee",
        onValueSelected: () {
          setState(() {
            _selectedEmployeeID = edt_employeeID.text;
          });
          _fetchList();
        });
  }

  void _onSearchChanged(String value) {
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is QuickFollowupListResponseState) {
            _onFollowupListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is QuickFollowupListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupDeleteCallResponseState) {
            _onFollowupDeleteCallSucess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is FollowupDeleteCallResponseState) {
            return true;
          }
          return false;
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
            'Quick Followup',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                    "AL2M-7IG1-H8S2-TOY3"
                ? IconButton(
                    icon: Icon(
                      Icons.report,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      navigateTo(context, QuickFollowUpReportScreen.routeName,
                          clearAllStack: true);
                    })
                : Container(),
            IconButton(
              icon: const Icon(Icons.add_circle_sharp,
                  color: Colors.white, size: 24),
              onPressed: () {
                navigateTo(context, QuickFollowUpAddEditScreen.routeName);
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
                  onRefresh: () async => _fetchList(),
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
            padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(8)),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildEmployeeFilter(r),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  flex: 3,
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
                    edt_employeeName.text.isEmpty
                        ? "Select Employee"
                        : edt_employeeName.text,
                    style: TextStyle(
                      color: edt_employeeName.text.isEmpty
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

  Widget _buildSearchField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search",
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
              Icon(Icons.search, color: Colors.grey.shade500, size: r.s(18)),
              SizedBox(width: r.s(8)),
              Expanded(
                child: TextField(
                  controller: edt_filter_customerName,
                  onChanged: (v) => _onSearchChanged(v),
                  decoration: InputDecoration(
                    hintText: "Customer name...",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.f(12)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: r.f(12), color: Colors.black87),
                ),
              ),
              if (edt_filter_customerName.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    edt_filter_customerName.clear();
                    _fetchList();
                  },
                  child: Icon(Icons.close,
                      size: r.s(16), color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ],
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
              final isSelected = _selectedStatus == status;
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
    if (!isListExist || _FollowupListResponse == null) {
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

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
      itemCount: _FollowupListResponse.details.length,
      itemBuilder: (ctx, i) => _buildFollowupCard(ctx, r, i),
    );
  }

  Widget _buildFollowupCard(BuildContext context, _R r, int index) {
    final model = _FollowupListResponse.details[index];
    final bool hasPunchIn = _hasValidValue(model.timeIn);
    final bool hasPunchOut = _hasValidValue(model.timeOut);
    print("${hasPunchIn} + ${hasPunchOut}");

    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _infoTile(r, Icons.calendar_today_outlined,
                                "Followup Date", _fmtDate(model.followupDate)),
                            SizedBox(height: r.s(7)),
                            _infoTile(r, Icons.category_outlined,
                                "Followup Type", model.inquiryStatus ?? "N/A"),
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
                                "Next Followup",
                                _fmtDate(model.nextFollowupDate)),
                            SizedBox(height: r.s(7)),
                            _infoTile(r, Icons.person_outline, "Created By",
                                model.createdBy ?? "N/A"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.s(10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoTile(
                          r,
                          Icons.login_outlined,
                          "Time In",
                          model.timeIn?.isNotEmpty == true
                              ? model.timeIn
                              : "N/A",
                        ),
                      ),
                      SizedBox(width: r.s(12)),
                      Expanded(
                        child: _infoTile(
                          r,
                          Icons.logout_outlined,
                          "Time Out",
                          model.timeOut?.isNotEmpty == true
                              ? model.timeOut
                              : "N/A",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (model.meetingNotes != null && model.meetingNotes.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(r.s(14), r.s(5), r.s(14), 0),
              child: Container(
                padding: EdgeInsets.all(r.s(8)),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(r.s(8))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.format_quote,
                        size: r.s(12), color: Colors.grey.shade500),
                    SizedBox(width: r.s(6)),
                    Expanded(
                      child: Text(
                        model.meetingNotes,
                        style: TextStyle(
                            fontSize: r.f(11), color: Colors.grey.shade700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                if (model.latitudeIN != "" || model.longitude_IN != "")
                  _actionChip(
                      r,
                      Icons.location_on,
                      "Loc In",
                      () => _openLocation(
                          model.latitudeIN, model.longitude_IN, "Location In")),
                if (model.latitudeOUT != "" || model.longitude_OUT != "")
                  _actionChip(
                      r,
                      Icons.location_on,
                      "Loc Out",
                      () => _openLocation(model.latitudeOUT,
                          model.longitude_OUT, "Location Out")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(4), r.s(14), r.s(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!hasPunchIn)
                  _punchButton(r, "Punch In", Icons.login_rounded,
                      () => _navigateToAddEdit(model, false, "PunchIn")),
                if (hasPunchIn && !hasPunchOut)
                  _punchButton(r, "Punch Out", Icons.logout_rounded,
                      () => _navigateToAddEdit(model, false, "PunchOut")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _punchButton(_R r, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(8)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff108dcf), Color(0xff0066b3)]),
          borderRadius: BorderRadius.circular(r.s(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: r.s(14), color: Colors.white),
            SizedBox(width: r.s(6)),
            Text(label,
                style: TextStyle(
                    fontSize: r.f(11),
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade600;
      case 'todays':
        return Colors.blue.shade600;
      case 'missed':
        return Colors.red.shade600;
      case 'future':
        return Colors.orange.shade600;
      case 'completestatus':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void _openLocation(String lat, String lng, String title) {
    if (lat.isNotEmpty && lng.isNotEmpty && lat != "0" && lng != "0") {
      MapsLauncher.launchCoordinates(
          double.parse(lat), double.parse(lng), title);
    } else {
      showCommonDialogWithSingleOption(context, "Location not available!",
          positiveButtonTitle: "OK");
    }
  }

  bool _hasValidValue(String value) {
    final normalized = value?.trim() ?? '';
    return normalized.isNotEmpty && normalized.toLowerCase() != 'null';
  }

  void _navigateToAddEdit(
      QuickFollowupListResponseDetails model, bool isFuture, String mode) {
    navigateTo(context, QuickFollowUpAddEditScreen.routeName,
            arguments:
                QuickAddUpdateFollowupScreenArguments(model, isFuture, mode))
        .then((value) => _fetchList());
  }

  void _onFollowupListCallSuccess(QuickFollowupListResponseState state) {
    if (state.quickFollowupListResponse.details.isNotEmpty) {
      _FollowupListResponse = state.quickFollowupListResponse;
      isListExist = true;
    } else {
      isListExist = false;
    }
  }

  void _onFollowupDeleteCallSucess(
      FollowupDeleteCallResponseState state, BuildContext buildContext123) {
    showCommonDialogWithSingleOption(
        Globals.context, "Visit Deleted Successfully",
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _fetchList();
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_EmployeeList.clear();
    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = state.details[i].employeeName;
        all_name_id1.Name1 = state.details[i].pkID.toString();
        all_name_id1.MenuName = state.details[i].userID;
        arr_EmployeeList.add(all_name_id1);
      }
    }
  }
}
