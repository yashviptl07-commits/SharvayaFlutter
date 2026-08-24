import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_delete_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_header/me_header_add_update.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
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

class MultiExpenseListScreen extends BaseStatefulWidget {
  static const routeName = 'MultiExpenseListScreen';

  @override
  _MultiExpenseListScreenState createState() => _MultiExpenseListScreenState();
}

class _MultiExpenseListScreenState extends BaseState<MultiExpenseListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  MainBloc _mainBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  int _pageNo = 0;
  int selected = 0;
  MultiExpenseListResponse _multiExpenseListResponse;
  bool expanded = true;
  bool isDeleteVisible = true;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);

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
    _mainBloc.add(MultiExpenseListRequestEvent(
        1,
        MultiExpenseListRequest(
            pkID: "0",
            SearchKey: _searchCtrl.text.trim(),
            PageNo: "1",
            PageSize: "10",
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID)));
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _fetchList();
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _debounceTimer?.cancel();
    _fetchList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is MultiExpenseListResponseState) {
            _onGetListCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MultiExpenseListResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MultiExpenseDeleteResponseState) {
            _onMultiExpenseDeleteResponseStateCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MultiExpenseDeleteResponseState) {
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
            'Multiple Expense',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            if (IsAddRights == true)
              IconButton(
                icon: const Icon(Icons.add_circle_sharp,
                    color: Colors.white, size: 24),
                onPressed: () async {
                  await _onTapOfDeleteALLMultipleExpense();
                  navigateTo(context, MultiExpenseAddEditScreen.routeName,
                      clearAllStack: true);
                },
              ),
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () async {
                await _onTapOfDeleteALLMultipleExpense();
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
              _buildSearchPanel(context, r),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async {
                    getUserRights(_menuRightsResponse);
                    _fetchList();
                  },
                  child: _buildExpenseList(context, r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPanel(BuildContext context, _R r) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(10)),
        child: Container(
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
                    hintText: "Search by voucher no...",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.f(13)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: r.f(13), color: Colors.black87),
                ),
              ),
              if (_searchCtrl.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: Icon(Icons.close,
                      size: r.s(16), color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseList(BuildContext context, _R r) {
    if (_multiExpenseListResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_multiExpenseListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Expenses Found",
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
          _onInquiryListPagination();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _multiExpenseListResponse.details.length,
        itemBuilder: (ctx, i) => _buildExpenseCard(ctx, r, i),
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, _R r, int index) {
    final model = _multiExpenseListResponse.details[index];

    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    Color statusColor = _getStatusColor(model.approvalStatus);

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
                  child: Icon(Icons.receipt_outlined,
                      size: r.s(18), color: const Color(0xff0066b3)),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.voucherNo ?? "N/A",
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        _fmtDate(model.expenseDate),
                        style:
                            TextStyle(fontSize: r.f(11), color: Colors.black54),
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
                      model.approvalStatus ?? "Pending",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: r.f(10),
                          fontWeight: FontWeight.bold),
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
                      children: [
                        _infoTile(r, Icons.person_outline, "Employee",
                            model.createdEmployeeName ?? "N/A"),
                        _infoTile(r, Icons.currency_rupee, "Amount",
                            model.amount.toString() ?? "N/A"),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      children: [
                        _infoTile(r, Icons.person_outline, "Created By",
                            model.createdBy ?? "N/A"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          LoginUserID == "admin"
              ? Padding(
                  padding:
                      EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (IsEditRights == true)
                        GestureDetector(
                          onTap: () => _onTapOfEditCustomer(model),
                          child: Container(
                            padding: EdgeInsets.all(r.s(6)),
                            child: Icon(Icons.edit_outlined,
                                size: r.s(18), color: const Color(0xff0066b3)),
                          ),
                        ),
                      if (IsDeleteRights == true)
                        GestureDetector(
                          onTap: () =>
                              _showDeleteConfirmation(model.pkID.toString()),
                          child: Container(
                            padding: EdgeInsets.all(r.s(6)),
                            child: Icon(Icons.delete_outline,
                                size: r.s(18), color: Colors.red.shade400),
                          ),
                        ),
                    ],
                  ),
                )
              : model.approvalStatus == "Approved"
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(
                          r.s(14), r.s(8), r.s(14), r.s(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (IsEditRights == true)
                            GestureDetector(
                              onTap: () => _onTapOfEditCustomer(model),
                              child: Container(
                                padding: EdgeInsets.all(r.s(6)),
                                child: Icon(Icons.edit_outlined,
                                    size: r.s(18),
                                    color: const Color(0xff0066b3)),
                              ),
                            ),
                          if (IsDeleteRights == true)
                            GestureDetector(
                              onTap: () => _showDeleteConfirmation(
                                  model.pkID.toString()),
                              child: Container(
                                padding: EdgeInsets.all(r.s(6)),
                                child: Icon(Icons.delete_outline,
                                    size: r.s(18), color: Colors.red.shade400),
                              ),
                            ),
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
                  maxLines: 2,
                  style: TextStyle(fontSize: r.f(12), color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status == null) return Colors.blueGrey.shade600;
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'rejected':
        return Colors.red.shade600;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  void _showDeleteConfirmation(String id) {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to delete this record?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _mainBloc.add(MultiExpenseDeleteRequestEvent(MultiExpenseDeleteRequest(
            pkID: id.toString(), CompanyId: CompanyID.toString())));
      },
    );
  }

  Future<void> _onTapOfDeleteALLMultipleExpense() async {
    await OfflineDbHelper.getInstance().deleteAllMultipleExpense();
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLMultipleExpense();
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onGetListCallSuccess(MultiExpenseListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _multiExpenseListResponse = state.response;
      } else {
        _multiExpenseListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  void _onInquiryListPagination() {
    _mainBloc.add(MultiExpenseListRequestEvent(
        _pageNo + 1,
        MultiExpenseListRequest(
            pkID: "0",
            SearchKey: _searchCtrl.text.trim(),
            PageNo: (_pageNo + 1).toString(),
            PageSize: "10",
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID)));
  }

  void _onMultiExpenseDeleteResponseStateCallSuccess(
      MultiExpenseDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _fetchList();
    });
  }

  void _onTapOfEditCustomer(MultiExpenseListResponseDetails detail) {
    navigateTo(context, MultiExpenseAddEditScreen.routeName,
            arguments: MultiExpenseAddEditScreenArguments(detail))
        .then((value) => _fetchList());
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgMultiExpense") {
        _mainBloc.add(UserMenuRightsRequestEvent(
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
