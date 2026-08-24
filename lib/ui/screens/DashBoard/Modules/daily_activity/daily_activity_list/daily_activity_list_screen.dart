import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailto/mailto.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/dailyactivity/dailyactivity_bloc.dart';
import 'package:soleoserp/models/api_requests/daily_activity/daily_activity_delete_request.dart';
import 'package:soleoserp/models/api_requests/daily_activity/daily_activity_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/daily_activity/daily_activity_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/contact_model.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/daily_activity/daily_activity_add_edit/daily_activity_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../home_screen.dart';

class AddUpdateDailyActivityListScreenArguments {
  String ListDate;

  AddUpdateDailyActivityListScreenArguments(this.ListDate);
}

class DailyActivityListScreen extends BaseStatefulWidget {
  static const routeName = '/DailyActivityListScreen';
  final AddUpdateDailyActivityListScreenArguments arguments;

  DailyActivityListScreen(this.arguments);

  @override
  _DailyActivityListScreenState createState() =>
      _DailyActivityListScreenState();
}

class _DailyActivityListScreenState extends BaseState<DailyActivityListScreen>
    with BasicScreen, WidgetsBindingObserver {
  DailyActivityScreenBloc _dailyActivityScreenBloc;
  DailyActivityListResponse _dailyActivityDetails;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F;
  int title_color = 0xff362d8b;
  int _pageNo = 0;
  int selected = 0;
  int CompanyID = 0;
  String LoginUserID = "";
  DateTime selectedDate = DateTime.now();
  double totduration = 0.00;
  bool _isForUpdate;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_FollowupStatusReverse =
      TextEditingController();
  final TextEditingController TASKTOTALDURATION = TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text =
        _offlineLoggedInData.details[0].employeeID.toString();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _dailyActivityScreenBloc = DailyActivityScreenBloc(baseBloc);

    edt_FollowupStatus.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();

    edt_FollowupStatusReverse.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      edt_FollowupStatus.text = widget.arguments.ListDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      _dailyActivityScreenBloc
        ..add(DailyActivityListCallEvent(
            1,
            DailyActivityListRequest(
                CompanyId: CompanyID,
                LoginUserID: LoginUserID,
                EmployeeID: edt_FollowupEmployeeUserID.text,
                ActivityDate: widget.arguments.ListDate)));
    } else {
      _dailyActivityScreenBloc
        ..add(DailyActivityListCallEvent(
            1,
            DailyActivityListRequest(
                CompanyId: CompanyID,
                LoginUserID: LoginUserID,
                EmployeeID: edt_FollowupEmployeeUserID.text,
                ActivityDate: edt_FollowupStatusReverse.text)));
    }

    edt_FollowupStatus.addListener(followerEmployeeList);
    edt_FollowupStatusReverse.addListener(followerEmployeeList);
    edt_FollowupEmployeeList.addListener(followerEmployeeList);
    edt_FollowupEmployeeUserID.addListener(followerEmployeeList);

    getUserRights(_menuRightsResponse);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dailyActivityScreenBloc,
      child: BlocConsumer<DailyActivityScreenBloc, DailyActivityScreenStates>(
        builder: (BuildContext context, DailyActivityScreenStates state) {
          if (state is DailyActivityCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is DailyActivityCallResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DailyActivityScreenStates state) {
          if (state is DailyActivityDeleteCallResponseState) {
            _onCustomerDeleteCallSucess(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is DailyActivityDeleteCallResponseState) {
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
        appBar: NewGradientAppBar(
          title: Text('Daily Activities List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IsAddRights == true
                ? IconButton(
                    icon: Icon(
                      Icons.add_circle_sharp,
                      color: colorWhite,
                    ),
                    onPressed: () {
                      navigateTo(context, DailyActivityAddEditScreen.routeName,
                              arguments:
                                  AddUpdateDailyActivityRequestScreenArguments(
                                      null, edt_FollowupStatusReverse.text))
                          .then((value) {
                        setState(() {});
                      });
                    })
                : Container(),
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    baseBloc.refreshScreen();

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 15,
                    ),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: _buildEmplyeeListView(),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSearchView(),
                          ),
                        ]),
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
              _buildCount()
            ],
          ),
        ),
        bottomSheet: Padding(padding: EdgeInsets.only(bottom: 80)),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  ///builds header and title view

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_dailyActivityDetails == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildActivityCard(context, index);
        },
        shrinkWrap: true,
        itemCount: _dailyActivityDetails.details.length,
      ),
    );
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(DailyActivityCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _dailyActivityDetails = state.dailyActivityListResponse;
      } else {
        _dailyActivityDetails.details
            .addAll(state.dailyActivityListResponse.details);
      }
      _pageNo = state.newPage;
    }

    if (state.dailyActivityListResponse.details.length != 0) {
      totduration = 0.00;
      for (int i = 0; i < state.dailyActivityListResponse.details.length; i++) {
        totduration += state.dailyActivityListResponse.details[i].taskDuration;
      }

      List<String> SpliteMinute = totduration.toStringAsFixed(2).split(".");

      int Hour = int.parse(SpliteMinute[0].toString());
      int Minute = int.parse(SpliteMinute[1].toString());
      int TotalMinute = 0;

      if (Minute > 60) {
        TotalMinute = Minute - 60;
        Hour = Hour + 1;
      } else {
        TotalMinute = Minute;
      }

      TASKTOTALDURATION.text =
          Hour.toString() + " Hrs. " + TotalMinute.toString() + " Min. ";
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    _dailyActivityScreenBloc.add(DailyActivityListCallEvent(
        _pageNo + 1,
        DailyActivityListRequest(
            CompanyId: CompanyID,
            LoginUserID: LoginUserID,
            EmployeeID: "",
            ActivityDate: "")));
  }

  /// Compact, always-open Daily Activity card.
  /// Replace your ExpantionCustomer() call with _buildActivityCard(context, index)
  /// Add the three helper methods (_infoTile, _noteTile, _cardActionBtn)
  /// anywhere inside _DailyActivityListScreenState.

// ─── Main card ────────────────────────────────────────────────────────────────

  Widget _buildActivityCard(BuildContext context, int index) {
    final DailyActivityDetails model = _dailyActivityDetails.details[index];

    final String initials = model.createdEmployeeName.trim().isNotEmpty
        ? model.createdEmployeeName.trim()[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4EAF3), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: const Color(0xFFF4F7FF),
              child: Row(
                children: [
                  // Avatar initials
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFD6E4FF),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF1A5FB4),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Name + category badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.createdEmployeeName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A237E),
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (model.taskCategoryName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFF90CAF9), width: 1),
                            ),
                            child: Text(
                              model.taskCategoryName,
                              style: const TextStyle(
                                color: Color(0xFF1565C0),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xFFFFCC80), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          model.taskDuration == 0
                              ? '0.00'
                              : model.taskDuration.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE65100),
                            height: 1.1,
                          ),
                        ),
                        const Text(
                          'HRS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF6C00),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _noteTile(model.taskDescription),
            Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                height: 1,
                color: const Color(0xFFEEF2F8)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (IsEditRights)
                    _cardActionBtn(
                      label: 'Edit',
                      icon: Icons.edit_rounded,
                      foreground: const Color(0xFF1E88E5),
                      background: const Color(0xFFE3F2FD),
                      borderColor: const Color(0xFF90CAF9),
                      onTap: () => _onTapOfEditCustomer(model),
                    ),
                  if (IsEditRights && IsDeleteRights) const SizedBox(width: 8),
                  if (IsDeleteRights)
                    _cardActionBtn(
                      label: 'Delete',
                      icon: Icons.delete_rounded,
                      foreground: const Color(0xFFE53935),
                      background: const Color(0xFFFFEBEE),
                      borderColor: const Color(0xFFEF9A9A),
                      onTap: () => _onTapOfDeleteInquiry(model.pkID),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ─── Notes tile ───────────────────────────────────────────────────────────────

  Widget _noteTile(String notes) {
    final bool isEmpty = notes.trim().isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: isEmpty ? const Color(0xFFF7F9FD) : const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isEmpty ? const Color(0xFFE4EAF3) : const Color(0xFFFFF176),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFFBC02D).withOpacity(0.15),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(Icons.notes_rounded,
                size: 13, color: Color(0xFFF9A825)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Work notes',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF90A4AE),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEmpty ? 'N/A' : notes,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isEmpty
                        ? const Color(0xFFB0BEC5)
                        : const Color(0xFF1A237E),
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ─── Action button ────────────────────────────────────────────────────────────

  Widget _cardActionBtn({
    @required String label,
    @required IconData icon,
    @required Color foreground,
    @required Color background,
    @required Color borderColor,
    @required VoidCallback onTap,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapOfDeleteInquiry(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this record?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _dailyActivityScreenBloc.add(DailyActivityDeleteByNameCallEvent(
          id, DailyActivityDeleteRequest(CompanyID: CompanyID.toString())));
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _onCustomerDeleteCallSucess(
      DailyActivityDeleteCallResponseState state, BuildContext context) {
    navigateTo(context, DailyActivityListScreen.routeName, clearAllStack: true);
  }

  void _onTapOfEditCustomer(DailyActivityDetails model) {
    navigateTo(context, DailyActivityAddEditScreen.routeName,
            arguments: AddUpdateDailyActivityRequestScreenArguments(
                model, model.createdDate))
        .then((value) {
      _dailyActivityScreenBloc.add(DailyActivityListCallEvent(
          1,
          DailyActivityListRequest(
              CompanyId: CompanyID,
              LoginUserID: LoginUserID,
              EmployeeID: edt_FollowupEmployeeUserID.text,
              ActivityDate: edt_FollowupStatusReverse.text)));
    });
  }

  followerEmployeeList() {
    _dailyActivityScreenBloc.add(DailyActivityListCallEvent(
        1,
        DailyActivityListRequest(
            CompanyId: CompanyID,
            LoginUserID: LoginUserID,
            EmployeeID: edt_FollowupEmployeeUserID.text,
            ActivityDate: edt_FollowupStatusReverse.text)));
    setState(() {});
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        showcustomdialogWithTWOName(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_FollowupEmployeeList,
            controller1: edt_FollowupEmployeeUserID,
            lable: "Select Employee");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Employee",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
          Card(
            elevation: 5,
            color: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: double.maxFinite,
              child: TextField(
                controller: edt_FollowupEmployeeList,
                enabled: false,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15, right: 15),
                    hintText: "Select"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_FollowupStatus, edt_FollowupStatusReverse);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Date",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
          Card(
            elevation: 5,
            color: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: double.maxFinite,
              child: TextField(
                controller: edt_FollowupStatus,
                enabled: false,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  hintText: "Select",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController edt_followupStatusReverse) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_FollowupStatus.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_FollowupStatusReverse.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
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

  Widget _buildCount() {
    final String hrs =
        TASKTOTALDURATION.text.isEmpty ? '0' : TASKTOTALDURATION.text;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1565C0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Color(0x551565C0),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      height: 62,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Clock icon pill ──────────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // ── Label + value ────────────────────────────────────────────
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total task duration',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hrs.isEmpty ? '0 Hrs.  0 Min.' : hrs,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFD54F),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // ── Thin divider ─────────────────────────────────────────────
          Container(
            width: 0.5,
            height: 30,
            color: Colors.white.withOpacity(0.20),
            margin: const EdgeInsets.symmetric(horizontal: 14),
          ),

          // ── Task count pill ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF69F0AE),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _dailyActivityDetails != null
                      ? '${_dailyActivityDetails.details.length} tasks'
                      : '0 tasks',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgDailyActivity") {
        _dailyActivityScreenBloc.add(UserMenuRightsRequestEvent(
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
}
