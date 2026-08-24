import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/Clients/BlueTone/Inquiry/AddEdit/bluetone_inquiry_add_edit.dart';
import 'package:soleoserp/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:soleoserp/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_delete_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_no_followup_details_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_search_by_pk_id_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_list_reponse.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_no_to_product_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/search_inquiry_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_fillter/FollowupFromInquiry.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_product_shortcut_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_share_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/broadcast_msg/make_call.dart';
import 'package:soleoserp/utils/broadcast_msg/share_msg.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
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

class MessageArguments {
  final RemoteMessage message;
  final bool openedApplication;
  MessageArguments(this.message, this.openedApplication);
}

class InquiryListScreen extends BaseStatefulWidget {
  static const routeName = '/inquiryListScreen';
  MessageArguments arguments;

  InquiryListScreen(this.arguments);

  @override
  _InquiryListScreenState createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends BaseState<InquiryListScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  int _pageNo = 0;
  InquiryListResponse _inquiryListResponse;
  SearchInquiryDetails _searchDetails;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;

  int CompanyID = 0;
  String LoginUserID = "";
  FilterDetails followupHistoryDetails;
  bool isDeleteVisible = true;
  List<InquiryShareModel> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  List<InquirySharedEmpDetails> arr_Inquiry_Share_Emp_List = [];
  CustomerDetails customerDetails = CustomerDetails();

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  List<ALL_Name_ID> arr_EmployeeList = [];

  final TextEditingController edt_loginUserID = TextEditingController();
  final TextEditingController edt_employeeName = TextEditingController();
  final TextEditingController edt_employeeID = TextEditingController();
  final TextEditingController edt_customerName = TextEditingController();
  final TextEditingController edt_customerpkID = TextEditingController();

  String _selectedEmployeeID = "";

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    edt_employeeName.text = _offlineLoggedInData.details[0].employeeName;
    edt_employeeID.text = _offlineLoggedInData.details[0].employeeID.toString();
    _selectedEmployeeID = edt_employeeID.text;
    _inquiryBloc = InquiryBloc(baseBloc);

    getUserRights(_menuRightsResponse);

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    edt_loginUserID.text = LoginUserID;
    edt_customerName.text = "";
    edt_customerpkID.text = "";

    _fetchList();
  }

  void _fetchList() {
    _inquiryBloc.add(InquiryListCallEvent(
        1,
        InquiryListApiRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
            PkId: "",
            EmployeeID: _selectedEmployeeID)));
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          if (state is InquiryListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is InquirySearchByPkIDResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InquiryListCallResponseState ||
              currentState is InquirySearchByPkIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {
          if (state is InquiryDeleteCallResponseState) {
            _onInquiryDeleteCallSucess(state, context);
          }
          if (state is FollowupHistoryListResponseState) {
            _OnInquiryNoToFollowupDetails(state, context);
          }
          if (state is InquiryShareResponseState) {
            _OnInquiryShareResponseSucess(state);
          }
          if (state is InquiryShareEmpListResponseState) {
            _OnInquiryShareEmpListResponse(state);
          }
          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }
          if (state is InquiryNotoProductResponseState) {
            _OnInquiryNoToProductListResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InquiryDeleteCallResponseState ||
              currentState is FollowupHistoryListResponseState ||
              currentState is InquiryShareResponseState ||
              currentState is InquiryShareEmpListResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is InquiryNotoProductResponseState) {
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
      onWillPop: () {
        navigateTo(context, HomeScreen.routeName, clearAllStack: true);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'Inquiry List',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search_rounded,
                  color: Colors.white, size: 24),
              onPressed: () => _onTaptoSearchInquiryView(),
            ),
            IsAddRights == true
                ? IconButton(
                    icon: const Icon(Icons.add_circle_sharp,
                        color: Colors.white, size: 24),
                    onPressed: () async {
                      await _onTapOfDeleteALLProduct();
                      await _onTapOfDeleteALLPrice();
                      if (_offlineLoggedInData.details[0].serialKey
                              .toUpperCase() ==
                          "BLG3-AF78-TO5F-NW16") {
                        navigateTo(
                            context, BlueToneInquiryAddEditScreen.routeName);
                      } else {
                        navigateTo(context, InquiryAddEditScreen.routeName);
                      }
                    },
                  )
                : Container(),
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () => navigateTo(context, HomeScreen.routeName,
                  clearAllStack: true),
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
                    getUserRights(_menuRightsResponse);
                    _fetchList();
                  },
                  child: _buildInquiryList(context, r),
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
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(10)),
        child: InkWell(
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
                        controller: edt_employeeName,
                        enabled: false,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: r.f(12),
                          fontWeight: FontWeight.w500,
                        ),
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
        ),
      ),
    );
  }

  Widget _buildInquiryList(BuildContext context, _R r) {
    if (_inquiryListResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_inquiryListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Inquiries Found",
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
        if (shouldPaginate(scrollInfo) && _searchDetails == null) {
          _onInquiryListPagination();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _inquiryListResponse.details.length,
        itemBuilder: (ctx, index) => _buildInquiryCard(ctx, r, index),
      ),
    );
  }

  Widget _buildInquiryCard(BuildContext context, _R r, int index) {
    final model = _inquiryListResponse.details[index];
    bool isIndiaMart =
        model.InquirySourceName.replaceAll(" ", "").toLowerCase().trim() ==
            "indiamart";

    Color statusColor = _getStatusColor(model.inquiryStatus ?? "Pending");

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
      color: isIndiaMart ? const Color(0xFFFAF6C3) : Colors.white,
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
                        model.customerName ?? "N/A",
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Row(
                        children: [
                          Icon(Icons.confirmation_num,
                              size: r.s(12), color: Colors.grey.shade500),
                          SizedBox(width: r.s(4)),
                          Text(model.inquiryNo ?? "N/A",
                              style: TextStyle(
                                  fontSize: r.f(10), color: Colors.black54)),
                        ],
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
                      model.inquiryStatus ?? "N/A",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
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
                        _infoTile(r, Icons.source_outlined, "Source",
                            model.InquirySourceName ?? "N/A"),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.calendar_today_outlined,
                            "Inquiry Date", _fmtDate(model.inquiryDate)),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      children: [
                        _infoTile(
                            r,
                            Icons.person_outline,
                            "Reference",
                            model.referenceName?.isNotEmpty == true
                                ? model.referenceName
                                : "N/A"),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.person_add_outlined, "Created By",
                            model.createdBy ?? "N/A"),
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
                _actionChip(
                    r,
                    Icons.history,
                    "History",
                    () => MoveTofollowupHistoryPage(
                        model.inquiryNo, model.customerID.toString())),
                _actionChip(
                    r,
                    Icons.share,
                    "Share",
                    () => _inquiryBloc.add(InquiryShareEmpListRequestEvent(
                        InquiryShareEmpListRequest(
                            InquiryNo: model.inquiryNo,
                            CompanyId: CompanyID.toString())))),
                _actionChip(
                    r,
                    Icons.add,
                    "Followup",
                    () => _inquiryBloc.add(
                        InquiryNoToFollowupDetailsRequestCallEvent(
                            model,
                            InquiryNoToFollowupDetailsRequest(
                                InquiryNo: model.inquiryNo,
                                CompanyId: CompanyID.toString(),
                                CustomerID: model.customerID.toString())))),
                _actionChip(r, Icons.account_box, "Info",
                    () => FetchCustomerDetails(model.customerID)),
                _actionChip(
                    r,
                    Icons.shopping_cart,
                    "Product",
                    () => MoveToProductHistoryPage(
                        model.inquiryNo, model.customerID.toString())),
              ],
            ),
          ),
          if (IsEditRights == true || IsDeleteRights == true)
            Padding(
              padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (IsEditRights == true)
                    GestureDetector(
                      onTap: () => _onTapOfEditInquiry(model),
                      child: Container(
                          padding: EdgeInsets.all(r.s(6)),
                          child: Icon(Icons.edit_outlined,
                              size: r.s(18), color: const Color(0xff0066b3))),
                    ),
                  if (IsDeleteRights == true)
                    GestureDetector(
                      onTap: () => _onTapOfDeleteInquiry(model.pkID),
                      child: Container(
                          padding: EdgeInsets.all(r.s(6)),
                          child: Icon(Icons.delete_outline,
                              size: r.s(18), color: Colors.red.shade400)),
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
        padding: EdgeInsets.symmetric(horizontal: r.s(8), vertical: r.s(6)),
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

  Color _getStatusColor(String status) {
    if (status == null) return Colors.blueGrey.shade600;
    if (status.contains("Success")) return Colors.green.shade600;
    if (status.contains("Progress")) return Colors.orange.shade600;
    switch (status.toLowerCase()) {
      case "close - success":
        return Colors.green.shade600;
      case "work in progress":
        return Colors.orange.shade600;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  // ==================== ALL ORIGINAL METHODS KEPT EXACTLY THE SAME ====================

  void _onInquiryListCallSuccess(InquiryListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _searchDetails = null;
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  void _onInquiryListPagination() {
    _inquiryBloc.add(InquiryListCallEvent(
        _pageNo + 1,
        InquiryListApiRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
            PkId: "",
            EmployeeID: _selectedEmployeeID)));
  }

  void _onInquiryListByNumberCallSuccess(
      InquirySearchByPkIDResponseState state) {
    _inquiryListResponse = state.response;
  }

  void _onTapOfEditInquiry(InquiryDetails model) {
    if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
        "BLG3-AF78-TO5F-NW16") {
      navigateTo(context, BlueToneInquiryAddEditScreen.routeName,
              arguments: AddUpdateBlueToneInquiryScreenArguments(model))
          .then((value) => _fetchList());
    } else {
      navigateTo(context, InquiryAddEditScreen.routeName,
              arguments: AddUpdateInquiryScreenArguments(model))
          .then((value) => _fetchList());
    }
  }

  void _onTapOfDeleteInquiry(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Inquiry Request?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      _inquiryBloc.add(InquiryDeleteByNameCallEvent(
          id, FollowupDeleteRequest(CompanyId: CompanyID.toString())));
    });
  }

  void _onInquiryDeleteCallSucess(
      InquiryDeleteCallResponseState state, BuildContext buildContext123) {
    navigateTo(buildContext123, InquiryListScreen.routeName,
        clearAllStack: true);
  }

  Future<void> _onTapOfDeleteALLProduct() async =>
      await OfflineDbHelper.getInstance().deleteALLInquiryProduct();
  Future<void> _onTapOfDeleteALLPrice() async {
    await OfflineDbHelper.getInstance().deleteAllBlueToneProductItems();
    await OfflineDbHelper.getInstance().deleteAllProductPriceList();
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo, String CustomerID) {
    return navigateTo(context, FollowupHistoryScreen.routeName,
        arguments: FollowupHistoryScreenArguments(inquiryNo, CustomerID));
  }

  Future<void> MoveToProductHistoryPage(String inquiryNo, String CustomerID) {
    return navigateTo(context, ProductHistoryScreen.routeName,
        arguments: ProductHistoryScreenArguments(inquiryNo, CustomerID));
  }

  void _OnInquiryNoToFollowupDetails(
      FollowupHistoryListResponseState state, BuildContext context) {
    followupHistoryDetails = FilterDetails();
    if (state.followupHistoryListResponse.details.isNotEmpty) {
      var f = state.followupHistoryListResponse.details[0];
      followupHistoryDetails = FilterDetails(
        pkID: 0,
        inquiryNo: f.inquiryNo,
        customerID: f.customerID,
        customerName: f.customerName,
        contactNumber1: f.contactNumber1,
        followupStatus: f.followupStatus,
        followupStatusID: f.followupStatusID,
        inquiryStatus: f.inquiryStatus,
        inquiryStatusID: f.inquiryStatusID,
        rating: f.rating,
      );
      navigateTo(context, FollowUpFromInquiryAddEditScreen.routeName,
              arguments: AddUpdateFollowupFromInquiryScreenArguments(
                  followupHistoryDetails))
          .then((value) => _fetchList());
    } else if (state.inquiryDetails != 0) {
      followupHistoryDetails = FilterDetails(
        pkID: 0,
        inquiryNo: state.inquiryDetails.inquiryNo,
        customerID: state.inquiryDetails.customerID,
        customerName: state.inquiryDetails.customerName,
        contactNumber1: state.inquiryDetails.ContactNo,
        rating: 0,
      );
      navigateTo(context, FollowUpFromInquiryAddEditScreen.routeName,
          arguments: AddUpdateFollowupFromInquiryScreenArguments(
              followupHistoryDetails));
    }
  }

  void _OnInquiryShareResponseSucess(InquiryShareResponseState state) {}
  void _OnInquiryShareEmpListResponse(InquiryShareEmpListResponseState state) {
    arr_Inquiry_Share_Emp_List.clear();
    if (state.response.totalCount != 0) {
      arr_Inquiry_Share_Emp_List.addAll(state.response.details);
    } else {
      var emp = InquirySharedEmpDetails();
      emp.inquiryNo = state.InquiryNo;
      emp.employeeID = _offlineLoggedInData.details[0].employeeID;
      emp.createdBy = _offlineLoggedInData.details[0].userID;
      arr_Inquiry_Share_Emp_List.add(emp);
    }
    if (arr_Inquiry_Share_Emp_List.isNotEmpty) {
      navigateTo(context, InquiryShareScreen.routeName,
              arguments:
                  AddInquiryShareScreenArguments(arr_Inquiry_Share_Emp_List))
          .then((value) => _fetchList());
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();
    arr_EmployeeList.clear();
    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(InquiryShareModel(
            LoginUserID,
            state.details[i].pkID.toString(),
            CompanyID.toString(),
            "",
            false,
            state.details[i].employeeName));
        arr_EmployeeList.add(ALL_Name_ID(
            Name: state.details[i].employeeName,
            Name1: state.details[i].pkID.toString(),
            MenuName: state.details[i].userID));
      }
    }
  }

  void _onTaptoSearchInquiryView() {
    navigateTo(context, SearchInquiryScreen.routeName,
            arguments: AddUpdateSearchInquiryScreenArguments(
                edt_employeeID.text, edt_employeeName.text))
        .then((value) {
      if (value != null) {
        edt_customerpkID.text = value.pkID.toString();
        edt_customerName.text = value.customerName.toString();
        _inquiryBloc.add(InquirySearchByPkIDCallEvent(
            value.pkID.toString(),
            InquirySearchByPkIdRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
        setState(() {});
      }
    });
  }

  void FetchCustomerDetails(int customerID321) {
    _inquiryBloc.add(SearchCustomerListByNumberCallEvent(
        CustomerSearchByIdRequest(
            companyId: CompanyID,
            loginUserID: LoginUserID,
            CustomerID: customerID321.toString())));
  }

  void _ONOnlyCustomerDetails(
      SearchCustomerListByNumberCallResponseState state) {
    for (int i = 0; i < state.response.details.length; i++) {
      print("CustomerDetailsw" +
          "CustomerName : " +
          state.response.details[i].customerName +
          " Customer ID : " +
          state.response.details[i].customerID.toString());
    }

    customerDetails = CustomerDetails();
    customerDetails.customerName = state.response.details[0].customerName;
    customerDetails.customerType = state.response.details[0].customerType;
    customerDetails.customerSourceName =
        state.response.details[0].customerSourceName;
    customerDetails.contactNo1 = state.response.details[0].contactNo1;
    customerDetails.emailAddress = state.response.details[0].emailAddress;
    customerDetails.address = state.response.details[0].address;
    customerDetails.area = state.response.details[0].area;
    customerDetails.pinCode = state.response.details[0].pinCode;
    customerDetails.countryName = state.response.details[0].countryName;
    customerDetails.stateName = state.response.details[0].stateName;
    customerDetails.cityName = state.response.details[0].cityName;
    customerDetails.cityName = state.response.details[0].cityName;

    showCustomDialog(
      context1: context,

      customerDetails123: customerDetails,
    );
  }

  showCustomDialog({
    BuildContext context1,
    CustomerDetails customerDetails123,
  }) async {
    final r = _R(context1);

    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.s(24)),
          ),
          elevation: 4,
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context123).size.width * 0.9,
            constraints: BoxConstraints(
              maxWidth: 450,
              maxHeight: MediaQuery.of(context123).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding:
                      EdgeInsets.fromLTRB(r.s(20), r.s(16), r.s(12), r.s(16)),
                  decoration: const BoxDecoration(
                    color: Color(0xff0066b3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Customer Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: r.f(16),
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context1).pop(),
                        child: Container(
                          padding: EdgeInsets.all(r.s(4)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(r.s(20)),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: r.s(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(r.s(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Name Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(r.s(12)),
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F5FA),
                            borderRadius: BorderRadius.circular(r.s(12)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                customerDetails123.customerName ?? "N/A",
                                style: TextStyle(
                                  fontSize: r.f(16),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff0066b3),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: r.s(16)),

                        // Category & Source
                        Row(
                          children: [
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.category_outlined,
                                label: "Category",
                                value: customerDetails123.customerType
                                        ?.toString() ??
                                    "N/A",
                              ),
                            ),
                            SizedBox(width: r.s(12)),
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.source_outlined,
                                label: "Source",
                                value: customerDetails123.customerSourceName ==
                                        "--Not Available--"
                                    ? "N/A"
                                    : customerDetails123.customerSourceName ??
                                        "N/A",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: r.s(12)),

                        // Contact Number with Actions
                        _detailCardWithActions(
                          r,
                          icon: Icons.phone_outlined,
                          label: "Contact Number",
                          value:
                              customerDetails123.contactNo1?.isNotEmpty == true
                                  ? customerDetails123.contactNo1
                                  : "N/A",
                          onCall: customerDetails123.contactNo1?.isNotEmpty ==
                                  true
                              ? () =>
                                  MakeCall.callto(customerDetails123.contactNo1)
                              : null,
                          onWhatsApp:
                              customerDetails123.contactNo1?.isNotEmpty == true
                                  ? () => ShareMsg.msg(
                                      context1, customerDetails123.contactNo1)
                                  : null,
                        ),
                        SizedBox(height: r.s(12)),

                        // Email
                        _detailCard(
                          r,
                          icon: Icons.email_outlined,
                          label: "Email",
                          value: customerDetails123.emailAddress?.isNotEmpty ==
                                  true
                              ? customerDetails123.emailAddress
                              : "N/A",
                        ),
                        SizedBox(height: r.s(12)),

                        // Address
                        _detailCard(
                          r,
                          icon: Icons.location_on_outlined,
                          label: "Address",
                          value: customerDetails123.address?.isNotEmpty == true
                              ? customerDetails123.address
                              : "N/A",
                        ),
                        SizedBox(height: r.s(12)),

                        // Area & Pin Code
                        Row(
                          children: [
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.location_city_outlined,
                                label: "Area",
                                value:
                                    customerDetails123.area?.isNotEmpty == true
                                        ? customerDetails123.area
                                        : "N/A",
                              ),
                            ),
                            SizedBox(width: r.s(12)),
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.local_post_office_outlined,
                                label: "Pin Code",
                                value: customerDetails123.pinCode?.isNotEmpty ==
                                        true
                                    ? customerDetails123.pinCode
                                    : "N/A",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: r.s(12)),

                        // Country, State, City
                        Row(
                          children: [
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.public_outlined,
                                label: "Country",
                                value: customerDetails123
                                            .countryName?.isNotEmpty ==
                                        true
                                    ? customerDetails123.countryName
                                    : "N/A",
                              ),
                            ),
                            SizedBox(width: r.s(12)),
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.map_outlined,
                                label: "State",
                                value:
                                    customerDetails123.stateName?.isNotEmpty ==
                                            true
                                        ? customerDetails123.stateName
                                        : "N/A",
                              ),
                            ),
                            SizedBox(width: r.s(12)),
                            Expanded(
                              child: _detailCard(
                                r,
                                icon: Icons.location_city,
                                label: "City",
                                value:
                                    customerDetails123.cityName?.isNotEmpty ==
                                            true
                                        ? customerDetails123.cityName
                                        : "N/A",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: r.s(24)),

                        // Close Button
                        GestureDetector(
                          onTap: () => Navigator.of(context1).pop(),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: r.s(12)),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff108dcf), Color(0xff0066b3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(r.s(12)),
                            ),
                            child: Center(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: r.f(14),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper Widget for Detail Card
  Widget _detailCard(_R r, {IconData icon, String label, String value}) {
    return Container(
      padding: EdgeInsets.all(r.s(10)),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5FA),
        borderRadius: BorderRadius.circular(r.s(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: r.s(14), color: const Color(0xff0066b3)),
              SizedBox(width: r.s(6)),
              Text(
                label,
                style: TextStyle(
                  fontSize: r.f(10),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: r.s(6)),
          Text(
            value,
            style: TextStyle(
              fontSize: r.f(12),
              color: const Color(0xff1A2332),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

// Helper Widget for Detail Card with Actions (Call & WhatsApp)
  Widget _detailCardWithActions(_R r,
      {IconData icon,
      String label,
      String value,
      VoidCallback onCall,
      VoidCallback onWhatsApp}) {
    return Container(
      padding: EdgeInsets.all(r.s(10)),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5FA),
        borderRadius: BorderRadius.circular(r.s(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: r.s(14), color: const Color(0xff0066b3)),
              SizedBox(width: r.s(6)),
              Text(
                label,
                style: TextStyle(
                  fontSize: r.f(10),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: r.s(6)),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: r.f(12),
                    color: const Color(0xff1A2332),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onCall != null)
                GestureDetector(
                  onTap: onCall,
                  child: Container(
                    padding: EdgeInsets.all(r.s(6)),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(r.s(8)),
                    ),
                    child: Icon(Icons.call,
                        size: r.s(16), color: Colors.green.shade700),
                  ),
                ),
              if (onWhatsApp != null) SizedBox(width: r.s(8)),
              if (onWhatsApp != null)
                GestureDetector(
                  onTap: onWhatsApp,
                  child: Container(
                    padding: EdgeInsets.all(r.s(6)),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(r.s(8)),
                    ),
                    child: Image.asset(WHATSAPP_IMAGE,
                        width: r.s(16), height: r.s(16)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _OnInquiryNoToProductListResponse(
      InquiryNotoProductResponseState state) {
    List<ALL_Name_ID> arr_ProductListArray = [];

    for (var i = 0; i < state.inquiryNoToProductResponse.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name =
          state.inquiryNoToProductResponse.details[i].productName;
      all_name_id.Name1 =
          "Qty: ${state.inquiryNoToProductResponse.details[i].quantity} | Price: ${state.inquiryNoToProductResponse.details[i].unitPrice}";
      arr_ProductListArray.add(all_name_id);
    }

    showcustomdialogWithOnlyName(
      values: arr_ProductListArray,
      context1: context,
      lable: "Product Details",
    );
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgInquiry") {
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
}
