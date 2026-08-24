import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/employee/employee_bloc.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_voucher_delete_request.dart';
import 'package:soleoserp/models/api_requests/employee/employee_list_request.dart';
import 'package:soleoserp/models/api_requests/employee/employee_search_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/employee/employee_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/contact_model.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/employee/employee_list/employee_search_screen.dart';
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

class EmployeeListScreen extends BaseStatefulWidget {
  static const routeName = '/EmployeeListScreen';

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends BaseState<EmployeeListScreen>
    with BasicScreen, WidgetsBindingObserver {
  EmployeeScreenBloc _CustomerBloc;
  int _pageNo = 0;
  EmployeeListResponse _inquiryListResponse;
  EmployeeDetails _searchDetails;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ContactModel> _contactsList = [];
  bool isDeleteVisible = true;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  final TextEditingController _searchCtrl = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _CustomerBloc = EmployeeScreenBloc(baseBloc);
    getContacts();
    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    getUserRights(_menuRightsResponse);
    _fetchList();
  }

  void _fetchList() {
    _CustomerBloc.add(EmployeeListCallEvent(
        1,
        EmployeeListRequest(
          CompanyId: CompanyID.toString(),
          OrgCode: "",
          LoginUserID: LoginUserID,
        )));
  }

  void _onSearchTap() async {
    final result = await navigateTo(context, SearchEmployeeScreen.routeName);
    if (result != null) {
      setState(() {
        _searchDetails = result;
        isSearching = true;
      });
      _CustomerBloc.add(EmployeeSearchCallEvent(EmployeeSearchRequest(
          CompanyId: CompanyID.toString(),
          SearchKey: _searchDetails.employeeName.toString(),
          LoginUserID: LoginUserID)));
    }
  }

  void _clearSearch() {
    setState(() {
      _searchDetails = null;
      isSearching = false;
      _searchCtrl.clear();
    });
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<EmployeeScreenBloc, EmployeeScreenStates>(
        builder: (BuildContext context, EmployeeScreenStates state) {
          if (state is EmployeeListResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is EmployeeSearchResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is EmployeeListResponseState ||
              currentState is EmployeeSearchResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, EmployeeScreenStates state) {
          if (state is EmployeeDeleteResponseState) {
            _onCustomerDeleteCallSucess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is EmployeeDeleteResponseState) {
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
            'Employee List',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home_outlined, color: Colors.white, size: 24),
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
              _buildSearchPanel(context),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async {
                    _clearSearch();
                    getUserRights(_menuRightsResponse);
                  },
                  child: _buildEmployeeList(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPanel(BuildContext context) {
    final r = _R(context);
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
        child: GestureDetector(
          onTap: _onSearchTap,
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
                  child: Text(
                    _searchDetails == null
                        ? "Search employee by name..."
                        : _searchDetails.employeeName,
                    style: TextStyle(
                      fontSize: r.f(13),
                      color: _searchDetails == null
                          ? Colors.grey.shade400
                          : Colors.black87,
                    ),
                  ),
                ),
                if (_searchDetails != null)
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Icon(Icons.close,
                        size: r.s(16), color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList(BuildContext context) {
    final r = _R(context);
    if (_inquiryListResponse != null &&
        _inquiryListResponse.details.isNotEmpty) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(scrollInfo) && !isSearching) {
            _onInquiryListPagination();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
          itemCount: _inquiryListResponse.details.length,
          itemBuilder: (ctx, i) => _buildEmployeeCard(ctx, i),
        ),
      );
    }
    return Center(
      child: Lottie.asset(NO_SEARCH_RESULT_FOUND,
          height: r.s(180), width: r.s(180)),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, int index) {
    final r = _R(context);
    final model = _inquiryListResponse.details[index];

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
                  radius: r.s(22),
                  backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                  child: Text(
                    model.employeeName?.substring(0, 1).toUpperCase() ?? "E",
                    style: TextStyle(
                      fontSize: r.f(18),
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
                        model.employeeName ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: r.f(14),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0066b3),
                        ),
                      ),
                      SizedBox(height: r.s(4)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: r.s(8), vertical: r.s(2)),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(r.s(12)),
                        ),
                        child: Text(
                          model.designation ?? "N/A",
                          style: TextStyle(
                            fontSize: r.f(10),
                            color: Colors.grey.shade600,
                          ),
                        ),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoTile(
                          r,
                          Icons.supervisor_account_outlined,
                          "Report To",
                          model.reportToEmployeeName?.isNotEmpty == true
                              ? model.reportToEmployeeName
                              : "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.attach_money_outlined,
                          "Fixed Salary",
                          model.fixedSalary != null && model.fixedSalary != 0.00
                              ? model.fixedSalary.toString()
                              : "N/A",
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
                          Icons.email_outlined,
                          "Email",
                          model.emailAddress?.isNotEmpty == true
                              ? model.emailAddress
                              : "N/A",
                        ),
                        SizedBox(height: r.s(7)),
                        _infoTile(
                          r,
                          Icons.cake_outlined,
                          "Birth Date",
                          model.birthDate != null
                              ? _fmtDate(model.birthDate)
                              : "N/A",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (IsDeleteRights == true)
                  GestureDetector(
                    onTap: () => _onTapOfDeleteInquiry(model.pkID),
                    child: Container(
                      padding: EdgeInsets.all(r.s(6)),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: r.s(16), color: Colors.red.shade400),
                          SizedBox(width: r.s(4)),
                          Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.red.shade400,
                                fontSize: r.f(11),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),*/
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

  void _onInquiryListCallSuccess(EmployeeListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        if (!isSearching) {
          _searchDetails = null;
        }
        _inquiryListResponse = state.employeeListResponse;
      } else {
        _inquiryListResponse.details.addAll(state.employeeListResponse.details);
      }
      _pageNo = state.newPage;
    }
  }

  void _onInquiryListPagination() {
    _CustomerBloc.add(EmployeeListCallEvent(
        _pageNo + 1,
        EmployeeListRequest(
          CompanyId: CompanyID.toString(),
          OrgCode: "",
          LoginUserID: LoginUserID,
        )));
  }

  void _onSearchInquiryListCallSuccess(EmployeeSearchResponseState state) {
    _inquiryListResponse = state.employeeListResponse;
  }

  void _onTapOfDeleteInquiry(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Employee?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _CustomerBloc.add(EmployeeDeleteCallEvent(
          id, BankVoucherDeleteRequest(CompanyID: CompanyID.toString())));
    });
  }

  void _onCustomerDeleteCallSucess(
      EmployeeDeleteResponseState state, BuildContext context) {
    showCommonDialogWithSingleOption(context, "Employee Deleted Successfully!",
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _clearSearch();
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  Future<void> getContacts() async {
    _contactsList.clear();
    _contactsList.addAll(await OfflineDbHelper.getInstance().getContacts());
    setState(() {});
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgEmployee") {
        _CustomerBloc.add(UserMenuRightsRequestEvent(
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
