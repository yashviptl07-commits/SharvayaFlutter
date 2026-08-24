import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/employee/employee_bloc.dart';
import 'package:soleoserp/models/api_requests/employee/employee_search_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/employee/employee_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
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

class SearchEmployeeScreen extends BaseStatefulWidget {
  static const routeName = '/SearchEmployeeScreen';

  @override
  _SearchEmployeeScreenState createState() => _SearchEmployeeScreenState();
}

class _SearchEmployeeScreenState extends BaseState<SearchEmployeeScreen>
    with BasicScreen, WidgetsBindingObserver {
  EmployeeScreenBloc _CustomerBloc;
  EmployeeListResponse _searchCustomerListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;

  bool isSearching = false;
  String _lastRequestedQuery = "";

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = const Color(0xff0066b3);
    _CustomerBloc = EmployeeScreenBloc(baseBloc);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();

    final q = value.trim();
    if (q.length > 2) {
      // Show searching indicator immediately
      setState(() => isSearching = true);

      // Schedule search after debounce delay
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _lastRequestedQuery = q;
        _CustomerBloc.add(EmployeeSearchCallEvent(EmployeeSearchRequest(
            CompanyId: CompanyID.toString(),
            SearchKey: q,
            LoginUserID: LoginUserID)));
      });
    } else if (q.isEmpty) {
      // clear results when search cleared
      setState(() {
        isSearching = false;
        _searchCustomerListResponse = null;
        _lastRequestedQuery = "";
      });
    } else {
      // fewer than 3 chars — cancel pending search and keep current UI
      _lastRequestedQuery = "";
    }
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {
      isSearching = false;
      _searchCustomerListResponse = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<EmployeeScreenBloc, EmployeeScreenStates>(
        builder: (BuildContext context, EmployeeScreenStates state) {
          // Keep builder pure — do not call setState here.
          return super.build(context);
        },
        // We do not rebuild the UI from bloc state here; handle updates in listener.
        buildWhen: (oldState, currentState) => false,
        listener: (BuildContext context, EmployeeScreenStates state) {
          if (state is EmployeeSearchResponseState) {
            // Defer setState to the next frame to avoid calling it during build.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onSearchInquiryListCallSuccess(state);
            });
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is EmployeeSearchResponseState;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F5FA),
      appBar: NewGradientAppBar(
        title: const Text(
          'Search Employee',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        gradient: const LinearGradient(colors: [
          Color(0xff108dcf),
          Color(0xff0066b3),
          Color(0xff108dcf),
        ]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchPanel(context),
            Expanded(
              child: _buildEmployeeList(context),
            ),
          ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Min. 3 chars to search Employee",
              style: TextStyle(
                fontSize: r.f(11),
                color: const Color(0xff0066b3),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: r.s(8)),
            Container(
              height: r.s(44),
              padding: EdgeInsets.symmetric(horizontal: r.s(12)),
              decoration: BoxDecoration(
                color: const Color(0xffF2F5FA),
                borderRadius: BorderRadius.circular(r.s(10)),
                border: Border.all(color: const Color(0xffDDE3EF)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: Colors.grey.shade500, size: r.s(20)),
                  SizedBox(width: r.s(10)),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: "Enter employee name...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: r.f(13)),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style:
                          TextStyle(fontSize: r.f(13), color: Colors.black87),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeList(BuildContext context) {
    final r = _R(context);

    if (isSearching && _searchCustomerListResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Searching...",
              style: TextStyle(
                fontSize: r.f(12),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchCustomerListResponse != null &&
        _searchCustomerListResponse.details.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _searchCustomerListResponse.details.length,
        itemBuilder: (ctx, i) => _buildEmployeeCard(ctx, i),
      );
    }

    if (_searchCustomerListResponse != null &&
        _searchCustomerListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No employees found",
              style: TextStyle(
                fontSize: r.f(14),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: r.s(8)),
            Text(
              "Try searching with a different name",
              style: TextStyle(
                fontSize: r.f(12),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_outlined,
              size: r.s(60), color: Colors.grey.shade300),
          SizedBox(height: r.s(16)),
          Text(
            "Search employees by name",
            style: TextStyle(
              fontSize: r.f(14),
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: r.s(8)),
          Text(
            "Enter at least 3 characters",
            style: TextStyle(
              fontSize: r.f(12),
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, int index) {
    final r = _R(context);
    final model = _searchCustomerListResponse.details[index];

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(model),
      child: Card(
        margin: EdgeInsets.only(bottom: r.s(10)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.s(14))),
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
                  EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
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
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.employeeName ?? "N/A",
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
                  Icon(Icons.chevron_right,
                      color: Colors.grey.shade400, size: r.s(20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchInquiryListCallSuccess(EmployeeSearchResponseState state) {
    // Ignore responses that do not match the most recent requested query
    final currentQuery = _searchCtrl.text.trim();
    if (currentQuery.length > 2 &&
        _lastRequestedQuery.isNotEmpty &&
        currentQuery != _lastRequestedQuery) {
      // Stale response — ignore
      return;
    }

    setState(() {
      _searchCustomerListResponse = state.employeeListResponse;
      isSearching = false;
    });
  }
}
