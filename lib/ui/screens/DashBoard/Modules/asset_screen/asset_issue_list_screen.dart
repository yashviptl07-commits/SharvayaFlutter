import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/journalVoucher_mstAsset_list_request/journalVoucher_mstAsset_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/asset_list_response/asset_issue_list_response.dart';
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

class AssetIssueListScreen extends BaseStatefulWidget {
  static const routeName = '/AssetIssueListScreen';

  @override
  _AssetIssueListScreenState createState() => _AssetIssueListScreenState();
}

class _AssetIssueListScreenState extends BaseState<AssetIssueListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  int _pageNo = 0;
  AssetIssueListResponse _listResponse;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  int selected = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;
  FocusNode _searchFocusNode;
  int FinalTotalCount = 0;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);
    _searchFocusNode = FocusNode();
    _fetchList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    _searchFocusNode?.dispose();
    super.dispose();
  }

  void _fetchList() {
    _mainBloc.add(
      AssetIssueListCallRequestEvent(
          JournalVoucherMstAssetListRequest(
            pkID: 0,
            SearchKey: _searchCtrl.text.trim(),
            PageNo: 1,
            PageSize: 10,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID,
          ),
          1),
    );
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
          if (state is AssetIssueListCallResponseState) {
            _onAssetIssueListCallResponseStateSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is AssetIssueListCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {},
        listenWhen: (oldState, currentState) {
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
            'Asset Issue',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
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
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchPanel(context, r),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async => _fetchList(),
                  child: _buildAssetList(context, r),
                ),
              ),
            ],
          ),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
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
                  focusNode: _searchFocusNode,
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  onChanged: (v) {
                    _onSearchChanged(v);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "Search by asset name...",
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

  Widget _buildAssetList(BuildContext context, _R r) {
    if (_listResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_listResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Assets Found",
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
        itemCount: _listResponse.details.length,
        itemBuilder: (ctx, i) => _buildAssetCard(ctx, r, i),
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, _R r, int index) {
    final model = _listResponse.details[index];

    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    return Card(
      margin: EdgeInsets.only(bottom: r.s(10)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.s(14)),
      ),
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with ID and Date
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
                  radius: r.s(18),
                  backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                  child: Icon(Icons.inventory_2_outlined,
                      size: r.s(18), color: const Color(0xff0066b3)),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Asset ID: ${model.pkID?.toString() ?? "N/A"}",
                        style: TextStyle(
                          fontSize: r.f(12),
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        model.assetName ?? "N/A",
                        style: TextStyle(
                          fontSize: r.f(14),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0066b3),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: r.s(8), vertical: r.s(4)),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(r.s(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: r.s(12), color: Colors.grey.shade600),
                      SizedBox(width: r.s(4)),
                      Text(
                        _fmtDate(model.assetDate ?? ""),
                        style: TextStyle(
                          fontSize: r.f(10),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Employee and Project Row
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(12), r.s(14), r.s(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoTile(r, Icons.person_outline, "Employee",
                      model.employeeName ?? "N/A"),
                ),
                SizedBox(width: r.s(12)),
                Expanded(
                  child: _infoTile(r, Icons.business_center_outlined, "Project",
                      model.projectName ?? "N/A"),
                ),
              ],
            ),
          ),

          // Model and IMEI Row
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(4), r.s(14), r.s(14)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoTile(r, Icons.devices_outlined, "Model No",
                      model.modelNo ?? "N/A"),
                ),
                SizedBox(width: r.s(12)),
                Expanded(
                  child: _infoTile(r, Icons.sim_card_outlined, "IMEI No",
                      model.iMEINo ?? "N/A"),
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
        Icon(icon, size: r.s(14), color: const Color(0xff0066b3)),
        SizedBox(width: r.s(6)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: r.f(9),
                  color: Colors.grey.shade500,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: r.s(2)),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: r.f(12),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1A2332),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onInquiryListPagination() {
    _mainBloc.add(
      AssetIssueListCallRequestEvent(
          JournalVoucherMstAssetListRequest(
            pkID: 0,
            SearchKey: _searchCtrl.text.trim(),
            PageNo: _pageNo + 1,
            PageSize: 10,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID,
          ),
          _pageNo + 1),
    );
  }

  void _onAssetIssueListCallResponseStateSuccess(
      AssetIssueListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _listResponse = state.response;
      } else {
        _listResponse.details.addAll(state.response.details);
      }
      FinalTotalCount = state.response.totalCount;
      _pageNo = state.newPage;
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }
}
