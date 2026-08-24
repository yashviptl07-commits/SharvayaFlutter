import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/external_lead/external_lead_bloc.dart';
import 'package:soleoserp/models/api_requests/external_leads/external_lead_search_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/external_leadsearch_response_by_name.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
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

class AddUpdateExternalLeadSearchScreenArguments {
  String LeadStatus;

  AddUpdateExternalLeadSearchScreenArguments(this.LeadStatus);
}

class SearchExternalLeadScreen extends BaseStatefulWidget {
  static const routeName = '/SearchExternalLeadScreen';
  final AddUpdateExternalLeadSearchScreenArguments arguments;

  SearchExternalLeadScreen(this.arguments);

  @override
  _SearchExternalLeadScreenState createState() =>
      _SearchExternalLeadScreenState();
}

class _SearchExternalLeadScreenState extends BaseState<SearchExternalLeadScreen>
    with BasicScreen, WidgetsBindingObserver {
  ExternalLeadBloc _inquiryBloc;
  ExternalLeadSearchResponseByName _searchInquiryListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  String _LeadStatus = "";

  final TextEditingController _searchController = TextEditingController();
  Timer _debounceTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _LeadStatus = widget.arguments.LeadStatus;
    _inquiryBloc = ExternalLeadBloc(baseBloc);

    // Add listener to handle text changes without setState during build
    _searchController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Handle text changes without calling setState during build
  void _onTextChanged() {
    // This will trigger rebuild when text changes
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<ExternalLeadBloc, ExternalLeadStates>(
        // ✅ MOVED response handling to LISTENER (not builder)
        listener: (BuildContext context, ExternalLeadStates state) {
          if (state is ExternalLeadSearchByNameResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is ExternalLeadSearchByNameResponseState;
        },
        builder: (BuildContext context, ExternalLeadStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
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
            'Search Customer',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                navigateTo(context, HomeScreen.routeName, clearAllStack: true),
          ),
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
              _buildSearchBar(r),
              Expanded(child: _buildSearchResults(r)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(_R r) {
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
        padding: EdgeInsets.all(r.s(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Min. 3 characters to search",
              style: TextStyle(
                fontSize: r.f(11),
                color: const Color(0xff0066b3),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: r.s(8)),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF2F5FA),
                borderRadius: BorderRadius.circular(r.s(12)),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Tap to enter customer name",
                  hintStyle: TextStyle(
                    fontSize: r.f(13),
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: r.s(20),
                    color: const Color(0xff0066b3),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: r.s(18)),
                          onPressed: () {
                            // Clear text without calling setState directly
                            _searchController.clear();
                            _onSearchChanged('');
                            // No setState needed here - _onTextChanged will handle it
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: r.s(16),
                    vertical: r.s(12),
                  ),
                ),
                style: TextStyle(
                  fontSize: r.f(14),
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(_R r) {
    if (_isLoading) {
      return Center(
        child: Lottie.asset(
          NO_SEARCH_RESULT_FOUND,
          height: r.s(180),
          width: r.s(180),
        ),
      );
    }

    if (_searchInquiryListResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              NO_SEARCH_RESULT_FOUND,
              height: r.s(150),
              width: r.s(150),
            ),
            SizedBox(height: r.s(12)),
            Text(
              "Type minimum 3 characters to search",
              style: TextStyle(
                fontSize: r.f(13),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchInquiryListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              NO_SEARCH_RESULT_FOUND,
              height: r.s(180),
              width: r.s(180),
            ),
            SizedBox(height: r.s(12)),
            Text(
              "No results found",
              style: TextStyle(
                fontSize: r.f(14),
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(r.s(12)),
      itemCount: _searchInquiryListResponse.details.length,
      itemBuilder: (context, index) => _buildSearchResultItem(r, index),
    );
  }

  Widget _buildSearchResultItem(_R r, int index) {
    final model = _searchInquiryListResponse.details[index];

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(model),
      child: Container(
        margin: EdgeInsets.only(bottom: r.s(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.s(14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(14)),
          child: Row(
            children: [
              Container(
                width: r.s(44),
                height: r.s(44),
                decoration: BoxDecoration(
                  color: const Color(0xff0066b3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(r.s(12)),
                ),
                child: Icon(
                  Icons.business_center,
                  size: r.s(24),
                  color: const Color(0xff0066b3),
                ),
              ),
              SizedBox(width: r.s(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.label ?? "N/A",
                      style: TextStyle(
                        fontSize: r.f(14),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (model.value != null)
                      Padding(
                        padding: EdgeInsets.only(top: r.s(4)),
                        child: Text(
                          "ID: ${model.value}",
                          style: TextStyle(
                            fontSize: r.f(11),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: r.s(20),
                color: const Color(0xff0066b3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();

    if (value.trim().length > 2) {
      // Use WidgetsBinding to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isLoading = true);
        }
      });

      _debounceTimer = Timer(const Duration(milliseconds: 350), () {
        _inquiryBloc.add(ExternalLeadSearchByNameCallEvent(
          ExternalLeadSearchRequest(
            CompanyId: CompanyID.toString(),
            word: value.toString(),
            needALL: "1",
            LoginUserID: LoginUserID,
            LeadStatus: _LeadStatus,
          ),
        ));
      });
    } else if (value.trim().isEmpty) {
      // Use WidgetsBinding to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _searchInquiryListResponse = null;
            _isLoading = false;
          });
        }
      });
    }
  }

  // ✅ This is now safe because it's called from LISTENER (not during build)
  void _onSearchInquiryListCallSuccess(
      ExternalLeadSearchByNameResponseState state) {
    if (mounted) {
      setState(() {
        _searchInquiryListResponse = state.sourceResponse;
        _isLoading = false;
      });
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }
}
