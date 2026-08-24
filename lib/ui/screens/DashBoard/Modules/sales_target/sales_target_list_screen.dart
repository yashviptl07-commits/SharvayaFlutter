import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:soleoserp/models/api_requests/sales_target/sales_target_delete_request.dart';
import 'package:soleoserp/models/api_requests/sales_target/sales_target_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/sales_target/sales_target_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/sales_target/sales_target_add_edit_screen.dart';
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

class SalesTargetListScreen extends BaseStatefulWidget {
  static const routeName = '/SalesTargetListScreen';

  @override
  _SalesTargetListScreenState createState() => _SalesTargetListScreenState();
}

class _SalesTargetListScreenState extends BaseState<SalesTargetListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  String LoginUserID;
  String CompanyID;
  SalesOrderBloc _inquiryBloc;
  int _pageNo = 0;
  SalesTargetListResponseDetails _searchDetails;
  SalesTargetListResponse _inquiryListResponse;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  String _selectedEmployeeID = "";
  String _selectedTargetType = "Amount";
  int TotalCount = 0;
  int _pageSize = 10;
  bool _isLoadingMore = false;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  final TextEditingController edt_SearchProduct = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_EmployeeID = TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  final TextEditingController edt_TargetType = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_TargetType = [];

  void _safeSetState(VoidCallback fn) {
    if (!mounted) {
      return;
    }
    setState(fn);
  }

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    TargetType();

    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_EmployeeID.text = _offlineLoggedInData.details[0].employeeID.toString();
    _selectedEmployeeID = edt_EmployeeID.text;

    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    edt_FollowupEmployeeUserID.text = LoginUserID;
    _selectedTargetType = "";

    _inquiryBloc = SalesOrderBloc(baseBloc);

    _fetchList();
  }

  void _fetchList() {
    _pageNo = 0;
    _isLoadingMore = false;
    _inquiryBloc.add(SalesTargetListCallEvent(
        0,
        SalaryTargetListRequest(
            LoginUserID: LoginUserID,
            Day: "0",
            Month: "0",
            Year: "0",
            TargetType: _selectedTargetType,
            PageNo: "1",
            PageSize: _pageSize.toString(),
            CompanyId: CompanyID.toString(),
            EmployeeID: _selectedEmployeeID)));

    getUserRights(_menuRightsResponse);
  }

  void _fetchNextPage() {
    if (_isLoadingMore) return;

    int totalPages = TotalCount > 0 ? (TotalCount / _pageSize).ceil() : 0;
    if (_pageNo + 1 >= totalPages) return;

    _isLoadingMore = true;
    _inquiryBloc.add(SalesTargetListCallEvent(
        _pageNo + 1,
        SalaryTargetListRequest(
            LoginUserID: LoginUserID,
            Day: "0",
            Month: "0",
            Year: "0",
            TargetType: _selectedTargetType,
            PageNo: (_pageNo + 1).toString(),
            PageSize: _pageSize.toString(),
            CompanyId: CompanyID.toString(),
            EmployeeID: _selectedEmployeeID)));

    getUserRights(_menuRightsResponse);
  }

  void _onEmployeeFilterTap() {
    showcustomdialog(
        values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
        context1: context,
        controller: edt_FollowupEmployeeList,
        controller2: edt_EmployeeID,
        lable: "Select Employee",
        onValueSelected: () {
          _safeSetState(() {
            _selectedEmployeeID = edt_EmployeeID.text;
          });
          _fetchList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<SalesOrderBloc, SalesOrderStates>(
        builder: (BuildContext context, SalesOrderStates state) {
          if (state is SalesTargetListCallResponseState) {
            _OnProductListResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is SalesTargetListCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SalesOrderStates state) {
          if (state is SalesTargetListCallResponseState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _safeSetState(() {});
            });
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          if (state is SalesTargetDeleteResponseState) {
            _onSalesTargetDeleteResponseStateSuccess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesTargetListCallResponseState) {
            return true;
          }
          if (currentState is UserMenuRightsResponseState) {
            return true;
          }
          if (currentState is SalesTargetDeleteResponseState) {
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
            'Sales Target',
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
                    TotalCount.toString(),
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
                  navigateTo(context, SalesTargetAddEditScreen.routeName,
                      clearAllStack: true);
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
                  },
                  child: _buildTargetList(context, r),
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
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(8)),
          child: _buildEmployeeFilter(r)),
    );
  }

  Widget _buildEmployeeFilter(_R r) {
    return InkWell(
      onTap: _onEmployeeFilterTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Employee",
            style: TextStyle(
              fontSize: r.f(10),
              color: const Color(0xff0066b3),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: r.s(3)),
          Container(
            height: r.s(38),
            padding: EdgeInsets.symmetric(horizontal: r.s(10)),
            decoration: BoxDecoration(
              color: const Color(0xffF2F5FA),
              borderRadius: BorderRadius.circular(r.s(10)),
              border: Border.all(color: const Color(0xffDDE3EF)),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    color: Colors.grey.shade500, size: r.s(16)),
                SizedBox(width: r.s(6)),
                Expanded(
                  child: Text(
                    edt_FollowupEmployeeList.text.isEmpty
                        ? "Select Employee"
                        : edt_FollowupEmployeeList.text,
                    style: TextStyle(
                      color: edt_FollowupEmployeeList.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(11),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
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

  Widget _buildTargetList(BuildContext context, _R r) {
    if (_inquiryListResponse == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xff0066b3),
        ),
      );
    }

    if (_inquiryListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Sales Target Found",
              style: TextStyle(
                  fontSize: r.f(14),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // Calculate total pages
    int totalPages = TotalCount > 0 ? (TotalCount / _pageSize).ceil() : 0;
    bool hasMorePages = _pageNo + 1 < totalPages;

    // If no more pages, show regular list without loader
    if (!hasMorePages) {
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _inquiryListResponse.details.length,
        itemBuilder: (ctx, i) => _buildTargetCard(ctx, r, i),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (hasMorePages &&
            !_isLoadingMore &&
            _searchDetails == null &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100 &&
            scrollInfo.metrics.maxScrollExtent > 0) {
          _fetchNextPage();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _inquiryListResponse.details.length + 1, // +1 for loader
        itemBuilder: (ctx, i) {
          // Show loader at the end
          if (i == _inquiryListResponse.details.length) {
            return _buildLoaderItem(r);
          }
          return _buildTargetCard(ctx, r, i);
        },
      ),
    );
  }

  Widget _buildLoaderItem(_R r) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.s(16)),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: const Color(0xff0066b3),
              strokeWidth: 2,
            ),
            SizedBox(height: r.s(8)),
            Text(
              "Loading more...",
              style: TextStyle(
                fontSize: r.f(11),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetCard(BuildContext context, _R r, int index) {
    final model = _inquiryListResponse.details[index];

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _offlineLoggedInData.details[0].serialKey
                                    .toLowerCase() !=
                                "al2m-7ig1-h8s2-t0y3"
                            ? model.customerName
                            : model.employeeName,
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: r.s(8), vertical: r.s(2)),
                        decoration: BoxDecoration(
                          color: const Color(0xff0066b3).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(r.s(10)),
                        ),
                        child: Text(
                          model.targetType ?? "Amount",
                          style: TextStyle(
                            fontSize: r.f(10),
                            color: const Color(0xff0066b3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (IsEditRights == true)
                      _actionChip(r, Icons.edit_outlined, "Edit",
                          () => _onTapOfEditCustomer(model)),
                    if (IsDeleteRights == true)
                      _actionChip(r, Icons.delete_outline, "Delete",
                          () => _onTapOfDeleteCustomer(model.pkID),
                          isDelete: true),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), 0, r.s(14), r.s(8)),
            child: Row(
              children: [
                Expanded(
                  child: _buildAmountCard(
                    r,
                    "Sales Target",
                    "₹${model.targetAmount?.toStringAsFixed(2) ?? '0.00'}",
                    Colors.blue.shade600,
                  ),
                ),
                SizedBox(width: r.s(8)),
                Expanded(
                  child: _buildAmountCard(
                    r,
                    "Achieved",
                    "₹${model.achievedAmount?.toStringAsFixed(2) ?? '0.00'}",
                    Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Period Details
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(4), r.s(14), r.s(10)),
            child: Row(
              children: [
                Expanded(
                  child: _buildPeriodInfo(
                    r,
                    Icons.calendar_today_outlined,
                    "From",
                    _fmtDate(model.fromDate),
                  ),
                ),
                SizedBox(width: r.s(8)),
                Expanded(
                  child: _buildPeriodInfo(
                    r,
                    Icons.calendar_today_outlined,
                    "To",
                    _fmtDate(model.toDate),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: r.s(10))
        ],
      ),
    );
  }

  void _onTapOfEditCustomer(SalesTargetListResponseDetails detail) {
    navigateTo(context, SalesTargetAddEditScreen.routeName,
            arguments: SalesTargetAddEditScreenArguments(detail))
        .then((value) {
      _fetchList();
    });
  }

  void _onTapOfDeleteCustomer(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Record?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _inquiryBloc.add(SalesTargetDeleteCallEvent(
          SalesTargetDeleteRequest(pkID: id.toString(), CompanyId: CompanyID)));
    });
  }

  void _onSalesTargetDeleteResponseStateSuccess(
      SalesTargetDeleteResponseState state, BuildContext buildContext123) {
    navigateTo(context, SalesTargetListScreen.routeName, clearAllStack: true);
  }

  Widget _actionChip(_R r, IconData icon, String label, VoidCallback onTap,
      {bool isDelete = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
        decoration: BoxDecoration(
          color: isDelete ? Colors.red.shade50 : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(r.s(20)),
        ),
        child: Icon(icon,
            size: r.s(20), color: isDelete ? Colors.red.shade600 : Colors.blue),
      ),
    );
  }

  Widget _buildAmountCard(_R r, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(8)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(r.s(10)),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: r.f(9),
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: r.s(2)),
          Text(
            value,
            style: TextStyle(
              fontSize: r.f(13),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodInfo(_R r, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: r.s(13), color: const Color(0xff0066b3)),
        SizedBox(width: r.s(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: r.f(9),
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: r.f(11),
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _OnProductListResponse(SalesTargetListCallResponseState state) {
    _isLoadingMore = false; // Reset loading flag

    if (_pageNo != state.newPage || state.newPage == 0) {
      if (state.newPage == 0) {
        // First page - reset list
        _searchDetails = null;
        _inquiryListResponse = state.response;
        TotalCount = state.response.totalCount;
      } else {
        // Next page - append data
        _inquiryListResponse.details.addAll(state.response.details);
        TotalCount = state.response.totalCount;
      }
      _pageNo = state.newPage;
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].pkID.toString();
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
    _safeSetState(() {});
  }

  void TargetType() {
    arr_ALL_Name_ID_TargetType.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      if (i == 0) {
        all_name_id.Name = "Amount";
      } else if (i == 1) {
        all_name_id.Name = "Quantity";
      }
      arr_ALL_Name_ID_TargetType.add(all_name_id);
    }
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgSalesTarget") {
        _inquiryBloc.add(UserMenuRightsRequestEvent(
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

  @override
  void dispose() {
    _inquiryBloc.close();
    super.dispose();
  }
}
