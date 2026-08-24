import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:soleoserp/models/api_requests/inquiry/search_inquiry_list_by_name_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/search_inquiry_list_response.dart';
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

class AddUpdateSearchInquiryScreenArguments {
  String EmployeeID;
  String EmployeeName;

  AddUpdateSearchInquiryScreenArguments(this.EmployeeID, this.EmployeeName);
}

class SearchInquiryScreen extends BaseStatefulWidget {
  static const routeName = '/searchInquiryScreen';

  final AddUpdateSearchInquiryScreenArguments arguments;

  SearchInquiryScreen(this.arguments);

  @override
  _SearchInquiryScreenState createState() => _SearchInquiryScreenState();
}

class _SearchInquiryScreenState extends BaseState<SearchInquiryScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  SearchInquiryListResponse _searchInquiryListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  String _EmployeeID = "";
  String _EmployeeName = "";

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _EmployeeID = widget.arguments.EmployeeID;
    _EmployeeName = widget.arguments.EmployeeName;

    _inquiryBloc = InquiryBloc(baseBloc);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();

    if (value.trim().length > 2) {
      setState(() => _isSearching = true);
      _debounceTimer = Timer(const Duration(milliseconds: 600), () {
        _inquiryBloc.add(
            SearchInquiryListByNameCallEvent(SearchInquiryListByNameRequest(
          word: value,
          CompanyId: CompanyID.toString(),
          LoginUserID: LoginUserID,
          needALL: "1",
          EmployeeID: _EmployeeID.toString(),
        )));
      });
    } else if (value.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchInquiryListResponse = null;
      });
    }
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {
      _isSearching = false;
      _searchInquiryListResponse = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = _R(context);

    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {
          if (state is SearchInquiryListByNameCallResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is SearchInquiryListByNameCallResponseState;
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
            'Search Customer',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchPanel(context, r),
              Expanded(
                child: _buildCustomerList(context, r),
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
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Min. 3 chars to search Customer",
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
                        hintText: "Enter customer name...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: r.f(13),
                        ),
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
                      child: Icon(
                        Icons.close,
                        size: r.s(16),
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerList(BuildContext context, _R r) {
    if (_isSearching && _searchInquiryListResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: r.s(40),
              width: r.s(40),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xff0066b3),
              ),
            ),
            SizedBox(height: r.s(16)),
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

    if (_searchInquiryListResponse != null &&
        _searchInquiryListResponse.details.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _searchInquiryListResponse.details.length,
        itemBuilder: (ctx, i) => _buildCustomerCard(ctx, r, i),
      );
    }

    if (_searchInquiryListResponse != null &&
        _searchInquiryListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No customers found",
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
            "Search customers by name",
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

  Widget _buildCustomerCard(BuildContext context, _R r, int index) {
    final model = _searchInquiryListResponse.details[index];

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(model),
      child: Card(
        margin: EdgeInsets.only(bottom: r.s(10)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.s(14)),
        ),
        elevation: 3,
        shadowColor: Colors.blue.withOpacity(0.12),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(14)),
          child: Row(
            children: [
              CircleAvatar(
                radius: r.s(22),
                backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                child: Text(
                  model.customerName?.substring(0, 1).toUpperCase() ?? "C",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.customerName ?? "N/A",
                      style: TextStyle(
                        fontSize: r.f(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0066b3),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (model.label != null && model.label.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: r.s(4)),
                        child: Text(
                          model.label,
                          style: TextStyle(
                            fontSize: r.f(11),
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: r.s(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchInquiryListCallSuccess(
      SearchInquiryListByNameCallResponseState state) {
    if (!mounted) {
      return;
    }
    setState(() {
      _searchInquiryListResponse = state.response;
      _isSearching = false;
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    return false;
  }
}
